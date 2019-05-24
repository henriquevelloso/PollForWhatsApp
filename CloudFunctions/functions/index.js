const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.pollApi = functions.https.onRequest((request, response) => {


    response.redirect('whatsapp://send?phone=555194519709')

});

