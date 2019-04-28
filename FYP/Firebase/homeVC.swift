//
//  homeVC.swift
//  FYP
//
//  Created by Farhan Fauzi on 03/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import Firebase

class homeVC: UIViewController {
    
    
    @IBOutlet weak var welcomeL: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        //authenticateUserAndConfigureView()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func scanQRAction(_ sender: Any) {
    }
    
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Users").child(uid).observe(.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: AnyObject]
            {
                let username = dict["Username"] as! String
                
                self.welcomeL.text = "Welcome \(username)!"
                print ("my name is \(username)")
                
            }
        }
        )
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
        handleSignOut()
        
    }
    
    
    @IBAction func myBook(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "userBook") as! bookUserInVC
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    func switchToNavigationViewController(Navigation : String ) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: Navigation) as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
    func signOut() {
        
        try! Auth.auth().signOut()
        switchToNavigationViewController(Navigation: "mainVC")
    }
    
    
    //mark : - Stack View Functionality
    
    @IBAction func goToBookTableView(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "bookTableView") as! bookTableView
        self.navigationController?.pushViewController(desVC, animated: true)
    }

    
    @IBAction func scanForBorrowing(_ sender: Any)
    {
        
    }
    
    
    @IBAction func adminNavController(_ sender: Any) {
        
        let alert = UIAlertController(title: "Navigating to Admin Page", message: "Please enter Admin password", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "ID"
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Go", style: .default) { _ in
            
             let logintext = alert.textFields![0]
            let passtext = alert.textFields![1]
            
            
            let login = logintext.text
            let text = passtext.text
            
            let log = login
            let pass = text
            
            if log == "123123" && pass == "123123"{
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let desVC = mainStoryboard.instantiateViewController(withIdentifier: "adminHomeVC") as! adminHomeVC
                self.navigationController?.pushViewController(desVC, animated: true)
            } else {return}
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
    }
}
