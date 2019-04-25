//
//  bookUserInVC.swift
//  FYP
//
//  Created by Farhan Fauzi on 26/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class bookUserInVC: UIViewController {

    var userBook = [structUserBook]()
    var ref : DatabaseReference!
    
    let uid = Auth.auth().currentUser?.uid
    @IBOutlet weak var userBookTV: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refToData()

    }



//    func loadBookLoc(){
//        ref = Database.database().reference().child("Books").
//    }

    func refToData(){
        
        
        let ref = Database.database().reference().child("UserBook")
         ref.observe(DataEventType.value, with: { (snapshot) in
        if let dict = snapshot.value as? [String: AnyObject]
        {
            let bUID = dict["UID"] as! String
            while self.uid == bUID{
            ref.observe(DataEventType.value, with: { (snapshot) in
                //if the reference have some values
                if snapshot.childrenCount > 0 {
                    
                    //iterating through all the values
                    for detail in snapshot.children.allObjects as! [DataSnapshot] {
                        //getting values
                        let obj = detail.value as? [String: AnyObject]
                        let id = detail.key
                        let title  = obj?["Title"] as? String
                        let bookLoc = obj?["Book_Location"] as? String
                        let returnDate = obj?["DateReturn"] as? String
                        let bookURL = obj?["BookURL"] as? String
                        
                        let list = structUserBook(id: id, title: title ?? "", bookLoc: bookLoc ?? "", returnDate: returnDate ?? "", bookURL: bookURL ?? "")
                        //appending it to list
                        
                        
                        self.userBook.append(list)
                        print(list)
                    }
                    //reloading the tableview
                    self.userBookTV.reloadData()
                }
            })}
            
            }})
  

    }
}

extension bookUserInVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBook.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history: structUserBook
        history = userBook[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userBookIdentifier") as? userBooksTVC
        
        cell?.userBookTitle.text = history.title
        cell?.userBookLoc.text = history.bookLoc
        cell?.userBookRD.text = history.returnDate
        
        
        cell?.imageUserBook!.sd_setImage(with: URL(string: "\(history.bookURL)" ), placeholderImage: UIImage(named: "placeholder.png"))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}




