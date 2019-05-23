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
    
    func signInAndRetrieveData(verificationCode:String, verificationID:String, completion: @escaping (UserLocal?, Error?) -> Void){
        
        refreshing = true
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
            let user = UserLocal(userId: nil, number: nil, countryCode: nil, verificationID: verificationID, authenticationCode: verificationCode)
            completion(user, nil)
            
        }
       
    }
    
}
