//
//  FirstViewController.swift
//  Ocha
//
//  Created by Talkov, Leah C on 10/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController, UIPickerViewDataSource,
UIPickerViewDelegate {
    
    //MARK: Outlet vars
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord1: UITextField!
    @IBOutlet weak var passWord2: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var email2: UITextField!
    @IBOutlet var userPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var typeOfUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userPicker.dataSource = self
        userPicker.delegate = self
        pickerData = ["Student", "Landlord"]
    }

    
    
    @IBAction func submitInfo(_ sender: UIButton) {
        //MARK: send these to database
        
        var firstNameVar = firstName.text
        var lastNameVar = lastName.text
        var userNameVar = userName.text
        var passWord1Var = passWord1.text
        var passWord2Var = passWord2.text
        var emailVar = email.text
        var email2Var = email2.text
        
        // Only if emails are the same and passwords are same
        if email.text == email2.text && passWord1.text == passWord2.text
        {
            guard let email = email2.text, let password = passWord2.text, let name = firstName.text else{
                print("Form is not valid")
                return
            }
            // Create user in Firebase
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user:FIRUser?, error) in
                if error != nil{
                    print(error)
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
                let values = ["name": fullname, "email": email]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
                    if err != nil{
                        print(err)
                        return
                    }
                    print("Saved user successfully")
                })
            })
            
        }
        else{
            let alertVC = UIAlertController(title: "Error", message: "Check that your email and password were typed correctly", preferredStyle: .alert)
            
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



}

