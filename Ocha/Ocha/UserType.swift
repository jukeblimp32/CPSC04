//
//  UserType.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/6/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class UserType: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Title
        let appTitle = UILabel()
        appTitle.text = "What Type Of User Are You?"
        appTitle.font = UIFont(name: appTitle.font.fontName, size: 33)
        appTitle.textColor = UIColor.white
        appTitle.textAlignment = .center
        appTitle.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (10/100), width: view.frame.width * (80/100), height: 200)
        appTitle.numberOfLines = 2
        view.addSubview(appTitle)
        
        //Student user button
        let studentButton = UIButton()
        studentButton.frame = CGRect(x: (view.frame.width) * (25/100), y: (view.frame.height) * (40/100), width: view.frame.width * (50/100), height: 50)
        studentButton.setTitle("Student", for: UIControlState.normal)
        studentButton.titleLabel?.font = UIFont(name: appTitle.font.fontName, size: 33)
        studentButton.setTitleColor(UIColor.white, for: .normal)
        studentButton.addTarget(self, action: #selector(UserType.choseStudentUser(_:)), for: UIControlEvents.touchUpInside)
        studentButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        studentButton.layer.cornerRadius = 4
        view.addSubview(studentButton)
        self.view.addSubview(studentButton)
        
        //Landlord user button
        let landlordButton = UIButton()
        landlordButton.frame = CGRect(x: (view.frame.width) * (25/100), y: (view.frame.height) * (55/100), width: view.frame.width * (50/100), height: 50)
        landlordButton.setTitle("Landlord", for: UIControlState.normal)
        landlordButton.titleLabel?.font = UIFont(name: appTitle.font.fontName, size: 33)
        landlordButton.setTitleColor(UIColor.white, for: .normal)
        landlordButton.addTarget(self, action: #selector(UserType.choseLandlordUser(_:)), for: UIControlEvents.touchUpInside)
        landlordButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        landlordButton.layer.cornerRadius = 4
        view.addSubview(landlordButton)
        self.view.addSubview(landlordButton)
        
    }
    
    
    func choseStudentUser(_ sender : UIButton) {
        
    
        let uid = FIRAuth.auth()?.currentUser?.uid
        let dataRef = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
        let usersReference = dataRef.child("users").child(uid!)
        let values = ["type" : "Student"]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
            if err != nil{
                print(err)
                return
            }
            print("Saved user successfully")
        })
    
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "StudentTabController") as UIViewController
        self.dismiss(animated: true, completion: nil)
        self.present(viewController, animated: true, completion: nil)


    }
    
    
    func choseLandlordUser(_ sender : UIButton) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let dataRef = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
        let usersReference = dataRef.child("users").child(uid!)
        let values = ["type" : "Landlord"]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
            if err != nil{
                print(err)
                return
            }
            print("Saved user successfully")
        })
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "LandlordTabController") as UIViewController
        self.dismiss(animated: true, completion: nil)
        self.present(viewController, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
