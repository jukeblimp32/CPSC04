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

class ViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        UITabBar.appearance().tintColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Create actual Facebook button
        let fbloginButton = FBSDKLoginButton()
        view.addSubview(fbloginButton)
<<<<<<< HEAD
        fbloginButton.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (75/100), width: (view.frame.width) * (60/100), height: 50)
=======
        fbloginButton.frame = CGRect(x: (view.frame.width) / 4, y: (view.frame.height) * (75/100), width: (view.frame.width) / 2, height: (view.frame.height) * 0.07)
>>>>>>> a10eff0af533cb38ea7ae38c5c92fa37fd460e46
        fbloginButton.delegate = self
        fbloginButton.readPermissions = ["email"]
        
        //add google sign in button
        let googleButton = GIDSignInButton()
<<<<<<< HEAD
        googleButton.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (85/100), width: view.frame.width * (60/100), height: 50)
=======
        googleButton.frame = CGRect(x: (view.frame.width) / 4, y: (view.frame.height) * (85/100), width: view.frame.width / 2, height: (view.frame.height) * 0.07)
>>>>>>> a10eff0af533cb38ea7ae38c5c92fa37fd460e46
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let divisorLine = UIView()
        divisorLine.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (70/100), width: (view.frame.width) * (25/100), height: 2)
        divisorLine.backgroundColor = UIColor.white
        view.addSubview(divisorLine)
        
        let divisorLine2 = UIView()
        divisorLine2.frame = CGRect(x: (view.frame.width) * (65/100), y: (view.frame.height) * (70/100), width: (view.frame.width) * (25/100), height: 2)
        divisorLine2.backgroundColor = UIColor.white
        view.addSubview(divisorLine2)
        
        
        //add title
        let appTitle = UILabel()
        appTitle.text = "OCHA"
        appTitle.font = UIFont(name: appTitle.font.fontName, size: 33)
        appTitle.textColor = UIColor.white
        appTitle.textAlignment = .center
        appTitle.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (2/100), width: view.frame.width * (80/100), height: 200)
        view.addSubview(appTitle)
        
        let orTitle = UILabel()
        orTitle.text = "OR"
        orTitle.font = UIFont(name: appTitle.font.fontName, size: 20)
        orTitle.textColor = UIColor.white
        orTitle.textAlignment = .center
        orTitle.frame = CGRect(x: (view.frame.width) * (40/100), y: (view.frame.height) * (70/100), width: view.frame.width * (20/100), height: 20)
        view.addSubview(orTitle)
        
        //add email label
        let emailLabel = UILabel()
        emailLabel.text = "Email:"
        emailLabel.font = UIFont(name: appTitle.font.fontName, size: 17)
        emailLabel.textColor = UIColor.white
        emailLabel.frame = CGRect(x: (view.frame.width) / 7, y: (view.frame.height) * (30/100), width: view.frame.width / 6, height: 15)
        view.addSubview(emailLabel)
        
        //add password label
        let passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        passwordLabel.font = UIFont(name: appTitle.font.fontName, size: 17)
        passwordLabel.textColor = UIColor.white
        passwordLabel.frame = CGRect(x: (view.frame.width) / 7, y: (view.frame.height) * (40/100), width: view.frame.width / 3, height: 15)
        view.addSubview(passwordLabel)
        
        //add password label
        let orLabel = UILabel()
        orLabel.text = "OR"
        orLabel.textAlignment = .center
        orLabel.adjustsFontSizeToFitWidth = true
        orLabel.minimumScaleFactor = 0.5
        orLabel.textColor = UIColor.white
        orLabel.frame = CGRect(x: (view.frame.width) / 4, y: (view.frame.height) * (70/100), width: view.frame.width / 2, height: 15)
        view.addSubview(orLabel)

        
        
        //add email textfield
        emailTextField.frame = CGRect(x: (view.frame.width) / 2.4, y: (view.frame.height) * (30/100), width: view.frame.width / 2, height: 25)
        view.addSubview(emailTextField)
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        emailTextField.backgroundColor = UIColor.white
        // Add these lines to dismiss the keyboard by clicking done
        emailTextField.returnKeyType = UIReturnKeyType.done
        self.emailTextField.delegate = self
        
        //add password textfield
        passwordTextField.frame = CGRect(x: (view.frame.width) / 2.4, y: (view.frame.height) * (40/100), width: view.frame.width / 2, height: 25)
        view.addSubview(passwordTextField)
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = UIReturnKeyType.done
        self.passwordTextField.delegate = self
        
        
        //add login button
        let loginButton = UIButton()
