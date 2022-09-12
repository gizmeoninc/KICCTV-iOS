//
//  SearchCollectionCell.swift
//  HappiTv
//
//  Created by GIZMEON on 03/11/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class SearchCollectionCell: UICollectionViewCell {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var titlelabelHeight: NSLayoutConstraint!
    @IBOutlet weak var imageviewHeight: NSLayoutConstraint!
    @IBOutlet weak var videoTitleLabel: UILabel!
    override  func awakeFromNib() {
           super.awakeFromNib()
           self.layoutIfNeeded()
       }
       override func layoutSubviews() {
       super.layoutSubviews()
       layoutIfNeeded()
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            titleLabel.font = UIFont(name: "Helvetica", size: 18)
//            titlelabelHeight.constant = 30
        }
       }
}
