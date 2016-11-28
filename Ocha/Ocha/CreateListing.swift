//
//  CreateListing.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class CreateListing: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    let firstName = UITextField()
    let lastName = UITextField()
    let userName = UITextField()
    let passWord1 = UITextField()
    let passWord2 = UITextField()
    let email = UITextField()
    let email2 = UITextField()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //View title
        //THIS WILL CHANGE TO HAVE A LABEL THAT CAN HAVE EDIT CURRENT LISTING OR CREATE
        let viewTitle = UILabel()
        viewTitle.text = "Create A New Listing"
        viewTitle.font = UIFont(name: viewTitle.font.fontName, size: 20)
        viewTitle.textColor = UIColor.white
        viewTitle.textAlignment = .center
        viewTitle.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (13/100), width: view.frame.width * (80/100), height: 40)
        scrollView.addSubview(viewTitle)
        
        
        //First name label
        let firstNameLabel = UILabel()
        firstNameLabel.text = "First Name:"
        firstNameLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        firstNameLabel.textColor = UIColor.white
        firstNameLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (20/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(firstNameLabel)
        
        //Last name label
        let lastNameLabel = UILabel()
        lastNameLabel.text = "Last Name:"
        lastNameLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        lastNameLabel.textColor = UIColor.white
        lastNameLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (27/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(lastNameLabel)
        
        //Username label
        let usernameLabel = UILabel()
        usernameLabel.text = "Username:"
        usernameLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        usernameLabel.textColor = UIColor.white
        usernameLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (34/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(usernameLabel)
        
        //Password label
        let passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        passwordLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        passwordLabel.textColor = UIColor.white
        passwordLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (41/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(passwordLabel)
        
        //Confirm Password Label
        let confirmPasswordLabel = UILabel()
        confirmPasswordLabel.text = "Confirm Password:"
        confirmPasswordLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        confirmPasswordLabel.textColor = UIColor.white
        confirmPasswordLabel.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (48/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(confirmPasswordLabel)
        
        //Email Label
        let emailLabel = UILabel()
        emailLabel.text = "Email:"
        emailLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        emailLabel.textColor = UIColor.white
        emailLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (55/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(emailLabel)
        
        //Confirm email label
        let confirmEmailLabel = UILabel()
        confirmEmailLabel.text = "Confirm Email:"
        confirmEmailLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        confirmEmailLabel.textColor = UIColor.white
        confirmEmailLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (62/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(confirmEmailLabel)
        
        //Type of User label
        let userTypeLabel = UILabel()
        userTypeLabel.text = "Select Type Of User:"
        userTypeLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        userTypeLabel.textColor = UIColor.white
        userTypeLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (69/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(userTypeLabel)
        
        //
        firstName.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (20/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(firstName)
        firstName.borderStyle = UITextBorderStyle.roundedRect
        firstName.backgroundColor = UIColor.white
        self.firstName.delegate = self
        
        lastName.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (27/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(lastName)
        lastName.borderStyle = UITextBorderStyle.roundedRect
        lastName.backgroundColor = UIColor.white
        self.lastName.delegate = self
        
        userName.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (34/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(userName)
        userName.borderStyle = UITextBorderStyle.roundedRect
        userName.backgroundColor = UIColor.white
        self.userName.delegate = self
        
        passWord1.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (41/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(passWord1)
        passWord1.borderStyle = UITextBorderStyle.roundedRect
        passWord1.backgroundColor = UIColor.white
        passWord1.isSecureTextEntry = true
        self.passWord1.delegate = self
        
        passWord2.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (48/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(passWord2)
        passWord2.borderStyle = UITextBorderStyle.roundedRect
        passWord2.backgroundColor = UIColor.white
        passWord2.isSecureTextEntry = true
        self.passWord2.delegate = self
        
        email.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (55/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(email)
        email.borderStyle = UITextBorderStyle.roundedRect
        email.backgroundColor = UIColor.white
        self.email.delegate = self
        
        email2.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (62/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(email2)
        email2.borderStyle = UITextBorderStyle.roundedRect
        email2.backgroundColor = UIColor.white
        // Make the final field have a done button rather than return
        email2.returnKeyType = UIReturnKeyType.done
        self.email2.delegate = self
        

        
        //Submit button
        let submitButton = UIButton()
        submitButton.frame = CGRect(x: (view.frame.width) * (2/3), y: (view.frame.height) * (90/100), width: view.frame.width * (1/4), height: 30)
        submitButton.setTitle("Submit", for: UIControlState.normal)
        submitButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        submitButton.titleLabel?.textColor = UIColor.white
        submitButton.addTarget(self, action: #selector(FirstViewController.submitInfo(_:)), for: UIControlEvents.touchUpInside)
        submitButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        submitButton.layer.cornerRadius = 4
        scrollView.addSubview(submitButton)
        self.scrollView.addSubview(submitButton)

        
        //logout button
        let toHomePageButton = UIButton()
        toHomePageButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (5/100), width: view.frame.width * (25/100) , height: 30)
        toHomePageButton.setTitle("Logout", for: UIControlState.normal)
        toHomePageButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        toHomePageButton.addTarget(self, action: #selector(CreateListing.logout(_:)), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(toHomePageButton)
        self.scrollView.addSubview(toHomePageButton)
        
        view.addSubview(scrollView)
        
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
