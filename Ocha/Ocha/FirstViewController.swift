//
//  FirstViewController.swift
//  Ocha
//
//  Created by Taylor, Scott A on 10/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord1: UITextField!
    
    @IBOutlet weak var passWord2: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var email2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    @IBAction func submitInfo(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        defaults.set(firstName.text, forKey: "firstName")
        defaults.set(lastName.text, forKey: "lastName")
        defaults.set(userName.text, forKey: "userName")
        defaults.set(passWord1.text, forKey: "passWord1")
        defaults.set(passWord2.text, forKey: "passWord2")
        defaults.set(email.text, forKey: "email")
        defaults.set(email2.text, forKey: "email2")
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

