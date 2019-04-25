//
//  loginVC.swift
//  FYP
//
//  Created by Farhan Fauzi on 03/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import TextFieldEffects


class loginVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var emailTF: AkiraTextField!    
    @IBOutlet weak var passwordTF: AkiraTextField!
    
    func navigationConfig(title: String, vc: UIViewController) {
        vc.navigationItem.title = title
        vc.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    var ref : DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationConfig(title: "Login", vc: self)
        if Auth.auth().currentUser == nil {
            
        } else {
            
            switchToNavigationViewController(Navigation: "homepageVC")
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func switchToNavigationViewController(Navigation : String ) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: Navigation) as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
        
        logUserIn(withEmail: email, password: password)
    }
    
    
    
    
    func logUserIn(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            let userID = Auth.auth().currentUser?.uid
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                
                let alertController = UIAlertController(title: "Invalid User", message: "Password or email wrong, Please try again!", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
                return
            } else {
                self.ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let status = value!["Status"] as? Int
                    
                    if let error = error {
                        print("Failed to sign user in with error: ", error.localizedDescription)
                        return
                    }
                    else if status == 0{
                        try! Auth.auth().signOut()
                        
                        let alert = UIAlertController(title: "Account Status", message: "Pending!", preferredStyle: .alert)
                        let post = UIAlertAction(title: "OK", style: .default) { _ in
                            return
                        }
                        alert.addAction(post)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if status == 1{
                        self.switchToNavigationViewController(Navigation: "homepageVC")
                        //                self.navigationController?.pushViewController(desVC, animated: true)
                        print("successfully signed in")
                    }
                    
                    
                })
            }
        }
    }
    
    //Mark : Show SignUpVC
    
    @IBAction func showSignUp(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "signUpVC") as! signUpVC
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    
    
    
}


