// [START all]
// [START import]
// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

'use strict';



// The Firebase Admin SDK to access the Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
// [END import]
var firestore = admin.firestore();


exports.PollAPI = functions.https.onRequest(async (request, response) => {

    const userID = '5551995512009' //request.query.userID;
    const pollID = 'DOjpM5GzUzQFQxuVypxU' //request.query.pollID;
    const optionID = 'WCjQn5t4M5Uvpu9Kmrj9'

    var option = await admin.firestore().collection('users').doc(userID).collection('poll').doc(pollID).collection('optionList').doc(optionID);

    option.update({
        count: admin.firestore.FieldValue.increment(1)
    });

    response.json({result: option.data})

});


// [START addMessage]
// Take the text parameter passed to this HTTP endpoint and insert it into 
// Cloud Firestore under the path /messages/:documentId/original
// [START addMessageTrigger]
exports.addMessage = functions.https.onRequest(async (req, res) => {
// [END addMessageTrigger]
  // Grab the text parameter.
  const original = req.query.text;
  // [START adminSdkAdd]
  // Push the new message into Cloud Firestore using the Firebase Admin SDK.
  const writeResult = await admin.firestore().collection('messages').add({original: original});
  // Send back a message that we've succesfully written the message
  res.json({result: `Message with ID: ${writeResult.id} added.`});
  // [END adminSdkAdd]
});
// [END addMessage]

// [START makeUppercase]
// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
// [START makeUppercaseTrigger]
exports.makeUppercase = functions.firestore.document('/messages/{documentId}')
    .onCreate((snap, context) => {
// [END makeUppercaseTrigger]
      // [START makeUppercaseBody]
      // Grab the current value of what was written to the Cloud Firestore.
      const original = snap.data().original;
      console.log('Uppercasing', context.params.documentId, original);
      const uppercase = original.toUpperCase();
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to the Cloud Firestore.
      // Setting an 'uppercase' field in the Cloud Firestore document returns a Promise.
      return snap.ref.set({uppercase}, {merge: true});
      // [END makeUppercaseBody]
    });
// [END makeUppercase]
// [END all]