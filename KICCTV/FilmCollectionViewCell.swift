//
//  FilmCollectionViewCell.swift
//  Justwatchme.tv
//
//  Created by GIZMEON on 16/08/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import Foundation
import  UIKit
class FilmCollectionViewCell: UICollectionViewCell {
    var flag = true
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!{
        didSet{
            gradientView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//           gradientView.setGradientBackground(colorTop: UIColor.clear, colorBottom: UIColor.black.withAlphaComponent(0.6))

        }
    }
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var gradientViewWidth: NSLayoutConstraint!{
        didSet{
        }
    }
    @IBOutlet weak var headerLabel: UILabel!{
        didSet{
            headerLabel.textColor = ThemeManager.currentTheme().HeadTextColor
        }
    }
    @IBOutlet weak var showNameLabel: UILabel!{
    didSet{
        showNameLabel.textColor = ThemeManager.currentTheme().HeadTextColor
    }
}
    @IBOutlet weak var meatadataLabel: UILabel!{
didSet{
    meatadataLabel.textColor = ThemeManager.currentTheme().HeadTextColor
}
}
    @IBOutlet weak var synopsisLabel: UILabel!{
didSet{
    synopsisLabel.textColor = ThemeManager.currentTheme().HeadTextColor
}
}
override func awakeFromNib() {
    super.awakeFromNib()
}
}


