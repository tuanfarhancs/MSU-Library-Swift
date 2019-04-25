//
//  booksTableViewCell.swift
//  FYP
//
//  Created by Farhan Fauzi on 22/04/2019.
//  Copyright © 2019 Farhan Fauzi. All rights reserved.
//

import UIKit

class booksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookTableImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
