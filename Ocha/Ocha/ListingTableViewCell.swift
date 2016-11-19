//
//  ListingTableViewCell.swift
//  Ocha
//
//  Created by Taylor, Scott A on 11/18/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    // MARK: Properties
    
    @IBOutlet weak var propertyAddress: UILabel!
    @IBOutlet weak var propertyDistance: UILabel!
    @IBOutlet weak var propertyRent: UILabel!
    @IBOutlet weak var propertyRooms: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
