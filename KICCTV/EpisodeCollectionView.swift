//
//  EpisodeCollectionView.swift
//  Mongol
//
//  Created by GIZMEON on 30/03/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class EpisodeCollectionCell: UICollectionViewCell {
    var fromKeyArtWork = false
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var freeTag: UIImageView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!{
        didSet{
            let width = UIScreen.main.bounds.width-50 //some width
            let height = (9 * width) / 16
            imageHeight.constant =  height
        }    }
    @IBOutlet weak var artWorkImageView: UIImageView!
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var EpisodeDescription: UILabel!
    override  func awakeFromNib() {
           super.awakeFromNib()
           self.layoutIfNeeded()
       }
       override func layoutSubviews() {
       super.layoutSubviews()
       layoutIfNeeded()
           
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//            titlelabelHeight.constant = 30
        }
       }
}
