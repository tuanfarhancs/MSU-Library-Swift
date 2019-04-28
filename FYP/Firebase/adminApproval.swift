//
//  adminApproval.swift
//  FYP
//
//  Created by Farhan Fauzi on 29/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class adminApproval: UIViewController {

    var rUser = [requestedUser]()
    
    
    
    @IBOutlet weak var requestedTableView: UITableView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func approveUser(_ sender: Any) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        referenceToData()
    }
    
    
    func referenceToData(){
        
        ref = Database.database().reference().child("Users")
        ref.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //iterating through all the values
                for detail in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    
                    let chatObject = detail.value as? [String: AnyObject]
                    let id = detail.key
                    let email  = chatObject?["Email"] as? String
                    let msuid  = chatObject?["MSUID"] as? String
                    let password = chatObject?["Password"] as? String
                    let status = chatObject?["Status"] as? Int
                    let username = chatObject?["Username"] as? String
                    
                    
                    
                    let list = requestedUser(id: id, email: email ?? "", msuID: msuid ?? "", password: password ?? "", status: status ?? 0, username: username ?? "")
                    //appending it to list
                    self.rUser.append(list)
                    print(id)
                }
                //reloading the tableview
                self.requestedTableView.reloadData()
            }
        })
    }
}


extension adminApproval: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rUser.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history: requestedUser
        history = rUser[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentier") as? requestedUserTableViewCell
        
        cell?.email.text = history.email
        cell?.msuID.text = history.msuID
        cell?.password.text = history.password
        cell?.username.text = history.username
        
        if history.status == 1 {
            cell?.status.text = "active"
        } else if history.status == 0 {
            cell?.status.text = "pending"
            
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Admin", message: "Approve this user?", preferredStyle: .alert)
        let post = UIAlertAction(title: "OK", style: .default) { _ in
            
            let detail: requestedUser
            detail = self.rUser[indexPath.row]
            let ref = Database.database().reference()
            
            let userRef = ref.child("Users").child("\(detail.id)")
            userRef.updateChildValues(["Status": 1])
            
            self.requestedTableView.reloadData()
            print("triggered")
            print("\(detail.id)")
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(post)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
}
