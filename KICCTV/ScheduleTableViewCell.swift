//
//  ScheduleTableViewCell.swift
//  PoppoTv
//
//  Created by GIZMEON on 27/05/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var channelLogoImage: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var channelLogoImageHeight: NSLayoutConstraint!
    @IBOutlet weak var channelLogoImageWidth: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        channelLogoImage.layer.cornerRadius = 8
        channelLogoImage.layer.masksToBounds = true
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            channelNameLabel.font = channelNameLabel.font.withSize(23)
            channelLogoImageHeight.constant = 140
            channelLogoImageWidth.constant = 200
            
        } else {
            channelNameLabel.font = channelNameLabel.font.withSize(16)
            channelLogoImageHeight.constant = 70
            channelLogoImageWidth.constant = 100
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        channelLogoImage.layer.cornerRadius = 8.208333333333336/2
        channelLogoImage.layer.masksToBounds = true
    }
    
}
