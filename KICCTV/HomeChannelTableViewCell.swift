//
//  HomeChannelTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 15/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit

class HomeChannelTableViewCell: UITableViewCell {
  @IBOutlet var homeChannelCollection: UICollectionView!
  @IBOutlet weak var channelCollectionviewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
