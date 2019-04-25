//
//  unusedCode.swift
//  FYP
//
//  Created by Farhan Fauzi on 16/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//


/*
import Foundation

Method :- retrieve data from firebase


Database.database().reference().child("users").child(uid).observe(.value, with: {
    snapshot in
    if let dict = snapshot.value as? [String: AnyObject]
    {
        let username = dict["username"] as! String
        
        self.welcomeL.text = "Welcome \(username)!"
        print ("my name is \(username)")
        
    }
}
)
 
 Method :- Create User
 
 func createUser(withEmail email: String, password: String, username: String, msuID: String, status: UILabel) {
 
 Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
 
 if let error = error {
 print("Failed to sign user up with error: ", error.localizedDescription)
 return
 }
 
 guard let uid = result?.user.uid else { return }
 
 let values = ["email": email, "username": username, "msuID": msuID]
 
 Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
 if let error = error {
 print("Failed to update database values with error: ", error.localizedDescription)
 return
 }
 self.dismiss(animated: true, completion: nil)
 print("successfully signed up")
 })
 }
 }

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */
