//
//  VideoDetailsViewController.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 26/09/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import AVFoundation
import AVKit
import Reachability
import SummerSlider

class VideoDetailsViewController: UIViewController,InternetConnectivityDelegate {
    @IBOutlet weak var showImageview: UIImageView!{
        didSet{
            showImageview.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var ratingView: UIView!{
        didSet{
            ratingView.isHidden = true
        }
    }
    @IBOutlet weak var ratingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var imdbRatingText: UILabel!
    @IBOutlet weak var numberOfRating: UILabel!
    @IBOutlet weak var mainView: UIView!{
    didSet{
        self.mainView.backgroundColor = UIColor.clear
//        setGradientBackgroundForDetailScreen(colorTop:UIColor.black, colorBottom: UIColor.clear)
    }
  }
    @IBOutlet weak var catagoriesCollectionViewHeight: NSLayoutConstraint!
  @IBOutlet weak var VideoImageView: UIImageView!
    @IBOutlet weak var CastCollectionView: UICollectionView!
    @IBOutlet weak var CastCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ShowImagevViewHeight: NSLayoutConstraint!
    @IBOutlet weak var synopsisHeight: NSLayoutConstraint!
  @IBOutlet weak var VideoNameLabel: UILabel!
  @IBOutlet weak var AwardTableView: UITableView!
  @IBOutlet weak var MainViewHeight: NSLayoutConstraint!
  @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
  @IBOutlet weak var mainScrollView: UIScrollView!
  @IBOutlet weak var ResalutionLabel: UILabel!
  @IBOutlet weak var ProducerLabel: UILabel!
  @IBOutlet weak var yearOfRelaseLabel: UILabel!
  @IBOutlet weak var categoriesCollectionView: UICollectionView!
  @IBOutlet weak var synopsisLabel: UILabel!

  @IBOutlet weak var subscriptionNameLabel: UILabel!
//  {
//    didSet{
//        self.subscriptionNameLabel.isHidden =
//    }
//}
  @IBOutlet weak var similarVideoCollectionView: UICollectionView!
    
    @IBOutlet weak var similarCollectionviewHeight: NSLayoutConstraint!
    
    
  @IBOutlet weak var audioLabel: UILabel!
    @IBOutlet weak var synopsisTitleLabel: UILabel!{
        didSet{
        }
    }
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
//  @IBOutlet weak var themeTitleLabel: UILabel!{
//      didSet{
//          self.themeTitleLabel.textColor = ThemeManager.currentTheme().UIImageColor
//      }
//  }
  @IBOutlet weak var producerTitleLabel: UILabel!{
      didSet{
          self.producerTitleLabel.textColor = ThemeManager.currentTheme().TabbarColor
      }
  }
  @IBOutlet weak var yearOfreleseTitleLabel: UILabel!{
      didSet{
//          self.yearOfreleseTitleLabel.textColor = ThemeManager.currentTheme().TabbarColor
      }
  }
  @IBOutlet weak var audioTitleLabel: UILabel!{
      didSet{
          self.audioTitleLabel.textColor = ThemeManager.currentTheme().TabbarColor
      }
  }
    
    @IBOutlet weak var youMayLikeLabel: UILabel!{
        didSet{
            self.youMayLikeLabel.isHidden = true
        }
    }
    @IBOutlet weak var castHeaderLabel: UILabel!{
        didSet{
            self.castHeaderLabel.isHidden = true
        }
    }
    @IBOutlet weak var castHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var youMayLikeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var producerLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var yearLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var audioTitleHeight: NSLayoutConstraint!
    
  @IBOutlet weak var watchTrailerButton: UIButton!{
    didSet{
      self.watchTrailerButton.layer.cornerRadius = 16
      self.watchTrailerButton.clipsToBounds = true
      self.watchTrailerButton.layer.borderWidth = 1
        self.watchTrailerButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
     self.watchTrailerButton.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
  }
  
  
//  @IBOutlet weak var playButton: UIButton!{
//    didSet{
//      self.playButton.layer.cornerRadius = 5
//      self.playButton.clipsToBounds = true
//      self.playButton.backgroundColor = ThemeManager.currentTheme().TabbarColor
//    }
//  }
  @IBOutlet weak var watchTrailerButtonWidth: NSLayoutConstraint!
//  @IBOutlet weak var playButtonWidth: NSLayoutConstraint!
  @IBOutlet weak var watchTrailerButtonHeight: NSLayoutConstraint!
  @IBOutlet weak var playNowButtonHeight: NSLayoutConstraint!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!{
    didSet{
      activityIndicatorView.color = ThemeManager.currentTheme().UIImageColor
    }
  }
  var avPlayer: AVPlayer? = AVPlayer()
    var contentPlayerLayer: AVPlayerLayer?
  @IBOutlet weak var videoTrailerView: UIView!{
    didSet{
      self.videoTrailerView.backgroundColor = .black
      self.videoTrailerView.isHidden = true
    }
  }
  
  
  @IBOutlet weak var youtubePlayeViewHeight: NSLayoutConstraint!
  @IBOutlet weak var videoImageViewHeight: NSLayoutConstraint!
  @IBOutlet weak var videoImageViewWidth: NSLayoutConstraint!
  @IBOutlet weak var VideoTrailerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ourtakeHeaderLabel: UILabel!
    @IBOutlet weak var ourtakeLabel: UILabel!
    @IBOutlet weak var keyArtWorkHeaderLabel: UILabel!
    @IBOutlet weak var KeyArtWorkCollectionView: UICollectionView!
    
    @IBOutlet weak var KeyArtWorkCollectionviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var keyArtWorkHeaderLabelHeight: NSLayoutConstraint!
    //    @IBOutlet weak var dislikeButton: FlexibleButton!{
//        didSet{
//          dislikeButton.set(image:UIImage(named: "facebookDislike") , title: "Dislike", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
//          dislikeButton.isUserInteractionEnabled = true
//        }
//    }
    @IBOutlet weak var seasonFilterCollectionView: UICollectionView!
    @IBOutlet weak var seasonFilterCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareButtton: FlexibleButton!{
    didSet{
      shareButtton.set(image: UIImage(named: "share-24gray") , title: "Share", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
    }
  }
  @IBOutlet weak var likeButton: FlexibleButton!{
    didSet{
      likeButton.set(image:UIImage(named: "icons8-circled-play-48") , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
      likeButton.isUserInteractionEnabled = true
        
    }
  }
  @IBOutlet weak var watchListButton: FlexibleButton!{
    didSet{
      watchListButton.set(image:UIImage(named: "plus-math") , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
      watchListButton.isUserInteractionEnabled = false
    }
  }
    
    @IBOutlet weak var playPauseButton: UIButton!
    {
        didSet{
               self.playPauseButton.isHidden = true
               }
    }
    @IBOutlet weak var forwardButton: UIButton!
    {
        didSet{
               self.forwardButton.isHidden = true
               }
    }
    
    @IBOutlet weak var backwardButton: UIButton!
    {
        didSet{
               self.backwardButton.isHidden = true
               }
    }
    
    @IBOutlet weak var videoSlider: SummerSlider!
    {
        didSet{
               self.videoSlider.isHidden = true
               }
    }
    @IBOutlet weak var startDurationLabel: UILabel!
    {
           didSet{
           self.startDurationLabel.isHidden = true
           }
       }
    @IBOutlet weak var durationLabel: UILabel!
    {
           didSet{
           self.durationLabel.isHidden = true
           }
       }
    
    
    @IBOutlet weak var fullscreenButton: UIButton!{
        didSet{
        self.fullscreenButton.isHidden = true
        }
    }
    
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var awardTableviewheight: NSLayoutConstraint!
    @IBOutlet weak var episodeListingTableView: UITableView!
    @IBOutlet weak var episodeListingTableViewHeight: NSLayoutConstraint!
    
    
   
    
    
        
  
  
  
  var reachability = Reachability()!
  var Categories = [VideoModel]()
  var ShowData = [ShowDetailsModel]()
  var categoryModel : VideoModel!
  var likeFlagModel = [LikeWatchListModel]()
  var watchFlagModel = [LikeWatchListModel]()
  
  var categoryListArray = [categoriesModel]()
  var languagesListArray = [languagesModel]()
  var showVideoListArray = [VideoModel]()
    var awardListArray = [awardModel]()
    var castListArray = [castModel]()
    var keyArtWorkArray = [keyArtWorkModel]()

  var selectedFilter = 0
  var categoryId = ""
  var fromTab = ""
  var token = ""
  var shareLink = ""
  var fromCategories = true
  var changescreen = false
  var VideoNameLabelHeight = CGFloat()
  var ProducerHeight = CGFloat()
  var themeHeight = CGFloat()
  var yearOfRelaseHeight = CGFloat()
  var resolutionLabelHeight = CGFloat()
  var synopsisLabelHeight = CGFloat()
  var audioLabelHeight = CGFloat()
  var subtitleLabelHeight = CGFloat()
  var synopsisTitleLabelHeight = CGFloat()
    var ourtakeTitleLabelHeight = CGFloat()
    var ourtakeLabelHeight = CGFloat()
    @IBOutlet weak var ourtakeHeight: NSLayoutConstraint!
    
  var themeTitleLabelHeight = CGFloat()
    var text = ""
  var teaser = ""
  var themeList = ""
  var audioList = ""
  var themeListArray = Array<String>()
  var observer: Any!
  var selectedIndex = 0
  var fromVideoPlaying = false
  var likevideo = false
  var dislikevideo = false
  var watchVideo = false
  var fromDeepLink = false
  var fromHomeViewController = false
  var show_Id = ""
    var episodeArray = [VideoModel]()
    var singleVideoArray = [VideoModel]()

  override func viewDidLoad() {
    super.viewDidLoad()

    similarVideoCollectionView.backgroundColor = .clear
    self.navigationTitle()
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
    self.mainView.isHidden = true
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    let nib =  UINib(nibName: "AwardListTableViewCell", bundle: nil)
    AwardTableView.register(nib, forCellReuseIdentifier: "AwardTableCell")
    self.AwardTableView.delegate = self
    self.AwardTableView.dataSource = self
    self.AwardTableView.separatorStyle = .none
      
      let nib1 =  UINib(nibName: "EpisodeTableViewCell", bundle: nil)
      episodeListingTableView.register(nib1, forCellReuseIdentifier: "EpisodeCell")
      self.episodeListingTableView.delegate = self
      self.episodeListingTableView.dataSource = self
      self.episodeListingTableView.separatorStyle = .none
      self.episodeListingTableView.backgroundColor = .black
      
    self.CastCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionCell")
    self.CastCollectionView.delegate = self
    self.CastCollectionView.dataSource = self
    CastCollectionView.backgroundColor = .clear
    let flowLayout2 = UICollectionViewFlowLayout()
    flowLayout2.scrollDirection = .horizontal
    self.CastCollectionView.collectionViewLayout = flowLayout2
      
      self.KeyArtWorkCollectionView.register(UINib(nibName: "EpisodeListCell", bundle: nil), forCellWithReuseIdentifier: "EpisodeCell")
      self.KeyArtWorkCollectionView.delegate = self
      self.KeyArtWorkCollectionView.dataSource = self
      KeyArtWorkCollectionView.backgroundColor = .clear
      let flowLayout3 = UICollectionViewFlowLayout()
      flowLayout3.scrollDirection = .horizontal
      self.KeyArtWorkCollectionView.collectionViewLayout = flowLayout3
     
      self.seasonFilterCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
      self.seasonFilterCollectionView.delegate = self
      self.seasonFilterCollectionView.dataSource = self
      seasonFilterCollectionView.backgroundColor = .clear
      let flowLayout4 = UICollectionViewFlowLayout()
      flowLayout4.scrollDirection = .horizontal
      self.seasonFilterCollectionView.collectionViewLayout = flowLayout4
        
    self.similarVideoCollectionView.register(UINib(nibName: "EpisodeListCell", bundle: nil), forCellWithReuseIdentifier: "EpisodeCell")
    self.similarVideoCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
    self.similarVideoCollectionView.delegate = self
    self.similarVideoCollectionView.dataSource = self
    let flowLayout1 = UICollectionViewFlowLayout()
    flowLayout1.scrollDirection = .horizontal
    self.similarVideoCollectionView.collectionViewLayout = flowLayout1
   
      self.videoViewHeight?.constant = (9 * (self.view.frame.size.width))/16
        self.videoImageViewHeight?.constant =  (9 * (self.view.frame.size.width))/16
        self.ShowImagevViewHeight?.constant = (9 * (self.view.frame.size.width))/16
      self.topViewHeight.constant = (9 * (self.view.frame.size.width))/16
         self.videoTrailerView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  videoViewHeight.constant)
      self.videoHeight = (9 * (self.view.frame.size.width))/16

    // self.InitialView()
  }
    

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = false
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
      if reachability.connection != .none {
      getShowData()
      getSimilarVideos()
      }
    if self.changescreen {
      self.AwardTableView.reloadData()
    }
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do {
      try reachability.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
     avPlayer?.play()
  }
  override func viewWillDisappear(_ animated: Bool) {
    CustomProgressView.hideActivityIndicator()
    self.avPlayer!.pause()
    super.viewWillDisappear(animated)
  }

    func updateUI(){
        
    }
  // MARK: Button Actions
  @objc func tapFunction(sender:UITapGestureRecognizer) {
    synopsisHeight.constant = self.synopsisLabelHeight
    synopsisLabel.lineBreakMode = .byWordWrapping
    synopsisLabel.text = ShowData[0].synopsis!
    let Metadataheight =  self.resolutionLabelHeight + self.VideoNameLabelHeight +  self.audioLabelHeight + self.themeTitleLabelHeight +  110
      self.MainViewHeight.constant = awardTableviewheight.constant +  Metadataheight + self.themeHeight + self.yearOfRelaseHeight + audioLabelHeight + self.synopsisLabelHeight + self.synopsisTitleLabelHeight  +  watchTrailerButtonHeight.constant  + self.ProducerHeight + youMayLikeHeight.constant + similarCollectionviewHeight.constant + 250 + CastCollectionViewHeight.constant + KeyArtWorkCollectionviewHeight.constant + ratingViewHeight.constant + ourtakeHeight.constant  + self.ourtakeTitleLabelHeight +  self.seasonFilterCollectionViewHeight.constant +  self.episodeListingTableViewHeight.constant
  }
    @objc func tapMoreFunctionOurTake(sender:UITapGestureRecognizer) {
      ourtakeHeight.constant = self.ourtakeLabelHeight
      ourtakeLabel.lineBreakMode = .byWordWrapping
        ourtakeLabel.text = ShowData[0].our_take!
      let Metadataheight =  self.resolutionLabelHeight + self.VideoNameLabelHeight +  self.audioLabelHeight + self.themeTitleLabelHeight +  110
        self.MainViewHeight.constant = awardTableviewheight.constant +  Metadataheight + self.themeHeight + self.yearOfRelaseHeight + audioLabelHeight + self.synopsisLabelHeight + self.synopsisTitleLabelHeight +  watchTrailerButtonHeight.constant  + self.ProducerHeight + youMayLikeHeight.constant + similarCollectionviewHeight.constant + 250 + CastCollectionViewHeight.constant + KeyArtWorkCollectionviewHeight.constant + ratingViewHeight.constant + self.ourtakeLabelHeight + self.ourtakeTitleLabelHeight +  self.seasonFilterCollectionViewHeight.constant +  self.episodeListingTableViewHeight.constant
    }
  @objc func tapProducerAction(sender:UITapGestureRecognizer) {
    self.didClickProducerName(producerName:  self.ShowData[0].producer!)
  }
  @IBAction func backAction(_ sender: Any){
    self.changescreen = true
    if let observer = self.observer {
        self.avPlayer!.removeTimeObserver(observer)
        self.avPlayer!.pause()
      self.observer = nil
    }
    if  fromHomeViewController || Application.shared.guestRegister {
      let delegate = UIApplication.shared.delegate as? AppDelegate
      delegate!.loadTabbar()
    } else {
      if fromVideoPlaying {
        self.navigationController!.popToRootViewController(animated: true)
      }else{
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  @IBAction func playAction(_ sender: Any) {
    self.changescreen = true
    self.avPlayer!.pause()
    self.videoTrailerView.isHidden = true
    if !episodeArray.isEmpty {
      let video = episodeArray[selectedIndex]
        print("video id = \(video.video_id)")
         let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
        
        if video.watched_duration != nil && video.watched_duration != 0{
            print("watched duration true")
            videoPlayerController.fromContinueWatching = true
            videoPlayerController.watchedDuration = video.watched_duration!
        }
        else{
            print("watched duration false")
            videoPlayerController.fromContinueWatching = false
            videoPlayerController.watchedDuration = 0
        }
        videoPlayerController.video = video
        if fromDeepLink {
            videoPlayerController.showId = Int(self.show_Id)!
        } else {
            videoPlayerController.showId = categoryModel.show_id!
        }
        if let premiumFlag = ShowData[0].premium_flag{
            videoPlayerController.premium_flag = premiumFlag
        }
      self.navigationController?.pushViewController(videoPlayerController, animated: false)
        
    }
      else{
          let video = singleVideoArray[0]
            print("video id = \(video.video_id)")
             let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
            
            if video.watched_duration != nil && video.watched_duration != 0{
                print("watched duration true")
                videoPlayerController.fromContinueWatching = true
                videoPlayerController.watchedDuration = video.watched_duration!
            }
            else{
                print("watched duration false")
                videoPlayerController.fromContinueWatching = false
                videoPlayerController.watchedDuration = 0
            }
            videoPlayerController.video = video
            if fromDeepLink {
                videoPlayerController.showId = Int(self.show_Id)!
            } else {
                videoPlayerController.showId = categoryModel.show_id!
            }
            if let premiumFlag = ShowData[0].premium_flag{
                videoPlayerController.premium_flag = premiumFlag
            }
          self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
  }
  @IBAction func watchListAction(_ sender: Any) {
    if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
        self.remove()
    } else {
      if !watchVideo {
        self.watchVideo = true
        self.watchListShow()
//         self.watchListButton.set(image:UIImage(named: "checkmark-24") , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
        let image = UIImage(named: "checkmark-24")?.withRenderingMode(.alwaysTemplate)
               watchListButton.tintColor = ThemeManager.currentTheme().TabbarColor
               self.watchListButton.set(image: image , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
      } else {
        self.watchVideo = false
        self.watchListShow()
        self.watchListButton.set(image:UIImage(named: "plus-math") , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
      }
    }
  }
  @IBAction func shareAction(_ sender: Any) {

    if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
        self.remove()
       }
    else{
        
        if let swhowid = ShowData[0].show_id {
          let text = "https://dev.projectfortysix.com/home/movies?show_id=\(swhowid)"
          if let synopsis = ShowData[0].synopsis ,let title = ShowData[0].show_name {
            let shareText = String(format:"%@",synopsis)
            shareLink = text + "\n\n\(title)" + "\n\n\(shareText)"
          } else {
            shareLink = text
          }
          let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
          present(vc, animated: true)
        }
    }
  }
    
    
    @IBAction func dislikeAction(_ sender: Any) {
        print("hello")
         if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
               let video = showVideoListArray[selectedIndex]
                 print("video id = \(video)")
               let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
               videoPlayerController.video = video
                 videoPlayerController.showId = categoryModel.show_id!
               self.navigationController?.pushViewController(videoPlayerController, animated: false)
           }else {
            self.likeButton.set(image:UIImage(named: "icons8-circled-play-48") , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
            self.likeButton.isUserInteractionEnabled = false

            self.likevideo = false
          if !dislikevideo {
            self.dislikevideo = true
            let image = UIImage(named: "dislikeGray")?.withRenderingMode(.alwaysTemplate)
//            dislikeButton.tintColor = ThemeManager.currentTheme().TabbarColor
//            self.dislikeButton.set(image: image , title: "Dislike", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
            

            self.dislikeShow()

          }
          else {
            self.dislikevideo = false
            self.likeButton.set(image:UIImage(named: "icons8-circled-play-48") , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)

            self.likeButton.isUserInteractionEnabled = true
//            self.dislikeButton.set(image:UIImage(named: "facebookDislike") , title: "Dislike", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
            
            self.dislikeShow()
            
            }
        }
    }
    @IBAction func likeAction(_ sender: Any) {
        self.changescreen = true
        self.avPlayer!.pause()
        self.videoTrailerView.isHidden = true
        if !episodeArray.isEmpty {
          let video = episodeArray[selectedIndex]
          let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
          videoPlayerController.video = video
            if video.watched_duration != nil && video.watched_duration != 0{
                videoPlayerController.fromContinueWatching = true
                videoPlayerController.watchedDuration = video.watched_duration!
            }
            else{
                videoPlayerController.fromContinueWatching = false
                videoPlayerController.watchedDuration = 0
            }
            if fromDeepLink {
                videoPlayerController.showId = Int(self.show_Id)!
            } else {
                videoPlayerController.showId = categoryModel.show_id!
            }
          self.navigationController?.pushViewController(videoPlayerController, animated: false)
            
        }
        else{
            let video = singleVideoArray[0]
              print("video id = \(video.video_id)")
               let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
              
              if video.watched_duration != nil && video.watched_duration != 0{
                  print("watched duration true")
                  videoPlayerController.fromContinueWatching = true
                  videoPlayerController.watchedDuration = video.watched_duration!
              }
              else{
                  print("watched duration false")
                  videoPlayerController.fromContinueWatching = false
                  videoPlayerController.watchedDuration = 0
              }
              videoPlayerController.video = video
              if fromDeepLink {
                  videoPlayerController.showId = Int(self.show_Id)!
              } else {
                  videoPlayerController.showId = categoryModel.show_id!
              }
              if let premiumFlag = ShowData[0].premium_flag{
                  videoPlayerController.premium_flag = premiumFlag
              }
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        }
  }
  @IBAction func watchTrailerAction(_ sender: UIButton) {
    self.watchTrailerButton.isUserInteractionEnabled = true
    if ShowData[0].teaser_flag != nil {
      if self.ShowData[0].teaser_flag == 0 {
        if self.ShowData[0].teaser_status_flag != nil {
          if self.ShowData[0].teaser_status_flag == 1 {
          }
        }
      } else if self.ShowData[0].teaser_flag == 1 {
        if let observer = self.observer {
            self.avPlayer!.removeTimeObserver(observer)
            self.avPlayer!.pause()
          self.observer = nil
        }
        if self.ShowData[0].teaser_status_flag != nil {
          if self.ShowData[0].teaser_status_flag == 1 {
            self.changescreen = true
            self.avPlayer!.pause()
           
              let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "trailerPlay") as! TrailerPlayingVC
            videoPlayerController.videoName = ShowData[0].teaser!
            if ShowData[0].show_name != nil{
                videoPlayerController.videoTitle = ShowData[0].show_name!

            }
            if ShowData[0].teaser_duration != nil{
                videoPlayerController.videoDuration = Double(ShowData[0].teaser_duration!)!

            }
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        
      }
    }
  }
    }
  }
//    lazy var sportlistCollectionview:UICollectionView = UICollectionView(frame: CGRect(x: 8, y: 90, width: self.view.frame.width , height:80), collectionViewLayout: UICollectionViewFlowLayout())
  // MARK: Main Functions

  func InitialView(){

   
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.mainViewWidth.constant = self.view.frame.width
        self.categoriesCollectionView.backgroundColor = .clear
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    var font = UIFont.boldSystemFont(ofSize:16)
      
      if ShowData[0].logo_thumb != nil {
          let image = ShowData[0].logo_thumb
          if image!.starts(with: "https"){
              self.showImageview.sd_setImage(with: URL(string: ShowData[0].logo_thumb!),placeholderImage:UIImage(named: "landscape_placeholder"))
          }
          else{
              self.showImageview.sd_setImage(with: URL(string: showUrl1 + ShowData[0].logo_thumb!),placeholderImage:UIImage(named: "landscape_placeholder"))
          }
         
      }
      else {
          self.showImageview.image = UIImage(named: "landscape_placeholder")
          self.VideoImageView.image = UIImage(named: "landscape_placeholder")
      }
    
    if ShowData[0].show_name != nil {
      self.VideoNameLabel.text = ShowData[0].show_name
      self.navigationItem.title = ShowData[0].show_name
      VideoNameLabelHeight = label.heightForLabel(text: ShowData[0].show_name!, font: font, width: view.frame.width - 30)
    }
    if ShowData[0].video_title != nil {
      self.VideoNameLabel.text = ShowData[0].video_title
      VideoNameLabelHeight = label.heightForLabel(text: ShowData[0].video_title!, font: font, width: view.frame.width - 30)
    }
      if ShowData[0].year != nil{
          if ShowData[0].resolution != nil{
              if ShowData[0].rating != nil{
                  if let year = ShowData[0].year,let duration = ShowData[0].resolution , let rating = ShowData[0].rating {
                    ResalutionLabel.text = String(format:"%@ • %@ • %@", year,duration,rating)
                    font = UIFont.boldSystemFont(ofSize:16)
                    resolutionLabelHeight = label.heightForLabel(text: ShowData[0].resolution!, font: font, width: view.frame.width - 30)
                  }
              }
              else{
                  if let year = ShowData[0].year,let duration = ShowData[0].resolution{
                    ResalutionLabel.text = String(format:"%@ • %@", year,duration)
                    font = UIFont.boldSystemFont(ofSize:16)
                    resolutionLabelHeight = label.heightForLabel(text: ShowData[0].resolution!, font: font, width: view.frame.width - 30)
                  }
              }
          }
          else{
              if let year = ShowData[0].year{
                ResalutionLabel.text = String(format:"%@", year)
                font = UIFont.boldSystemFont(ofSize:16)
                resolutionLabelHeight = label.heightForLabel(text: ShowData[0].year!, font: font, width: view.frame.width - 30)
              }
          }
          
      }
      else{
          if ShowData[0].resolution != nil{
              if ShowData[0].rating != nil{
                  if let duration = ShowData[0].resolution , let rating = ShowData[0].rating {
                    ResalutionLabel.text = String(format:"%@ • %@", duration,rating)
                    font = UIFont.boldSystemFont(ofSize:16)
                    resolutionLabelHeight = label.heightForLabel(text: ShowData[0].resolution!, font: font, width: view.frame.width - 30)
                  }
              }
              else{
                 
                  resolutionLabelHeight  = 0
              }
              
          }
          else{
              if ShowData[0].rating != nil{
                  if  let rating = ShowData[0].rating {
                    ResalutionLabel.text = String(format:"%@ ", rating)
                    font = UIFont.boldSystemFont(ofSize:16)
                    resolutionLabelHeight = label.heightForLabel(text: ShowData[0].rating!, font: font, width: view.frame.width - 30)
                  }
              }
              else{
                 
                  resolutionLabelHeight  = 0
              }
             
          }
      }
    
    font = UIFont.boldSystemFont(ofSize: 12)
    themeTitleLabelHeight = label.heightForLabel(text: "", font: font, width: view.frame.width - 30)
    if ShowData[0].producer != nil {
        ProducerHeight = label.heightForLabel(text:  "", font: font, width: view.frame.width - 30)
        ProducerHeight = 0
        
    }
    else{
        ProducerHeight = label.heightForLabel(text:  "", font: font, width: view.frame.width - 30)
        ProducerHeight = 0
    }
    
    if ShowData[0].director != nil {
//        self.yearOfreleseTitleLabel.text = "Director:"
        yearOfRelaseHeight = label.heightForLabel(text:  ShowData[0].director!, font: font, width: view.frame.width - 30)
          yearOfRelaseLabel.text =  ShowData[0].director
    }
    else{
        yearOfRelaseHeight = label.heightForLabel(text:  "", font: font, width: view.frame.width - 30)
        yearOfRelaseHeight = 0
    }
   if ShowData[0].show_cast != nil {
   
      self.audioTitleLabel.text = "Cast:"
    self.audioTitleLabel.isHidden = true
    self.audioLabel.isHidden = true
    audioLabelHeight = 0
    }
    else{
    audioLabelHeight = label.heightForLabel(text:  "", font: font, width: view.frame.width - 30)
        self.audioTitleLabel.isHidden = true
        audioLabelHeight = 0
    }

    if let rating = ShowData[0].imdb_rating{
        ratingViewHeight.constant = 100
//        imdbRatingText.text = rating
        let amountText = NSMutableAttributedString.init(string: "\(rating)/10")
       let len  = amountText.length
        // set the custom font and color for the 0,1 range in string
        amountText.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                      NSAttributedString.Key.foregroundColor: UIColor.gray],
                                     range: NSMakeRange(len-3, 3))
        // if you want, you can add more attributes for different ranges calling .setAttributes many times
        // set the attributed string to the UILabel object

        // set the attributed string to the UILabel object
        imdbRatingText.attributedText = amountText
        ratingView.isHidden = false
        if let numberOfRatings = ShowData[0].number_of_rating{
            self.numberOfRating.text = "\(numberOfRatings)  Ratings"
        }
        else{
            self.numberOfRating.isHidden = true
        }
        ratingImage.setImageColor(color: .white)
    }
    else{
        ratingView.isHidden = true
        ratingViewHeight.constant = 0

    }
    if ShowData[0].synopsis != nil {
         let text = ShowData[0].synopsis!
         self.text = ShowData[0].synopsis!
           self.synopsisTitleLabel.text = "Synopsis:"
           synopsisTitleLabelHeight = (label.heightForLabel(text: "Synopsis:", font: font, width: view.frame.width - 30)) + 10
         font = UIFont.boldSystemFont(ofSize: 12)
         synopsisLabelHeight = label.heightForLabel(text: text, font: font, width: view.frame.width - 30)
         let labelText = NSMutableAttributedString.init(string: text)
         if synopsisLabelHeight > 110 {
           synopsisHeight.constant = 110
           synopsisLabel.text = text
           _ = UIFont.boldSystemFont(ofSize: 13)
           _ = UIColor().colorFromHexString("5D87A0")
           DispatchQueue.main.async {
             self.synopsisLabel.addReadMoreString(to: self.synopsisLabel)
             //self.synopsisLabel.addTrailing(with: "...", moreText: "More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
           }
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
           synopsisLabel.isUserInteractionEnabled = true
           synopsisLabel.addGestureRecognizer(tap)
         } else {
           synopsisHeight.constant = synopsisLabelHeight
         }
         self.synopsisLabel.attributedText = labelText
       } else {
         self.synopsisTitleLabel.isHidden = true
           self.synopsisTitleLabel.text = ""
           synopsisTitleLabelHeight = (label.heightForLabel(text: "", font: font, width: view.frame.width - 30)) + 10
         synopsisTitleLabelHeight = 0
           self.synopsisHeight.constant = 0
       }
    if ShowData[0].our_take != nil {
         let text = ShowData[0].our_take!
         self.text = ShowData[0].our_take!
           self.ourtakeHeaderLabel.text = "Programmer's Notes:"
           ourtakeTitleLabelHeight = (label.heightForLabel(text: "Programmer's Notes:", font: font, width: view.frame.width - 30)) + 10
         font = UIFont.boldSystemFont(ofSize: 12)
         ourtakeLabelHeight = label.heightForLabel(text: text, font: font, width: view.frame.width - 30)
         let labelText = NSMutableAttributedString.init(string: text)
         if ourtakeLabelHeight > 110 {
           ourtakeHeight.constant = 110
           ourtakeLabel.text = text
           _ = UIFont.boldSystemFont(ofSize: 13)
           _ = UIColor().colorFromHexString("5D87A0")
           DispatchQueue.main.async {
             self.ourtakeLabel.addReadMoreString(to: self.ourtakeLabel)
             //self.synopsisLabel.addTrailing(with: "...", moreText: "More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
           }
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapMoreFunctionOurTake))
           ourtakeLabel.isUserInteractionEnabled = true
           ourtakeLabel.addGestureRecognizer(tap)
         } else {
           ourtakeHeight.constant = ourtakeLabelHeight
         }
         self.ourtakeLabel.attributedText = labelText
       } else {
         self.ourtakeHeaderLabel.isHidden = true
           self.ourtakeHeaderLabel.text = ""
           ourtakeTitleLabelHeight = (label.heightForLabel(text: "", font: font, width: view.frame.width - 30)) + 10
         ourtakeTitleLabelHeight = 0
           self.ourtakeHeight.constant = 0
       }
     

    if !categoryListArray.isEmpty {
        self.categoriesCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        self.categoriesCollectionView.delegate = self
        self.categoriesCollectionView.dataSource = self
        let flowLayout = CustomFlowLayout()
        self.categoriesCollectionView.collectionViewLayout = flowLayout

      self.categoriesCollectionView.reloadData()
      self.categoriesCollectionView.layoutIfNeeded()
      catagoriesCollectionViewHeight.constant = categoriesCollectionView.collectionViewLayout.collectionViewContentSize.height
      themeHeight = catagoriesCollectionViewHeight.constant
    }
      else{
          catagoriesCollectionViewHeight.constant = 0

      }
    if awardListArray.count > 0 {
          self.AwardTableView.isHidden = false
            awardTableviewheight.constant = CGFloat((self.awardListArray.count * 50)) + 150
        } else {
          self.AwardTableView.isHidden = true
            awardTableviewheight.constant = 0.0
     
        }
    if castListArray.count > 0 {
      self.CastCollectionView.isHidden = false
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            CastCollectionViewHeight.constant = 380
        }
        else{
            CastCollectionViewHeight.constant = 190
        }
        castHeaderHeight.constant = 21
    } else {
      self.CastCollectionView.isHidden = true
        CastCollectionViewHeight.constant = 0.0
        castHeaderHeight.constant = 0.0
    }
      if keyArtWorkArray.count > 0 {
        self.KeyArtWorkCollectionView.isHidden = false
          let width = (UIScreen.main.bounds.width) / 2.5
          let height =  (9 * width) / 16
          KeyArtWorkCollectionviewHeight.constant = height

          keyArtWorkHeaderLabelHeight.constant = 21
      } else {
        self.KeyArtWorkCollectionView.isHidden = true
          KeyArtWorkCollectionviewHeight.constant = 0.0
          keyArtWorkHeaderLabelHeight.constant = 0.0
      }
      
    if ShowData[0].teaser_flag != nil && self.ShowData[0].teaser_status_flag == 1 &&  ShowData[0].teaser_flag != 3 && ShowData[0].teaser_flag != 0 {
      self.getVideoToken()
      self.watchTrailerButtonWidth.constant = (self.categoriesCollectionView.frame.width)/2 - 10
//      self.playButtonWidth.constant = (self.categoriesCollectionView.frame.width)/2 - 10
//      self.teaser = ShowData[0].teaser!
    }
    if ShowData[0].teaser != nil{
    }  else {
      self.watchTrailerButton.isHidden = true
      self.watchTrailerButtonWidth.constant = 0
        self.watchTrailerButtonHeight.constant = 0
//      self.playButtonWidth.constant = (self.categoriesCollectionView.frame.width)
    }
    self.AwardTableView.reloadData()
    self.CastCollectionView.reloadData()
      self.KeyArtWorkCollectionView.reloadData()
    let Metadataheight =  self.resolutionLabelHeight + self.VideoNameLabelHeight + self.audioLabelHeight + self.yearOfRelaseHeight + self.themeTitleLabelHeight +  110 + self.synopsisTitleLabelHeight + self.ProducerHeight
      self.MainViewHeight.constant = awardTableviewheight.constant + Metadataheight + self.themeHeight + self.yearOfRelaseHeight + synopsisHeight.constant  + self.synopsisTitleLabelHeight + self.ProducerHeight + youMayLikeHeight.constant +  20 + similarCollectionviewHeight.constant + 250 + CastCollectionViewHeight.constant + ratingViewHeight.constant + KeyArtWorkCollectionviewHeight.constant + ourtakeHeight.constant  + self.ourtakeTitleLabelHeight +  self.seasonFilterCollectionViewHeight.constant +  self.episodeListingTableViewHeight.constant
    self.mainView.isHidden = false
    CustomProgressView.hideActivityIndicator()
  }
    
    @IBAction func rewindVideo(_ sender: Any) {
       if let currentTime = avPlayer?.currentTime() {
          var newTime = CMTimeGetSeconds(currentTime) - 10.0
            if newTime <= 0 {
                newTime = 0
            }
            avPlayer?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
     }
    @IBAction func forwardVideo(_ sender: Any) {
          if let currentTime = avPlayer?.currentTime(), let duration = avPlayer?.currentItem?.duration {
              var newTime = CMTimeGetSeconds(currentTime) + 10.0
                if newTime >= CMTimeGetSeconds(duration) {
                    newTime = CMTimeGetSeconds(duration)
                }
                avPlayer?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
            }
     }
    @available(iOS 10.0, *)

    @IBAction func fullScreenAction(_ sender: UIButton) {
        var value = UIInterfaceOrientation.portrait.rawValue
                   if(sender.isSelected) {
                     sender.isSelected = false
                     tabBarController?.tabBar.isHidden = false
                     self.navigationController?.navigationBar.isHidden = false
                     self.navigationController?.navigationBar.isTranslucent = false
                     navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
                     UIDevice.current.setValue(value, forKey: "orientation")
                     videoViewHeight.constant = videoHeight
                     self.videoTrailerView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  videoViewHeight.constant)
                     contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  videoViewHeight.constant )
                     contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                     if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        //               fullScreenBottomHeight.constant = 20
                     }
                   } else {
                     sender.isSelected = true
                     tabBarController?.tabBar.isHidden = true
                     self.navigationController?.navigationBar.isHidden = true
                     navigationItem.leftBarButtonItem?.tintColor = UIColor.white
                     value = UIInterfaceOrientation.landscapeRight.rawValue
                     UIDevice.current.setValue(value, forKey: "orientation")
                     let screenSize = UIScreen.main.bounds
                     let screenWidth = screenSize.width
                     let screenHeight = screenSize.height
                     videoViewHeight.constant = self.view.frame.size.height
                     self.videoTrailerView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight)
                     contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width:screenWidth , height:  screenHeight  )
                     contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                     if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        //               fullScreenBottomHeight.constant = 50
                     }
                     contentPlayerLayer!.backgroundColor = UIColor.black.cgColor
                   }
      }
     func gotoFullScreen() {
    //    self.volumeControlView.isHidden = false
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
//        self.normalScreenButtonflag = true
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        videoViewHeight.constant = screenWidth
        self.videoTrailerView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight )
