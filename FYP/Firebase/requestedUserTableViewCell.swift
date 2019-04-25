//
//  requestedUserTableViewCell.swift
//  FYP
//
//  Created by Farhan Fauzi on 19/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit

class requestedUserTableViewCell: UITableViewCell {
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var msuID: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
