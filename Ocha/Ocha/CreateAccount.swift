//
//  FirstViewController.swift
//  Ocha
//
//  Created by Talkov, Leah C on 10/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController{
    
    //MARK: Outlet vars
    let firstName = UITextField()
    let lastName = UITextField()
    let userName = UITextField()
    let passWord1 = UITextField()
    let passWord2 = UITextField()
    let email = UITextField()
    let email2 = UITextField()
    
    let studentUserButton = UIButton()
    let landlordUserButton = UIButton()
    var userType: Int!
    var userTypes: Array<UIButton> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        userType = 1
        
        userTypes = [studentUserButton, landlordUserButton]
        
        //View title
        let viewTitle = UILabel()
        viewTitle.text = "Create An Account"
        viewTitle.font = UIFont(name: viewTitle.font.fontName, size: 20)
        viewTitle.textColor = UIColor.white
        viewTitle.frame = CGRect(x: (view.frame.width) * (27.5/100), y: (view.frame.height) * (13/100), width: view.frame.width * (45/100), height: 20)
        view.addSubview(viewTitle)
  
        //First name label
        let firstNameLabel = UILabel()
        firstNameLabel.text = "First Name:"
        firstNameLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        firstNameLabel.textColor = UIColor.white
        firstNameLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (20/100), width: view.frame.width / 2, height: 15)
        view.addSubview(firstNameLabel)
        
        //Last name label
        let lastNameLabel = UILabel()
        lastNameLabel.text = "Last Name:"
        lastNameLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        lastNameLabel.textColor = UIColor.white
        lastNameLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (27/100), width: view.frame.width / 2, height: 15)
        view.addSubview(lastNameLabel)
        
        //Username label
        let usernameLabel = UILabel()
        usernameLabel.text = "Username:"
        usernameLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        usernameLabel.textColor = UIColor.white
        usernameLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (34/100), width: view.frame.width / 2, height: 15)
        view.addSubview(usernameLabel)
        
        //Password label
        let passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        passwordLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        passwordLabel.textColor = UIColor.white
        passwordLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (41/100), width: view.frame.width / 2, height: 15)
        view.addSubview(passwordLabel)
        
        //Confirm Password Label
        let confirmPasswordLabel = UILabel()
        confirmPasswordLabel.text = "Confirm Password:"
        confirmPasswordLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        confirmPasswordLabel.textColor = UIColor.white
        confirmPasswordLabel.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (48/100), width: view.frame.width / 2, height: 15)
        view.addSubview(confirmPasswordLabel)
        
        //Email Label
        let emailLabel = UILabel()
        emailLabel.text = "Email:"
        emailLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        emailLabel.textColor = UIColor.white
        emailLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (55/100), width: view.frame.width / 2, height: 15)
        view.addSubview(emailLabel)
        
        //Confirm email label
        let confirmEmailLabel = UILabel()
        confirmEmailLabel.text = "Confirm Email:"
        confirmEmailLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        confirmEmailLabel.textColor = UIColor.white
        confirmEmailLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (62/100), width: view.frame.width / 2, height: 15)
        view.addSubview(confirmEmailLabel)
        
        //Type of User label
        let userTypeLabel = UILabel()
        userTypeLabel.text = "Select Type Of User:"
        userTypeLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        userTypeLabel.textColor = UIColor.white
        userTypeLabel.frame = CGRect(x: (view.frame.width) / 8, y: (view.frame.height) * (69/100), width: view.frame.width / 2, height: 15)
        view.addSubview(userTypeLabel)
        
        //
        firstName.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (20/100), width: view.frame.width * 0.4, height: 25)
        view.addSubview(firstName)
        firstName.borderStyle = UITextBorderStyle.roundedRect
        firstName.backgroundColor = UIColor.white
        
        lastName.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (27/100), width: view.frame.width * 0.4, height: 25)
        view.addSubview(lastName)
        lastName.borderStyle = UITextBorderStyle.roundedRect
        lastName.backgroundColor = UIColor.white
        
        userName.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (34/100), width: view.frame.width * 0.4, height: 25)
        view.addSubview(userName)
        userName.borderStyle = UITextBorderStyle.roundedRect
        userName.backgroundColor = UIColor.white
        
        passWord1.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (41/100), width: view.frame.width * 0.4, height: 25)
        view.addSubview(passWord1)
        passWord1.borderStyle = UITextBorderStyle.roundedRect
        passWord1.backgroundColor = UIColor.white
        passWord1.isSecureTextEntry = true
        
        passWord2.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (48/100), width: view.frame.width * 0.4, height: 25)
        view.addSubview(passWord2)
        passWord2.borderStyle = UITextBorderStyle.roundedRect
        passWord2.backgroundColor = UIColor.white
        passWord2.isSecureTextEntry = true
        
        email.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (55/100), width: view.frame.width * 0.4, height: 25)
        view.addSubview(email)
        email.borderStyle = UITextBorderStyle.roundedRect
        email.backgroundColor = UIColor.white
        
        email2.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (62/100), width: view.frame.width * 0.4, height: 25)
        view.addSubview(email2)
        email2.borderStyle = UITextBorderStyle.roundedRect
        email2.backgroundColor = UIColor.white
        
        
        //Landlord button
        landlordUserButton.frame = CGRect(x: (view.frame.width) / 2, y: (view.frame.height) * (75/100), width: view.frame.width * (1/3), height: 50)
        landlordUserButton.setTitle("Landlord", for: UIControlState.normal)
        landlordUserButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        landlordUserButton.backgroundColor = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 0.2)
        landlordUserButton.setTitleColor(UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2), for: .normal)
        landlordUserButton.addTarget(self, action: #selector(FirstViewController.chooseUser(_:)), for: UIControlEvents.touchUpInside)
        landlordUserButton.layer.cornerRadius = 4
        view.addSubview(landlordUserButton)
        self.view.addSubview(landlordUserButton)
        
        //Student button
        studentUserButton.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (75/100), width: view.frame.width * (1/3), height: 50)
        studentUserButton.setTitle("Student", for: UIControlState.normal)
        studentUserButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        studentUserButton.backgroundColor = UIColor.white
        studentUserButton.setTitleColor(UIColor.black, for: .normal)
        studentUserButton.addTarget(self, action: #selector(FirstViewController.chooseUser(_:)), for: UIControlEvents.touchUpInside)
        studentUserButton.layer.cornerRadius = 4
        view.addSubview(studentUserButton)
        self.view.addSubview(studentUserButton)
        
        //Submit button
        let submitButton = UIButton()
        submitButton.frame = CGRect(x: (view.frame.width) * (2/3), y: (view.frame.height) * (90/100), width: view.frame.width * (1/4), height: 30)
        submitButton.setTitle("Submit", for: UIControlState.normal)
        submitButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        submitButton.titleLabel?.textColor = UIColor.white
        submitButton.addTarget(self, action: #selector(FirstViewController.submitInfo(_:)), for: UIControlEvents.touchUpInside)
        submitButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        submitButton.layer.cornerRadius = 4
        view.addSubview(submitButton)
        self.view.addSubview(submitButton)

        //Back button
        let toHomePageButton = UIButton()
        toHomePageButton.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (5/100), width: view.frame.width / 5 , height: 30)
        toHomePageButton.setTitle("Back", for: UIControlState.normal)
        toHomePageButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        toHomePageButton.addTarget(self, action: #selector(FirstViewController.backToMain(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(toHomePageButton)
        self.view.addSubview(toHomePageButton)
    }

    
    
    
    
    
    
    @IBAction func backToMain(_ sender: Any) {
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController()! as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
    }
    
    @IBAction func chooseUser(_ sender: UIButton) {
        for button in userTypes {
            if button == sender {
                userType = button.tag
                button.backgroundColor = UIColor.white
                button.setTitleColor(UIColor.black, for: .normal)
            }
            else {
                button.backgroundColor = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 0.2)
                button.titleLabel?.textColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
            }
        }
    }

    
    
    @IBAction func submitInfo(_ sender: UIButton) {
        //MARK: send these to database
        
        // Only if emails are the same and passwords are same
        if email.text == email2.text && passWord1.text == passWord2.text
        {
            guard let email = email2.text, let password = passWord2.text, let name = firstName.text else{
                print("Form is not valid")
                return
            }
            
            if firstName.text == "" || lastName.text == "" || userName.text == ""
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
                if self.userType == 1 {
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
    
    func backToLogin(_ sender : UIButton) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.dismiss(animated: true, completion: nil)
        self.present(viewController, animated: true, completion: nil)
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
    
   
    /*
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String! {
        return pickerData[row]
        
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeOfUser = pickerData[row]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/


}

