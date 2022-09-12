//
//  EpisodeTableViewCell.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 03/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var episodeNameLabel: UILabel!{
    didSet{

    }
  }
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!{
        didSet{
            progressBar.progressTintColor = .red
            progressBar.trackTintColor = .white
            if UIDevice.current.userInterfaceIdiom == .pad{
                progressBar.layer.cornerRadius = 4
            }
            else{
                progressBar.layer.cornerRadius = 2
            }
        }
    }
    @IBOutlet weak var freeTag: UIImageView!{
        didSet{
            freeTag.isHidden = true
        }
    }
    
    @IBOutlet weak var episodeImageWidth: NSLayoutConstraint!{
        didSet{
            let width = UIScreen.main.bounds.width / 2.3
            episodeImageWidth.constant = width
        }
    }
    @IBOutlet weak var episodeImageView: UIImageView!{
        didSet{
            self.episodeImageView.layer.cornerRadius = 8
            self.episodeImageView.layer.masksToBounds = true
        }
    }
    var episodeArray: VideoModel? {
        didSet{
            
            if let description = episodeArray?.video_description{
                self.descriptionLabel.text = description
                self.descriptionLabel.isHidden = false
            }
            else{
                self.descriptionLabel.isHidden = true
            }
            if let video_title = episodeArray?.video_title{
                self.episodeNameLabel.text = video_title
                self.episodeNameLabel.isHidden = false
            }
            else{
                self.episodeNameLabel.isHidden = true
            }
            if episodeArray?.thumbnail_350_200
                != nil {

                self.episodeImageView.sd_setImage(with:URL(string: ((imageUrl + (episodeArray?.thumbnail_350_200!)!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"), completed: { image, error, cacheType, imageURL in
                    // your rest code
               })
            }
            else {
                self.episodeImageView.image = UIImage(named: "landscape_placeholder")
            }
//            if episodeArray?.free_video == true {
//                self.freeTag.isHidden = true
//            }
//            else{
//                self.freeTag.isHidden = false
//
//            }
            if episodeArray?.watched_percentage != 0{
                let duration = Float((episodeArray?.watched_percentage)!) / 100
                progressBar.setProgress(duration, animated: false)
                progressBar.isHidden = false

            }
            else{
                progressBar.setProgress(.zero, animated: false)
                progressBar.isHidden = true

            }
            if let duration = episodeArray?.duration_text{
                let array = duration.components(separatedBy: ":")
                let hour = array[0]
                let minutes = array[1]
                let seconds = array[2]
                self.durationLabel.text = "\(duration)"
                self.durationLabel.isHidden = false

            }
            else{
                self.durationLabel.isHidden = true
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
  override func awakeFromNib() {
    
        super.awakeFromNib()

        // Initialization code
    }

  @IBOutlet weak var mainView: UIView!
  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
