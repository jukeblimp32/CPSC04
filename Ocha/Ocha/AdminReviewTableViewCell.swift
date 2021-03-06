//
//  AdminReviewTableViewCell.swift
//  Ocha
//
//  Created by Talkov, Leah C on 3/24/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class AdminReviewTableViewCell: UITableViewCell {
    
    var propertyID : Int = 0
    var reviewNum: Int = 0
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var deleteReview: UIButton!
    @IBOutlet var responseScore: UILabel!
    @IBOutlet var locationScore: UILabel!
    @IBOutlet var valueScore: UILabel!
    @IBOutlet var spaceScore: UILabel!
    @IBOutlet var qualityScore: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailLabel.adjustsFontSizeToFitWidth = true
    }
    
    
}
