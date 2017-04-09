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
    @IBOutlet weak var backToLogin: UIButton!
    
    
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
        
        backToLogin.frame = CGRect(x: 0, y: (view.frame.width) * (5/100), width: view.frame.width * (18/100), height: (view.frame.height) * (5/100))
        view.addSubview(backToLogin)
        
        //header
        let headerLabel = UILabel()
        headerLabel.frame =  CGRect(x: 0, y: (view.frame.width) * (4/100), width: view.frame.width , height: (view.frame.height) * (5/100))
        headerLabel.font = UIFont.systemFont(ofSize: 24 * screenScale)
        headerLabel.text = "Reset Password"
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.white
        view.addSubview(headerLabel)
        
        let instLabel = UILabel()
        instLabel.frame =  CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (10/100), width: view.frame.width * (80/100), height: (view.frame.height) * (10/100))
        instLabel.font = UIFont.systemFont(ofSize: 14 * screenScale)
        instLabel.text = "Please enter the email address that you registered with Ocha."
        instLabel.textColor = UIColor.white
        instLabel.lineBreakMode = .byWordWrapping
        instLabel.numberOfLines = 2
        view.addSubview(instLabel)

        let submitButton = UIButton()
        submitButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (30/100), width: view.frame.width * (80/100), height: (view.frame.height) * (6/100))
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
        loadEmails()

    }
    
    @IBAction func backToLogin(_ sender: Any) {
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController()! as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
    }


    func loadEmails(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let fbUser = FireUser()
                fbUser.name = dictionary["name"] as! String?
                fbUser.email = dictionary["email"] as! String?
                fbUser.type = dictionary["type"] as! String?
                fbUser.fbId = snapshot.key
                self.emailList.append(fbUser.fbId!)
                
            }
        }, withCancel: nil)


    }
    
    func submitEmail(_ sender: UIButton){
        print("Here we go")
        print(emailTextField.text)
        guard let email = emailTextField.text else{
            print("Please enter valid email address")
            return
        }
        loadEmails()
        print(emailList)
        
        //if (emailList.contains(email))
        //{
            // Create alert
            let alertConfirm = UIAlertController(title: "Confirmation", message: "Are you sure you would like to send a reset email to \(email)?", preferredStyle: .alert)
            
            // Do nothing if we cancel
            let alertCancel = UIAlertAction(title: "Cancel", style: .default) {
                (_) in
                return
            }
            // If yes, delete the listing from the database
            let alertYes = UIAlertAction(title: "Yes", style: .default){
                (_) in
                FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
                    if error != nil{
                        print(error)
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                            // Create alerts for each Firebase error
                            switch errCode {
                            // Operation not allowed
                            case .errorCodeInvalidEmail:
                                let alert = UIAlertController(title: "Failure to Submit", message:"The email you entered is badly formatted. Cannot reset password.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                                self.present(alert, animated: true){}
                            // Too short of password
                            case .errorCodeUserNotFound:
                                let alert = UIAlertController(title: "Failure to Submit", message:"The email entered does not match any registered with Ocha. Please enter a valid email.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                                self.present(alert, animated: true){}
                                
                            // Miscellaneous errors
                            default:
                                let alert = UIAlertController(title: "Failure to Submit", message:"Make sure the email you entered is valid", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                                self.present(alert, animated: true){}
                            }
                        }
                        return
                    }
                    else if ((email != "") && (email != " ")){
                        let alertVC = UIAlertController(title: "Email Sent", message: "Check your email to reset your password. IF USING ZAGMAIL, CHECK YOUR SPAM FOLDER", preferredStyle: .alert)
                        
                        let alertActionOkay = UIAlertAction(title: "Okay", style: .default){
                            (_) in
                            // Go back to login
                            self.backToLogin.sendActions(for: .touchUpInside)
                        }
                        alertVC.addAction(alertActionOkay)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }

            }
            alertConfirm.addAction(alertCancel)
            alertConfirm.addAction(alertYes)
            self.present(alertConfirm, animated: true, completion: nil)
        /*}
        else
        {
            let alert = UIAlertController(title: "Email Not Found", message:"The email you entered is not registered with Ocha. Please enter a registered email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true){}

        } */

    }
    
    // Called when 'return' key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        textField.resignFirstResponder()
        return true
    }


}
