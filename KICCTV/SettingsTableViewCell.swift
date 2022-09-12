//
//  SettingsTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 16/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var settingsName: UILabel!
    @IBOutlet weak var settingsImage: UIImageView!
    @IBOutlet weak var modeChangeSwitch: UISwitch!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
