//
//  bookInfoVC.swift
//  FYP
//
//  Created by Farhan Fauzi on 01/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseDatabase

class bookInfoVC: UIViewController {
    
    var bookS = [structBook]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var bookLoc: UILabel!
    @IBOutlet weak var numOfBooks: UILabel!
    @IBOutlet weak var bookNotes: UILabel!
    @IBOutlet weak var bookIDF: UILabel!
    
    var ref: DatabaseReference!
    var bookID = ""
    var msuid = ""
    var bookURLL = ""
    var bookLocc = ""
    var bookTitlee = ""
    var bookNum = 0
    let uid = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("my uid is \(uid!)")
        print ("myBookid is \(bookID)")
        referenceToBookInfo()
        loadUserData()
        
    }
    
    func loadUserData() {
        Database.database().reference().child("Users").child(uid!).observe(.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: AnyObject]
            {
                let msuId = dict["MSUID"] as! String
                
                print ("my msuid is \(msuId)")
                self.msuid = msuId
                
            }
        }
        )
    }
    
    
    
    func referenceToBookInfo(){
        
        ref =   Database.database().reference().child("Books").child(bookID)
        ref.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            
            if let dict = snapshot.value as? [String: AnyObject]
            {
                let title = dict["Title"] as! String
                let author = dict["Author"] as! String
                let genre = dict["Genre"] as! String
                let year = dict["Year"] as! String
                let bookLoc = dict["Book_Location"] as! String
                let numOfBooks = dict["Number_of_Books"] as! Int
                let bookNotes = dict["Notes"] as! String
                let bookIDF = dict["Book_ID"] as! String
                let bookURL = dict["BookURL"] as! String
                
                self.bookTitlee = title
                self.bookNum = numOfBooks
                self.bookURLL = bookURL
                self.bookLocc = bookLoc
                self.titleLabel.text = title
                self.authorLabel.text = author
                self.genreLabel.text = genre
                self.yearLabel.text = year
                self.bookLoc.text = bookLoc
                self.numOfBooks.text = String(numOfBooks)
                self.bookNotes.text = bookNotes
                self.bookIDF.text = bookIDF
                
                self.bookImage.sd_setImage(with: URL(string: bookURL), placeholderImage: UIImage(named: "placeholder.png"))
            }
            
        })
    }
    
    
    @IBAction func reserveBook(_ sender: Any) {
        let alert = UIAlertController(title: "Reserve This Book?", message: "Please enter the date for reservation", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Date"
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let reserve = UIAlertAction(title: "Reserve", style: .default) { _ in
            guard let dateReserved = alert.textFields?.first?.text else { return }
            let userBookBorrowValues = ["DateReserved": dateReserved, "BookTitle": self.bookTitlee, "MSUID": self.msuid, "URL": self.bookURLL] as [String : Any]
            
            Database.database().reference().child("ReservedBook").childByAutoId().setValue(userBookBorrowValues)
            
            
            
    }
        
        alert.addAction(cancel)
        alert.addAction(reserve)
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func borrowBookButtonClicked(_ sender: Any) {
        
        if bookNum <= 0{
            let alertController = UIAlertController(title: "No Book Currently Available", message: "You can reserve book", preferredStyle: .alert)
            
            // Create the actions
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            let reserveAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                
            }
            
            // Add the actions
            alertController.addAction(cancel)
            alertController.addAction(reserveAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            borrowBook()
        }
    }
    
    
    
    func addUsertToBookDatabase(bookTitle:String, msuID:String, bookid:String, bookurl: String, bookLocc: String){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMMM-yyyy"
        let borrowedDate = formatter.string(from: date)
        
        let calendar = Calendar.current
        let rightNow = Date()
        let sevenDaysAfter = calendar.date(byAdding: .day, value: 7, to: rightNow)
        print(sevenDaysAfter!)
        let returnDate = formatter.string(from: sevenDaysAfter!)
        
        let values = ["BookID": bookid, "BookTitle": bookTitle, "DateBorrowed": borrowedDate, "DateReturn": returnDate, "MSUID": msuID, "UID": uid!] as [String : Any]
        
        Database.database().reference().child("Book_Borrowed").childByAutoId().updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            
            self.dismiss(animated: true, completion: nil)
            let alertController = UIAlertController(title: "Borrow Book", message: "your have successfully borrowed a book!", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        })
        
        let userBookBorrowValues = ["UID": uid!,"BookID": bookid, "BookTitle": bookTitle,"BookLocation": bookLocc, "DateBorrowed": borrowedDate, "DateReturn": returnDate, "BookURL": bookurl] as [String : Any]
        
        Database.database().reference().child("UserBook").childByAutoId().child(uid!).setValue(userBookBorrowValues)
        
    }
    
    func borrowBook(){
        
        let dataref = Database.database().reference().child("Books").child(bookID)
        dataref.observeSingleEvent(of: .value) {
            (snapshot) in
            print (snapshot)
            if let dict = snapshot.value as? [String: AnyObject]
            {
                
                if  let numOfBooks = dict["Number_of_Books"] as? Int {
                    print ("num of book :\(numOfBooks)")
                    let numofBooksAfterClicked = (numOfBooks - 1)
                    dataref.updateChildValues(["Number_of_Books": numofBooksAfterClicked])
                    self.numOfBooks.text = String(numofBooksAfterClicked)
                    
                    self.addUsertToBookDatabase(bookTitle: self.titleLabel.text!, msuID: "\(self.msuid)", bookid: self.bookID, bookurl: self.bookURLL, bookLocc: self.bookLocc)
                    
                    
                }
            }
            
        }
        
    }
    
    
    
}
