//
//  HomeVideoCollectionViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 29/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit

class HomeVideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.tintColor = .white
        }
    }
    
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == .pad{
                progressViewHeight.constant = 8
            }
        }
    }
    @IBOutlet weak var freeTag: UIImageView!{
        didSet{
            freeTag.isHidden = true

        }
    }
    @IBOutlet weak var progressView: UIProgressView!{
        didSet{
            progressView.progressTintColor = .red
            progressView.trackTintColor = .white
            if UIDevice.current.userInterfaceIdiom == .pad{
                progressView.layer.cornerRadius = 4
            }
            else{
                progressView.layer.cornerRadius = 2
            }
        }
    }
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoImage: UIImageView!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.videoImage.layer.cornerRadius = 8
            } else {
                self.videoImage.layer.cornerRadius = 8
            }
        }
    }
    @IBOutlet weak var liveLabel: UILabel!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.liveLabel.font = UIFont.init(name: "Poppins-SemiBold ", size: 15)
            }else{
               
            }
        }
    }
    @IBOutlet weak var videoName: UILabel!{
        didSet{
            self.videoName.textColor = ThemeManager.currentTheme().HeadTextColor
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {

             self.videoName.font = UIFont.init(name: "Poppins-SemiBold ", size: 20)
            } else {
             
            }
        }
    }
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//                self.weekDayLabelHeigh.constant = 50
                self.videoViewHeight.constant =  270
            } else {
                self.videoViewHeight.constant = 0
                
            }
        }
    }
    @IBOutlet weak var videoImageHeight: NSLayoutConstraint!{
        didSet{
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//                self.weekDayLabelHeigh.constant = 50
                let width = (UIScreen.main.bounds.width) / 2.5//some width
                let  height = (9 * width) / 16
                self.videoImageHeight.constant =  height 
            } else {
                let width = (UIScreen.main.bounds.width) / 2.3//some width
                let  height = (9 * width) / 16
                self.videoImageHeight.constant = height
                
            }
        }
    }
    @IBOutlet weak var premiumImage: UIImageView!
  @IBOutlet weak var PartNumber: UILabel!
   
//    @IBOutlet weak var episodeLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var episodeLabel: UILabel!{
           didSet{
               
               if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//                   self.episodeLabelHeight.constant = 60
                   self.episodeLabel.font = UIFont.init(name: "Helvetica-Bold", size: 25)
               } else {
                
                   //                       self.timeLabel.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 22)
               }
               
           }
       }
  override func awakeFromNib() {
        super.awakeFromNib()
    self.layoutIfNeeded()
    videoImage.layer.masksToBounds = true
    liveLabel.isHidden = true
    premiumImage.isHidden = true
    premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
    premiumImage.layer.masksToBounds = false
    premiumImage.layer.cornerRadius = premiumImage.frame.height/2
    premiumImage.clipsToBounds = true
    PartNumber.isHidden = true
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        self.episodeLabel.font = UIFont.init(name: "Helvetica-Bold", size: 25)
    }
   
    }
    
  override func layoutSubviews() {
    super.layoutSubviews()
    layoutIfNeeded()
      
    videoImage.layer.cornerRadius = 8.208333333333336/2
    videoImage.layer.masksToBounds = true
  }
}
