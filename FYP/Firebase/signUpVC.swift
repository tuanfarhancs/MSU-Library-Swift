//
//  signUpVC.swift
//  FYP
//
//  Created by Farhan Fauzi on 03/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects
import FirebaseDatabase


class signUpVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var msuidTF: AkiraTextField!
    
    @IBOutlet weak var usernameTF: AkiraTextField!
    
    @IBOutlet weak var emailTF: AkiraTextField!
    
    @IBOutlet weak var passTF: AkiraTextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
       
    }
    
 
    
    @IBAction func signupbutt(_ sender: Any) {
        
        guard let msuID = msuidTF.text else { return }
        guard let email = emailTF.text else { return }
        guard let password = passTF.text else { return }
        guard let username = usernameTF.text else { return }
        
        let currentStatus = 0
        
        createUser(withEmail: email, password: password, username: username, msuID: msuID, currentStatus: currentStatus)
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "loginVC") as! loginVC
        self.navigationController?.pushViewController(desVC, animated: true)
        
    
    }
    
    
    
    
   
    //Mark : User Request SignUP
    
    func createUser(withEmail email: String, password: String, username: String, msuID: String, currentStatus: Int ) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("Failed to sign user up with error: ", error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else { return }
            
            let values = ["Email": email, "Username": username,"Password": password, "MSUID": msuID, "Status": currentStatus] as [String : Any]
        
            self.ref.child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("Failed to update database values with error: ", error.localizedDescription)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                print("successfully signed up")
            })
    }
    
    

    

   
}
}
