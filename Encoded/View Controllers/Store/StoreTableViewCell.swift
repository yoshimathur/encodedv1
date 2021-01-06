//
//  StoreTableViewCell.swift
//  Secret Messages
//
//  Created by Yash Mathur on 7/21/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    

}
