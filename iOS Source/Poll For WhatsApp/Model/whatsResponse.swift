//
//  whatsResponse.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 19/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation

struct WhatsResponse {
    
    var success: Bool
    var description: String
    var resultCode: Int
    
    init(success: Bool, description: String, resultCode:Int) {
        
        self.success = success
        self.description = description
        self.resultCode = resultCode
    }
}


extension WhatsResponse: Decodable {
    enum MyStructKeys: String, CodingKey { // declaring our keys
        case success = "success"
        case description = "description"
        case resultCode = "result_code"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
        
        let success: Bool = try container.decode(Bool.self, forKey: .success) // extracting the data
        let description: String = try container.decode(String.self, forKey: .description) // extracting the data
         let resultCode: Int = try container.decode(Int.self, forKey: .resultCode) // extracting the data
        
        self.init(success: success, description: description, resultCode: resultCode)
        
    }
}
