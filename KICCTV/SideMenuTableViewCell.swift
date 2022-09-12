//
//  SideMenuTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 28/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

  @IBOutlet weak var sideMenuView: UIView!
  @IBOutlet weak var sideMenuName: UILabel!
  @IBOutlet weak var sideMenuImageView: UIImageView!

  override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
