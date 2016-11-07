//
//  UserType.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/6/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class UserType: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func studentType(_ sender: Any) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let dataRef = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
        let usersReference = dataRef.child("users").child(uid!)
        let values = ["type" : "Student"]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
            if err != nil{
                print(err)
                return
            }
            print("Saved user successfully")
        })


    }
    
    
    @IBAction func landlordType(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let dataRef = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
        let usersReference = dataRef.child("users").child(uid!)
        let values = ["type" : "Landlord"]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
            if err != nil{
                print(err)
                return
            }
            print("Saved user successfully")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
