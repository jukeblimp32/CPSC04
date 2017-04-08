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
        // Get a scale based on iPhone 5
        let screenScale = view.frame.height / 568.0

        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Create actual Facebook button
        let fbloginButton = FBSDKLoginButton()
        view.addSubview(fbloginButton)
        fbloginButton.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (75/100), width: (view.frame.width) * (60/100), height: (view.frame.height) * (6/100))
        fbloginButton.delegate = self
        fbloginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20 * screenScale)
        fbloginButton.readPermissions = ["email"]
        
        //add google sign in button
        //let googleButton = GIDSignInButton()
        let googleButton = UIButton()
        googleButton.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (85/100), width: view.frame.width * (60/100), height: (view.frame.height) * (6/100))
        googleButton.setImage(UIImage(named: "google1.png"), for: UIControlState.normal)
        //googleButton.contentMode = UIViewContentMode.scaleToFill
        googleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 7 * screenScale, 0, 0)
        googleButton.setTitle("Sign in", for: UIControlState.normal)
        googleButton.titleEdgeInsets = UIEdgeInsetsMake(0, (googleButton.frame.width / 4) - (20 * screenScale) / 2, 0, 0);
        googleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        googleButton.setTitleColor(UIColor.black, for: .normal)
        googleButton.titleLabel?.font = UIFont.systemFont(ofSize: 20 * screenScale)
        googleButton.backgroundColor = UIColor.white
        googleButton.addTarget(self, action: #selector(ViewController.googleLogin), for: UIControlEvents.touchUpInside)
        view.addSubview(googleButton)
        //GIDSignIn.sharedInstance().uiDelegate = self
        
        let divisorLine = UIView()
        divisorLine.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (70/100), width: (view.frame.width) * (25/100), height: 2)
        divisorLine.backgroundColor = UIColor.white
        view.addSubview(divisorLine)
        
        let divisorLine2 = UIView()
        divisorLine2.frame = CGRect(x: (view.frame.width) * (65/100), y: (view.frame.height) * (70/100), width: (view.frame.width) * (25/100), height: 2)
        divisorLine2.backgroundColor = UIColor.white
        view.addSubview(divisorLine2)
        
        //add logo
        let imageName = "Logo.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: (view.frame.width) * (15/100), y: (view.frame.height) * (2/100), width: view.frame.width * (70/100), height: (view.frame.height) * (20/100))
        view.addSubview(imageView)
        
        // forgot password?
        let recoverLabel = UILabel()
        recoverLabel.attributedText = NSAttributedString(string: "Forgot password?", attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        recoverLabel.font = UIFont.systemFont(ofSize: 14 * screenScale)
        recoverLabel.textColor = UIColor.init(red: 0.0/255, green: 177.0/255, blue: 176.0/255, alpha: 1)
        let width = recoverLabel.intrinsicContentSize.width
        recoverLabel.frame = CGRect(x: (view.frame.width) / 2 - (width / 2), y: (view.frame.height) * (54/100), width: view.frame.width / 2, height: 14 * screenScale)
        //recoverLabel.textAlignment = .center
        recoverLabel.sizeToFit()
        recoverLabel.isUserInteractionEnabled = true
        recoverLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.resetPassword)))
        view.addSubview(recoverLabel)

        
        //add email label
        let emailLabel = UILabel()
        emailLabel.text = "Email:"
        //emailLabel.font = UIFont(name: emailLabel.font.fontName, size: 17)
        emailLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        emailLabel.textColor = UIColor.white
        emailLabel.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (23/100), width: view.frame.width / 6, height: 20 * screenScale)
        view.addSubview(emailLabel)
        
        //add password label
        let passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        passwordLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        passwordLabel.textColor = UIColor.white
        passwordLabel.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (33/100), width: view.frame.width / 3, height: 20 * screenScale)
        view.addSubview(passwordLabel)
        
        //add OR label
        let orLabel = UILabel()
        orLabel.text = "OR"
        orLabel.textAlignment = .center
        orLabel.adjustsFontSizeToFitWidth = true
        orLabel.minimumScaleFactor = 0.5
        orLabel.font = UIFont.systemFont(ofSize: 20 * screenScale)
        orLabel.textColor = UIColor.white
        let orOffset = (20 * screenScale) / 2
        orLabel.frame = CGRect(x: (view.frame.width) / 4, y: (view.frame.height) * (70/100) - orOffset, width: view.frame.width / 2, height: 20 * screenScale)
        view.addSubview(orLabel)

        
        
        //add email textfield
        emailTextField.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (26/100), width: view.frame.width * (60/100), height: (view.frame.height) * (5/100))
        view.addSubview(emailTextField)
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        emailTextField.backgroundColor = UIColor.white
        // Add these lines to dismiss the keyboard by clicking done
        emailTextField.font = UIFont.systemFont(ofSize: 18 * screenScale)
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.adjustsFontSizeToFitWidth = true
        self.emailTextField.delegate = self
        
        //add password textfield
        passwordTextField.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (36/100), width: view.frame.width * (60/100), height: (view.frame.height) * (5/100))
        view.addSubview(passwordTextField)
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = UIFont.systemFont(ofSize: 18 * screenScale)
        passwordTextField.returnKeyType = UIReturnKeyType.done
        self.passwordTextField.delegate = self
        
        //add login button
        let loginButton = UIButton()
        loginButton.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (45/100), width: view.frame.width * (60/100), height: (view.frame.height) * (6/100))
        loginButton.setTitle("Login", for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        //loginButton.titleLabel?.minimumScaleFactor = 0.01;
        loginButton.titleLabel?.numberOfLines = 1;
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        loginButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping;
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20 * screenScale)
        loginButton.addTarget(self, action: #selector(ViewController.submitUserInfo(_:)), for: UIControlEvents.touchUpInside)
        loginButton.backgroundColor = UIColor.init(red: 0.0/255, green: 177.0/255, blue: 176.0/255, alpha: 1)
        loginButton.layer.cornerRadius = 4
        view.addSubview(loginButton)
        self.view.addSubview(loginButton)
        
        
         //add create account button
        let createAccountButton = UIButton()
        createAccountButton.frame = CGRect(x: (view.frame.width) * (20/100), y: (view.frame.height) * (60/100), width: view.frame.width * (60/100), height: (view.frame.height) * (6/100))
        createAccountButton.setTitle("Create An Account", for: UIControlState.normal)
        // Dynamically change size of font to fit screen
        createAccountButton.titleLabel?.adjustsFontSizeToFitWidth = true
        createAccountButton.titleLabel?.minimumScaleFactor=0.5
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 20 * screenScale)
        createAccountButton.setTitleColor(UIColor.white, for: .normal)
        createAccountButton.addTarget(self, action: #selector(ViewController.goToCreateAccount(_:)), for: UIControlEvents.touchUpInside)
        createAccountButton.backgroundColor = UIColor.init(red: 0.0/255, green: 177.0/255, blue: 176.0/255, alpha: 1)
        createAccountButton.layer.cornerRadius = 4
        view.addSubview(createAccountButton)
        self.view.addSubview(createAccountButton)
        
    }
    
    func googleLogin(){
        GIDSignIn.sharedInstance().signIn()
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
    
    func resetPassword(sender: UITapGestureRecognizer)
    {
       // let viewController = self.storyboard!.instantiateViewController(withIdentifier: "PasswordResetPage") as UIViewController
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ResetPassword") as UIViewController
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
        else if snapshot["type"] as? String == "Student"{
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "StudentTabController") as UIViewController
            self.dismiss(animated: true, completion: nil)
            self.present(viewController, animated: true, completion: nil)
        }
        // Delete a blocked user
        else{
            if let user = FIRAuth.auth()?.currentUser{
                FIRDatabase.database().reference().child("users").child(user.uid).removeValue()
                user.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("You've been deleted")
                    }
                }
                self.deletedAlert()
            }
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
                            else if dictionary["type"] as? String == "Student"{
                                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "StudentTabController") as UIViewController
                                self.dismiss(animated: true, completion: nil)
                                self.present(viewController, animated: true, completion: nil)
                            }
                            // Delete a blocked user
                            else{
                                FIRDatabase.database().reference().child("users").child(uid!).removeValue()
                                user.delete { error in
                                    if let error = error {
                                        print(error)
                                    } else {
                                        print("You've been deleted")
                                    }
                                }
                                self.deletedAlert()
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
    
    func deletedAlert()
    {
        let alertVC = UIAlertController(title: "Deleted", message: "Your account has been deleted by the administrator. Create a new one if you wish to continue using Ocha.", preferredStyle: .alert)
        let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
        alertVC.addAction(alertActionOkay)
        self.present(alertVC, animated: true, completion: nil)
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
