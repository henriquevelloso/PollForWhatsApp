//
//  PollTableViewCell.swift
//  Poll For WhatsApp
//
//  Created by Henrique Velloso on 02/07/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit

class PollTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var voteContainer: TrueUIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(title: String, voteCount: String) {
        
        self.titleLabel.text = title
        self.voteCountLabel.text = voteCount
    }
    
    func setVoteCountainerColor(voteCount: Int) {
        
        var color = UIColor.init(hexString: "#EEEDEF")
        
        if voteCount > 3 && voteCount < 7 {
            color = UIColor.init(hexString: "#64FC92")
        } else if voteCount > 7 && voteCount < 11 {
            color = UIColor.init(hexString: "#CDF45F")
        }  else if voteCount > 11 && voteCount < 15 {
            color = UIColor.init(hexString: "#E9CB36")
        } else if voteCount > 15 && voteCount < 19 {
            color = UIColor.init(hexString: "#E97B36")
        } else if voteCount > 19 {
            color = UIColor.init(hexString: "#D21A1A")
        }
        
        self.voteContainer.backgroundColor = color
        
    }
}