<<<<<<< HEAD
        loginButton.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (50/100), width: view.frame.width * (60/100), height: 40)
=======
        loginButton.frame = CGRect(x: (view.frame.width) / 4, y: (view.frame.height) * (50/100), width: (view.frame.width) / 2, height: (view.frame.height) * 0.07)
>>>>>>> a10eff0af533cb38ea7ae38c5c92fa37fd460e46
        loginButton.setTitle("Login", for: UIControlState.normal)
        loginButton.titleLabel?.font = UIFont(name: appTitle.font.fontName, size: 20)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(ViewController.submitUserInfo(_:)), for: UIControlEvents.touchUpInside)
        loginButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        loginButton.layer.cornerRadius = 4
        view.addSubview(loginButton)
        self.view.addSubview(loginButton)
        
        
         //add create account button
        let createAccountButton = UIButton()
<<<<<<< HEAD
        createAccountButton.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (60/100), width: view.frame.width * (60/100), height: 40)
=======
        createAccountButton.frame = CGRect(x: (view.frame.width) / 4, y: (view.frame.height) * (60/100), width: (view.frame.width) / 2, height: (view.frame.height) * 0.07)
>>>>>>> a10eff0af533cb38ea7ae38c5c92fa37fd460e46
        createAccountButton.setTitle("Create An Account", for: UIControlState.normal)
        // Dynamically change size of font to fit screen
        createAccountButton.titleLabel?.adjustsFontSizeToFitWidth = true
        createAccountButton.titleLabel?.minimumScaleFactor=0.5
        createAccountButton.setTitleColor(UIColor.white, for: .normal)
        createAccountButton.addTarget(self, action: #selector(ViewController.goToCreateAccount(_:)), for: UIControlEvents.touchUpInside)
        createAccountButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        createAccountButton.layer.cornerRadius = 4
        view.addSubview(createAccountButton)
        self.view.addSubview(createAccountButton)
        
    }
 
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func goToCreateAccount(_ sender : UIButton) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CreateAccount") as UIViewController
        self.dismiss(animated: true, completion: nil)
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        
        
        fbLogin()
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
        
            // Get the proper info from Facebook
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start{(connection, result, err) in
            
                if err != nil{
                    print("Failed to start graph request:", err ?? "")
                    return
                }
            
                guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                    return
                }
            
                // Get a reference to the Firebase database
                let data:[String:AnyObject] = result as! [String : AnyObject]
                let dataRef = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
                let usersReference = dataRef.child("users").child(uid)
            
           
                // See if an instance of the user already exists
                usersReference.observeSingleEvent(of: .value, with: {(snapshot) in
                    let snapshot = snapshot.value as? NSDictionary
                    // Only add user if this is first login
                    if(snapshot == nil)
                    {
                        let values = ["name": data["name"], "email": data["email"]]
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
                            if err != nil{
                                print(err)
                                return
                            }
                            print("Saved user successfully")
                        })
                        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectType") as UIViewController
                        self.dismiss(animated: true, completion: nil)
                        self.present(viewController, animated: true, completion: nil)
                    }
                    else
                    {
                        self.goToHomePage(snapshot: snapshot!)
                    }
                })
                print("Successfully logged in with Facebook...")
            }
        })

    }
    
    func goToHomePage(snapshot: NSDictionary)
    {
        if snapshot["type"]as? String  == "Admin" {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "AdminTabController") as UIViewController
            self.dismiss(animated: true, completion: nil)
            self.present(viewController, animated: true, completion: nil)
        }
        else if snapshot["type"] as? String == "Landlord" {
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
    
    
    
    @IBAction func submitUserInfo(_ sender: UIButton) {
        
        // Login with email and password
        handleLogin()

        
    }
    
    func handleLogin() {
        
        print("here")
        guard let email = emailTextField.text, let password = passwordTextField.text else{
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
            print("now signed in")
            
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
    
    // Called when 'return' key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
