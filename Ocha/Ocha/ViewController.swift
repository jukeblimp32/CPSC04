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
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var errorOutput: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Create actual Facebook button
        let fbloginButton = FBSDKLoginButton()
        view.addSubview(fbloginButton)
        fbloginButton.frame = CGRect(x: (view.frame.width) / 4, y: (view.frame.height) * (55/100), width: (view.frame.width) / 2, height: 50)
        fbloginButton.delegate = self
        fbloginButton.readPermissions = ["email"]
        
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: (view.frame.width) / 4, y: (view.frame.height) * (65/100), width: view.frame.width / 2, height: 50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        fbLogin()
        print("Successfully logged in with Facebook...")
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectType") as UIViewController
        self.dismiss(animated: true, completion: nil)
        self.present(viewController, animated: true, completion: nil)
    }
    
    func fbLogin(){
        // Login with FB credentials
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
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            
            // Add new user to Firebase database
            let data:[String:AnyObject] = result as! [String : AnyObject]
            let dataRef = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
            let usersReference = dataRef.child("users").child(uid)
            let values = ["name": data["name"], "email": data["email"]]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
                if err != nil{
                    print(err)
                    return
                }
                print("Saved user successfully")
            })

            
            //access individual values
            //print(result ?? "")
            //let data:[String:AnyObject] = result as! [String : AnyObject]
            //print(data["name"]!)
        }

    }
    
    
    
    @IBAction func submitUserInfo(_ sender: UIButton) {
        
        
        //MARK: Send these to database
        var userNameVar = email.text
        
        var passWordVar = passWord.text
        
        // Login with email and password
        handleLogin()
        //var alert = UIAlertController(title: "Could not login", message: "Your password or email are incorrect", preferredStyle: UIAlertControllerStyle.alert)
        //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //alert.show(self, sender: self)
        //errorOutput.text = "Incorrect Email or Password"
        
    }
    
    func handleLogin() {
        guard let email = email.text, let password = passWord.text else{
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                let alertVC = UIAlertController(title: "Can't Login", message: "Incorrect email or password", preferredStyle: .alert)
                let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
                alertVC.addAction(alertActionOkay)
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            
            // Signed in
            if let user = FIRAuth.auth()?.currentUser {
                if user.isEmailVerified{
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            if dictionary["type"]as? String  == "Admin" {
                                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "AdminTabController") as UIViewController
                                self.dismiss(animated: true, completion: nil)
                                self.present(viewController, animated: true, completion: nil)
                            }
                            else if dictionary["type"] as? String == "Landlord" {
                                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "LandlordTabController") as UIViewController
                                self.dismiss(animated: true, completion: nil)
                                self.present(viewController, animated: true, completion: nil)
                            }
                            else {
                                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "StudentTabController") as UIViewController
                                self.dismiss(animated: true, completion: nil)
                                self.present(viewController, animated: true, completion: nil)
                            }
                        }
                    }, withCancel: nil)

                }
                else {
                    let alertVC = UIAlertController(title: "Verify Email", message: "Your email has not yet been verified. Check your email for verification or register an account", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
                    alertVC.addAction(alertActionOkay)
                    self.present(alertVC, animated: true, completion: nil)
                }

            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
