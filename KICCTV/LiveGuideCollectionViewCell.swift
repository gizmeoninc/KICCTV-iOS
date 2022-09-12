//
//  LiveGuideCollectionViewCell.swift
//  Justwatchme.tv
//
//  Created by GIZMEON on 22/07/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import  UIKit
class LiveGuideCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var trendingImageLogo: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!{
        didSet{
            let width = (UIScreen.main.bounds.width) / 2.3//some width
            let height  = (9 * width) / 16
            self.imageHeight.constant = height

        }
    }
    @IBOutlet weak var timeLabel: UILabel!{
        didSet{
            self.timeLabel.isHidden = true
            self.timeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                
                self.timeLabel.font = UIFont.init(name: "Poppins-Regular", size: 22)
            } else {
                
            }
            
        }
    }
    @IBOutlet weak var weekDayLabelHeigh: NSLayoutConstraint!
    @IBOutlet weak var timeLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var weekdayLabel: UILabel!{
        didSet{
            self.weekdayLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.weekdayLabel.textColor = ThemeManager.currentTheme().HeadTextColor
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//                self.weekDayLabelHeigh.constant = 50
                self.weekdayLabel.font = UIFont.init(name: "Poppins-SemiBold", size: 20)
            } else {
                //                       self.timeLabel.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 22)
            }
        }
    }
    
    @IBOutlet weak var videoTitle: UILabel!{
        didSet{
            self.videoTitle.textColor = ThemeManager.currentTheme().HeadTextColor
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.videoTitle.font = UIFont.init(name: "Poppins-Regular", size: 18)

            } else {
            }
            
        }
    }
    var featuredVideos: LiveGuideModel?
    var featuredVideos1: VideoModel?

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  override func layoutSubviews() {
     super.layoutSubviews()
    trendingImageLogo.layer.cornerRadius = 8.208333333333336/2
    trendingImageLogo.layer.masksToBounds = true
    trendingImageLogo.contentMode = .scaleToFill
    

   }
}

