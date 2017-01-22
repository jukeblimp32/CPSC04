//
//  User.swift
//  Ocha
//
//  Created by Taylor, Scott A on 1/16/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class User {
    
    // Class variables
    var userName: String
    var fireId: String
    var emailAdd: String
    var userType: String
    
    init(newId: String, newName: String, newEmail: String, newType: String)
    {
        fireId = newId
        userName = newName
        emailAdd = newEmail
        userType = newType
    }
    
    init(newId: String, newName: String, newEmail: String)
    {
        fireId = newId
        userName = newName
        emailAdd = newEmail
        userType = ""
    }
    
    init(newId: String, newEmail: String)
    {
        fireId = newId
        userName = ""
        emailAdd = newEmail
        userType = ""
    }
    
    init(newId: String)
    {
        fireId = newId
        userName = ""
        emailAdd = ""
        userType = ""
        
    }
    
    init(mediaId: String, mediaFlag: String)
    {
        fireId = ""
        userName = ""
        emailAdd = ""
        userType = ""
    }
    
    init()
    {
        fireId = ""
        userName = ""
        emailAdd = ""
        userType = ""
    }

    
    func googleSignIn(user: GIDGoogleUser!)
    {
        // Login to Firebase with Google credentials
        let authentification = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentification?.idToken)!, accessToken: (authentification?.accessToken)!)
        FIRAuth.auth()?.signIn(with: credential){ (user, error) in
            print("User signed into Firebase")
            
            // Get reference to database.
            let databaseRef = FIRDatabase.database().reference()
            
            databaseRef.child("users").child(user!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                let snapshot = snapshot.value as? NSDictionary
                
                // Only add to database if the user hasn't already been created.
                if(snapshot == nil)
                {
                    databaseRef.child("users").child(user!.uid).child("name").setValue(user?.displayName)
                    databaseRef.child("users").child(user!.uid).child("email").setValue(user?.email)
                    self.fireId = user!.uid
                    self.userName = (user?.displayName)!
                    self.emailAdd = (user?.email)!
                    self.userType = ""
                    
                }
                else{
                    self.fireId = user!.uid
                    self.userName = (snapshot?["name"] as? String)!
                    self.emailAdd = (snapshot?["email"] as? String)!
                    self.userType = (snapshot?["type"] as? String)!
                    
                }
            })
        }
        
    }
    
    func getName() -> String
    {
        return self.userName
    }
    
    func getType() -> String
    {
        return self.userType
    }
    
    
}

