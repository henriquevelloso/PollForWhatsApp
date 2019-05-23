//
//  PhoneNumberViewModel.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 26/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation
import Firebase

class PhoneNumberViewModel {
    
    var refreshing = false
    
    func verifyPhoneNumber(countryCode:String, phoneNumber:String, completion: @escaping (UserLocal?, Error?) -> Void){
        
        refreshing = true
    
        let phone = countryCode + phoneNumber
        
        Auth.auth().useAppLanguage()
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let user = UserLocal(userId: nil, number: phoneNumber, countryCode: countryCode, verificationID: verificationID, authenticationCode: nil)
            completion(user, nil)
        }
    }
    
}
