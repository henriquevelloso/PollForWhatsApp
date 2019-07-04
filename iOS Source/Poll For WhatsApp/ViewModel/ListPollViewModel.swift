//
//  PollListViewModel.swift
//  Poll For WhatsApp
//
//  Created by Henrique Velloso on 02/07/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ListPollViewModel {
    
    var refreshing = false
    var userLocal: UserLocal
    
    init(userLocal: UserLocal) {
        self.userLocal = userLocal
    }
    
    func pollListRetrieveData(completionMain: @escaping ([Poll]?, Error?) -> Void){
        
        refreshing = true
        var polls = [Poll]()
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(self.userLocal.number!).collection("poll")
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let title = document.data()["title"] as? String
                    let timeStamp = document.data()["creationDate"] as? Timestamp
                    let creationDate = timeStamp?.dateValue()
                    let poll = Poll(documentId: document.documentID, title: title, creationDate: creationDate, optionList: nil, voteCount: 0)
                    polls.append(poll)
                }
                
                var options = [Option]()
                var countIndex = 0
                
                for (index, item) in polls.enumerated() {
                    
                    db.collection("users").document(self.userLocal.number!).collection("poll").document(item.documentId!).collection("optionList").getDocuments(completion: { (querySnapshotOption, errorOptin) in
                        if let errOption = errorOptin {
                            print("Error getting documents: \(errOption)")
                        } else {
                            for documentOption in querySnapshotOption!.documents {
                                print("\(documentOption.documentID) => \(documentOption.data())")
                                
                                let count = documentOption.data()["count"] as? Int
                                let title = documentOption.data()["title"] as? String
                                
                                let option = Option(documentId: documentOption.documentID, title: title, count: count)
                                options.append(option)
                            }
                            
                            countIndex = countIndex + 1
                            polls[index].optionList = options
                            options = [Option]()
                            if countIndex == polls.count {
                                self.refreshing = false
                                
                                for (i, poll) in polls.enumerated() {
                                    let votes = self.countPollVotes(poll: poll)
                                    polls[i].voteCount = votes
                                }
                                
                                var orderedPoll = polls.sorted(by: { $0.creationDate  > $1.creationDate})
                                
                                completionMain(orderedPoll, nil)
                            }
                        }
                    })
                }
                
            }
        }
    }
    
    private func countPollVotes(poll: Poll) -> Int {
        
        if let list = poll.optionList {
            let count = list.map({$0.count!}).reduce(0,+)
            return count
        } else {
            return 0
        }
    }
}
