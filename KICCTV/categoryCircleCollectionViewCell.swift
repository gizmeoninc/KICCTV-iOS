//
//  categoryCircleCollectionViewCell.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 25/02/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import UIKit

class categoryCircleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var videoImage: UIImageView!{
        didSet{
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.imageWidth.constant = 160
                   } else {
                       //                       self.timeLabel.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 22)
                   }
        }
    }
    @IBOutlet weak var videoName: UILabel!{
        didSet{
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                       self.videoName.font = UIFont.init(name: "Helvetica-Bold", size: 25)
                   } else {
                       //                       self.timeLabel.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 22)
                   }
        }
    }

    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var partnerDescriptionLabel: UILabel!{
        didSet{
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                       self.partnerDescriptionLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
            self.partnerDescriptionLabel.numberOfLines = 13
                   } else {
                       //                       self.timeLabel.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 22)
                   }
        }
    }
    override func awakeFromNib() {
      super.awakeFromNib()
      videoImage.layer.cornerRadius = 5
      videoImage.clipsToBounds = true
//      videoName.isHidden = true
        // Initialization code
    }
  override func layoutSubviews() {
    super.layoutSubviews()
    layoutIfNeeded()
//    videoImage.layer.cornerRadius = videoImage.frame.height/2
  }
}
