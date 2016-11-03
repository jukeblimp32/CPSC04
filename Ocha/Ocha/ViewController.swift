//
//  ViewController.swift
//  Ocha
//
//  Created by Talkov, Leah C on 10/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    
    
    
    @IBOutlet var appTitle: UILabel!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let fbloginButton = FBSDKLoginButton()
        view.addSubview(fbloginButton)
        fbloginButton.frame = CGRect(x: 94, y: 400, width: 203, height: 50)
        fbloginButton.delegate = self
        fbloginButton.readPermissions = ["email"]
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        showEmailAddress()
        print("Successfully logged in with Facebook...")
    }
    
    func showEmailAddress(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessTokenString))
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start{(connection, result, err) in
            
            if err != nil{
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }
    }
    
    
    
    @IBAction func submitUserInfo(_ sender: UIButton) {
        
        
        //MARK: Send these to database
        var userNameVar = userName.text
        
        var passWordVar = passWord.text
        
        appTitle.text = userNameVar
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
