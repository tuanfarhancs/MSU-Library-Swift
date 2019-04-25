//
//  bookTableView.swift
//  FYP
//
//  Created by Farhan Fauzi on 01/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class bookTableView: UIViewController {
    
    var bookS = [structBook]()
    
    @IBOutlet weak var bookTableView: UITableView!
    
      var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        referenceToBookData()
    }
    
    
    func referenceToBookData(){
        
        bookS.removeAll()
        bookTableView.reloadData()
        
        ref = Database.database().reference().child("Books")
        ref.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //iterating through all the values
                for detail in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let chatObject = detail.value as? [String: AnyObject]
                    let id = detail.key
                    let title  = chatObject?["Title"] as? String
                    let author  = chatObject?["Author"] as? String
                    let year = chatObject?["Year"] as? String
                    let genre = chatObject?["Genre"] as? String
                    let bookURL = chatObject?["BookURL"] as? String
                    
                    let list = structBook(id:id, title: title ?? "", author: author ?? "", year: year ?? "", genre: genre ?? "", bookURL: bookURL ?? "")
                    //appending it to list
                    
                    print ("test Book URl2: \(bookURL ?? "")")
                    self.bookS.append(list)
                    print(list)
                }
                //reloading the tableview
                self.bookTableView.reloadData()
            }
        })
    }
}

extension bookTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookS.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history: structBook
        history = bookS[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookIdentifier") as? booksTableViewCell
        
        cell?.bookTitle.text = history.title
        cell?.bookAuthor.text = history.author
        cell?.bookYear.text = history.year
        cell?.bookGenre.text = history.genre
        
cell?.bookTableImage!.sd_setImage(with: URL(string: "\(history.bookURL)" ), placeholderImage: UIImage(named: "placeholder.png"))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detail: structBook
        detail = self.bookS[indexPath.row]
        
        ref.child("Books").child("\(detail.id)")
        let firstVCDATA = detail.id
        
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "bookInfo") as! bookInfoVC
        desVC.bookID = firstVCDATA
        self.navigationController?.pushViewController(desVC, animated: true)
        

    }
}



