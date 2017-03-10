//
//  FireUser.swift
//  Ocha
//
//  Created by Taylor, Scott A on 3/9/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import Foundation

class FireUser: NSObject {
    var email: String?
    var name:  String?
    var type:  String?
}

/* storing this code here until we make the page
 
 func fetchUsers(){
    FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: {(snapshot) in
    if let dictionary = snapshot.value as? [String: AnyObject] {
        let fbUser = FireUser()
        fbUser.setValuesForKeysWithDictionary(dictionary)
        self.userList.append(fbUser)
 
        //Update the tableview to show users
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    }, withCancelBlock: nil)
 }
 
 */
