//
//  Poll.swift
//  Poll For WhatsApp
//
//  Created by Henrique Velloso on 02/07/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation

struct Poll : Codable{
    var documentId: String?
    var title: String?
    var pollDescription: String?
    var creationDate: String?
    var optionList: [Option]?
    var voteCount: Int?
}

struct Option : Codable{
    var documentId: String?
    var title: String?
    var count: Int?
}
