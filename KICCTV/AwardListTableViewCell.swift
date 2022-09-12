//
//  SearchResultTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 19/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit

class AwardListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var awardName: UILabel!
    @IBOutlet weak var year: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