//        self.videoSlider.bottomAnchor.constraint(equalToSystemSpacingBelow: 8, multiplier: 1)
//       var constraintButton = NSLayoutConstraint (item: videoSlider,
//                                                  attribute: NSLayoutConstraint.Attribute.bottom,
//                                                  relatedBy: NSLayoutConstraint.Relation.equal,
//                                                  toItem: self.view,
//                                                  attribute: NSLayoutConstraint.Attribute.bottom,
//                                                  multiplier: 1,
//                                                  constant: 0)
//       // Add the constraint to the view
//       self.view.addConstraint(constraintButton)
        
        if  contentPlayerLayer == nil {
               contentPlayerLayer = AVPlayerLayer(player: avPlayer)
            contentPlayerLayer!.backgroundColor = UIColor.clear.cgColor
            contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            videoTrailerView.layer.addSublayer(contentPlayerLayer!)
             } else{
               contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
             }
        contentPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
//        self.fullscreenButton.setImage(UIImage(named: "icon_minimize.png"), for: .normal)
      }
      func gotoNormalScreen() {
    //    self.volumeControlView.isHidden = true
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
//        self.normalScreenButtonflag = false
        navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
          videoViewHeight?.constant = 400
        } else {
          videoViewHeight?.constant = 225
        }
        self.videoTrailerView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: videoViewHeight.constant )
       
        if contentPlayerLayer != nil {
            contentPlayerLayer!.frame = CGRect(x: 0, y: 0, width: screenWidth  , height: videoViewHeight.constant )
            contentPlayerLayer!.frame =  self.videoTrailerView.frame
            contentPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
        }
      }
    var isLandscape = false
    var isPresentController = false

    @IBOutlet weak var fullScreenBottomHeight: NSLayoutConstraint!
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           if isPresentController {
             super.viewWillTransition(to: size, with: coordinator)
             let mopPubinterstitialVideoPlaying = UserDefaults.standard.bool(forKey: "MopPubinterstitialVideoPlaying")
             if mopPubinterstitialVideoPlaying == false  {
               if UIDevice.current.orientation.isLandscape {
                 if !isLandscape {
                   self.mainScrollView.setContentOffset(.zero, animated: true)
                   gotoFullScreen()
                   isLandscape = true
                 }
               } else {
                 gotoNormalScreen()
                 isLandscape = false
               }
             }
           }
         }
         override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
          }
    func getCurrentDate() -> String {
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
      let result = formatter.string(from: date)
      return result
    }
    func durationForvideo(startTime: String,endTime: String) -> String {
      if (startTime != "" && endTime != "") {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let startVideoDate = formatter.date(from:startTime)!
        let endVideoDate = formatter.date(from:endTime)
        let interval = endVideoDate?.timeIntervalSince(startVideoDate)
        let hour = interval! / 3600;
        let minute = interval!.truncatingRemainder(dividingBy: 3600) / 60 + (hour * 60)
        return "\(Int(minute)) Minutes"
      } else {
        return "0 Minutes"
      }
    }

    var videoStartTime = ""
    var videoDuration = Double()

  func setUpContentPlayer() {
    if ShowData[0].teaser != nil && self.token != "" {
      self.teaser = ShowData[0].teaser!
      self.activityIndicatorView.isHidden = false
      self.activityIndicatorView.startAnimating()
        videoStartTime = getCurrentDate()

      let contentUrl = URL(string: String(format: self.teaser))
      //      let contentUrl = URL(string:      String(format:"https://gizmeon.s.llnwi.net/vod/201911051572939358/playlist.m3u8"))
      let headers = ["token": token]
      let asset: AVURLAsset = AVURLAsset(url: contentUrl!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
      let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
      avPlayer = AVPlayer(playerItem: playerItem)
      contentPlayerLayer = AVPlayerLayer(player: avPlayer)
        contentPlayerLayer!.videoGravity=AVLayerVideoGravity.resizeAspect
        self.observer = avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main) {
        [weak self] time in
        do {
          try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch let error {
          print("Error in AVAudio Session\(error.localizedDescription)")
        }
            if self?.avPlayer?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
            if let isPlaybackLikelyToKeepUp = self?.avPlayer?.currentItem?.isPlaybackLikelyToKeepUp {
            if  isPlaybackLikelyToKeepUp == false {
              self?.activityIndicatorView.isHidden = false
              self?.activityIndicatorView.startAnimating()
                self?.playPauseButton.isHidden = true
            } else {
              if self!.changescreen {
                self!.avPlayer!.pause()
              }
                if (self!.videoSlider.isHidden){
                     self?.playPauseButton.isHidden = true
                } else {
                  self?.playPauseButton.isHidden = false
                }
              self?.activityIndicatorView.stopAnimating()
            }
          }
        }
      }
        contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.videoTrailerView.frame.size.width , height: videoHeight )
        videoTrailerView.layer.addSublayer(contentPlayerLayer!)
       videoTrailerView.bringSubviewToFront(fullscreenButton)
        videoTrailerView.bringSubviewToFront(playPauseButton)
        videoTrailerView.bringSubviewToFront(videoSlider)
        videoTrailerView.bringSubviewToFront(startDurationLabel)
        videoTrailerView.bringSubviewToFront(durationLabel);
        videoTrailerView.bringSubviewToFront(forwardButton)
videoTrailerView.bringSubviewToFront(backwardButton)
        contentPlayerLayer!.videoGravity=AVLayerVideoGravity.resizeAspect
        avPlayer!.play()
        playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
            playPauseButton.titleLabel?.text = ""
            playPauseButton.imageView?.image = UIImage.init(named: "play")
            videoSlider.minimumValue = 0
            // let duration: CMTime = playerItem.asset.duration
            videoSlider.maximumValue = 1
            videoSlider.isContinuous = false
            videoSlider.selectedBarColor = ThemeManager.currentTheme().UIImageColor
            videoSlider.unselectedBarColor = UIColor.black.withAlphaComponent(0.6)
            videoSlider.addTarget(self, action: #selector(playbackSliderValueChanged), for: .valueChanged)
            durationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            durationLabel.layer.cornerRadius = 5
            durationLabel?.layer.masksToBounds = true
            startDurationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            startDurationLabel.layer.cornerRadius = 5
            startDurationLabel?.layer.masksToBounds = true
           
            self.videoSlider.value = 0
            self.startDurationLabel.text = "00:00"
        self.durationLabel.text = formatMinuteSeconds(asset.duration.seconds)
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (progressTime) -> Void in
              let seconds = CMTimeGetSeconds(progressTime)
              let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
              let minutesString = String(format: "%02d", Int(seconds / 60))
              self.startDurationLabel.text = "\(minutesString):\(secondsString)"
              if Int((seconds.truncatingRemainder(dividingBy: 60))) ==  0 && seconds != 0 {
//                self.videoPlayingEvent()
              }
              //lets move the slider thumb
              if(self.isSlidding == true) {
                self.isSlidding = false
              } else {
                if let duration = self.avPlayer?.currentItem?.duration {
                  let durationSeconds = CMTimeGetSeconds(duration)
                  self.videoSlider.value = Float(seconds / durationSeconds)
        //            print(self?.avplayer?.currentItem?.presentationSize)
                    print("presentation size",self.avPlayer?.currentItem?.presentationSize)
                }
              }
            }
            if adPositionsArray.count != 0 {
              self.videoSlider.markPositions = adPositionsArray
            }

            if playerItem.asset.isPlayable{
              print("isPlayable")
//              self.errorMessageLabel.isHidden = true
              let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
              videoTrailerView.addGestureRecognizer(tap)
              videoTrailerView.isUserInteractionEnabled = true
            }else{
              print("NotPlayable")
              self.activityIndicatorView.stopAnimating()
//              self.errorMessageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//              self.errorMessageLabel.layer.cornerRadius = 5
//              self.errorMessageLabel.layer.masksToBounds = true
//              self.errorMessageLabel.isHidden = false
              self.videoTrailerView.isUserInteractionEnabled = false
            }
      self.watchTrailerButton.isUserInteractionEnabled = true
    } else {
      self.activityIndicatorView.stopAnimating()
    }
  }
    var isSlidding = false
     @objc func playbackSliderValueChanged() {
       self.isSlidding = true
        if let duration = avPlayer?.currentItem?.duration {
         let totalSeconds = CMTimeGetSeconds(duration)
         let value = Float64(videoSlider.value) * totalSeconds
         let seekTime = CMTime(value: Int64(value), timescale: 1)
            avPlayer!.seek(to: seekTime)
       }
       if isPlaying {
        avPlayer!.play()
       } else {
        avPlayer!.pause()
       }

     }
    var videoHeight = CGFloat()
    var videoPlayerHeight = CGFloat()
    var adPositionsArray = Array<Float>()
    var isPlaying = true
    @objc func playPauseAction() {
      if !(Application.shared.CastSessionStart) {
        if isPlaying {
            avPlayer!.pause()
//          self.VideoPauseEvent()
          playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            avPlayer!.play()
          playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
      }
    }
    func formatMinuteSeconds(_ totalSeconds: Double) -> String {
      let secondsString = String(format: "%02d", Int(totalSeconds .truncatingRemainder(dividingBy: 60)))
      let minutesString = String(format: "%02d", Int(totalSeconds / 60))
      return "\(minutesString):\(secondsString)"
    }
    var hidevideoController = true
     var normalScreenButtonflag = false
    var isAdPlayback = false

     @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if !self.activityIndicatorView.isAnimating{
        if isAdPlayback {
          self.fullscreenButton.isHidden = true
        }else {
          if hidevideoController {
            
            self.playPauseButton.isHidden = false
            self.fullscreenButton.isHidden = true
            self.videoSlider.isHidden = false
            self.durationLabel.isHidden = false
            self.startDurationLabel.isHidden = false
            self.hidevideoController = false
    //         self.subTitleButton.isHidden =  false
            self.forwardButton.isHidden = false
            self.backwardButton.isHidden = false
            //self.BackButton.isHidden = false
          } else {
            self.playPauseButton.isHidden = true
            self.fullscreenButton.isHidden = true
            self.videoSlider.isHidden = true
            self.durationLabel.isHidden = true
            self.startDurationLabel.isHidden = true
            self.hidevideoController = true
         
            self.forwardButton.isHidden = true
    //        self.subTitleButton.isHidden =  true
            self.backwardButton.isHidden = true
            //  self.BackButton.isHidden = true
          }
        }
        }
      }
  func navigationTitle(){

    self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.5)
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    let newBackButton = UIButton(type: .custom)
    newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
    newBackButton.contentMode = .scaleAspectFit
    newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
    newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
    newBackButton.addTarget(self, action: #selector(VideoDetailsViewController.backAction), for: .touchUpInside)
    let item2 = UIBarButtonItem(customView: newBackButton)
    self.navigationItem.leftBarButtonItem = item2
  }
  /*
  func videoPlayer(videoId: String) {
    let playerVars = [
      "playsinline": NSNumber(value: 1)
    ]

  }
 */
  func didClickProducerName(producerName: String) {
    let videoPlayerController = storyboard!.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
    videoPlayerController.videoName = "ProducerName"
    videoPlayerController.ProducerName = self.ShowData[0].producer!
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
  }
  
  @objc func reachabilityChanged(note: Notification) {
    guard let reachability = note.object as? Reachability else {
      return
    }
    switch reachability.connection {
    case .wifi:
      print("Reachable via WiFi")
    case .cellular:
      print("Reachable via Cellular")
    case .none:
      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "noNetwork") as! NoNetworkDisplayViewController
      viewController.delegate = self
      self.navigationController?.pushViewController(viewController, animated: false)
      print("Network not reachable")
    }
  }
    var videos = [VideoModel]()

    // MARK: Api methods
    func getSimilarVideos() {
      videos.removeAll()
      var parameterDict: [String: String?] = [ : ]
        if fromDeepLink {
            parameterDict["video_id"] = self.show_Id
        } else {
            parameterDict["video_id"] = String(categoryModel.show_id!)
            
        }
      parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["language"] = Application.shared.langugeIdList
      ApiCommonClass.getSimilarVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            // self.noResultView.isHidden = false
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          self.videos.removeAll()
          self.videos = responseDictionary["Channels"] as! [VideoModel]
          if self.videos.count == 0 {
            DispatchQueue.main.async {
              CustomProgressView.hideActivityIndicator()
            }
          } else {
            DispatchQueue.main.async {
              CustomProgressView.hideActivityIndicator()
                self.similarVideoCollectionView.reloadData()
            }
          }
        }
      }
    }
  func gotoOnline() {
    if reachability.connection != .none {
        getShowData()
        getSimilarVideos()

    }
  }
  // MARK: Api Calls
  func getShowVideos() {
    Categories.removeAll()
    var parameterDict: [String: String?] = [ : ]
    parameterDict["show-id"] = String(categoryModel.show_id!)
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    ApiCommonClass.getShowVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.Categories = responseDictionary["Channels"] as! [VideoModel]
        if self.Categories.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultView.isHidden = true
            
          }
        }
      }
    }
  }
  
  let vc = SubscriptionViewController()
  func getShowData() {
    
    Categories.removeAll()
    var parameterDict: [String: String?] = [ : ]
    if fromDeepLink {
      parameterDict["show-id"] = self.show_Id
    } else {
      parameterDict["show-id"] = String(categoryModel.show_id!)
    }
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))

    ApiCommonClass.getShowData(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.ShowData = responseDictionary["data"] as! [ShowDetailsModel]
        if self.ShowData.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            if let showVideoListArray =  self.ShowData[0].videos,let categoryListArray = self.ShowData[0].categories{
              self.showVideoListArray = showVideoListArray
              self.categoryListArray = categoryListArray
                if let award = self.ShowData[0].awards{
                    self.awardListArray = award
                }
                if let cast = self.ShowData[0].cast{
                    self.castListArray = cast
                }
                if let artWork = self.ShowData[0].keyArtWork{
                    self.keyArtWorkArray = artWork
                }
              if (self.ShowData[0].single_video! == 0) {
                    self.episodeArray =   self.showVideoListArray[0].videos!
                    self.seasonFilterCollectionViewHeight.constant = 50
                    let width = UIScreen.main.bounds.width / 2.3
                    let height =   (self.episodeArray.count * ((9 * Int(width)) / 16))
                    let spaceHeight = (self.episodeArray.count * 25)
                    self.episodeListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)

                }
                else{
//                    if self.showVideoListArray[0].hide_subscription == true {
//                        print("hide")
//                    }
//                    else{
//                    let SubscriptionCount = self.showVideoListArray[0].subscriptions?.count
//                    print("subscription count",SubscriptionCount!)

//                    for i in self.showVideoListArray[0].subscriptions!{
//                        var largest: Float = 0.0
//                        var subscriberName = ""
//                        let priceArray = Float(self.showVideoListArray[0].subscriptions![0].price!)
//                        print(priceArray,"pricearray")
//                        if (priceArray > largest){
//                          largest = self.showVideoListArray[0].subscriptions![0].price!
//                          subscriberName = self.showVideoListArray[0].subscriptions![0].subscription_name!
//                          print("subscribername",subscriberName)
//                          }
//                        }

//              self.subscriptionNameLabel.isHidden = false
//
//                    self.subscriptionNameLabel.backgroundColor = ThemeManager.currentTheme().subscriptionLabelColor
//
//                    self.subscriptionNameLabel.text = self.showVideoListArray[0].subscriptions![0].subscription_name
//
//                    self.subscriptionNameLabel.tintColor = ThemeManager.currentTheme().backgroundColor
//
//              self.subscriptionNameLabel.layer.masksToBounds = true
//              self.subscriptionNameLabel.layer.cornerRadius = 5
//                  }

                    self.singleVideoArray = showVideoListArray
                    self.seasonFilterCollectionView.isHidden = true
                    self.seasonFilterCollectionViewHeight.constant = 0
                    self.episodeListingTableViewHeight.constant = 0
                }

//              if self.ShowData[0].single_video == 1{
//                print("single video")
                self.episodeListingTableView.reloadData()
                self.seasonFilterCollectionView.reloadData()
                self.AwardTableView.reloadData()
                self.similarVideoCollectionView.reloadData()
                self.seasonFilterCollectionView.layoutIfNeeded()

                self.InitialView()
              if UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
                self.watchFlag()
                if  self.ShowData[0].liked_flag == 1  && self.ShowData[0].disliked_flag == 0 {
                     let image = UIImage(named: "icons8-circled-play-48")?.withRenderingMode(.alwaysTemplate)
                     self.likeButton.tintColor = ThemeManager.currentTheme().TabbarColor
                     self.likeButton.set(image: image , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                    self.likeButton.isUserInteractionEnabled = true
                 }
                if self.ShowData[0].liked_flag == 0  && self.ShowData[0].disliked_flag == 1{

                    self.likeButton.isUserInteractionEnabled = false
                    let image = UIImage(named: "icons8-circled-play-48")?.withRenderingMode(.alwaysTemplate)
                    self.likeButton.set(image: image , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)


                 }
                if self.ShowData[0].liked_flag == 0 && self.ShowData[0].disliked_flag == 0 {
                    self.likeButton.set(image:UIImage(named: "icons8-circled-play-48") , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                    self.likeButton.isUserInteractionEnabled = true

                }
                

              }else{
                self.watchListButton.isUserInteractionEnabled = true
              }
            } else {
              WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
              CustomProgressView.hideActivityIndicator()
            }
          }
        }
      }
    }
  }
  func getVideoToken() {
    ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
      DispatchQueue.main.async {
        if responseDictionary["error"] != nil {
        } else {
          self.token = responseDictionary["Channels"] as! String
        }
      }
    }
  }
  func watchListShow() {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["show-id"] = String(ShowData[0].show_id!)
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    if watchVideo {
      parameterDict["watchlistflag"] = "1"
      parameterDict["deletestatus"] = "0"
    } else {
      parameterDict["watchlistflag"] = "0"
      parameterDict["deletestatus"] = "1"
    }

    parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    ApiCommonClass.WatchlistShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          self.watchVideo = !self.watchVideo
        }
      } else {
        DispatchQueue.main.async {
          if self.watchVideo  {
//            self.watchListButton.set(image:UIImage(named: "checkmark-24") , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
            let image = UIImage(named: "checkmark-24")?.withRenderingMode(.alwaysTemplate)
            self.watchListButton.tintColor = ThemeManager.currentTheme().TabbarColor
                         self.watchListButton.set(image: image , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
          } else {
            self.watchListButton.set(image:UIImage(named: "plus-math") , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
          }
        }
      }
    }
  }
  func likeShow() {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["show-id"] = String(ShowData[0].show_id!)
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        

    if likevideo {
      parameterDict["likeflag"] = "1"
      parameterDict["version"] = "1.0.0"
    } else {
      parameterDict["likeflag"] = "0"
      parameterDict["version"] = "1.0.0"
    }
    parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    ApiCommonClass.LikeShow(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          self.likevideo = !self.likevideo
        }
      } else {
        DispatchQueue.main.async {
          if self.likevideo  {
//            self.likeButton.set(image:UIImage(named: "likeGray") , title: "Like", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
            let image = UIImage(named: "likeGray")?.withRenderingMode(.alwaysTemplate)
            self.likeButton.tintColor = ThemeManager.currentTheme().TabbarColor
               self.likeButton.set(image: image , title: "Like", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
//            self.dislikeButton.set(image: #imageLiteral(resourceName: "dislikeGray"), title: "Dislike", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
//            self.dislikeButton.isUserInteractionEnabled = false

          } else {
            self.likeButton.set(image:UIImage(named: "facebookLike") , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
          }
        }
      }
    }
  }
    func dislikeShow(){
        var parameterDict: [String: String?] = [ : ]
            parameterDict["show-id"] = String(ShowData[0].show_id!)
            parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
            parameterDict["device_type"] = "ios-phone"
            parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
                

            if dislikevideo {
              parameterDict["dislikFlag"] = "1"
              parameterDict["version"] = "1.0.0"
            } else {
              parameterDict["dislikFlag"] = "0"
              parameterDict["version"] = "1.0.0"
            }
            parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
            ApiCommonClass.disLikeShow(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
              if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                  self.dislikevideo = !self.dislikevideo
                }
              } else {
                DispatchQueue.main.async {
                  if self.dislikevideo  {
        //            self.likeButton.set(image:UIImage(named: "likeGray") , title: "Like", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                    let image = UIImage(named: "dislikeGray")?.withRenderingMode(.alwaysTemplate)
//                    self.dislikeButton.tintColor = ThemeManager.currentTheme().TabbarColor
//                       self.dislikeButton.set(image: image , title: "Dislike", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                    self.likeButton.set(image: #imageLiteral(resourceName: "likeGray"), title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                    self.likeButton.isUserInteractionEnabled = false

                  } else {
//                    self.dislikeButton.set(image:UIImage(named: "facebookDislike") , title: "Dislike", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                  }
                }
              }
            }
    }
  
  func likedFlag() {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["show-id"] = String(ShowData[0].show_id!)
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    ApiCommonClass.getLikeFlag(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          self.likevideo = !self.likevideo
          self.likeButton.isUserInteractionEnabled = true
        }
      } else {
        DispatchQueue.main.async {
          self.likeButton.isUserInteractionEnabled = true
          self.likeFlagModel  = responseDictionary["data"] as! [LikeWatchListModel]
          if self.likeFlagModel.count != 0 {
            if let like_video =  self.likeFlagModel[0].liked_flag {
              if like_video == 1 {
                self.likevideo = true
//                self.likeButton.set(image:UIImage(named: "likeGray") , title: "Like", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                let image = UIImage(named: "likeGray")?.withRenderingMode(.alwaysTemplate)
                self.likeButton.tintColor = ThemeManager.currentTheme().TabbarColor
                   self.likeButton.set(image: image , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
              } else {
                self.likevideo = false
                self.likeButton.set(image:UIImage(named: "facebookLike") , title: "Play ", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
              }
            }
          }
        }
      }
    }
  }
  
  func watchFlag() {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["show-id"] = String(ShowData[0].show_id!)
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    ApiCommonClass.getWatchFlag(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          self.watchVideo = !self.watchVideo
          self.watchListButton.isUserInteractionEnabled = true

        }
      } else {
        DispatchQueue.main.async {
          self.watchListButton.isUserInteractionEnabled = true
          self.watchFlagModel = responseDictionary["data"] as! [LikeWatchListModel]
          if self.watchFlagModel.count != 0 {
            if let watch_flag =  self.watchFlagModel[0].watchlist_flag {
              if watch_flag == 1  {
                self.watchVideo = true
//                self.watchListButton.set(image:UIImage(named: "checkmark-24") , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                let image = UIImage(named: "checkmark-24")?.withRenderingMode(.alwaysTemplate)
                self.watchListButton.tintColor = ThemeManager.currentTheme().TabbarColor
                             self.watchListButton.set(image: image , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
              } else {
                self.watchVideo = false
                self.watchListButton.set(image:UIImage(named: "plus-math") , title: "My List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
              }
            }
          }
        }
      }
    }
  }
  func MoveTORegisterPage() {
    let loginController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
    
    self.present(loginController, animated: true, completion: nil)
  }
    func remove(){
       DispatchQueue.main.async {
          WarningDisplayViewController().customActionAlert(viewController :self,title: "Please login to use this feature", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
            },{action2 in
                self.Login()
            }, nil])
        }
    }
    func Login() {
      let loginController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
      loginController.isFromAccountScreen = true
      self.present(loginController, animated: true, completion: nil)
    }
    lazy var HeaderImageView:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "icon_award")
        image.frame = CGRect(x: view.frame.width/2 - 60, y: 0, width: 120, height: 120)
        image.tintColor = .white
        return image
    }()
}
extension VideoDetailsViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if awardListArray.count > 0{
        return awardListArray.count

    }
      else{
          return  episodeArray.count
      }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if tableView == AwardTableView{
          let cell = tableView.dequeueReusableCell(withIdentifier: "AwardTableCell", for: indexPath) as! AwardListTableViewCell
          if awardListArray.count > 0{
              cell.awardName.text = awardListArray[indexPath.item].award_name
              cell.year.text =  String(awardListArray[indexPath.item].year!)
          }
          cell.selectionStyle = .none
          cell.backgroundColor = .clear
          return cell
      }
      else{
          let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeTableViewCell
          cell.backgroundColor = .black
          if episodeArray.count > 0{
              cell.episodeArray = episodeArray[indexPath.row]
              cell.episodeImageView.layer.masksToBounds = true
              cell.episodeImageView.contentMode = .scaleToFill
              cell.episodeImageView.isHidden = false
              
          }
          if indexPath.row == selectedIndex {
            cell.mainView.layer.cornerRadius = 5
            cell.mainView.clipsToBounds = true
            cell.mainView.layer.borderWidth = 0.8
            cell.mainView.layer.borderColor = ThemeManager.currentTheme().ThemeColor.cgColor
          }else {
            cell.mainView.layer.cornerRadius = 0
            cell.mainView.clipsToBounds = true
            cell.mainView.layer.borderWidth = 0.0
            cell.mainView.layer.borderColor = UIColor.clear.cgColor
          }
          cell.selectionStyle = .none
          cell.backgroundColor = .clear
          return cell
      }
  }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == AwardTableView{
        }else{
            self.selectedIndex = indexPath.row
            self.avPlayer!.pause()
            self.videoTrailerView.isHidden = true
            let video = episodeArray[indexPath.row]
            let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
            if video.watched_duration != nil && video.watched_duration != 0{
                videoPlayerController.fromContinueWatching = true
                videoPlayerController.watchedDuration = video.watched_duration!
            }
            else{
                videoPlayerController.fromContinueWatching = false
                videoPlayerController.watchedDuration = 0
            }
            videoPlayerController.video = video
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        }
    }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if tableView == AwardTableView{
          return 60
      }
      else{
          let width = UIScreen.main.bounds.width / 2.3
          let height =  (9 * width) / 16
          return height + 25
      }
    
  }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == AwardTableView{
            return 60
        }
        else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if tableView == AwardTableView{
            headerView.addSubview(HeaderImageView)
            return headerView
        }
        else{
            return nil
        }
    }
}

