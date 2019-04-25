//
//  userBooksTVC.swift
//  FYP
//
//  Created by Farhan Fauzi on 26/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit

class userBooksTVC: UITableViewCell {
    @IBOutlet weak var userBookTitle: UILabel!
    @IBOutlet weak var userBookLoc: UILabel!
    @IBOutlet weak var userBookRD: UILabel!
    @IBOutlet weak var imageUserBook: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
