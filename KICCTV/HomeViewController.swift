//
//  demoFirstViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 29/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.

import UIKit
import SideMenu
import MapKit
import CoreLocation
import Reachability
import SystemConfiguration.CaptiveNetwork
import CoreTelephony
import AVFoundation
import AVKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, InternetConnectivityDelegate, HomeVideoTableViewCellDelegate, TrendingVideoTableViewCellDelegate,SideMenuDelegate,CategoryTableViewCellDelegate,FilmVideoTableViewCellDelegate ,liveTableViewCellDelegate{
    
    
    
    
  @IBOutlet weak var videoListingTableview: UITableView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var pausePlayButton: UIButton!{
        didSet{
            self.pausePlayButton.isHidden = true
        }
    }
    @IBOutlet weak var liveLabel: UILabel!{
        didSet{
            self.liveLabel.isHidden = true
            self.liveLabel.textColor = ThemeManager.currentTheme().TabbarColor
        }
    }
    @IBOutlet weak var fullScreenButton: UIButton!{
        didSet{
            self.fullScreenButton.isHidden = true
        }
    }
    @IBOutlet weak var muteButton: UIButton!{
        didSet{
            self.muteButton.isHidden = true
        }
    }
    
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
    var popularVideos = [VideoModel]()
    var filmVideos = [VideoModel]()
    var liveVideos = [VideoModel]()
    var watchList = [VideoModel]()
    var continueWatchingVideos = [VideoModel]()
    var showVideos = [VideoModel]()
    var channelVideos = [VideoModel]()
    var categoryVideos = [VideoModel]()
    var featuredVideos = [VideoModel]()
    var loactionIpArray = [VideoModel]()
    var dianamicVideos = [showByCategoryModel]()
    var maxDianamicArray = [showByCategoryModel]()
    var offsetValue = 0
    var isOffsetChanged = true
      var maxArrayCount = 0
      var liveGuideArray = [LiveGuideModel]()
      var isVersionCheckCalled = false
    var isLivePlaying = true
    var offsetOnceCalledForLazyLoading = false
    var passModelSelected = [VideoModel]()
    var tableviewTag = Int()
    var trendingImage = [String]()
    var refreshFlag = false
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var reachability = Reachability()!
    var TableViewCellHeight = CGFloat()
    var isLandscape = false
    var isPresentController = true
    var ismuted = false

   

  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(NSTimeZone.abbreviationDictionary)
//    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    Application.shared.existingSession = true
    self.videoListingTableview.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.videoListingTableview.showsVerticalScrollIndicator = false
     
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      self.edgesForExtendedLayout = .all
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
    if reachability.connection != .none {
      if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
          getIpandlocation()
          if UserDefaults.standard.string(forKey: "countryCode") == nil {
            UserDefaults.standard.set("US", forKey: "countryCode")
          }
        case .authorizedAlways, .authorizedWhenInUse:
          if UserDefaults.standard.string(forKey: "countryCode") == nil {
            UserDefaults.standard.set("US", forKey: "countryCode")
          }
          if UserDefaults.standard.string(forKey:"access_token") == nil {
            getToken()
          } else {
            if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
              SubscriptionHelperClass().getUserSubscriptions()
            }
            if Application.shared.isFromDeepLink {
              CustomProgressView.hideActivityIndicator()
              self.moveToDeatailsPage()
            } else if Application.shared.isFromChannelNotification {
              self.moveToChannelPage()
            } else {
                self.getDianamicHomeVideos(filterType: "")
//                self.getFeaturedVideos(filterType: "")
            }
          }
        @unknown default:
          getIpandlocation()
          if UserDefaults.standard.string(forKey: "countryCode") == nil {
            UserDefaults.standard.set("US", forKey: "countryCode")
          }
        }
      } else {
        getIpandlocation()
        print("Location services are not enabled")
      }
    }
    initialView()
    videoListingTableview.isHidden = true
    refreshControlAction()
      Application.shared.guestRegister = false
          if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.videoHeight = 0
            self.videoViewHeight?.constant = 0
          } else {
            self.videoViewHeight?.constant = 0
            self.videoHeight = 0
          }
    self.parse()
    Application.shared.guestRegister = false
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
      print("viewwill disaapear")
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
      self.avPlayer?.pause()

  }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if isPresentController {
          super.viewWillTransition(to: size, with: coordinator)
          let mopPubinterstitialVideoPlaying = UserDefaults.standard.bool(forKey: "MopPubinterstitialVideoPlaying")
          if mopPubinterstitialVideoPlaying == false  {
            if UIDevice.current.orientation.isLandscape {
              if !isLandscape {
                self.videoListingTableview.setContentOffset(.zero, animated: true)
//                gotoFullScreen()
                isLandscape = true
              }
            } else {
//              gotoNormalScreen()
                self.videoListingTableview.reloadData()
                 isLandscape = false
            }
          }
        }
      }
      override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
         return .all
       }
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    setupSideMenu()
    if UserDefaults.standard.string(forKey: "fromTerminate") == "true" {
      handleNotificationFromInactive()
    } else {
      NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .myNotification, object: nil)
    }
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
    
    self.navigationController?.navigationBar.isHidden = true
    navigationItem.backBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    self.tabBarController?.tabBar.isHidden = false

    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do {
      try reachability.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
      if UserDefaults.standard.string(forKey:"access_token") == nil {
          getTokenViewWillappear()
      }
//      self.videoViewHeight.constant = 0
//      self.getLiveGuide()
      pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)

      self.avPlayer?.play()

  }
    func getLiveToken(){
      ApiCommonClass.generateLiveToken { (responseDictionary: Dictionary) in
        DispatchQueue.main.async {
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
              self.token = responseDictionary["Channels"] as! String
                if  self.reachability.connection != .none {
                    self.setUpContentPlayer(liveLink: self.channelVideoLink, type: self.channelType)
                }
            }
          }
        }
      }
    }
    func getTokenViewWillappear() {
        ApiCommonClass.getToken { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
            } else {
                DispatchQueue.main.async {
                    self.getLiveGuide()
                }
            }
        }
    }
    func getContinueWatchingVideos() {
      print("ContinueWatchingVideos")
        
      ApiCommonClass.getContinueWatchingVideos { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            //CustomProgressView.hideActivityIndicator()
          }
        } else {
          self.continueWatchingVideos.removeAll()
          if let videos = responseDictionary["data"] as? [VideoModel] {
            self.continueWatchingVideos = videos
          }
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: 0, section: 2)
                self.videoListingTableview.reloadRows(at: [indexPath], with: .fade)
            }
            
        }
      }
    }
    
    @IBAction func fullScreenAction(_ sender: UIButton) {
        var value = UIInterfaceOrientation.portrait.rawValue
           if(sender.isSelected) {
             sender.isSelected = false
               tabBarController?.tabBar.isHidden = false
               self.navigationController?.navigationBar.isHidden = true
            self.pausePlayButton.isHidden = true
                    self.fullScreenButton.isHidden = true
             self.muteButton.isHidden = true
            self.fullScreenButton.setImage(UIImage(named: "fullNormalButttton"), for: .normal)

            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                      delegate.restrictRotation = .portrait
                  }
             UIDevice.current.setValue(value, forKey: "orientation")
             videoViewHeight.constant = videoHeight
             self.videoView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  videoViewHeight.constant)
             contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  videoViewHeight.constant )
             contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
             if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
             }
           } else {
             sender.isSelected = true
               tabBarController?.tabBar.isHidden = true
               self.navigationController?.navigationBar.isHidden = true
               navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            self.pausePlayButton.isHidden = true
            self.fullScreenButton.isHidden = true
            self.muteButton.isHidden = true
           self.fullScreenButton.setImage(UIImage(named: "icon_minimize"), for: .normal)
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                       delegate.restrictRotation = .landscapeRight
                   }
             value = UIInterfaceOrientation.landscapeRight.rawValue
             UIDevice.current.setValue(value, forKey: "orientation")
             let screenSize = UIScreen.main.bounds
             let screenWidth = screenSize.width
             let screenHeight = screenSize.height
             videoViewHeight.constant = self.view.frame.size.height
             self.videoView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight)
             contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width:screenWidth , height:  screenHeight  )
             contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
             contentPlayerLayer!.backgroundColor = UIColor.black.cgColor
           }
    }
    @IBAction func muteAction(_ sender: Any) {
        if ismuted {
            print("muteVideo")
            muteButton.setImage(UIImage(named: "ic_mute"), for: .normal)
            avPlayer?.isMuted = true
          

        } else {
            print("unmuteVideo")
            muteButton.setImage(UIImage(named: "ic_sound"), for: .normal)
            avPlayer?.isMuted = false
        }
        
        ismuted = !ismuted
    }
    func initialView() {
    self.navigationController?.navigationBar.isHidden = true
    trendingImage = ["ic_banner_three","ic_banner_two","ic_banner"]
    let nib =  UINib(nibName: "HomeVideoTableViewCell", bundle: nil)
    videoListingTableview.register(nib, forCellReuseIdentifier: "homecell")
    

    let nib2 =  UINib(nibName: "TrendingVideoTableViewCell", bundle: nil)
    videoListingTableview.register(nib2, forCellReuseIdentifier: "trendingTableCell")
     
    let nib3 =  UINib(nibName: "CategoryTableViewCell", bundle: nil)
    videoListingTableview.register(nib3, forCellReuseIdentifier: "CategoryTableViewCell")
      let nib4 =  UINib(nibName: "LiveTableViewCell", bundle: nil)
      videoListingTableview.register(nib4, forCellReuseIdentifier: "liveTableCell")
      
    if reachability.connection != .none {
      let ssid = self.fetchSSIDInfo()
      if ssid != nil  {
        UserDefaults.standard.set("\(ssid!)", forKey: "NETWORK")
      }
      getCarrierName()
      let currentTimeStamp = generateCurrentTimeStamp ()
      if currentTimeStamp != "" {
        UserDefaults.standard.set("\(currentTimeStamp)", forKey: "currentTimeStamp")
      }
    }
    videoListingTableview.backgroundColor = ThemeManager.currentTheme().backgroundColor
  }

  func handleNotificationFromInactive() {
    let userInfo = UserDefaults.standard.dictionary(forKey: "userInfo")
    guard let content_type = userInfo!["content_type"] as? String
      else {
        return
    }
    if UserDefaults.standard.string(forKey:"user_id") != nil {
      if content_type == "video" {
        guard let video_id = userInfo!["video_id"] as? String else {
          return
        }
        guard let premium_flag = userInfo!["premium_flag"] as? String else {
          return
        }
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
        videoPlayerController.fromNotification = true
        videoPlayerController.videoNotificationId = Int(video_id)!
        videoPlayerController.premium_flag = Int(premium_flag)!
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }else {
        guard let channel_id = userInfo!["channel_id"] as? String else {
          return
        }
        guard let premium_flag = userInfo!["premium_flag"] as? String else {
          return
        }
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "channelvideo") as! ChannelVideoViewController
        videoPlayerController.fromNotification = true
        videoPlayerController.channelNotificationId = Int(channel_id)!
        videoPlayerController.premium_flag = Int(premium_flag)!
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
    } else {
      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
      let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
      self.navigationController?.pushViewController(nextViewController, animated: false)
    }
  }
    
    
   func setupLiveView(){
        
   }
  @objc func notificationReceived(_ notification: Notification) {
    guard let content_type = notification.userInfo!["content_type"] as? String
      else {
        return
    }
    if UserDefaults.standard.string(forKey:"user_id") != nil {
      if content_type == "video" {
        guard let video_id = notification.userInfo!["video_id"] as? String else {
          return
        }
        guard let premium_flag = notification.userInfo!["premium_flag"] as? String else {
          return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let videoPlayerController = storyBoard.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
        videoPlayerController.fromNotification = true
        videoPlayerController.videoNotificationId = Int(video_id)!
        videoPlayerController.premium_flag = Int(premium_flag)!
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      } else {
        guard let channel_id = notification.userInfo!["channel_id"] as? String else {
          return
        }
        guard let premium_flag = notification.userInfo!["premium_flag"] as? String else {
          return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let videoPlayerController = storyBoard.instantiateViewController(withIdentifier: "channelvideo") as! ChannelVideoViewController
        videoPlayerController.fromNotification = true
        videoPlayerController.premium_flag = Int(premium_flag)!
        videoPlayerController.channelNotificationId = Int(channel_id)!
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
    } else {
      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
      let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
      self.navigationController?.pushViewController(nextViewController, animated: false)
    }
  }

  // MARK: Newtork connection checking
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
      viewController.fromHome = true
      self.navigationController?.pushViewController(viewController, animated: false)
      print("Network not reachable")
    }
  }
  fileprivate func setupSideMenu() {
    // Define the menus
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "sidemenu") as! SideMenuViewController
    vc.progressdelegates = self
    let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: vc)
    SideMenuManager.default.menuFadeStatusBar = false
    SideMenuManager.default.menuWidth = view.frame.width - 100
    SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
  }
  @objc func showSideMenu(sender: UIBarButtonItem) {
    present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
  }
  // MARK: Network Delegate
  func gotoOnline() {
    if UserDefaults.standard.string(forKey:"user_id") != nil {
      self.videoListingTableview.isHidden = false
    }
  }
    func didSelectActivation() {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
                DispatchQueue.main.async {
                    WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see Live", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                            self.MoveTOLoginPage()
                        },nil])
                }
            }
            else{
                guard let tabbarController = self.tabBarController else { return }
                TVActivationVC.showActivationPopup(viewController: tabbarController)
//                ActivationVC.showFromActivation(viewController: tabbarController)
            }
       
    }
    func didSelectShedule(passModel: LiveGuideModel) {
        print("shedule clicked")
    }
    
    func didSelectWatchList() {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            DispatchQueue.main.async {
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see your My List", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                        self.MoveTOLoginPage()
                    },nil])
            }
        }
        else{
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
        watchListController.fromwatchlist = true
        self.navigationController?.pushViewController(watchListController, animated: false)
        }
      }
      func didSelectMyVideos() {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            DispatchQueue.main.async {
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see Live", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                        self.MoveTOLoginPage()
                    },nil])
            }
        }
        else{
         let myVideosController = self.storyboard?.instantiateViewController(withIdentifier: "liveTab") as! LiveTabViewController
           self.navigationController?.pushViewController(myVideosController, animated: false)
        }
      }
      func didSelectLanguage() {
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "updatelanguage") as! UpdateLanguageListViewController
        self.navigationController?.pushViewController(watchListController, animated: false)
      }
      func didSelectSchedule() {
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "scheduleController") as! ScheduleViewController
        self.navigationController?.pushViewController(watchListController, animated: false)
      }
      func didSelectContactUs() {
        guard let tabbarController = self.tabBarController else { return }
        ContactUSViewController.showFromContactUs(viewController: tabbarController)
      }
      func didSelectPremium() {
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionListnew") as! subscriptionListViewController
        SubscriptionHelperClass().getUserSubscriptions()

        self.navigationController?.pushViewController(watchListController, animated: false)
      }
    // MARK: HomeVideoTableViewCellDelegate
      func didSelectTrending(passModel: VideoModel) {
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
        videoPlayerController.categoryModel = passModel
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
    func didSelectFilm(passModel: VideoModel) {
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
        videoPlayerController.categoryModel = passModel
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
    }
     
      func didSelectShowVideos(passModel: VideoModel) {
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
        print("show videos")
        videoPlayerController.categoryModel = passModel
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
      func didSelectPopular(passModel: VideoModel) {
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
        videoPlayerController.video = passModel
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
      func didSelectCategory(passModel: VideoModel) {
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
        videoPlayerController.categoryModel = passModel
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
    func didSelectNews(passModel: VideoModel) {
      let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "NewsVC") as! NewsViewController
        videoPlayerController.newsId = passModel.show_id
      self.navigationController?.pushViewController(videoPlayerController, animated: false)
        
    }
    
    func didSelectEventLive(passModel: VideoModel) {
        print("Live Event Clicked")
    }
    func didSelectLiveNowVideos(passModel: VideoModel) {
        if passModel.type == "UPCOMING_EVENT"{
            let newsController = storyboard?.instantiateViewController(withIdentifier: "NewsVC") as! NewsViewController
            newsController.eventId = passModel.event_id
            newsController.isFromUpcomingEvents = true
            self.navigationController?.pushViewController(newsController, animated: false)
            print("Upcoming Event Clicked")

        }
        else if  passModel.type == "LIVE"{
            print("live Clicked")
            self.getLiveGuide()
            self.setUpContentPlayer(liveLink: passModel.live_link, type: passModel.type)
        }
        else if passModel.type == "LIVE_EVENT"{
            print("LIVE_EVENT Clicked")
            self.liveGuideArray.removeAll()
            DispatchQueue.main.async {
                self.videoListingTableview.reloadSections([0], with: .fade)
            }
            self.setUpContentPlayer(liveLink: passModel.live_url, type: passModel.type)
        }
        else{
            print("other event Clicked")

        }
    }
    func didSelectUpcomingEvents(passModel: VideoModel) {
        print("Upcoming Event Clicked")
//        setUpContentPlayer(liveLink: passModel.video_name, type: passModel.type)
    }
    func didSelectEndedEvents(passModel: VideoModel) {
//        setUpContentPlayer(liveLink: passModel.video_name, type: passModel.type)
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
        videoPlayerController.categoryModel = passModel
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
        print("Ended Event Clicked")
    }
    func didSelectChannel(passModel: VideoModel) {
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "channelvideo") as! ChannelVideoViewController
        videoPlayerController.channelVideo = passModel
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
    }
      func didSelectDianamicVideos(passModel: VideoModel) {
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
          videoPlayerController.fromHomeScreen = true
          videoPlayerController.watchedDuration = passModel.watched_duration!
        videoPlayerController.video = passModel
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
      func didSelectFavorites() {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            DispatchQueue.main.async {
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see Favorites", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                        self.MoveTOLoginPage()
                    },nil])
            }
        }
        else{
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
        self.navigationController?.pushViewController(watchListController, animated: false)
        }
      }

        func cancelAlertAction(){
            self.navigationController?.popToRootViewController(animated: false) // return to home
        }
        func MoveTOLoginPage() {
            let loginController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController // move to login page from guest user                                                                                                                       login
            loginController.isFromSideMenu = true
            self.navigationController?.pushViewController(loginController, animated: true)
        }

  func refreshControlAction() {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = ThemeManager.currentTheme().UIImageColor
    refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
    if #available(iOS 10.0, *) {
      videoListingTableview.refreshControl = refreshControl
    } else {
      videoListingTableview.addSubview(refreshControl)
    }
  }
  @objc func doSomething(refreshControl: UIRefreshControl) {
    refreshFlag  = true
    if UserDefaults.standard.string(forKey:"access_token") == nil {
      getToken()
    } else {
      SubscriptionHelperClass().getUserSubscriptions()
        self.offsetValue = 0
        self.getDianamicHomeVideos(filterType: "")
    }
    refreshControl.endRefreshing()
  }
    
    

  // MARK: Api Calls
  func getToken() {
    ApiCommonClass.getToken { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        CustomProgressView.hideActivityIndicator()
      } else {
        DispatchQueue.main.async {
          if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
            SubscriptionHelperClass().getUserSubscriptions()
          }
          if Application.shared.isFromDeepLink {
            CustomProgressView.hideActivityIndicator()
            self.moveToDeatailsPage()
          } else if Application.shared.isFromChannelNotification {
            self.moveToChannelPage()
          }else {
              self.getDianamicHomeVideos(filterType: "")

//            self.getFeaturedVideos(filterType: "")
          }
        }
      }
    }
  }
    func getFeaturedVideos(filterType:String?) {
//    if !UserDefaults.standard.bool(forKey: "luanchInformationOfApp") {
//      UserDefaults.standard.setValue(true, forKey: "luanchInformationOfApp")
//      self.app_Install_Launch()
//    }
    if Application.shared.APP_LAUNCH{
      self.firstEventAppLuanch()
      Application.shared.APP_LAUNCH = false
    }
        var parameterDict: [String: String?] = [ : ]
        parameterDict["type"] = ""
        print("parameterDict",parameterDict)
//        CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    ApiCommonClass.getFeaturedVideos (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
            self.getFilmOfTheDayVideos(filterType: filterType)
            CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.featuredVideos.removeAll()
        if let videos = responseDictionary["data"] as? [VideoModel] {
          self.featuredVideos = Array(videos.prefix(5))
        }
//        DispatchQueue.main.async {
//          self.videoListingTableview.reloadData()
//          CustomProgressView.hideActivityIndicator()
//          self.videoListingTableview.isHidden = false

//          CustomProgressView.hideActivityIndicator()
//        }
        self.getFilmOfTheDayVideos(filterType: filterType)
      }
    }
  }
    func getFilmOfTheDayVideos(filterType:String?) {
      var parameterDict: [String: String?] = [ : ]
      parameterDict["type"] = filterType
      print("parameterDict",parameterDict)
          ApiCommonClass.getFilmOfTheDayVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            CustomProgressView.hideActivityIndicator()
              self.getFreeshows(filterType: filterType)
          }
        } else {
          self.filmVideos.removeAll()
          if let videos = responseDictionary["data"] as? [VideoModel] {
            self.filmVideos = Array(videos.prefix(10))
          }
//          DispatchQueue.main.async {
//            self.videoListingTableview.reloadData()
//            self.videoListingTableview.isHidden = false
//
//          }
          self.getFreeshows(filterType: filterType)
        }
      }
    }
   
    func getFreeshows(filterType:String?) {
        var parameterDict: [String: String?] = [ : ]
        parameterDict["type"] = filterType
        print("parameterDict",parameterDict)
        ApiCommonClass.getFreeShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in

        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            CustomProgressView.hideActivityIndicator()
            self.getWatchList(filterType: filterType)
          }
        } else {
          self.showVideos.removeAll()
          if  UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            if let videos = responseDictionary["data"] as? [VideoModel] {
              self.showVideos = Array(videos.prefix(10))
            }
          }
          else{
              if let videos = responseDictionary["data"] as? [VideoModel] {
                print("show videos count",videos.count)
                self.showVideos = videos
              }
//            DispatchQueue.main.async {
//              self.videoListingTableview.reloadData()
//              self.videoListingTableview.isHidden = false
//            }
          }
            self.getWatchList(filterType: filterType)
        }
      }
    }
   func getWatchList(filterType:String?) {
  //    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)

      var parameterDict: [String: String?] = [ : ]
      parameterDict["type"] = filterType
      print("parameterDict",parameterDict)
      if  UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
        CustomProgressView.hideActivityIndicator()

        self.getHomeNewArrivals(filterType: filterType)

    }
    else{
        ApiCommonClass.getWatchList(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
            self.getHomeNewArrivals(filterType: filterType)
        }
      } else {
        self.watchList.removeAll()
        if let videos = responseDictionary["Channels"] as? [VideoModel] {
          self.watchList = Array(videos.prefix(10))
        }
        self.getHomeNewArrivals(filterType: filterType)
      }
    }

    }
    
    }
  func getHomeNewArrivals(filterType:String?) {

    var parameterDict: [String: String?] = [ : ]
    parameterDict["type"] = filterType
    print("parameterDict",parameterDict)
        ApiCommonClass.getHomeNewArrivals(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
            self.getDianamicHomeVideos(filterType: filterType)
        }
      } else {
        self.popularVideos.removeAll()
        if let videos = responseDictionary["data"] as? [VideoModel] {
          self.popularVideos = Array(videos.prefix(10))
        }

        self.getDianamicHomeVideos(filterType: filterType)
      }
    }
  }
   
  
  func getDianamicHomeVideos(filterType:String?) {
      print("offset value called",offsetValue)
    var parameterDict: [String: String?] = [ : ]
      if isOffsetChanged{
          if offsetValue == 0{
              if !refreshFlag {
                  CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
              }
              parameterDict["offset"] = "0"
          }
          else{
              parameterDict["offset"] = String(offsetValue * 10)
          }
          offsetValue = offsetValue + 1

      }
     
    print("parameterDict",parameterDict)
    ApiCommonClass.getDianamicHomeVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          self.videoListingTableview.reloadData()
          CustomProgressView.hideActivityIndicator()
          self.videoListingTableview.isHidden = false
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
            if let data = responseDictionary["data"] as? [showByCategoryModel]{
                if data.count > 0 {
                    if self.refreshFlag{
                        self.dianamicVideos.removeAll()
                        self.refreshFlag = false
                      CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
                    }
                    self.dianamicVideos.append(contentsOf: data)
                    DispatchQueue.main.async {
                      self.videoListingTableview.reloadData()
                      CustomProgressView.hideActivityIndicator()
                      self.videoListingTableview.isHidden = false
                      CustomProgressView.hideActivityIndicator()
                        self.offsetOnceCalledForLazyLoading = false
                    }
                }else{
                    if self.dianamicVideos.count == 0{
                        DispatchQueue.main.async {
                          self.videoListingTableview.reloadData()
                            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                            self.maxArrayCount = self.dianamicVideos.count
                          CustomProgressView.hideActivityIndicator()
                          self.videoListingTableview.isHidden = false
                          CustomProgressView.hideActivityIndicator()
                        }
                    }
                    else{
                        self.maxArrayCount = self.dianamicVideos.count
                        self.offsetOnceCalledForLazyLoading = false

                    }
                }
        }
          else{
              DispatchQueue.main.async {
//                self.videoListingTableview.reloadData()
                  WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                CustomProgressView.hideActivityIndicator()
                self.videoListingTableview.isHidden = false
                CustomProgressView.hideActivityIndicator()
              }
          }
      }
    }
      if !isVersionCheckCalled{
          self.perform(#selector(vesionCheckAppstore), with: nil, afterDelay: 15)
          self.isVersionCheckCalled = true
      }

  }

    func getLiveGuide() {
        print("getLiveGuide")
        ApiCommonClass.getLiveGuide { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    
                }
            } else {
                self.liveGuideArray.removeAll()
                if let videos = responseDictionary["data"] as? [LiveGuideModel] {
                    self.liveGuideArray = videos
                    if self.liveGuideArray.count == 0 {
                        DispatchQueue.main.async {
                            CustomProgressView.hideActivityIndicator()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.videoListingTableview.reloadSections([0], with: .fade)
                            CustomProgressView.hideActivityIndicator()
                        }
                    }
                }
            }
        }
    }

    @objc func vesionCheckAppstore(){
        checkVersion(force: false)
        
    }
    private  func checkVersion(force: Bool) {
        if let currentVersion = self.getBundle(key: "CFBundleShortVersionString") {
            _ = CheckAppstoreUpdate.getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version {
                    if let error = error {
                        print("error getting app store version: ", error)
                    } else if appStoreAppVersion == currentVersion {
                        print("Already on the last app version: ",currentVersion)
                    } else {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ",currentVersion)
                        DispatchQueue.main.async {
                            print("Needs update")
                            
                            //                            let topController: UIViewController = (UIApplication.shared.windows.first?.rootViewController)!
                            //                            topController.
                            self.showAppUpdateAlert(Version: (info?.version)!, Force: force, AppURL: (info?.trackViewUrl)!)
                        }
                    }
                }
            }
        }
    }
    @objc fileprivate func showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {
        guard let appName = self.getBundle(key: "CFBundleName") else { return } //Bundle.appName()
        let alertTitle = "Version Update"
        let alertMessage = "A new version of \(appName) is available on AppStore. Update now!"
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        if !Force {
            let notNowButton = UIAlertAction(title: "Not now", style: .default)
            alertController.addAction(notNowButton)
        }
        
        let updateButton = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
    func getBundle(key: String) -> String? {
        
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2 - Add the file to a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        // Check if the variable on plist exists
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in 'Info.plist'.")
        }
        return value
    }
  func getIpandlocation() {
    ApiCommonClass.getIpandlocation { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        UserDefaults.standard.set("103.71.169.219", forKey: "IPAddress")
                        UserDefaults.standard.set("IN", forKey: "countryCode")
                        CustomProgressView.hideActivityIndicator()
      } else{
        DispatchQueue.main.async {
          if self.reachability.connection != .none {
            if UserDefaults.standard.string(forKey:"access_token") == nil {
              self.getToken()
            } else {
              if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
                SubscriptionHelperClass().getUserSubscriptions()
              }
              if Application.shared.isFromDeepLink {
                CustomProgressView.hideActivityIndicator()
                self.moveToDeatailsPage()
              } else if Application.shared.isFromChannelNotification {
                self.moveToChannelPage()
              } else{
                  self.getDianamicHomeVideos(filterType: "")
//                self.getFeaturedVideos(filterType: "")
              }
            }
          }
        }
      }
    }
  }

    func app_Install_Launch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }

      parameterDict["device_type"] = "iOS"
      if let longitude = UserDefaults.standard.string(forKey:"longitude") {
        parameterDict["longitude"] = longitude
      }
      if let latitude = UserDefaults.standard.string(forKey: "latitude"){
        parameterDict["latitude"] = latitude
      }
      if let country = UserDefaults.standard.string(forKey:"country"){
        parameterDict["country"] = country
      }
      if let city = UserDefaults.standard.string(forKey:"city"){
        parameterDict["city"] = city
      }
      if let userAgent = UserDefaults.standard.string(forKey:"userAgent"){
           parameterDict["ua"] = userAgent
         }
      if let IPAddress = UserDefaults.standard.string(forKey:"IPAddress") {
        parameterDict["ip_address"] = IPAddress
      }
     
      if let advertiser_id = UserDefaults.standard.string(forKey:"Idfa"){
        parameterDict["advertiser_id"] = advertiser_id
      }
      else{
            parameterDict["advertiser_id"] = "00000000-0000-0000-0000-000000000000"
          }
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
         parameterDict["width"] =  String(format: "%.3f",UIScreen.main.bounds.width)
         parameterDict["height"] = String(format: "%.3f",UIScreen.main.bounds.height)
         parameterDict["device_make"] = "Apple"
        parameterDict["device_model"] = UserDefaults.standard.string(forKey:"deviceModel")
         if (UserDefaults.standard.string(forKey: "first_name") != nil){
          parameterDict["user_name"] = UserDefaults.standard.string(forKey: "first_name")
         }
      if let user_email = UserDefaults.standard.string(forKey: "user_email"){
       parameterDict["user_email"] = user_email
      }
       
      if let publisherid = UserDefaults.standard.string(forKey: "pubid") {
        parameterDict["publisherid"] = publisherid
      }
      
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
     
      if (UserDefaults.standard.string(forKey:"skiplogin_status") == "false") {
  //    if (UserDefaults.standard.string(forKey: "user_email") != nil){
  //     parameterDict["user_email"] = UserDefaults.standard.string(forKey: "user_email")
  //    }
  //
      if (UserDefaults.standard.string(forKey: "phone") != nil){
       parameterDict["user_contact_number"] = UserDefaults.standard.string(forKey: "phone")
      }
          
      }
        print("param for device api",parameterDict)
      ApiCommonClass.analayticsAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            print("device api success")
          }
        }
      }
    }
    func firstEventAppLuanch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
      parameterDict["event_type"] = "POP01"
      
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
          parameterDict["app_id"] = app_id
        }
      
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
      print(parameterDict)
      ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            print("Event api success")
          }
        }
      }
    }

  func fetchSSIDInfo() -> String? {
    var ssid: String?
    if let interfaces = CNCopySupportedInterfaces() as NSArray? {
      for interface in interfaces {
        if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
          ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
          break
        }
      }
    }
    return ssid
  }
  func getCarrierName() {
    let networkInfo = CTTelephonyNetworkInfo()
    let carrier = networkInfo.subscriberCellularProvider
    if carrier?.carrierName != nil || carrier?.carrierName != "" {
      UserDefaults.standard.set(carrier?.carrierName, forKey: "CARRIER")
    }
  }
  func generateCurrentTimeStamp () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
    return (formatter.string(from: Date()) as NSString) as String
  }
  func moveToDeatailsPage(){
    CustomProgressView.hideActivityIndicator()
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
    viewController.fromDeepLink = true
    viewController.fromHomeViewController = true
    viewController.show_Id = Application.shared.deepLink_ShowID
    Application.shared.isFromDeepLink = false
    self.navigationController?.pushViewController(viewController, animated: false)
  }
  func moveToChannelPage(){
    CustomProgressView.hideActivityIndicator()
    let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "channelvideo") as! ChannelVideoViewController
    videoPlayerController.fromNotification = true
    videoPlayerController.channelId = Application.shared.notificationchannelId
    videoPlayerController.premium_flag = Application.shared.notificationpremiumFlag
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
  }
  func parse(){

    let path = Bundle.main.path(forResource: "joker-2019-720p-hdcam-english-x264ndi-sub-katmoviehd-to-english-elsubtitle-com-1570583398", ofType: "srt")

    var string: String? = nil
    do {
      string = try String(contentsOfFile: path ?? "", encoding: .utf8)
    } catch {
    }

    let scanner = Scanner(string: string ?? "")

    while !scanner.isAtEnd {
      autoreleasepool {
        var indexString: String?
        scanner.scanUpToCharacters(from: CharacterSet.newlines, into: AutoreleasingUnsafeMutablePointer<NSString?>(&indexString))

        var startString: String?
        scanner.scanUpTo(" --> ", into: AutoreleasingUnsafeMutablePointer<NSString?>(&startString))

        // My string constant doesn't begin with spaces because scanners
        // skip spaces and newlines by default.
        scanner.scanString("-->", into: nil)

        var endString: String?
        scanner.scanUpToCharacters(from: CharacterSet.newlines, into: AutoreleasingUnsafeMutablePointer<NSString?>(&endString))
        var textString: String?
        // (void) [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&textString];
        // BEGIN EDIT
        scanner.scanUpTo("\r\n\r\n", into: AutoreleasingUnsafeMutablePointer<NSString?>(&textString))
        textString = textString?.replacingOccurrences(of: "\r\n", with: " ")
        // Addresses trailing space added if CRLF is on a line by itself at the end of the SRT file
        textString = textString?.trimmingCharacters(in: CharacterSet.whitespaces)
        // END EDIT

        let dictionary = [
          "index" : indexString,
          "start" : startString,
          "end" : endString,
          "text" : textString ?? ""
        ]

        print("\(dictionary)")
      }
    }
  }

  // MARK: Button Action
  @IBAction func homeSearchAction(_ sender: Any) {
  }
  @objc func btnOpenSearch(){
    let serachController = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! HomeSearchViewController
    serachController.type = "video"
    self.navigationController!.pushViewController(serachController, animated: false)
  }
    var channelVideoLink = ""
    var channelType = ""
    var channelStartTime = ""
    var playerItem: AVPlayerItem?

    var avPlayer: AVPlayer? = AVPlayer(playerItem: nil)
    var token = ""
    var watchUpdateFlag = false
    var contentPlayerLayer: AVPlayerLayer?
    var observer: Any!
    var isPlaying = true
    var hidevideoController = true
    var videoHeight = CGFloat()

    func setUpContentPlayer(liveLink:String?,type:String?) {

       self.activityIndicatorView.isHidden = false
       self.activityIndicatorView.startAnimating()
        self.isPresentController = true

       channelStartTime = getCurrentDate()
        let contentUrl = URL(string: String(format: liveLink!))
           let asset: AVURLAsset = AVURLAsset(url: contentUrl! as URL)
           playerItem = AVPlayerItem(asset: asset)
           avPlayer?.replaceCurrentItem(with: playerItem)
           avPlayer?.play()
         // Create a player layer for the player.
         contentPlayerLayer = AVPlayerLayer(player: avPlayer)
         contentPlayerLayer?.backgroundColor = UIColor.clear.cgColor
         contentPlayerLayer?.videoGravity=AVLayerVideoGravity.resizeAspect
           let topController = UIApplication.topViewController()
           let top = topController as! UIViewController
           if top is HomeViewController {
               print("topcontroller5",topController)
               self.avPlayer?.play()
           }
           else{
               print("topcontroller error",topController)
               self.avPlayer?.pause()
           }
           self.observer = avPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main) {
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
               } else {
                 if self!.watchUpdateFlag == false {
                   self?.watchUpdateFlag = true
                 }
                 self?.activityIndicatorView.stopAnimating()
               }
             }
           }
         }
        contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: videoView.frame.size.width , height: videoHeight )

           videoView.layer.addSublayer(contentPlayerLayer!)
           videoView.bringSubviewToFront(fullScreenButton)
           videoView.bringSubviewToFront(pausePlayButton)
      
           videoView.bringSubviewToFront(liveLabel)
           videoView.bringSubviewToFront(muteButton)
        pausePlayButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        pausePlayButton.titleLabel?.text = ""
        pausePlayButton.imageView?.image = UIImage.init(named: "play")
        pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
         avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (progressTime) -> Void in
                       let seconds = CMTimeGetSeconds(progressTime)
                          let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
                          let minutesString = String(format: "%02d", Int(seconds / 60))
                          if Int((seconds.truncatingRemainder(dividingBy: 60))) ==  0 && seconds != 0 {
//                            self.channelPlayingEvent()
                          }
        }
        if ((playerItem?.asset.isPlayable) != nil){
                     print("isPlayable")
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                     videoView.addGestureRecognizer(tap)
                     videoView.isUserInteractionEnabled = true
                   }else{
                     print("NotPlayable")
                     self.activityIndicatorView.stopAnimating()
                     self.videoView.isUserInteractionEnabled = false
                   }
       
        
     }
    @objc func playPauseAction() {
       if !(Application.shared.CastSessionStart) {
         if isPlaying {
           avPlayer?.pause()
           pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
         } else {
           avPlayer?.play()
           pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
         }
         isPlaying = !isPlaying
       }
     }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
      
        if hidevideoController {
            self.fullScreenButton.isHidden = false
            self.pausePlayButton.isHidden = false
            self.muteButton.isHidden = false
            self.liveLabel.isHidden = false
           self.hidevideoController = false
          //self.playPauseButton.isHidden = false
        } else {
          self.fullScreenButton.isHidden = true
            self.pausePlayButton.isHidden = true
            
            self.muteButton.isHidden = true
//            self.liveLabel.isHidden = true
          self.hidevideoController = true
            
          //self.playPauseButton.isHidden = true
        }
      
    }
    func getCurrentDate() -> String {
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
      let result = formatter.string(from: date)
      return result
    }
   
 
}
// MARK: Tableview
extension HomeViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
     
         return 1 + dianamicVideos.count
   }
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
  }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
                if  pos > 0 && pos > videoListingTableview.contentSize.height-50 - scrollView.frame.size.height && !offsetOnceCalledForLazyLoading{
                    offsetOnceCalledForLazyLoading = true

                    if maxArrayCount != 0 && (maxArrayCount==dianamicVideos.count){
                    }
                    else{
                        self.getDianamicHomeVideos(filterType: "")
                    }
                }

    }
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if indexPath.section == 0{
          let cell = tableView.dequeueReusableCell(withIdentifier: "liveTableCell", for: indexPath) as! LiveTableViewCell
          cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
          cell.homeButton.setTitle("LIVE GUIDE", for: UIControl.State.normal)
          cell.homeButton.titleLabel?.textColor = ThemeManager.currentTheme().HeadTextColor
          cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
          cell.rightArrowImageView.isHidden = true
          cell.liveGuideArray = liveGuideArray
          cell.delegate = self
          if liveGuideArray.count>0{
              cell.homeButton.isHidden = false
          }else{
              cell.homeButton.isHidden = true
          }
          cell.layer.cornerRadius = 8
          return cell
      }
      else if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "BANNER" {
         let cell = tableView.dequeueReusableCell(withIdentifier: "trendingTableCell", for: indexPath) as! TrendingVideoTableViewCell
         cell.channelType = "FeaturedBanner"
         cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
         cell.featuredVideos = dianamicVideos[indexPath.section - 1].shows
         cell.delegate = self
         cell.layer.cornerRadius = 8
         return cell
      }
      else{
          let cell = tableView.dequeueReusableCell(withIdentifier: "homecell", for: indexPath) as! HomeVideoTableViewCell
          cell.selectionStyle = .none
          cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
          cell.homeButton.tag = indexPath.section - 1
          cell.homeButton.addTarget(self, action:#selector(self.allVideos(_:)), for:.touchUpInside)
          cell.homeButton.setTitle(dianamicVideos[indexPath.section - 1].category_name?.uppercased(), for: UIControl.State.normal)
          cell.homeButton.titleLabel?.textColor = ThemeManager.currentTheme().HeadTextColor
          if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "LIVE"{
          cell.homeButton.isHidden = false
          cell.rightArrowImageView.isHidden = true
          cell.channelType = "LIVE"
          cell.delegate = self
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
              self.videoHeight = 450
              self.videoViewHeight?.constant = 450
            } else {
              self.videoViewHeight?.constant = 250
              self.videoHeight = 250
            }
          cell.channelArray = dianamicVideos[indexPath.section - 1].shows
          if isLivePlaying{
              self.channelVideoLink = dianamicVideos[indexPath.section - 1].shows![indexPath.row].live_link!
            print("link",self.channelVideoLink)
              self.getLiveToken()
              if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                  self.videoViewHeight.constant = 450

              }else{
                  self.videoViewHeight.constant = 250
              }
              self.getLiveGuide()
              isLivePlaying = false
              
          }
        return cell
      }
      else if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "CONTINUE_WATCHING"{
          cell.homeButton.isHidden = false
          cell.rightArrowImageView.isHidden = true
          cell.channelType = "ContinueWatching"
          cell.channelArray = dianamicVideos[indexPath.section - 1].shows
          cell.delegate = self
          return cell
      }
      else if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "LIVE_EVENT"{
          cell.channelType = "LIVE_EVENT"
          cell.delegate = self
          cell.homeButton.isHidden = false
          cell.rightArrowImageView.isHidden = true
          cell.channelArray = dianamicVideos[indexPath.section - 1].shows
        return cell
      }
      else if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "UPCOMING_EVENT"{
          cell.homeButton.isHidden = false
          cell.rightArrowImageView.isHidden = true
          cell.channelType = "UPCOMING_EVENT"
          cell.delegate = self
          cell.channelArray = dianamicVideos[indexPath.section - 1].shows
        return cell
      }
      else if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "ENDED_EVENT"{
          cell.homeButton.isHidden = false
          cell.rightArrowImageView.isHidden = true
          cell.channelType = "ENDED_EVENT"
          cell.delegate = self
          cell.channelArray = dianamicVideos[indexPath.section - 1].shows
          
        return cell
      }
      else if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "NEWS"{
          cell.homeButton.isHidden = false
          cell.rightArrowImageView.isHidden = true
          cell.channelType = "News"
          cell.delegate = self
          cell.channelArray = dianamicVideos[indexPath.section - 1].shows
        return cell
      }
      else{
          cell.homeButton.isHidden = false
          cell.channelType = "Dianamic"
          cell.delegate = self
          let data = dianamicVideos[indexPath.section - 1].shows
          cell.channelArray = dianamicVideos[indexPath.section - 1].shows
          if (data?.count)! >= 5 {
              cell.rightArrowImageView.isHidden = false
            cell.channelArray = Array(data!.prefix(upTo: 5))
          } else {
              cell.rightArrowImageView.isHidden = true
              cell.channelArray = dianamicVideos[indexPath.section - 1].shows
          }
        return cell
      }
          
      }
      
  }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            let width = (UIScreen.main.bounds.width) / 2.5//some width
            let  height = (9 * width) / 16
            if indexPath.section == 0{
                if liveGuideArray.count > 0{
                    return height + 100
                }
                return 0
            }
            else if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "BANNER" {
                let width = (UIScreen.main.bounds.width)//some width
                let  height = (9 * width) / 16
                return height + 10
            }
            return height + 100
        } else {
            let width = (UIScreen.main.bounds.width) / 2.3//some width
            let  height = (9 * width) / 16
            if indexPath.section == 0{
                if liveGuideArray.count > 0{
                    return height + 100
                }
                return 0
            }
            else if dianamicVideos[indexPath.section - 1].shows![indexPath.row].type == "BANNER" {
                let width = (UIScreen.main.bounds.width)//some width
                let  height = (9 * width) / 16
                return height + 10
            }
            return height + 100
        }
        
        
    }
    
    @objc func goToVideolistingVc(_ sender: UIButton) {
      if sender.tag == 1 {
        let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
        videoPlayerController.videoName = "FreeShows"
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
      else{
      }
    }
  @objc func allVideos(_ sender: UIButton) {
      if dianamicVideos[sender.tag].type == "NEW_RELEASES"{
          let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
          videoPlayerController.videoName = "NewReleases"
          self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
      else if dianamicVideos[sender.tag].type == "WATCHLIST"{
          let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
          videoPlayerController.videoName = "MyList"
          self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
     else if dianamicVideos[sender.tag].type == "FREE_SHOWS"{
         let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
         videoPlayerController.videoName = "FreeShows"
         self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
      else if dianamicVideos[sender.tag].type == "CATEGORY_SHOWS"{
          let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allCategories") as! AllCategoryViewController
               videoPlayerController.fromHomeVC = true
                 if dianamicVideos[sender.tag].category_id != nil{
                     videoPlayerController.dynamicVideoId = dianamicVideos[sender.tag].category_id
                 }
               self.navigationController?.pushViewController(videoPlayerController, animated: false)
      }
       

  }
}
struct AppUtility {

  static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = orientation
    }
  }

  /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
  static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

    self.lockOrientation(orientation)

    UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    UINavigationController.attemptRotationToDeviceOrientation()
  }

}
