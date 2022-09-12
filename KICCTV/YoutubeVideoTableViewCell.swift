//
//  YoutubeVideoTableViewCell.swift
//  PoppoTv
//
//  Created by Firoze Moosakutty on 13/05/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class YoutubeVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var youtubeImageView: UIImageView!
    @IBOutlet weak var youtubeVideoName: UILabel!
    @IBOutlet weak var youtubeVideoDescription: UILabel!
    @IBOutlet weak var youtubeChannelName: UILabel!
    @IBOutlet weak var youtubeImageviewWidht: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        youtubeVideoName.textColor = ThemeManager.currentTheme().sideMenuTextColor
        youtubeVideoDescription.textColor = ThemeManager.currentTheme().sideMenuTextColor
        youtubeChannelName.textColor = ThemeManager.currentTheme().sideMenuTextColor
        youtubeImageView.layer.cornerRadius = 8
        youtubeImageView.layer.masksToBounds = true
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            youtubeVideoName.font = youtubeVideoName.font.withSize(23)
               youtubeChannelName.font = youtubeChannelName.font.withSize(18)
               youtubeVideoDescription.font = youtubeVideoDescription.font.withSize(18)
            
        } else {
              youtubeVideoName.font = youtubeVideoName.font.withSize(13)
               youtubeChannelName.font = youtubeChannelName.font.withSize(12)
               youtubeVideoDescription.font = youtubeVideoDescription.font.withSize(12)
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
        youtubeImageView.layer.cornerRadius = 8.208333333333336/2
        youtubeImageView.layer.masksToBounds = true
    }
}
