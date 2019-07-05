//
//  NewPollViewModel.swift
//  Poll For WhatsApp
//
//  Created by Henrique Velloso on 04/07/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewPollViewModel {
    
    var refreshing = false
    var userLocal: UserLocal
    
    init(userLocal: UserLocal) {
        self.userLocal = userLocal
    }
    
    func createNewPollData(poolTitle: String, pollOptions: [String?], completionMain: @escaping (Poll?, Error?) -> Void){
        
        refreshing = true
        var poll = Poll(documentId: nil, title: poolTitle, creationDate: Date(), optionList: [], voteCount: 0)
        
        let db = Firestore.firestore()
        
        // Add a new Poll with a generated ID
        var pollRef: DocumentReference? = nil
        pollRef = db.collection("users").document(self.userLocal.number!).collection("poll").addDocument(data: [
            "creationDate": poll.creationDate!,
            "title": poll.title!
        ]) { err in
            if let err = err {
                completionMain(nil, err)
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(pollRef!.documentID)")
                poll.documentId = pollRef!.documentID
                
                var countIndex = 0
                for (index, optionTitle) in pollOptions.enumerated() {
                    
                    if optionTitle == nil || optionTitle == ""{
                        
                        countIndex = countIndex + 1
                        if countIndex == pollOptions.count {
                            self.refreshing = false
                            completionMain(poll, nil)
                        }
                        
                        continue
                    }
                    
                    var prefix = ""
                    switch index {
                    case 0:
                        prefix = "A)"
                    case 1:
                        prefix = "B)"
                    case 2:
                        prefix = "C)"
                    case 3:
                        prefix = "D)"
                    case 4:
                        prefix = "E)"
                    case 5:
                        prefix = "F)"
                    default:
                        break
                    }
                    
                    var option = Option(prefix: prefix, link: nil, documentId: nil, title: optionTitle, count: 0)
                    var optionRef: DocumentReference? = nil
                    optionRef = db.collection("users").document(self.userLocal.number!).collection("poll").document(pollRef!.documentID).collection("optionList").addDocument(data: ["title" : option.title!, "count" : 0, "prefix": option.prefix!], completion: { (errorOption) in
                        if let errOption = errorOption {
                            completionMain(nil, errOption)
                            print("Error adding document: \(errOption)")
                        } else {
                            
                            option.documentId = optionRef?.documentID
                            poll.optionList?.append(option)
                            
                            countIndex = countIndex + 1
                            if countIndex == pollOptions.count {
                                self.refreshing = false
                                completionMain(poll, nil)
                            }
                            
                        }
                    })
                }
                
            }
        }
        
        
    }
    
}
