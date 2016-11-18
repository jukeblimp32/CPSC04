//
//  EditAccountInfo.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/6/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class EditAccountInfo: UIViewController {
    
    
    
    @IBOutlet var firstName: UITextField!
    
    @IBOutlet var lastName: UITextField!
    
    @IBOutlet var email1st: UITextField!
    
    @IBOutlet var email2nd: UITextField!
    
    @IBOutlet var password1st: UITextField!
    
    @IBOutlet var password2nd: UITextField!
    
    @IBOutlet var newPassword1st: UITextField!
    
    @IBOutlet var newPassword2nd: UITextField!
    
    @IBOutlet var newEmail1st: UITextField!
    
    @IBOutlet var newEmail2nd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sendEmailVer(){
        // Send verification email
        if let user = FIRAuth.auth()?.currentUser {
            if !user.isEmailVerified{
                // Setup alert
                let alertVC = UIAlertController(title: "Email Sent", message: "Check your email to verify your account and then login. If using zagmail, check your spam folder", preferredStyle: .alert)
                
                // Send email twice, just in case
                let alertActionResend = UIAlertAction(title: "Resend", style: .default) {
                    (_) in
                    user.sendEmailVerification(completion: nil)
                }
                let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                    (_) in
                    user.sendEmailVerification(completion: nil)
                }
                
                alertVC.addAction(alertActionResend)
                alertVC.addAction(alertActionOkay)
                self.present(alertVC, animated: true, completion: nil)
            } else {
                print ("Email verified. Signing in...")
            }
        }
        
        
    }
    
    @IBAction func submitInfo(_ sender: Any) {
        
        //MARK: CHECK FOR VALID EMAIL
        if (email1st.text != email2nd.text) || newEmail1st.text != newEmail2nd.text {
            let alertEmail = UIAlertController(title: "Non-Matching Emails", message: "Emails do not match", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
            alertEmail.addAction(alertActionOkay)
            self.present(alertEmail, animated: true, completion: nil)
        }
        else if ((password1st.text != password2nd.text) || (newPassword1st.text != newPassword2nd.text)) {
            let alertPassword = UIAlertController(title: "Non-Matching Passwords", message: "Passwords do not match", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
            alertPassword.addAction(alertActionOkay)
            self.present(alertPassword, animated: true, completion: nil)
        }
        else {
            let user = FIRAuth.auth()?.currentUser
            
            // Prompt the user to re-provide their sign-in credentials
            
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email1st.text!, password: password1st.text!)
            
            user?.reauthenticate(with: credential) { error in
                if error != nil{
                    let alertPassword = UIAlertController(title: "Incorrect Credentials", message: "Incorrect password or email", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
                    alertPassword.addAction(alertActionOkay)
                    self.present(alertPassword, animated: true, completion: nil)
                } else {
                    let currentUser = FIRAuth.auth()?.currentUser
                    currentUser?.updateEmail(self.newEmail1st.text!) { error in
                        if let error = error {
                            print(error)
                            
                        } else {
                            self.sendEmailVer()
                            // Email updated.
                            if self.newPassword1st.text != "" {
                                currentUser?.updatePassword(self.password1st.text!) { error in
                                    if let error = error {
                                    
                                    } else {
                                    // Password updated
                                    }
                                }
                            }
                        }
                        let alertConfirm = UIAlertController(title: "Changes Saved", message: "Your changes have been saved. If you inputted a new email, you will get an email to verify your new address. ", preferredStyle: .alert)
                        let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
                        alertConfirm.addAction(alertActionOkay)
                        self.present(alertConfirm, animated: true, completion: nil)
                    }
                }
        
                
            }
            
            
            
        }
        
        
        
    }
    
    
}