extension UILabel {
  
  //  func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
  //    let readMoreText: String = trailingText + moreText
  //
  //    let lengthForVisibleString: Int = self.vissibleTextLength
  //    let mutableString: String = self.text!
  //    let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
  //    let readMoreLength: Int = (readMoreText.count)
  //    let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
  //    let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font as Any])
  //    let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
  //    answerAttributed.append(readMoreAttributed)
  //    self.attributedText = answerAttributed
  //  }
  //
  //  var vissibleTextLength: Int {
  //    let font: UIFont = self.font
  //    let mode: NSLineBreakMode = self.lineBreakMode
  //    let labelWidth: CGFloat = self.frame.size.width
  //    let labelHeight: CGFloat = self.frame.size.height
  //    let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
  //
  //    let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
  //    let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
  //    let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
  //
  //    if boundingRect.size.height > labelHeight {
  //      var index: Int = 0
  //      var prev: Int = 0
  //      let characterSet = CharacterSet.whitespacesAndNewlines
  //      repeat {
  //        prev = index
  //        if mode == NSLineBreakMode.byCharWrapping {
  //          index += 1
  //        } else {
  //          index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
  //        }
  //      } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
  //      return prev
  //    }
  //    return self.text!.count
  //  }
}

extension UILabel {
  
  func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
    let readMoreText: String = trailingText + moreText
    
