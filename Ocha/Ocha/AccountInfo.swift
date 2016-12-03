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

class AccountInfo: UIViewController {
    
    
    @IBOutlet var firstName: UILabel!
    
    @IBOutlet var lastName: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        
        let viewTitle = UILabel()
        viewTitle.text = "Account Information"
        viewTitle.font = UIFont(name: viewTitle.font.fontName, size: 20)
        viewTitle.textColor = UIColor.white
        viewTitle.textAlignment = .center
        viewTitle.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (10/100), width: view.frame.width * (80/100), height: 30)
        view.addSubview(viewTitle)
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var myString: String = (dictionary["name"] as? String)!
                var myStringArr = myString.components(separatedBy: " ")
                if myStringArr.count == 1 {
                    self.self.firstName.text = myStringArr[0]
                }
                else {
                    self.self.firstName.text = myStringArr[0]
                    self.self.lastName.text = myStringArr[1]
                }
                self.self.emailLabel.text  = dictionary["email"] as? String
            }
            
        }, withCancel: nil)
        
        let firstNameLabel = UILabel()
        firstNameLabel.text = "First Name:"
        firstNameLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        firstNameLabel.textColor = UIColor.white
        firstNameLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (30/100), width: view.frame.width * (30/100), height: 30)
        view.addSubview(firstNameLabel)
        
        let lastNameLabel = UILabel()
        lastNameLabel.text = "Last Name:"
        lastNameLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        lastNameLabel.textColor = UIColor.white
        lastNameLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (40/100), width: view.frame.width * (30/100), height: 30)
        view.addSubview(lastNameLabel)
        
        let email = UILabel()
        email.text = "Email:"
        email.font = UIFont(name: viewTitle.font.fontName, size: 15)
        email.textColor = UIColor.white
        email.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (50/100), width: view.frame.width * (30/100), height: 30)
        view.addSubview(email)
        
        firstName.frame = CGRect(x: (view.frame.width) * (35/100), y: (view.frame.height) * (30/100), width: view.frame.width * (60/100), height: 30)
        firstName.textColor = UIColor.white
        
        lastName.frame = CGRect(x: (view.frame.width) * (35/100), y: (view.frame.height) * (40/100), width: view.frame.width * (60/100), height: 30)
        lastName.textColor = UIColor.white
        
        emailLabel.frame = CGRect(x: (view.frame.width) * (35/100), y: (view.frame.height) * (50/100), width: view.frame.width * (60/100), height: 30)
        emailLabel.textColor = UIColor.white
        emailLabel.adjustsFontSizeToFitWidth = true
        emailLabel.minimumScaleFactor = 0.5
        
        let toHomePageButton = UIButton()
        toHomePageButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (5/100), width: view.frame.width * (25/100) , height: 20)
        toHomePageButton.setTitle("Logout", for: UIControlState.normal)
        toHomePageButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        toHomePageButton.addTarget(self, action: #selector(AccountInfo.logout(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(toHomePageButton)
        
    }
    
    
    func logout(_ sender : UIButton) {
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
