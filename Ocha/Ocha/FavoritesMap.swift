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


class Properties: NSObject{
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, location:CLLocationCoordinate2D, zoom: Float){
        self.name = name
        self.location = location
        self.zoom = zoom
    }
}


class FavoritesMap: UIViewController {
    
    var mapView: GMSMapView?
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    let apiKey = GMSServices.provideAPIKey("AIzaSyC-HdTV2ioRSQvhGJyBJVmd3B78Lfigjv8")
    
    
    var currentProperty: Properties?
  
    var property = [Properties(name: "St Aloysius Church", location: CLLocationCoordinate2DMake(47.668132, -117.404259), zoom: 14),Properties(name: "Kennedy Apartments", location: CLLocationCoordinate2DMake(47.669114, -117.408657), zoom: 14)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("overhere")
        //getLatLngForZip(address: "1217 N Hamilton St, Spokane, WA, USA")
        
        //let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
        
       // let apiKey = GMSServices.provideAPIKey("AIzaSyC-HdTV2ioRSQvhGJyBJVmd3B78Lfigjv8")
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
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
            print("look here")
            print(item.name)
            print(item.location)
            print(item.zoom)
            
            let marker = GMSMarker(position: item.location)
            marker.title = item.name
            marker.map = mapView
            
            //let currentProperty = item
            //setMapCamara()
        }
    }
    
    
    //"1217 N Hamilton St, Spokane, WA, USA"
    /*
 let prop = Properties(name: address, location: coordinates, zoom: 14)
 print("added prop")
 print (prop)
 self.property.append(prop)*/
  /*  func getLatLngForZip(address: String) {
        let url = NSURL(string: "\(baseUrl)address=\(address)&key=\(apiKey)")
        let data = NSData(contentsOf: url! as URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let latitude = location["lat"] as! Float
                    let longitude = location["lng"] as! Float
                    print("\n\(latitude), \(longitude)")
                }
            }
        }
    }*/
    
    /*private func setMapCamara(){
      //  CATransaction.begin()
      //  CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
      //  mapView?.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(currentProperty!.location,zoom: currentProperty!.zoom))
      //  CATransaction.commit()
        
        let marker = GMSMarker(position: currentProperty!.location)
        marker.title = currentProperty?.name
        marker.map = mapView
    }*/
    
}
