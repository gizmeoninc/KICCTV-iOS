//
//  SubscriptionCollectionViewCell.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 21/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class SubscriptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var packageDuration: UILabel!
    @IBOutlet weak var packageNameLabelHeight: NSLayoutConstraint!
  override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 5
        self.mainView.clipsToBounds = true
        self.mainView.layer.borderWidth = 0.8
        self.packagePrice.textColor = ThemeManager.currentTheme().textColor
        // Initialization code
    }

}
