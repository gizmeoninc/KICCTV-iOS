//
//  SearchListTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 10/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {

    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
