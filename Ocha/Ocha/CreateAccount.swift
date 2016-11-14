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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord1: UITextField!
    @IBOutlet weak var passWord2: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var email2: UITextField!
    var userType: Int!
    
    
    @IBOutlet var userTypes: [UIButton]!
    
    //@IBOutlet var userPicker: UIPickerView!
    
    //var pickerData: [String] = [String]()
    //var typeOfUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in userTypes {
            button.backgroundColor = UIColor.white
        }
        userType = 1

        // Do any additional setup after loading the view, typically from a nib.
        /*
        userPicker.dataSource = self
        userPicker.delegate = self
        pickerData = ["Student", "Landlord"]
 */
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
                button.titleLabel?.textColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
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
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login") as UIViewController
                
                // Delay so that the presentation won't collide with the email alert
                let when = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    self.dismiss(animated: true, completion: nil)
                    self.present(viewController, animated: true, completion: nil)
                }
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
        //titleLabel.text = firstNameVar
        
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
                }
                let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
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

