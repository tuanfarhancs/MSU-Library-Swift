//
//  viewReserveCell.swift
//  FYP
//
//  Created by Farhan Fauzi on 29/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit

class viewReserveCell: UITableViewCell {
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewMSUID: UILabel!
    @IBOutlet weak var viewDateReserve: UILabel!
    
    @IBOutlet weak var viewImageReserve: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
