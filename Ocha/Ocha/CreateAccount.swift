//
//  FirstViewController.swift
//  Ocha
//
//  Created by Talkov, Leah C on 10/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class CreateAccount: UITableViewController, UITextFieldDelegate{
    
    //MARK: Outlet vars
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var password1: UITextField!
    
    @IBOutlet weak var password2: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var email2: UITextField!
    
    @IBOutlet weak var usertype: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        firstName.delegate = self
        lastName.delegate = self
        password1.delegate = self
        password2.delegate = self
        email.delegate = self
        email2.delegate = self
    }

    @IBAction func backToMain(_ sender: Any) {
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController()! as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
    }
    
    @IBAction func submitInfo(_ sender: Any) {
        // Only if emails are the same and passwords are same
        if email.text == email2.text && password1.text == password2.text
        {
            guard let email = email2.text, let password = password2.text, let name = firstName.text else{
                print("Form is not valid")
                return
            }
            
            if firstName.text == "" || lastName.text == ""
            {
                let alert = UIAlertController(title: "Empty Fields", message:"Make sure you have entered information for all fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(alert, animated: true){}
                
            }
            // Create user in Firebase
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user:FIRUser?, error) in
                if error != nil{
                    print(error)
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        // Create alerts for each Firebase error
                        switch errCode {
                            
                        // Invalid email
                        case .errorCodeInvalidEmail:
                            let alert = UIAlertController(title: "Failure to Submit", message:"Email is invalid. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default))
                            self.present(alert, animated: true){}
                            
                        // Email is already used
                        case .errorCodeEmailAlreadyInUse:
                            let alert = UIAlertController(title: "Failure to Submit", message:"Email is already in use. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default))
                            self.present(alert, animated: true){}
                            
                        // Too short of password
                        case .errorCodeWeakPassword:
                            let alert = UIAlertController(title: "Failure to Submit", message:"Password must be at least 6 characters. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default))
                            self.present(alert, animated: true){}
                            
                        // Miscellaneous errors
                        default:
                            let alert = UIAlertController(title: "Failure to Submit", message:"Make sure all fields are filled out properly", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default))
                            self.present(alert, animated: true){}
                        }
                    }
                    return
                }
                
                guard let uid = user?.uid else {
                    return
                }
                
                // Send verification email
                self.sendEmailVer()
                
                // Store created user in the database
                let dataRef = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
                let usersReference = dataRef.child("users").child(uid)
                var fullname = name + " " + self.lastName.text!
                var type = ""
                if self.usertype.selectedSegmentIndex == 0 {
                    type = "Student"
                }
                else {
                    type = "Landlord"
                }
                let values = ["name": fullname, "email": email, "type" : type]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
                    if err != nil{
                        print(err)
                        return
                    }
                    print("Saved user successfully")
                })
                return
            })
            
        }
        else{
            let alertVC = UIAlertController(title: "Field Mismatch", message: "Check that your email and password were typed correctly", preferredStyle: .alert)
            
            // Send email twice, just in case
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    func transitionToLogin(){
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.dismiss(animated: true, completion: nil)
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sendEmailVer(){
        // Send verification email
        if let user = FIRAuth.auth()?.currentUser {
            if !user.isEmailVerified{
                user.sendEmailVerification(completion: nil)
                // Setup alert
                let alertVC = UIAlertController(title: "Email Sent", message: "Check your email to verify your account and then login. If using zagmail, check your spam folder", preferredStyle: .alert)
                
                // Send email twice, just in case
                let alertActionResend = UIAlertAction(title: "Resend", style: .default) {
                    (_) in
                    user.sendEmailVerification(completion: nil)
                    // Go back to login
                    self.transitionToLogin()
                }
                let alertActionOkay = UIAlertAction(title: "Okay", style: .default){
                    (_) in
                    // Go back to login
                    self.transitionToLogin()
                }
                alertVC.addAction(alertActionResend)
                alertVC.addAction(alertActionOkay)
                self.present(alertVC, animated: true, completion: nil)
            } else {
                print ("Email verified. Signing in...")
            }
        }

        
    }
    
    // Called when 'return' key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        // Set so that hitting return key advances to next field
        if textField == self.firstName {
            self.lastName.becomeFirstResponder()
        }
        else if textField == self.lastName{
            self.password1.becomeFirstResponder()
        }
        else if textField == self.password1{
            self.password2.becomeFirstResponder()
        }
        else if textField == self.password2{
            self.email.becomeFirstResponder()
        }
        else if textField == self.email{
            self.email2.becomeFirstResponder()
        }
        // If we are in the last field, just dismiss keyboard
        else{
            textField.resignFirstResponder()
        }
        return true
        
    }


}

