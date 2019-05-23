//
//  Timer.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 26/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation


extension Timer {
    
   class func setTimeout(_ delay:TimeInterval, completion:@escaping ()->Void) {
        var _ = Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: completion), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
    
}
