//
//  addBookVC.swift
//  FYP
//
//  Created by Farhan Fauzi on 01/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class addBookVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var titleAddBook: UITextField!
    
    @IBOutlet weak var authorAddBook: UITextField!
    
    @IBOutlet weak var yearAddBook: UITextField!
    
    @IBOutlet weak var genreAddBook: UITextField!
    
    @IBOutlet weak var imageViewAddBook: UIImageView!
    
    @IBOutlet weak var bookLoc: UITextField!
    
    @IBOutlet weak var numOfBook: UITextField!
    
    @IBOutlet weak var bookNotes: UITextField!
    
    @IBOutlet weak var bookID: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    }
    
    
    
    
    
    
    @IBAction func saveBook(_ sender: Any) {
        
        
        
        guard let title = titleAddBook.text else { return }
        guard let author = authorAddBook.text else { return }
        guard let year = yearAddBook.text else { return }
        guard let genre = genreAddBook.text else { return }
        guard let bookLocF = bookLoc.text else { return }
        guard let numOfBookF = numOfBook.text else { return }
        guard let bookNotesF = bookNotes.text else { return }
        guard let bookIDF = bookID.text else { return }
        
        let numOfBookFINT = Int(numOfBookF)
        
        let filePath = "\(String(describing: Auth.auth().currentUser))/\(Date.timeIntervalSinceReferenceDate)"
        
        let storageRef = Storage.storage().reference().child(filePath)
        let uploadData = imageViewAddBook.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        
        
        storageRef.putData(uploadData!, metadata: metaData) { (metadata, error) in
            if error != nil {
                print("error")
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url?.absoluteString else {
                    
                    return
                }
                print(downloadURL)
                
                self.addBookToFirebase(title: title, author: author, year: year, genre: genre, bookLocF: bookLocF ,numOfBookFINT: numOfBookFINT ?? 1, bookNotesF: bookNotesF, bookIDF: bookIDF, localURL: downloadURL)
            }
            
        }
        let alert = UIAlertController(title: "You have successfully Borrowed this book", message: "Great Book Choice!!", preferredStyle: .alert)
        
        let reserve = UIAlertAction(title: "OK", style: .default) { _ in
        }
        
        
        alert.addAction(reserve)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func addBookToFirebase(title: String, author: String, year: String, genre: String, bookLocF: String, numOfBookFINT: Int, bookNotesF: String, bookIDF: String ,localURL: String){
        
        let values = ["Title": title, "Author": author, "Year": year, "Genre": genre, "Book_Location": bookLocF, "Number_of_Books": numOfBookFINT, "Notes": bookNotesF, "Book_ID": bookIDF, "BookURL": localURL] as [String : Any]
        
        self.ref.child("Books").childByAutoId().updateChildValues(values, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("Failed to update database values with error: ", error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
            print("successfully add book")
        })
        
    }
    
    
    
    
    
    
    @IBAction func uploadPic(_ sender: Any) {
        
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in imagepicker.sourceType = .camera
            self.present(imagepicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in imagepicker.sourceType = .photoLibrary
            self.present(imagepicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageViewAddBook.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}





