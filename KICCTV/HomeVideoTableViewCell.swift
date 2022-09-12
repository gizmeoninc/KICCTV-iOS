//
//  HomeVideoTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 29/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Foundation
protocol HomeVideoTableViewCellDelegate:class {
     func didSelectPopular(passModel :VideoModel)
     func didSelectCategory(passModel :VideoModel)
    func didSelectNews(passModel :VideoModel)
     func didSelectChannel(passModel :VideoModel)
     func didSelectDianamicVideos(passModel :VideoModel)
     func didSelectLiveNowVideos(passModel :VideoModel)
    func didSelectEventLive(passModel :VideoModel)
    func didSelectUpcomingEvents(passModel :VideoModel)
     func didSelectShowVideos(passModel :VideoModel)
    func didSelectEndedEvents(passModel :VideoModel)
    
}
class HomeVideoTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

  @IBOutlet weak var homeButton: UIButton!{
    didSet{
      if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        homeButton.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 20)
      } else {
        homeButton.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 16)
      }
    }
  }
  @IBOutlet weak var homeLabel: UIButton!
  @IBOutlet weak var rightArrowImageView: UIImageView!
  @IBOutlet weak var homevdeoCollectionView: UICollectionView!
    weak var delegate: HomeVideoTableViewCellDelegate!
    var channelType = ""
    var startTime = Date()
    var endTime = Date()
    var timeStart = String()
    var timeEnd = String()
    var channelArray: [VideoModel]? {
        didSet{
            
            homevdeoCollectionView.reloadData()
            
            self.layoutIfNeeded()
        }
    }
    var liveGuideArray:[LiveGuideModel]? {
        didSet{
            
            homevdeoCollectionView.reloadData()
            
            self.layoutIfNeeded()
        }
    }
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   // channelArray = []
     homevdeoCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
    homevdeoCollectionView.register(UINib(nibName: "partnerDescriptionCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
    homevdeoCollectionView.register(UINib(nibName: "LiveGuideCollelctionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveGuideCollectionCell")
    homevdeoCollectionView.showsHorizontalScrollIndicator = false
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.invalidateLayout()
      homevdeoCollectionView.collectionViewLayout = layout
    
       homevdeoCollectionView.delegate = self
    homevdeoCollectionView.dataSource = self
    channelArray = []
    rightArrowImageView.setImageColor(color: ThemeManager.currentTheme().HeadTextColor)
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animate(alongsideTransition: { (_) in
            self.homevdeoCollectionView.collectionViewLayout.shouldInvalidateLayout(forBoundsChange: .zero) // layout update
        }, completion: nil)
    }
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.date(from:item)!
        return date
    }
    
    func GetFormatedDate(date_string:String,dateFormat:String)-> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        
        let dateFromInputString = dateFormatter.date(from: date_string)
        dateFormatter.dateFormat = "MM-dd-yyyy" // Here you can use any dateformate for output date
        if(dateFromInputString != nil){
            return dateFormatter.string(from: dateFromInputString!)
        }
        else{
            debugPrint("could not convert date")
            return "N/A"
        }
    }
  // MARK: Collectionview
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if channelType == "LiveGuide"{
          return liveGuideArray!.count
      }
    return channelArray!.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


     if channelType == "NewReleases" {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
        cell.videoImage.layer.cornerRadius = 8.0
        cell.videoImage.layer.masksToBounds = true
        cell.videoImage.contentMode = .scaleToFill
//         if channelArray![indexPath.row].is_free_video == true{
//             cell.freeTag.isHidden = true
//         }
//         else{
//             cell.freeTag.isHidden = false

//         }
                if channelArray![indexPath.row].show_name != nil {

            cell.videoName.text = channelArray![indexPath.row].show_name?.uppercased()
        }
        else{
            cell.videoName.text = ""
        }
        cell.episodeLabel.isHidden = true
      if channelArray![indexPath.row].logo != nil {
        cell.videoImage.sd_setImage(with: URL(string: imageUrl + channelArray![indexPath.row].logo!),placeholderImage:UIImage(named: "landscape_placeholder"))
      } else {
        cell.videoImage.image = UIImage(named: "landscape_placeholder")
      }
      if channelArray![indexPath.row].premium_flag != nil {
        if channelArray![indexPath.row].premium_flag == 0 {
          cell.premiumImage.isHidden = true
          cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
        } else {
          cell.premiumImage.isHidden = true
        }
      } else {
        cell.premiumImage.isHidden = true
        cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
      }
    cell.episodeLabel.isHidden = true
      cell.liveLabel.isHidden = true
         cell.progressView.isHidden = true
         cell.playButton.isHidden = true
        return cell

    }
     else if channelType == "ContinueWatching" {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
         cell.videoImage.layer.cornerRadius = 8.0
         cell.videoImage.layer.masksToBounds = true
         cell.videoImage.contentMode = .scaleToFill
//         if channelArray![indexPath.row].is_free_video == true{
//             cell.freeTag.isHidden = true
//         }
//         else{
//             cell.freeTag.isHidden = false
//
//         }
         if channelArray![indexPath.row].watched_percentage != 0{
             let duration = Float((channelArray![indexPath.row].watched_percentage)!) / 100
             cell.progressView.setProgress(duration, animated: false)
         }
         else{

             cell.progressView.setProgress(0.1, animated: false)

         }
       if channelArray![indexPath.row].logo_thumb != nil {
         cell.videoImage.sd_setImage(with: URL(string: channelArray![indexPath.row].logo_thumb!),placeholderImage:UIImage(named: "landscape_placeholder"))
       } else {
         cell.videoImage.image = UIImage(named: "landscape_placeholder")
       }
       
             if channelArray![indexPath.row].video_title != nil{
                 cell.videoName.isHidden = false
                 cell.videoName.text = channelArray![indexPath.row].video_title!.uppercased()
                 
             }
             else{
                 cell.videoName.isHidden = true
                 cell.videoName.text = ""
             }
             
         
       if channelArray![indexPath.row].premium_flag != nil {
         if channelArray![indexPath.row].premium_flag == 0 {
           cell.premiumImage.isHidden = true
           cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
         } else {
           cell.premiumImage.isHidden = true
         }
       } else {
         cell.premiumImage.isHidden = true
         cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
       }
     cell.episodeLabel.isHidden = true
     cell.liveLabel.isHidden = true
     cell.progressView.isHidden = false
         cell.playButton.isHidden = false

         return cell

     }
      
    else if channelType == "MyList" {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
       cell.videoImage.layer.cornerRadius = 8.0
       cell.videoImage.layer.masksToBounds = true
       cell.videoImage.contentMode = .scaleToFill
//        if channelArray![indexPath.row].is_free_video == true{
//            cell.freeTag.isHidden = true
//        }
//        else{
//            cell.freeTag.isHidden = false
//
//        }
       if channelArray![indexPath.row].show_name != nil {

        cell.videoName.text = channelArray![indexPath.row].show_name?.uppercased()
       }
       else{
           cell.videoName.text = ""
       }
       cell.episodeLabel.isHidden = true
     if channelArray![indexPath.row].logo != nil {
       cell.videoImage.sd_setImage(with: URL(string: imageUrl + channelArray![indexPath.row].logo!),placeholderImage:UIImage(named: "landscape_placeholder"))
     } else {
       cell.videoImage.image = UIImage(named: "landscape_placeholder")
     }
     if channelArray![indexPath.row].premium_flag != nil {
       if channelArray![indexPath.row].premium_flag == 0 {
         cell.premiumImage.isHidden = true
         cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
       } else {
         cell.premiumImage.isHidden = true
       }
     } else {
       cell.premiumImage.isHidden = true
       cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
     }
   cell.episodeLabel.isHidden = true
     cell.liveLabel.isHidden = true
        cell.progressView.isHidden = true
        cell.playButton.isHidden = true

       return cell

   }
     else if channelType == "LiveGuide"{
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveGuideCollectionCell", for: indexPath as IndexPath) as! LiveGuideCollectionViewCell
         if liveGuideArray![indexPath.row].video_title != nil {
             cell.videoTitle.text = liveGuideArray![indexPath.row].video_title
         }
         else{
             cell.videoTitle.text = "Live"
         }
         
         if liveGuideArray![indexPath.row].thumbnail != nil {
             cell.trendingImageLogo.sd_setImage(with: URL(string: ((imageUrl + liveGuideArray![indexPath.row].thumbnail!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
       } else {
          cell.trendingImageLogo.image = UIImage(named: "landscape_placeholder")
           
       }
      
        cell.layer.masksToBounds = true
         return cell
     }
      
     else if channelType == "FreeShows"{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
        cell.videoImage.layer.cornerRadius = 8.0
        cell.videoImage.layer.masksToBounds = true
        cell.videoImage.contentMode = .scaleToFill
//         if channelArray![indexPath.row].is_free_video == true{
//             cell.freeTag.isHidden = true
//         }
//         else{
//             cell.freeTag.isHidden = false
//
//         }
        if channelArray![indexPath.row].show_name != nil {

            cell.videoName.text = channelArray![indexPath.row].show_name?.uppercased()
        }
        else{
            cell.videoName.text = ""
        }
        if channelArray![indexPath.row].logo != nil {
        cell.videoImage.sd_setImage(with: URL(string: ((imageUrl + channelArray![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
//         cell.videoName.isHidden = true
      } else {
        cell.videoName.isHidden = false
        cell.episodeLabel.isHidden = true
        //cell.backgroundColor = .lightGray
       cell.videoImage.image = UIImage(named: "landscape_placeholder")
      }
      cell.liveLabel.isHidden = true
      cell.PartNumber.isHidden = true
         cell.progressView.isHidden = true
         cell.playButton.isHidden = true

        return cell
    }
      else if channelType == "LIVE" {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
          if channelArray![indexPath.row].logo_thumb != nil{
              cell.videoImage.sd_setImage(with: URL(string: ((channelArray![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
          }
          else{
              cell.videoImage.image = UIImage(named: "landscape_placeholder")

          }
          cell.freeTag.isHidden = true
          cell.videoImage.contentMode = .scaleAspectFill
          cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
          if channelArray![indexPath.row].show_name != nil {

              cell.videoName.text = channelArray![indexPath.row].show_name?.uppercased()
          }
          else{
              cell.videoName.text  = "KICCTV"
          }
          cell.videoName.isHidden = false
          if channelArray![indexPath.row].type == "UPCOMING_EVENT"{
              cell.liveLabel.isHidden = true
          }
          else{
              cell.liveLabel.isHidden = false
          }
          cell.liveLabel.layer.masksToBounds = true
          cell.progressView.isHidden = true
          cell.liveLabel.layer.cornerRadius = 4
          cell.playButton.isHidden = true

          return cell
      }
      else if channelType == "ENDED_EVENT"{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
             cell.videoImage.layer.cornerRadius = 8.0
             cell.videoImage.layer.masksToBounds = true
             cell.videoImage.contentMode = .scaleToFill
              
                  cell.freeTag.isHidden = true

              
             if channelArray![indexPath.row].show_name != nil {

                 cell.videoName.text = channelArray![indexPath.row].show_name?.uppercased()
             }
             else{
                 cell.videoName.text = ""
             }
             cell.episodeLabel.isHidden = true
             if channelArray![indexPath.row].logo_thumb != nil {
             cell.videoImage.sd_setImage(with: URL(string: (( channelArray![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
           }
             else {
            cell.videoImage.image = UIImage(named: "landscape_placeholder")
           }
              cell.progressView.isHidden = true

           cell.liveLabel.isHidden = true
              cell.playButton.isHidden = true

           cell.PartNumber.isHidden = true
             return cell
         }
      else if channelType == "News"{
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
         cell.videoImage.layer.cornerRadius = 8.0
         cell.videoImage.layer.masksToBounds = true
         cell.videoImage.contentMode = .scaleToFill
         
              cell.freeTag.isHidden = true

          
         if channelArray![indexPath.row].show_name != nil {

             cell.videoName.text = channelArray![indexPath.row].show_name?.uppercased()
         }
         else{
             cell.videoName.text = ""
         }
         cell.episodeLabel.isHidden = true
         if channelArray![indexPath.row].logo_thumb != nil {
         cell.videoImage.sd_setImage(with: URL(string: (( channelArray![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
       }
         else {
        cell.videoImage.image = UIImage(named: "landscape_placeholder")
       }
          cell.progressView.isHidden = true

       cell.liveLabel.isHidden = true
          cell.playButton.isHidden = true

       cell.PartNumber.isHidden = true
         return cell
     }
     else if channelType == "Dianamic"{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
        cell.videoImage.layer.cornerRadius = 8.0
        cell.videoImage.layer.masksToBounds = true
        cell.videoImage.contentMode = .scaleToFill
         cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
//         if channelArray![indexPath.row].is_free_video == true{
//             cell.freeTag.isHidden = true
//         }
//         else{
//             cell.freeTag.isHidden = false
//
//         }
        if channelArray![indexPath.row].show_name != nil {

            cell.videoName.text = channelArray![indexPath.row].show_name?.uppercased()
        }
        else{
            cell.videoName.text = ""
        }
        cell.episodeLabel.isHidden = true
        if channelArray![indexPath.row].logo_thumb != nil {
        cell.videoImage.sd_setImage(with: URL(string: (( channelArray![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
      }
        else {
       cell.videoImage.image = UIImage(named: "landscape_placeholder")
      }
         cell.progressView.isHidden = true

      cell.liveLabel.isHidden = true
         cell.playButton.isHidden = true

      cell.PartNumber.isHidden = true
        return cell
    }
     else if channelType == "Partner" {
            let cell: SearchCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionCell
                   cell.ImageView.layer.masksToBounds = true
                   cell.ImageView.contentMode = .scaleToFill
        if channelArray![indexPath.row].thumbnail != nil {
          cell.ImageView.sd_setImage(with: URL(string: ((imageUrl + channelArray![indexPath.row].thumbnail!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
           
//            cell.episodeLabel.text = channelArray![indexPath.row].thumbnail
        }
        
        
        else {
          cell.ImageView.image = UIImage(named: "landscape_placeholder")
        }
        //cell.videoImage.image = UIImage(named: "AndroidScreenShot")
        if channelArray![indexPath.row].video_title != nil{
             cell.titleLabel.text = channelArray![indexPath.row].video_title
            
        }
        else{
            cell.titleLabel.text = " "
        }

        
        
        
        return cell
     }else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
//         if channelArray![indexPath.row].is_free_video == true{
//             cell.freeTag.isHidden = true
//         }
//         else{
//             cell.freeTag.isHidden = false
//
//         }
        if channelArray![indexPath.row].show_name != nil {

            cell.episodeLabel.text = channelArray![indexPath.row].show_name
        }
        else{
            cell.episodeLabel.text = ""
        }
        if channelArray![indexPath.row].logo != nil {
            cell.videoImage.sd_setImage(with: URL(string: ((showUrl1 + channelArray![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        }
            
            
        else {
            cell.videoImage.image = UIImage(named: "landscape_placeholder")
        }
        //cell.videoImage.image = UIImage(named: "AndroidScreenShot")
        cell.videoName.text = channelArray![indexPath.row].video_title
//        cell.videoName.isHidden = true
        cell.liveLabel.isHidden = true
         cell.playButton.isHidden = true

        if channelArray![indexPath.row].premium_flag != nil {
            if channelArray![indexPath.row].premium_flag == 0 {
                cell.premiumImage.isHidden = true
                cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
            } else {
                cell.premiumImage.isHidden = true
            }
        }else {
            cell.premiumImage.isHidden = true
            cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
        }
        if channelArray![indexPath.row].video_flag != nil {
            if channelArray![indexPath.row].video_flag == 1 {
                cell.PartNumber.isHidden = false
//                cell.videoName.isHidden = false
            } else {
                cell.PartNumber.isHidden = true
//                cell.videoName.isHidden = true
            }
        } else {
            cell.PartNumber.isHidden = true
//            cell.videoName.isHidden = true
        }
         cell.progressView.isHidden = true

        return cell
    }
    
  }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if channelType == "NewReleases" {
         delegate.didSelectShowVideos(passModel: channelArray![indexPath.item])
        }
        else if channelType == "LIVE"{
            delegate.didSelectLiveNowVideos(passModel: channelArray![indexPath.item])
        }
        else if channelType == "LIVE_EVENT"{
            delegate.didSelectLiveNowVideos(passModel: channelArray![indexPath.item])

        }
        else if channelType == "UPCOMING_EVENT"{
            delegate.didSelectLiveNowVideos(passModel: channelArray![indexPath.item])

        }
        else if channelType == "ENDED_EVENT"{
            delegate.didSelectEndedEvents(passModel: channelArray![indexPath.item])

        }
        else if channelType == "FreeShows"{
             delegate.didSelectCategory(passModel: channelArray![indexPath.item])
        }else if channelType == "Dianamic"{
             delegate.didSelectCategory(passModel: channelArray![indexPath.item])
        }
        else if channelType == "News"{
             delegate.didSelectNews(passModel: channelArray![indexPath.item])
        }
        else if channelType == "ContinueWatching" {
            delegate.didSelectDianamicVideos(passModel: channelArray![indexPath.item])
        } else {
       delegate.didSelectShowVideos(passModel: channelArray![indexPath.item])
      }
    }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
       
        let width = (UIScreen.main.bounds.width) / 2.5//some width
        let  height = (9 * width) / 16
      if channelType == "Dianamic" {
          return CGSize(width: width , height: height + 50)

      }
      else {
          return CGSize(width: width , height: height + 50)
      }
    } else {
        let width = (UIScreen.main.bounds.width) / 2.3//some width
        let  height = (9 * width) / 16
       if channelType == "Dianamic" {
        return CGSize(width: width , height: height + 50)
      }
       else {
          return CGSize(width: width , height: height + 50)
      }
    }
  }

}
