//
//  SendMessageViewModel.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 01/04/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SendMessageViewModel {
    
    var refreshing = false
    
    func sendMessageWassenger(countryCode:String, phoneNumber:String, messageText:String, completion: @escaping (WhatsResponse?, Error?) -> Void){
        
        
        var formattedNumber : String = countryCode + phoneNumber
        if formattedNumber.first == "0" {
            formattedNumber = formattedNumber.removingPrefix("0")
        }
        formattedNumber.trim()
        
        let message = messageText
        
        
        
        
        let headers = [
            "content-type": "application/json",
            "token": "b34274a161f700994b804f92affd0f0ac4618f51ffbc50bc743741276b9431811ff4c53db7750be9"
        ]
        let parameters = [
            "phone": formattedNumber,
            "message": message
            ] as [String : Any]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.wassenger.com/v1/messages")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                    completion(nil, error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    completion(nil, nil)
                }
            })
            dataTask.resume()
        } catch {
            
        }
    }
    
    
    func sendMessageApiWha(countryCode:String, phoneNumber:String, messageText:String, completion: @escaping (WhatsResponse?, Error?) -> Void){
        
        refreshing = true
        
        var formattedNumber : String = countryCode + phoneNumber
        if formattedNumber.first == "0" {
            formattedNumber = formattedNumber.removingPrefix("0")
        }
        let message = messageText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        if formattedNumber.first == "+" {
            formattedNumber = formattedNumber.removingPrefix("+")
        }
        formattedNumber.trim()
        
        let url = URL(string: "https://panel.apiwha.com/send_message.php?apikey=J6HZ4DJ3HM9FAY0NAKTE&number=\(formattedNumber)&text=\(message)")
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    do {
                        let decodedItens = try decoder.decode(WhatsResponse.self, from: data)
                        
                        completion(decodedItens, nil)
                        
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }
        
        dataTask.resume()
        
    }
    
}

