//
//  AccountInfo.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/6/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class AccountInfo: UIViewController {
    
    
    @IBOutlet var firstName: UILabel!
    
    @IBOutlet var lastName: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var myString: String = (dictionary["name"] as? String)!
                var myStringArr = myString.components(separatedBy: " ")
                self.self.firstName.text = myStringArr[0]
                self.self.lastName.text = myStringArr[1]
                self.self.emailLabel.text  = dictionary["email"] as? String
            }
            
            
        }, withCancel: nil)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
