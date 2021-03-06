//
//  FavoritesMap.swift
//  Ocha
//
//  Created by Talkov, Leah C on 2/23/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import CoreLocation



class FavoritesMap: UIViewController {
    
    var favListings = [Listing]()
    
    var mapView: GMSMapView?
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"

    var currentProperty: Properties?
    
    var property = [Properties]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.loadViewIfNeeded()
        
        for listing in favListings {
            let propAddress = listing.address
            let location = propAddress + ", Spokane, WA, USA"
            let propRent = listing.monthRent
            getLatLngForZip(address: location, rent: propRent)
        }
        let camera = GMSCameraPosition.camera(withLatitude: 47.667160, longitude: -117.402342, zoom: 14)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let currentProperty = CLLocationCoordinate2DMake(47.667160, -117.402342)
        // Creates a marker in the center of the map.
        let marker = GMSMarker(position: currentProperty)
        marker.title = "Gonzaga University"
        marker.snippet = "College Hall"
        marker.map = mapView
        
        for item in property{
            print(item.name)
            print(item.location)
            print(item.zoom)
            
            let marker = GMSMarker(position: item.location)
            marker.title = item.name
            marker.snippet = ("Monthly Rent: $"+item.rent)
            marker.map = mapView
            
        }
    }
    
    func getLatLngForZip(address: String, rent: String){
        let key = "AIzaSyCoeK0AFvWvqHTIHOrlzvOKK2YeaoGa7Gk"
        
        let url : NSString = "\(baseUrl)address=\(address)&key=\(key)" as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        
        let data = NSData(contentsOf: searchURL as URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        if let results = json["results"] as? [[String: AnyObject]] {
            if(results.count == 0) {
                return
            }
            let result = results[0]
            if let geometry = result["geometry"] as? [String:AnyObject] {
                if let location = geometry["location"] as? [String:Double] {
                    let lat = location["lat"]
                    let lon = location["lng"]
                    let latitude = Double(lat!)
                    let longitude = Double(lon!)
                    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                    let prop = Properties(name: address, location: coordinates, zoom: 14, rent: rent)
                    print("added prop")
                    print (prop)
                    self.property.append(prop)
                    print("OVERHERE")
                    print("\n\(latitude), \(longitude)")
                }
            }
        }
    }
}



