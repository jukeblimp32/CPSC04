//
//  UpdatePassword.swift
//  Ocha
//
//  Created by Talkov, Leah C on 4/7/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class UpdatePassword: UIViewController, UITextFieldDelegate {
    // Email textfield
    
    
    @IBOutlet var backToAccount: UIButton!
    let passwordTextField = UITextField()
    let confirmTextField = UITextField()
    let currentPwTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        let screenScale = view.frame.height / 568.0
        
        //add password textfield
        currentPwTextField.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (20/100), width: view.frame.width * (80/100), height: (view.frame.height) * (5/100))
        view.addSubview(currentPwTextField)
        currentPwTextField.borderStyle = UITextBorderStyle.roundedRect
        currentPwTextField.backgroundColor = UIColor.white
        currentPwTextField.font = UIFont.systemFont(ofSize: 18 * screenScale)
        currentPwTextField.returnKeyType = UIReturnKeyType.done
        currentPwTextField.placeholder = "Enter Current Password"
        currentPwTextField.adjustsFontSizeToFitWidth = true
        currentPwTextField.isSecureTextEntry = true
        self.currentPwTextField.delegate = self

        
        //add password textfield
        passwordTextField.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (30/100), width: view.frame.width * (80/100), height: (view.frame.height) * (5/100))
        view.addSubview(passwordTextField)
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.font = UIFont.systemFont(ofSize: 18 * screenScale)
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.placeholder = "New Password"
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.isSecureTextEntry = true
        self.passwordTextField.delegate = self
        
        //add password confirmation textfield
        confirmTextField.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (40/100), width: view.frame.width * (80/100), height: (view.frame.height) * (5/100))
        view.addSubview(confirmTextField)
        confirmTextField.borderStyle = UITextBorderStyle.roundedRect
        confirmTextField.backgroundColor = UIColor.white
        confirmTextField.font = UIFont.systemFont(ofSize: 18 * screenScale)
        confirmTextField.returnKeyType = UIReturnKeyType.done
        confirmTextField.placeholder = "Confirm New Password"
        confirmTextField.adjustsFontSizeToFitWidth = true
        confirmTextField.isSecureTextEntry = true
        self.confirmTextField.delegate = self
        
        
        //header
        let headerLabel = UILabel()
        headerLabel.frame =  CGRect(x: 0, y: (view.frame.width) * (4/100), width: view.frame.width , height: (view.frame.height) * (5/100))
        headerLabel.font = UIFont.systemFont(ofSize: 24 * screenScale)
        headerLabel.text = "Update Password"
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.white
        view.addSubview(headerLabel)
        
        let instLabel = UILabel()
        instLabel.frame =  CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (10/100), width: view.frame.width * (80/100), height: (view.frame.height) * (10/100))
        instLabel.font = UIFont.systemFont(ofSize: 14 * screenScale)
        instLabel.text = "Please enter your current password and your new password."
        instLabel.textColor = UIColor.white
        instLabel.lineBreakMode = .byWordWrapping
        instLabel.numberOfLines = 2
        view.addSubview(instLabel)
        
        
        //add login button
        let submitButton = UIButton()
        submitButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (50/100), width: view.frame.width * (80/100), height: (view.frame.height) * (6/100))
        submitButton.setTitle("Submit", for: UIControlState.normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        //loginButton.titleLabel?.minimumScaleFactor = 0.01;
        submitButton.titleLabel?.numberOfLines = 1;
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        submitButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping;
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 20 * screenScale)
        submitButton.addTarget(self, action: #selector(UpdatePassword.submitEmail(_:)), for: UIControlEvents.touchUpInside)
        submitButton.backgroundColor = UIColor.init(red: 0.0/255, green: 177.0/255, blue: 176.0/255, alpha: 1)
        submitButton.layer.cornerRadius = 4
        view.addSubview(submitButton)
        //loadEmails()
    }
    
    func submitEmail(_ sender: UIButton){
        if(passwordTextField.text == confirmTextField.text)
        {
            guard let password = confirmTextField.text else{
                print("Please enter valid email address")
                return
            }
            
            let user = FIRAuth.auth()?.currentUser
            // Get credential using current email and entered password
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: (user?.email)!, password: currentPwTextField.text!)
            user?.reauthenticate(with: credential, completion: { (error) in
                if error != nil{
                    print("I'm here")
                    let alert = UIAlertController(title: "Incorrect Password", message:"Your entered password was incorrect", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default))
                    self.present(alert, animated: true){}
                   //print(error)
                    return
                }
                else{
                    self.updatePassword(password: password)
                }
            })

            
            
        }
        else
        {
            let alert = UIAlertController(title: "Field Mismatch", message:"Your entered passwords do not match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true){}
            
        }
        
    }
    
    func updatePassword(password : String){
        // Create alert
        let alertConfirm = UIAlertController(title: "Confirmation", message: "Are you sure you would like to update your password?", preferredStyle: .alert)
        
        // Do nothing if we cancel
        let alertCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, delete the listing from the database
        let alertYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            FIRAuth.auth()?.currentUser?.updatePassword(password) { (error) in
                if error != nil{
                    print(error)
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        // Create alerts for each Firebase error
                        switch errCode {
                        // Operation not allowed
                        case .errorCodeOperationNotAllowed:
                            let alert = UIAlertController(title: "Failure to Submit", message:"Your sign in has been disabled by an administrator", preferredStyle: .alert)
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
                else {
                    let alertVC = UIAlertController(title: "Password Changed", message: "Your password has been successfully updated!", preferredStyle: .alert)
                    
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default){
                        (_) in
                        // Go back to login
                        self.backToAccount.sendActions(for: .touchUpInside)
                    }
                    alertVC.addAction(alertActionOkay)
                    self.present(alertVC, animated: true, completion: nil)
                }
                
            }
        }
        alertConfirm.addAction(alertCancel)
        alertConfirm.addAction(alertYes)
        self.present(alertConfirm, animated: true, completion: nil)
    }
    
    // Called when 'return' key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        // Set so that hitting return key advances to next field
        if textField == self.currentPwTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == self.passwordTextField {
            self.confirmTextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }

        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
