//
//  ReviewTableViewCell.swift
//  Ocha
//
//  Created by Talkov, Leah C on 3/22/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class ReviewTableViewCell: UITableViewCell {
    
    var propertyID : Int = 0
    var reviewNum: Int = 0
    
    
    @IBOutlet var responseScore: UILabel!
    @IBOutlet var qualityScore: UILabel!
    @IBOutlet var spaceScore: UILabel!
    @IBOutlet var valueScore: UILabel!
    @IBOutlet var locationScore: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
