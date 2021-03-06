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
import FBSDKLoginKit

class AccountInfo: UITableViewController {

    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet var appLogo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var myString: String = (dictionary["name"] as? String)!
                var myStringArr = myString.components(separatedBy: " ")
                if myStringArr.count == 1 {
                    self.firstName.text = myStringArr[0]
                }
                else {
                    self.firstName.text = myStringArr[0]
                    self.lastName.text = myStringArr[1]
                }
                self.emailLabel.text  = dictionary["email"] as? String
            }
            
        }, withCancel: nil)
        
        emailLabel.adjustsFontSizeToFitWidth = true
        let image = UIImage(named: "Logo.png")
        appLogo.image = image
    }

    @IBAction func logout(_ sender: Any) {
        if FIRAuth.auth() != nil {
            
            do {
                try FIRAuth.auth()?.signOut()
                print("the user is logged out")
            } catch let error as NSError {
                print(error.localizedDescription)
                print("the current user id is \(FIRAuth.auth()?.currentUser?.uid)")
            }
            do {
                try GIDSignIn.sharedInstance().signOut()
                print("Google signed out")
            } catch let error as NSError {
                print(error.localizedDescription)
                print("Error logging out of google")
            }
            FBSDKLoginManager().logOut()
            print("Facebook signed out")
            
        }
        
        
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController()! as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
