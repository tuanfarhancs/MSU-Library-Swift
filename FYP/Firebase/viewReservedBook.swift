//
//  viewReservedBook.swift
//  FYP
//
//  Created by Farhan Fauzi on 29/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


class viewReservedBook: UIViewController {
    
    @IBOutlet weak var reserveTableView: UITableView!
    
    var reserve = [viewReserveStruct]()
    
    var ref : DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewReserve()
    }
    
    func viewReserve(){
        
        reserve.removeAll()
        reserveTableView.reloadData()
        
        ref = Database.database().reference().child("ReservedBook")
        ref.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //iterating through all the values
                for detail in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let chatObject = detail.value as? [String: AnyObject]
                    
                    let title  = chatObject?["BookTitle"] as? String
                    let msuID  = chatObject?["MSUID"] as? String
                    let dateReserve = chatObject?["DateReserved"] as? String
                    let url = chatObject?["URL"] as? String
               
                    
                    let list = viewReserveStruct( title: title ?? "", msuID: msuID ?? "", dateReserve: dateReserve ?? "", url: url ?? "")
                    //appending it to list
                    
                    
                    self.reserve.append(list)
                    print(list)
                }
                //reloading the tableview
                self.reserveTableView.reloadData()
            }
        })
        
    }

}


extension viewReservedBook: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reserve.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history: viewReserveStruct
        history = reserve[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewReserveCell") as? viewReserveCell
        
        cell?.viewTitle.text = history.title
        cell?.viewMSUID.text = history.msuID
        cell?.viewDateReserve.text = history.dateReserve
        
        
        cell?.viewImageReserve!.sd_setImage(with: URL(string: "\(history.url)" ), placeholderImage: UIImage(named: "placeholder.png"))
        return cell!
    }
    

}



