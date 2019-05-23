//
//  UILabel.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 26/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setLineSpace(space:CGFloat) {
    
        if let text = self.text {
            let attributedString = NSMutableAttributedString(string: text)
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = space // Whatever line spacing you want in points
            paragraphStyle.alignment = .center
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            // *** Set Attributed String to your label ***
            self.attributedText = attributedString
            
        }
    
    }
    
}
