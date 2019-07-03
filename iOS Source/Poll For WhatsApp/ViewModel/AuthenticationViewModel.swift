//
//  AuthenticationViewModel.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 27/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AuthenticationViewModel {
    
    var refreshing = false
    
    func signInAndRetrieveData(userLocal: UserLocal, verificationCode:String, verificationID:String, completion: @escaping (UserLocal?, Error?) -> Void){
        
        refreshing = true
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
            let user = UserLocal(userId: authResult?.user.uid, number: authResult?.user.phoneNumber, countryCode: userLocal.countryCode, verificationID: verificationID, authenticationCode: verificationCode)
            
            let db = Firestore.firestore()
            let ref = db.collection("users").document(user.number!)
            ref.setData([
                "userId": user.userId!,
                "phoneNumber": user.number!,
                "countryCode": user.countryCode!,
                "lastLogin": Date()
            ]) { (err) in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref.documentID)")
                    completion(user, nil)
                }
            }
            
            self.refreshing = false
            
        }
        
    }
    
}
