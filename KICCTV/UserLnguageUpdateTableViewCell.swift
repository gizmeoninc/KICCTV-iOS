//
//  UserLnguageUpdateTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 17/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class UserLnguageUpdateTableViewCell: UITableViewCell {
    @IBOutlet weak var languageSelectionButton: UIButton!
    @IBOutlet weak var languageName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
