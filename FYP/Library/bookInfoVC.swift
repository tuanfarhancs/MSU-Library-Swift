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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        referenceToBookInfo()
        
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
    
    @IBAction func borrowBookButtonClicked(_ sender: Any) {
        borrowBook()
        
    }
    
    addUsertToBookDatabase(){
    
    }
    
    
    
}

extension bookInfoVC{
    
    func borrowBook(){
        ref = Database.database().reference().child("Books").child(bookID)
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject]
            {
                
                if  let numOfBooks = dict["Number_of_Books"] as? Int {
                    let numofBooksAfterClicked = (numOfBooks - 1)
                    self.ref.updateChildValues(["Number_of_Books": numofBooksAfterClicked])
                    self.numOfBooks.text = String(numofBooksAfterClicked)
                }
                
            }
        })}

}
