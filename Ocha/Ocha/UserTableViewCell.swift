//
//  ListingTableViewCell.swift
//  Ocha
//
//  Created by Taylor, Scott A on 11/18/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {
    // MARK: Properties

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var deleteUser: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteUser.layer.cornerRadius = 4
        nameLabel.adjustsFontSizeToFitWidth = true
        emailLabel.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func deleteSelectedUser(_ sender: Any) {
        var userId = " "
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let fbUser = FireUser()
                fbUser.setValuesForKeys(dictionary)
                if (fbUser.email == self.emailLabel.text) {
                    userId = snapshot.key
                    print(userId)
                }
            }
        }, withCancel: nil)
    }
    
    
    
}

