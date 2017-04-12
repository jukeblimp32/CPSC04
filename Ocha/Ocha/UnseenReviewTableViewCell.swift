//
//  UnseenReviewTableViewCell.swift
//  Ocha
//
//  Created by Talkov, Leah C on 4/12/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class UnseenReviewTableViewCell: UITableViewCell {
    
    var propertyID : Int = 0
    var reviewNum: Int = 0
    
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var responseScore: UILabel!
    @IBOutlet var locationScore: UILabel!
    @IBOutlet var valueScore: UILabel!
    @IBOutlet var spaceScore: UILabel!
    @IBOutlet var qualityScore: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailLabel.adjustsFontSizeToFitWidth = true
        addressLabel.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func unseenButton(_ sender: Any) {
        print("hi")
    }
    
}
