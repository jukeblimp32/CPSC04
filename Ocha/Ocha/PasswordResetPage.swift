//
//  PasswordResetPage.swift
//  Ocha
//
//  Created by Taylor, Scott A on 4/6/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import Foundation
import Firebase



class PasswordResetPage: UIViewController, UITextFieldDelegate{
    // Email textfield
    let emailTextField = UITextField()
    var emailList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        let screenScale = view.frame.height / 568.0

        //add email textfield
        emailTextField.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (20/100), width: view.frame.width * (80/100), height: (view.frame.height) * (5/100))
        view.addSubview(emailTextField)
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        emailTextField.backgroundColor = UIColor.white
        emailTextField.font = UIFont.systemFont(ofSize: 18 * screenScale)
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.placeholder = "Email address"
        emailTextField.adjustsFontSizeToFitWidth = true
        self.emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        //add login button
        let submitButton = UIButton()
        submitButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (45/100), width: view.frame.width * (80/100), height: (view.frame.height) * (6/100))
        submitButton.setTitle("Submit", for: UIControlState.normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        //loginButton.titleLabel?.minimumScaleFactor = 0.01;
        submitButton.titleLabel?.numberOfLines = 1;
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        submitButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping;
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 20 * screenScale)
        submitButton.addTarget(self, action: #selector(PasswordResetPage.submitEmail(_:)), for: UIControlEvents.touchUpInside)
        submitButton.backgroundColor = UIColor.init(red: 0.0/255, green: 177.0/255, blue: 176.0/255, alpha: 1)
        submitButton.layer.cornerRadius = 4
        view.addSubview(submitButton)

    }
    
    /*func loadEmails(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
     
                self.emailList.append(dictionary["email"] as! String?)
            }
        }, withCancel: nil)
    } */
    
    func submitEmail(_ sender: UIButton){
        print("Here we go")
        print(emailTextField.text)
        guard let email = emailTextField.text else{
            print("Please enter valid email address")
            return
        }

        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
            if error != nil{
                print(error)
                return
            }
        }
    }
    
    // Called when 'return' key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        textField.resignFirstResponder()
        return true
    }


}
