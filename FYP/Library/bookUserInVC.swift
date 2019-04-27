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
//        bookDetails()
        refToData()
        
    }
    
    
    
    //    func loadBookLoc(){
    //        ref = Database.database().reference().child("Books").
    //    }
    
//    func bookDetails() {
//        Database.database().reference().child("Books").child("-LdITt-TTRisguRhIZwt").observe(.value, with: {
//            snapshot in
//            if let dict = snapshot.value as? [String: AnyObject]
//            {
//                let author = dict["Author"] as! String
//
//                print ("my book author is \(author)")
//
//            }
//        }
//        )
//
//    }
    
    func refToData(){
        
        
        
        let ref = Database.database().reference().child("Book_Borrowed")
        ref.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //iterating through all the values
                for detail in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let obj = detail.value as? [String: AnyObject]
                    let id = detail.key
                    let bookid  = obj?["BookID"] as? String
                    let booktitle = obj?["BookTitle"] as? String
                    let dateborrowed = obj?["DateBorrowed"] as? String
                    let datereturn = obj?["DateReturn"] as? String
                    let msuid = obj?["MSUID"] as? String
                    let uid = obj?["UID"] as? String
                    
                    print ("my current book id is \(bookid ?? "no val")")
                    Database.database().reference().child("Books").child("\(bookid ?? "")").observe(.value, with: {
                        snapshot in
                        if let dict = snapshot.value as? [String: AnyObject]
                        {
                            let bookurl = dict["BookURL"] as! String
                            let booklocation = dict["Book_Location"] as! String
                            
                            if self.uid ?? "" == uid {
                                let list = structUserBook(id: id, bookid: bookid!, title: booktitle!, dateborrowed: dateborrowed!, datereturn: datereturn!, msuid: msuid!, uid: uid!, bookurl: bookurl, booklocation: booklocation)
                                self.userBook.append(list)
                                self.userBookTV.reloadData()
                            } else {
                                self.userBookTV.reloadData()
                            }
                            
                            //  self.userBookTV.reloadData()
                            //  print ("mu current uid is \(self.uid ?? "no val")")
                            //      let test = self.userBook.filter { $0.uid == "\(self.uid ?? "")" }
                            // print (list)
                            
                        }
                    }
                    )
                    
                    //                    let list = structUserBook()
                    //                    //appending it to list
                    //
                    //                    self.userBook.append(list)
                    //                    print(list)
                }
                //reloading the tableview
                self.userBookTV.reloadData()
            }
        })
        
        //         ref.observe(DataEventType.value, with: { (snapshot) in
        //        if let dict = snapshot.value as? [String: AnyObject]
        //        {
        //            let bUID = dict["UID"] as! String
        //            while self.uid == bUID{
        //            ref.observe(DataEventType.value, with: { (snapshot) in
        //                //if the reference have some values
        //                if snapshot.childrenCount > 0 {
        //
        //                    //iterating through all the values
        //                    for detail in snapshot.children.allObjects as! [DataSnapshot] {
        //                        //getting values
        //                        let obj = detail.value as? [String: AnyObject]
        //                        let id = detail.key
        //                        let title  = obj?["Title"] as? String
        //                        let bookLoc = obj?["Book_Location"] as? String
        //                        let returnDate = obj?["DateReturn"] as? String
        //                        let bookURL = obj?["BookURL"] as? String
        //
        //                        let list = structUserBook(id: id, title: title ?? "", bookLoc: bookLoc ?? "", returnDate: returnDate ?? "", bookURL: bookURL ?? "")
        //                        //appending it to list
        //
        //
        //                        self.userBook.append(list)
        //                        print(list)
        //                    }
        //                    //reloading the tableview
        //                    self.userBookTV.reloadData()
        //                }
        //            })}
        //
        //            }})
        
        
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
        cell?.userBookLoc.text = history.booklocation
        cell?.userBookRD.text = history.datereturn
        
        
        cell?.imageUserBook!.sd_setImage(with: URL(string: "\(history.bookurl)" ), placeholderImage: UIImage(named: "placeholder.png"))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
