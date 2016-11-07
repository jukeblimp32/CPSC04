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
    
    @IBOutlet var newEmail1st: UITextField!
    
    @IBOutlet var newEmail2nd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func submitInfo(_ sender: Any) {
        
        //MARK: CHECK FOR VALID EMAIL
        if (email1st.text != email2nd.text) || newEmail1st.text != newEmail2nd.text {
            let alertEmail = UIAlertController(title: "Non-Matching Emails", message: "Emails do not match", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
            alertEmail.addAction(alertActionOkay)
            self.present(alertEmail, animated: true, completion: nil)
        }
        else if (password1st.text != password2nd.text) {
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
                            // Email updated.
                            currentUser?.updatePassword(self.password1st.text!) { error in
                                if let error = error {
                                    
                                } else {
                                    // Password updated.
                                    let alertConfirm = UIAlertController(title: "Changes Saved", message: "Your changes have been saved", preferredStyle: .alert)
                                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
                                    alertConfirm.addAction(alertActionOkay)
                                    self.present(alertConfirm, animated: true, completion: nil)
                                    
                                }
                            }
                }
            }
            }
        
                
            }
            
            
            
        }
        
        
    }
    
    
}
