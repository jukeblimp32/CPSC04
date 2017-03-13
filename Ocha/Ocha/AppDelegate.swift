//
//  AppDelegate.swift
//  Ocha
//
//  Created by Taylor, Scott A on 10/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var databaseRef: FIRDatabaseReference!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        // Logout of existing Firebase user to avoid conflicts
        do {
            try FIRAuth.auth()?.signOut()
            
            print("the user is logged out")
        } catch let error as NSError {
            print(error.localizedDescription)
            print("the current user id is \(FIRAuth.auth()?.currentUser?.uid)")
        }

        //Google Signin
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //Facebook Signin
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Logout of existing user
        FBSDKLoginManager().logOut()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        let fbDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return googleDidHandle || fbDidHandle
    }
    
    
    func applicationWillEnterForeground(application: UIApplication!) {
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("\(error.localizedDescription)")
            return
        }
        print("User signed into Google")
        
        // Login to Firebase with Google credentials
        let authentification = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentification?.idToken)!, accessToken: (authentification?.accessToken)!)
        FIRAuth.auth()?.signIn(with: credential){ (user, error) in
            print("User signed into Firebase")
            
            // Get reference to database.
            self.databaseRef = FIRDatabase.database().reference()
            
            self.databaseRef.child("users").child(user!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                let snapshot = snapshot.value as? NSDictionary
                
                // Only add to database if the user hasn't already been created.
                if(snapshot == nil)
                {
                    self.databaseRef.child("users").child(user!.uid).child("name").setValue(user?.displayName)
                    self.databaseRef.child("users").child(user!.uid).child("email").setValue(user?.email)
                    
                    // Go to select type if this is the first time logging in with Google
                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "SelectType") as UIViewController
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = initialViewControlleripad
                    self.window?.makeKeyAndVisible()
                    return
                    
                }
                
                // Go to correct homepage if the user exists
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "StudentTabController") as UIViewController
                
                if snapshot?["type"]as? String != "Block"
                {
                    print(snapshot?["type"])
                    // Choose the correct home screen based off of the type name from Firebase database
                    if snapshot?["type"]as? String  == "Admin" {
                        initialViewControlleripad  = mainStoryboardIpad.instantiateViewController(withIdentifier: "AdminTabController") as UIViewController
                    }
                    else if snapshot?["type"] as? String == "Landlord" {
                        initialViewControlleripad  = mainStoryboardIpad.instantiateViewController(withIdentifier: "LandlordTabController") as UIViewController
                    }
                    else {
                        initialViewControlleripad  = mainStoryboardIpad.instantiateViewController(withIdentifier: "StudentTabController") as UIViewController
                    }
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = initialViewControlleripad
                    self.window?.makeKeyAndVisible()
                }
                else
                {
                    FIRDatabase.database().reference().child("users").child(user!.uid).removeValue()
                    user?.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("You've been deleted")
                        }
                    }
                    self.deletedAlert()
                }
            })
        }
    }
    
    func deletedAlert()
    {
        let alertVC = UIAlertController(title: "Deleted", message: "Your account has been deleted by the administrator. Create a new one if you wish to continue using Ocha.", preferredStyle: .alert)
        let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
        alertVC.addAction(alertActionOkay)
        self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }

    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

