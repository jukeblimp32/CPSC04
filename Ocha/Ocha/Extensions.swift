//
//  Extensions.swift
//  Ocha
//
//  Created by Taylor, Scott A on 1/27/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

let propertyImageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadCachedImages(url: String){
        self.image = nil
        
        // Load default image if no url
        if(url == "" || url == nil)
        {
            self.image = UIImage(named: "default")
            return
        }
        
        // Check if the picture exists in the cache
        if let cachedImage = propertyImageCache.object(forKey: url as NSString) {
            self.image = cachedImage
            return
        }

        let durl = URL(string: url)
        URLSession.shared.dataTask(with: durl!, completionHandler: { (data, response, error) in
            // download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            // Set the listing image
            DispatchQueue.main.async{
                if let propertyImage = UIImage(data: data!){
                    propertyImageCache.setObject(propertyImage, forKey: url as NSString)
                    self.image = propertyImage
                }
            }
        }).resume()

    }
}


/******************************************************************************************
 * This extension exists for an in place shuffle, but due to me not understanding arc4random
 * , I am currently instead using the shuffling provided by the GameplayKit
 ******************************************************************************************/
extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<self.count
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