    let lengthForVisibleString: Int = self.vissibleTextLength
    let mutableString: String = self.text!
    let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
    let readMoreLength: Int = (readMoreText.count)
    let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
    let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font as Any])
    let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
    answerAttributed.append(readMoreAttributed)
    self.attributedText = answerAttributed
  }
  
  var vissibleTextLength: Int {
    let font: UIFont = self.font
    let mode: NSLineBreakMode = self.lineBreakMode
    let labelWidth: CGFloat = self.frame.size.width
    let labelHeight: CGFloat = self.frame.size.height
    let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
    
    let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
    let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
    let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
    
    if boundingRect.size.height > labelHeight {
      var index: Int = 0
      var prev: Int = 0
      let characterSet = CharacterSet.whitespacesAndNewlines
      repeat {
        prev = index
        if mode == NSLineBreakMode.byCharWrapping {
          index += 1
        } else {
          index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
        }
      } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
      return prev
    }
    return self.text!.count
  }
  
  
  
  
  func addReadMoreString(to label: UILabel) {
    let readMoreText = " ...More"
    let lengthForString = label.text?.count ?? 0
    if lengthForString >= 30 {
      let lengthForVisibleString = fit(label.text, into: label)
      let mutableString = label.text ?? ""
      //        let trimmedString = mutableString.replacingCharacters(in: NSMakeRange(lengthForVisibleString, (label.text?.count ?? 0) - lengthForVisibleString), with: "")
      //      let trimmedString = mutableString.prefix(lengthForVisibleString)
      let trimmedString = mutableString.prefix(lengthForVisibleString != 0 ? lengthForVisibleString : 270)
      
      //          let trimmedString = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: (label.text?.count ?? 0) - lengthForVisibleString), with: "")
      let readMoreLength = readMoreText.count + 2
      let trimmedForReadMore = trimmedString.prefix(trimmedString.count - readMoreLength)
      //           let trimmedForReadMore = (trimmedString as NSString).replacingCharacters(in: NSRange(location: trimmedString.count - readMoreLength, length: readMoreLength), with: "")
      var answerAttributed: NSMutableAttributedString?
      if let font = label.font {
        answerAttributed = NSMutableAttributedString(string: String(trimmedForReadMore), attributes: [NSAttributedString.Key.font: font])
      }
      
      let readMoreAttributed = NSMutableAttributedString(string: readMoreText, attributes: [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13),
        NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().ThemeColor
      ])
      if let answerAttributed = answerAttributed {
        answerAttributed.append(readMoreAttributed)
        label.attributedText = answerAttributed
        label.isUserInteractionEnabled = true
      }
    } else {
      
      print("No need for 'Read More'...")
    }
  }
  func fit(_ string: String?, into label: UILabel) -> Int {
    let inputString = string ?? ""
    let font = label.font
    let mode = label.lineBreakMode
    
    let labelWidth = label.frame.size.width
    let labelHeight = label.frame.size.height
    let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
    
    var attributes: [NSAttributedString.Key : Any]? = nil
    if let font = font {
      attributes = [NSAttributedString.Key.font: font]
    }
    let attributedText = NSAttributedString(string: inputString, attributes: attributes)
    let boundingRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
    do {
      if boundingRect.size.height > labelHeight {
        var index = 0
        var prev: Int
        let characterSet = CharacterSet.whitespacesAndNewlines
        
        repeat {
          prev = index
          if mode == .byCharWrapping {
            index += 1
          } else {
            index = (inputString as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: inputString.count - index - 1)).location
          }
          //        } while index != NSNotFound && index < (inputString.count ?? 0) && (((string as NSString?)?.substring(to: index))!.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height ?? 0.0) <= labelHeight
        } while index != NSNotFound && index < inputString.count && String(inputString.prefix(index)).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height <= labelHeight
        
        return prev
      }
    }
    return inputString.count
  }
    
  
}


