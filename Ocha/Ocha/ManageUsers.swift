//
//  ManageUsers.swift
//  Ocha
//
//  Created by Talkov, Leah C on 3/10/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase



class ManageUsers: UITableViewController {
    
    var userList = [FireUser]()
    var tempUsers = [(FireUser, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userList.removeAll()
        tempUsers.removeAll()
        fetchUsers()
        self.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchUsers(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let fbUser = FireUser()
                fbUser.name = dictionary["name"] as! String?
                fbUser.email = dictionary["email"] as! String?
                fbUser.type = dictionary["type"] as! String?
                fbUser.fbId = snapshot.key
                
                if (fbUser.type != "Admin" && fbUser.type != "Block") {
                    self.userList.append(fbUser)
                }
                self.userList.sort {$0.email!.lowercased() < $1.email!.lowercased()}
                //Update the tableview to show users
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserTableViewCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as! UserTableViewCell
        
        let user = userList[indexPath.row]
        
        cell.emailLabel.text = user.email
        cell.nameLabel.text = user.name
        cell.userID = user.fbId!
        cell.deleteUser.tag = indexPath.row
        cell.deleteUser.addTarget(self, action: #selector(self.deleteUser(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }

/*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4.0
    }
    */
    
    func deleteUser(_ sender: UIButton)
    {
        let cell = userList[sender.tag]
        let userReference =   FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/").child("users").child(cell.fbId!)
        
        // Make pop up
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete \(cell.email!) from the users?", preferredStyle: .alert)
        
        // If cancel, do nothing
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, open up the email app after switching to edit status
        let alertActionYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            //Block the user by setting their type
            let values = ["type" : "Block"]
            userReference.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
                //If there was an error in saving user type, return and print error
                if err != nil {
                    print(err)
                    return
                }
                print("Saved user successfully")
            })
            
            
        }
        alertVC.addAction(alertActionCancel)
        alertVC.addAction(alertActionYes)
        self.present(alertVC, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
