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
                fbUser.setValuesForKeys(dictionary)
                if (fbUser.type != "Admin") {
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
        return cell
    }

/*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4.0
    }
    */
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
