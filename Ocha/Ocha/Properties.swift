//
//  Properties.swift
//  Ocha
//
//  Created by Talkov, Leah C on 4/16/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import CoreLocation


class Properties: NSObject{
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    let rent: String
    
    init(name: String, location:CLLocationCoordinate2D, zoom: Float, rent: String){
        self.name = name
        self.location = location
        self.zoom = zoom
        self.rent = rent
    }
}

