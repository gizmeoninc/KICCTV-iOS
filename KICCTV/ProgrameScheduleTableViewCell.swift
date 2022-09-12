//
//  ProgrameScheduleTableViewCell.swift
//  PoppoTv
//
//  Created by GIZMEON on 28/05/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class ProgrameScheduleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var programLogo: UIImageView!
    @IBOutlet weak var programName: UILabel!
    @IBOutlet weak var ProgramSchedue: UILabel!
    @IBOutlet weak var LiveNowLabel: UILabel!
    @IBOutlet weak var programLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var programeLogoWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        programLogo.layer.cornerRadius = 8
        programLogo.layer.masksToBounds = true
        LiveNowLabel.layer.cornerRadius = 8.0
        LiveNowLabel.layer.masksToBounds = true
        programName.textColor = ThemeManager.currentTheme().sideMenuTextColor
        ProgramSchedue.textColor = ThemeManager.currentTheme().sideMenuTextColor
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            programName.font = programName.font.withSize(23)
            ProgramSchedue.font = ProgramSchedue.font.withSize(17)
            programLogoHeight.constant = 140
            programeLogoWidth.constant = 155
            
        } else {
            programName.font = programName.font.withSize(17)
            ProgramSchedue.font = ProgramSchedue.font.withSize(15)
            programLogoHeight.constant = 70
            programeLogoWidth.constant = 85
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        programLogo.layer.cornerRadius = 8.208333333333336/2
        programLogo.layer.masksToBounds = true
    }
    
}
