//
//  UpdatedTableViewCell.swift
//  AUSFLIX
//
//  Created by Firoze Moosakutty on 14/11/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class UpdatedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  @IBOutlet weak var languageName: UILabel!
  @IBOutlet weak var selectionImage: UIImageView!
  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