extension VideoDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  // MARK:CollectionView Methods
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == categoriesCollectionView{
        return  categoryListArray.count

    }
      else if collectionView == seasonFilterCollectionView{
         if showVideoListArray.count > 0{
              return showVideoListArray.count
         }
          return  0
      }
    else if collectionView == CastCollectionView{
       if castListArray.count > 0{
            return castListArray.count
       }
        return  0
    }
      else if collectionView == KeyArtWorkCollectionView{
         if keyArtWorkArray.count > 0{
              return keyArtWorkArray.count
         }
          return  0
      }
    else{
        if videos.count > 0{
            print("videos count",videos.count)
            return videos.count
        }
        return 0
        
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == categoriesCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        if categoryListArray.count > 0{
            cell.categoryName = categoryListArray[indexPath.row].category_name

        }
        return cell
    }
    else if collectionView == seasonFilterCollectionView{
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
             cell.deselct()  // Call subclassed cell method.
            if indexPath.item == selectedFilter {
                cell.select() // Call subclassed cell method.
            }
        if showVideoListArray.count > 0{
        if let season = showVideoListArray[indexPath.row].season{
                cell.categoryName =  "Season \(season)"
            }
            
        }
          return cell
      }

    else if collectionView == CastCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionCell", for: indexPath as IndexPath) as! CastCollectionViewCell
        
        if castListArray.count > 0{
            self.castHeaderLabel.isHidden = false
            self.castHeaderLabel.text = "Cast & Crew"
            if castListArray[indexPath.row].image
                != nil {

                cell.imageView.sd_setImage(with:URL(string: ((imageUrl + castListArray[indexPath.row].image!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"), completed: { image, error, cacheType, imageURL in
                    print("enter to cast section")
                    cell.imageView.image = cell.imageView.image?.noir
                    // your rest code
               })
                
            }
            else {
                cell.imageView.image = UIImage(named: "landscape_placeholder")
            }
            cell.name.text = castListArray[indexPath.item].name
            cell.role.text = castListArray[indexPath.item].role
        }
        
        return cell
    }
      else if collectionView == KeyArtWorkCollectionView{
          let cell: EpisodeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCollectionCell
          cell.layer.cornerRadius = 8
          cell.layer.borderColor = ThemeManager.currentTheme().ThemeColor.cgColor
          cell.layer.borderWidth = 1.5
          if keyArtWorkArray.count > 0{
              self.keyArtWorkHeaderLabel.isHidden = false
              self.keyArtWorkHeaderLabel.text = "Showing as"
              cell.artWorkImageView.layer.masksToBounds = true
              cell.artWorkImageView.contentMode = .scaleToFill
              cell.imageView.isHidden = true
              cell.artWorkImageView.isHidden = false
              if keyArtWorkArray[indexPath.row].image
                  != nil {

                  cell.artWorkImageView.sd_setImage(with:URL(string: ((imageUrl + keyArtWorkArray[indexPath.row].image!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"), completed: { image, error, cacheType, imageURL in
                      print("enter to cast section")
                      // your rest code
                 })
                  
              }
              else {
                  cell.artWorkImageView.image = UIImage(named: "landscape_placeholder")
              }
            
             
          }
          
          return cell
      }
    else{
            let width = (self.view.frame.size.width-20) / 2.3//some width
            let height = (9 * width) / 16
            self.similarCollectionviewHeight.constant = CGFloat(height + 50)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
            if videos.count > 0
                {
                print("video item count ",videos.count)
                    self.youMayLikeLabel.isHidden = false
                    self.youMayLikeLabel.text = "You may also like"
                    if videos[indexPath.item].logo != nil{
                        cell.videoImage.sd_setImage(with: URL(string: showUrl1 + videos[indexPath.row].logo!),placeholderImage:UIImage(named: "landscape_placeholder"))
                    }
                    else{
                        cell.videoImage.image = UIImage(named: "landscape_placeholder")
                    }
                    if videos[indexPath.row].show_name != nil{
                        cell.videoName.text = videos[indexPath.row].show_name
                    }
                    else{
                        cell.videoName.text = ""
                    }
                cell.episodeLabel.isHidden = true
                if videos[indexPath.row].premium_flag == 0 {
                      cell.premiumImage.isHidden = true
                      cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
                    } else {
                      cell.premiumImage.isHidden = true
                    }
                    cell.liveLabel.isHidden = true
                    cell.PartNumber.isHidden = true
                cell.backgroundColor = .clear
            }
            let Metadataheight =  self.resolutionLabelHeight + self.VideoNameLabelHeight + self.audioLabelHeight + self.yearOfRelaseHeight + self.themeTitleLabelHeight +  110 + self.synopsisTitleLabelHeight + self.ProducerHeight
            self.MainViewHeight.constant = awardTableviewheight.constant + Metadataheight + self.themeHeight + self.yearOfRelaseHeight + synopsisHeight.constant  + self.synopsisTitleLabelHeight + self.ProducerHeight
        + youMayLikeHeight.constant +  20 + similarCollectionviewHeight.constant + 250 + CastCollectionViewHeight.constant + KeyArtWorkCollectionviewHeight.constant + ratingViewHeight.constant + ourtakeHeight.constant  + self.ourtakeTitleLabelHeight +  self.seasonFilterCollectionViewHeight.constant +  self.episodeListingTableViewHeight.constant
            return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if collectionView == categoriesCollectionView{
        let width = self.textWidth(text: categoryListArray[indexPath.row].category_name!, font: UIFont.systemFont(ofSize: 12)) + 30
        return CGSize(width: width , height: 30)
    }
    else if collectionView == seasonFilterCollectionView{
          return CGSize(width: 120 , height: 30)
    }
    else if collectionView == CastCollectionView{
        if castListArray.count > 0{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                let width = (view.frame.width  / 3.2)

                return CGSize(width: width, height: 350)
            }
            else{
                let width = (view.frame.width  / 3)
                return CGSize(width: width - 20, height: 190)
            }
           
        }
        else{
            return CGSize(width: 0, height: 0)
        }
    }
    else if collectionView == KeyArtWorkCollectionView{
          if keyArtWorkArray.count > 0{
              let width = (UIScreen.main.bounds.width) / 2.5
              let height =  (9 * width) / 16
              return CGSize(width: width, height: height )
          }
          else{
              return CGSize(width: 0, height: 0)
          }
      }
    else{
        let width = (self.view.frame.size.width-20) / 2.3//some width
        let height = (9 * width) / 16
        
            if videos.count > 0{
                return CGSize(width: width , height: height + 50)

            }
        else{
            return CGSize(width: width , height: height + 50)
        }
    }
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if collectionView == categoriesCollectionView{
          let viewController = storyboard?.instantiateViewController(withIdentifier: "allCategories") as! AllCategoryViewController
          viewController.fromCategories = true
          viewController.fromVideoPlaying = true
          viewController.categoryTitle = categoryListArray[indexPath.row].category_name!
          viewController.categoryId = categoryListArray[indexPath.row].category_id!
          self.navigationController?.pushViewController(viewController, animated: false)
      }
      else if collectionView == seasonFilterCollectionView{
          self.episodeArray = showVideoListArray[indexPath.item].videos!
          let width = UIScreen.main.bounds.width / 2.3
          let height =   (self.episodeArray.count * ((9 * Int(width)) / 16))
          let spaceHeight = (self.episodeArray.count * 25)
          self.episodeListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
          seasonFilterCollectionView.allowsMultipleSelection = false
          if let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell?{
              let indexPathData = NSKeyedArchiver.archivedData(withRootObject: indexPath)
              UserDefaults.standard.set(indexPathData,forKey: "backgroundIndexPath")
              self.selectedFilter = indexPath.item
              self.selectedIndex = 0
              seasonFilterCollectionView.reloadData() //update all cells. It could be heavy if you have many cells.
          }
          episodeListingTableView.reloadData()
          let Metadataheight =  self.resolutionLabelHeight + self.VideoNameLabelHeight + self.audioLabelHeight + self.yearOfRelaseHeight + self.themeTitleLabelHeight +  110 + self.synopsisTitleLabelHeight + self.ProducerHeight
          self.MainViewHeight.constant = awardTableviewheight.constant + Metadataheight + self.themeHeight + self.yearOfRelaseHeight + synopsisHeight.constant  + self.synopsisTitleLabelHeight + self.ProducerHeight  + youMayLikeHeight.constant +  20 + similarCollectionviewHeight.constant + 250 + CastCollectionViewHeight.constant + ratingViewHeight.constant + KeyArtWorkCollectionviewHeight.constant + ourtakeHeight.constant  + self.ourtakeTitleLabelHeight +  self.seasonFilterCollectionViewHeight.constant +  self.episodeListingTableViewHeight.constant
      }
      else if collectionView == CastCollectionView{
      }
      else if collectionView == KeyArtWorkCollectionView{
          print("contactus button clicked")
          guard let tabbarController = self.tabBarController else { return }
          KeyArtWorkViewController.showKeyArtWork(viewController: tabbarController, array: keyArtWorkArray, index: indexPath)
      }
      else{
          let video = self.videos[indexPath.row]
          let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
          viewController.categoryModel = video
          viewController.fromVideoPlaying = true
          self.navigationController?.pushViewController(viewController, animated: false)
      }
  }
  func textWidth(text: String, font: UIFont?) -> CGFloat {
    let attributes = font != nil ? [NSAttributedString.Key.font: font!] : [:]
    return text.size(withAttributes: attributes).width
  }
}



extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}
