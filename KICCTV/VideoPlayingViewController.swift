//
//  VideoPlayingViewController.swift
//  PoppoTv
//
//  Created by Firoze Moosakutty on 26/04/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//
//
import UIKit
import AVFoundation
import AVKit
import GoogleInteractiveMediaAds
import SummerSlider
import Reachability
import GoogleCast

class VideoPlayingViewController: UIViewController, IMAAdsManagerDelegate, IMAAdsLoaderDelegate, VideoheaderViewDelegate,SubscriptionDelegate,GCKSessionManagerListener, GCKRemoteMediaClientListener, GCKRequestDelegate ,CastMessageChannelDelegate,VideoCheckingDelegate,videoPlayingDelegate,SubtitleDelegate{

  //  @IBOutlet weak var volumeControlView: UIView!{
  //    didSet{
  //      volumeControlView.layer.cornerRadius = 5.0
  //      volumeControlView.layer.borderWidth = 0.5
  //      volumeControlView.clipsToBounds = true
  //    volumeControlView.isHidden = true
  //    }
  //  }
  @IBOutlet weak var AutoPlayingView: UIView!{
    didSet{
      self.AutoPlayingView.isHidden = true
    }
  }
  @IBOutlet weak var AutoPlayingViewHeight: NSLayoutConstraint!
  @IBOutlet weak var autoPlayImageView: UIImageView!{
    didSet{
    }
  }

  @IBOutlet weak var upNextLabel: UILabel!{
    didSet{
      upNextLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
  }

  @IBOutlet weak var UpNextTitle: UILabel!{
    didSet{
      UpNextTitle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
  }



  @IBOutlet weak var UpNextTitleLabelWidth: NSLayoutConstraint!

  @IBOutlet weak var seperatorView: UILabel!{
    didSet{
      seperatorView.backgroundColor = ThemeManager.currentTheme().ThemeColor
      seperatorView.isHidden = true
    }
  }

  @IBOutlet weak var popupView: UIView!{
    didSet{
      self.popupView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.popupView.isHidden = true
    }
  }

  @IBOutlet weak var continueWatchingView: UIView!{
    didSet{
      self.continueWatchingView.backgroundColor = ThemeManager.currentTheme().grayImageColor
      self.continueWatchingView.isHidden = true
      self.continueWatchingView.layer.cornerRadius = 10.0
      self.continueWatchingView.layer.masksToBounds = true
    }
  }


  @IBOutlet weak var continueWatchingViewHeight: NSLayoutConstraint!
  @IBOutlet weak var continueWatchingWidth: NSLayoutConstraint!

  @IBOutlet weak var LoginButton: UIButton!{
    didSet{
      self.LoginButton.backgroundColor = ThemeManager.currentTheme().ThemeColor
      self.LoginButton.layer.cornerRadius = 8.0
      self.LoginButton.layer.borderWidth = 1
      self.LoginButton.layer.masksToBounds = true
    }
  }

  @IBOutlet weak var SubscribeNowButton: UIButton!{
    didSet{
      self.SubscribeNowButton.backgroundColor = ThemeManager.currentTheme().ThemeColor

      self.SubscribeNowButton.layer.cornerRadius = 8.0
      self.SubscribeNowButton.layer.masksToBounds = true
    }
  }


  @IBOutlet weak var OrLabel: UILabel!

  @IBOutlet weak var continueButton: UIButton!{
    didSet{
      self.continueButton.backgroundColor = ThemeManager.currentTheme().ThemeColor
      self.continueButton.layer.cornerRadius = 8.0
      self.continueButton.layer.borderWidth = 1
      //            self.continueButton.layer.borderColor = ThemeManager.currentTheme().UIImageColor.cgColor
      self.continueButton.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var playButton: UIButton!{
    didSet{
      self.playButton.backgroundColor = ThemeManager.currentTheme().ThemeColor

      self.playButton.layer.cornerRadius = 8.0
      self.playButton.layer.masksToBounds = true
    }
  }

  @IBOutlet weak var closeButton: UIButton!




  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!{
    didSet{
      self.activityIndicatorView.color = ThemeManager.currentTheme().UIImageColor
    }
  }
  @IBOutlet weak var BackButton: UIButton!{
    didSet{
      self.BackButton.addTarget(self, action: #selector(VideoPlayingViewController.backAction), for: .touchUpInside)
    }
  }
  @IBOutlet weak var mainView: UIView!{
    didSet {
      self.mainView.isHidden = true
      self.mainView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
  }

  @IBOutlet weak var forwardButton: UIButton!{
    didSet{
      self.forwardButton.addTarget(self, action: #selector(VideoPlayingViewController.forwardVideo), for: .touchUpInside)

    }
  }
  @IBOutlet weak var backwardButton: UIButton!{
    didSet{
      self.backwardButton.addTarget(self, action: #selector(VideoPlayingViewController.rewindVideo), for: .touchUpInside)
    }
  }


  @IBOutlet weak var playerControlViewHeight: NSLayoutConstraint!
  @IBOutlet weak var videoPlayingView: UIView!
  @IBOutlet weak var playerControlsView: UIView!
  @IBOutlet weak var videoPlayingViewHeight: NSLayoutConstraint!
  @IBOutlet weak var moreVideosCollectionView: UICollectionView!{
    didSet{
      self.moreVideosCollectionView.backgroundColor = .black
    }
  }
  @IBOutlet weak var fullScreenButton: UIButton!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var startDurationLabel: UILabel!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var videoPlaybackSlider: SummerSlider!
  @IBOutlet weak var YouMayAlsoLikeLabel: UILabel!{
    didSet{
      self.YouMayAlsoLikeLabel.isHidden = true
      self.YouMayAlsoLikeLabel.textColor = ThemeManager.currentTheme().ThemeColor
      self.YouMayAlsoLikeLabel.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
  }
  @IBOutlet weak var errorMessageLabel: UILabel!
  @IBOutlet weak var subTitleButton: UIButton!{
    didSet{
      self.subTitleButton.isHidden = true
    }
  }
  @IBOutlet weak var videoTitleLable: UILabel!

  @IBOutlet weak var videoTitleHeight: NSLayoutConstraint!
  @IBOutlet weak var youMayAlsoLikeLabelHeight: NSLayoutConstraint!
  @IBOutlet weak var catagoriesCollectionViewHeight: NSLayoutConstraint!
  @IBOutlet weak var VideoImageView: UIImageView!
  @IBOutlet weak var synopsisHeight: NSLayoutConstraint!
  @IBOutlet weak var VideoNameLabel: UILabel!
  @IBOutlet weak var EpisodeTableView: UITableView!
  @IBOutlet weak var MainViewHeight: NSLayoutConstraint!
  @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
  @IBOutlet weak var mainScrollView: UIScrollView!
  @IBOutlet weak var ResalutionLabel: UILabel!
  @IBOutlet weak var ProducerLabel: UILabel!
  @IBOutlet weak var yearOfRelaseLabel: UILabel!
  @IBOutlet weak var categoriesCollectionView: UICollectionView!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var audioLabel: UILabel!
  @IBOutlet weak var synopsisTitleLabel: UILabel!
  @IBOutlet weak var themeTitleLabel: UILabel!
  @IBOutlet weak var watchTrailerButtonWidth: NSLayoutConstraint!
  @IBOutlet weak var playButtonWidth: NSLayoutConstraint!
  @IBOutlet weak var subTitleLabel: UILabel!

  private var castButton: GCKUICastButton!
  private var mediaInformation: GCKMediaInformation?
  private var sessionManager: GCKSessionManager!
  var videoPlayFlag = false
  var videos = [VideoModel]()
  var categoryModel : VideoModel!
  var selectedIndex = -1

  var subtitleIsOn = false
  var subtitleUrl = String()
  var subtitleListArray = [subtitleModel]()
  var dummyarray = [subtitleModel]()

  let listArray: NSDictionary = [
    "language_name": "Off",
    "short_code": "off",
    "code": "off",
    "subtitle_url": "off",

  ]
  let playerViewController = AVPlayerViewController()
  var avPlayer: AVPlayer? = AVPlayer()
  var contentPlayerLayer: AVPlayerLayer?
  var observer: Any!
  var video: VideoModel!
  var contentPlayhead: IMAAVPlayerContentPlayhead?
  var adsLoader: IMAAdsLoader!
  var adsManager: IMAAdsManager!
  var companionSlot: IMACompanionAdSlot?
  var isAdPlayback = false
  var isLandscape = false
  let playerItem: AVPlayerItem? = nil
  var videoHeight = CGFloat()
  var videoPlayerHeight = CGFloat()
  var adPositionsArray = Array<Float>()
  var isPlaying = true
  var videoName = ""
  var videoTitle = ""
  var addLink = ""
  var videoId = Int()
  var showId = Int()

  var channelId = ""
  var channelName = ""
  var liked = ""
  var token  = ""
  var theme = ""
  var programeTitle = ""
  var appStoreEncodedUrl = ""
  var videoStartTime = ""
  var categoryList = ""
  var videoDuration = Double()
  var watchUpdateFlag = false
  var fromContinueWatching = false
  var fromHomeScreen = false
  var watchedDuration = 0
  var currentPlayerTime = 0
  var reachability = Reachability()!
  var sampleArray = Array<Float>()
  var videoDescription = ""
  var isFromSub = false

  var fullScreenValue = Int()
  var videoPlayerWidth = Int()
  var videoPlayerMacroHeight = Int()
  var btnLeftMenu : UIButton = UIButton()
  var hidevideoController = true
  var normalScreenButtonflag = false
  var adDisplayContainer:IMAAdDisplayContainer?
  var fromNotification = Bool()
  var dropDownflag = true
  var videoNotificationId = Int()
  var interstitial_status = Int()
  var mobpub_interstitial_status = Int()
  private var imageView: UIImageView!
  var isPresentController = false
  var subscribedUser = false
  var premium_flag = Int()
  var isfromSubscription = false
  var isbackActionPerformed = false
  let metadata = GCKMediaMetadata()
  var messageChannel: CastMessageChannel?
  var pointsArr = Array<String>()
  var LabelDict: [String: NSRange?] = [ : ]
  var slider = UISlider()
  var replacedString = ""
  var countTimer:Timer!
  var counter = 15
  var videoPlayingeventValue = false
  var parsedPayload: NSDictionary?
  var rotationAngle : CGFloat!
  var autoPlayVideomodel = [VideoModel]()
  var isAdComplete=false
  var autoPlayvideovideo: VideoModel!
  override func viewDidLoad() {
    super.viewDidLoad()
    print(UserDefaults.standard.string(forKey:"skiplogin_status"))
    //        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    self.navigationTitle()
    self.castButtonSetup()
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      videoPlayerHeight = 450
      videoPlayingViewHeight?.constant = 450
      playerControlViewHeight?.constant = 450
      AutoPlayingViewHeight?.constant = 450
      self.continueWatchingWidth.constant = 400
      self.continueWatchingViewHeight.constant = 400
    } else {
      videoPlayingViewHeight?.constant = 250
      playerControlViewHeight?.constant = 250
      AutoPlayingViewHeight?.constant = 250
      videoPlayerHeight = 250
      self.continueWatchingWidth.constant = 230
      self.continueWatchingViewHeight.constant = 260
    }
    self.interstitial_status = (UserDefaults.standard.integer(forKey: "interstitial_status"))
    self.mobpub_interstitial_status = (UserDefaults.standard.integer(forKey: "mobpub_interstitial_status"))
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.moreVideosCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
    self.moreVideosCollectionView.register(UINib(nibName: "videoPlayerHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "videoPlayerHeader")
    if fromNotification {
      self.notificationSelectedVideo(selectedVideoId: videoNotificationId, premium_flag: premium_flag)
    } else {
      self.getUserSubscriptions()  // call to function to check user have subscription or not

    }
    Application.shared.isVideoPlaying = true
    self.videoPlayingView.backgroundColor = .black
  }
  override func viewWillAppear(_ animated: Bool) {
    sessionManager.add(self)
    sessionManager.currentCastSession?.remoteMediaClient?.add(self)
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
    self.tabBarController?.tabBar.isHidden = false
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do {
      try reachability.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
    NotificationCenter.default.addObserver(self, selector: #selector(self.playerPause), name: NSNotification.Name(rawValue: "PausePlayer"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.playerPlay), name: NSNotification.Name(rawValue: "PlayPlayer"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(playVideoAfterAd), name: NSNotification.Name("RewardVideoPlayedinVideo"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(lodMopPubAd), name: NSNotification.Name("LodMopPubAd"), object: nil)
    playPauseButton.imageView?.image = UIImage.init(named: "pause")

    self.avPlayer?.play()
  }


  override func viewWillDisappear(_ animated: Bool) {
    self.avPlayer?.pause()
    sessionManager.remove(self)
    sessionManager.currentCastSession?.remoteMediaClient?.remove(self)
    super.viewWillDisappear(animated)
    let value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    if isAdPlayback == true || isAdPlayback == false {
      if adsManager != nil {
        adsManager?.destroy()
      }
    }
    if avPlayer != nil {
      avPlayer?.pause()
    }
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PausePlayer"), object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlayPlayer"), object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RewardVideoPlayedinVideo"), object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LodMopPubAd"), object: nil)
  }
  // return to videoDetails VC upon clicking close button in login page and register page
  func loadAfterIntermediateLogin(){
    self.navigationController?.popViewController(animated: false)
  }

  // delegate for load video after intermediate login
  // checks user subscription
  // call to func collectionViewSelectedVideo() for further subscription details
  func guestUserLogin(){
    if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
      ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
        if responseDictionary["forcibleLogout"] as? Bool == true {
          DispatchQueue.main.async {

            CustomProgressView.hideActivityIndicator()
            WarningDisplayViewController().customActionAlert(viewController :self,title: "You are no longer Logged in this device. Please Login again to access.", message: "", actionTitles: ["OK"], actions:[{action1 in
              CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
              self.logOutApi()
            },nil])
          }
        }
        else if responseDictionary["session_expired"] as? Bool == true {
          DispatchQueue.main.async {

            CustomProgressView.hideActivityIndicator()
            WarningDisplayViewController().customActionAlert(viewController :self,title: "Your session expired. Please Login again to access.", message: "", actionTitles: ["OK"], actions:[{action1 in
              CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
              self.logOutApi()
            },nil])
          }
        }
        else if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            //CustomProgressView.hideActivityIndicator()
          }
        } else {
          if UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {

          }
          if let videos = responseDictionary["data"] as? [SubscriptionModel] {
            if videos.count == 0 {
              Application.shared.userSubscriptionStatus = false

            }
            else{
              Application.shared.userSubscriptionStatus = true
            }
            Application.shared.userSubscriptionsArray = videos
            self.collectionViewSelectedVideo(selectedVideoModel: self.video)

          }
        }
      }
    }

  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    if  isPresentController {
      super.viewWillTransition(to: size, with: coordinator)
      let mopPubinterstitialVideoPlaying = UserDefaults.standard.bool(forKey: "MopPubinterstitialVideoPlaying")
      if mopPubinterstitialVideoPlaying == false  {
        if UIDevice.current.orientation.isLandscape {
          if !isLandscape {
            gotoFullScreen()
            self.videoTitleHeight.constant = 0
            self.youMayAlsoLikeLabelHeight.constant = 0
            self.moreVideosCollectionView.setContentOffset(.zero, animated: true)
            isLandscape = true
          }
        } else {
          gotoNormalScreen()
          self.videoTitleHeight.constant = 25
          self.youMayAlsoLikeLabelHeight.constant = 25
          self.moreVideosCollectionView.reloadData()

          isLandscape = false
        }
      }
    }
  }
  // MARK: Button Action
  @objc func playVideoAfterAd() {
    UserDefaults.standard.set(false, forKey: "MopPubinterstitialVideoPlaying")
    if self.video.video_name != nil {
      if self.token != "" {
        self.setUpContentPlayer()
        self.setUpAdsLoader()
        self.requestAds()
        CustomProgressView.hideActivityIndicator()
      } else {
        self.GenerateToken(flag : true)
      }
    }
  }

  @objc func   lodMopPubAd() {
    if self.mobpub_interstitial_status == 1 {
      let tabbarcontroller = self.tabBarController as? HomeTabBarViewController
      // tabbarcontroller?.loadInterstitial()
    } else {
      self.playVideoAfterAd()
    }
  }
//
//  @IBAction func LoginButtonAction(_ sender: Any) {
//    self.MoveTOLoginPage()
//  }
//
//  @IBAction func SubscribeNowAction(_ sender: Any) {
//    if UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
//      self.getUserSubscriptions()
//    }
//    else{
//    self.MoveTORegisterPage()
//    }
//  }

  @IBAction func backAction(_ sender: Any) {
    if let observer = self.observer {
      self.avPlayer?.removeTimeObserver(observer)
      self.observer = nil
    }
    self.isbackActionPerformed = true
    contentPlayerLayer?.removeFromSuperlayer()
    DispatchQueue.main.async {
      self.avPlayer?.isMuted = true
      if self.countTimer != nil {
        self.countTimer.invalidate()
      }
      self.avPlayer?.pause()

      if self.fromNotification == true {
        UserDefaults.standard.set("false", forKey: "fromTerminate")
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "myNotification"), object: nil)
        if self.isAdPlayback == true || self.isAdPlayback == false {
          if self.adsManager != nil {
            self.adsManager?.destroy()
            self.avPlayer?.pause()
          }
          self.navigationController?.popToRootViewController(animated: false)
        }
      } else {
        if self.isAdPlayback == true || self.isAdPlayback == false {
          if self.adsManager != nil {
            self.adsManager?.destroy()
          }
          self.avPlayer = nil
          self.avPlayer?.pause()
          self.navigationController?.popViewController(animated: false)
        }
        else if self.avPlayer != nil {
          self.avPlayer?.pause()
          self.navigationController?.popViewController(animated: false)
        }
      }
    }
    Application.shared.isVideoPlaying = false

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
      print("Network not reachable")
    }
  }
  // get user subscription details
  func getUserSubscriptions(){
    ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
      if responseDictionary["forcibleLogout"] as? Bool == true {
        DispatchQueue.main.async {

          CustomProgressView.hideActivityIndicator()
          WarningDisplayViewController().customActionAlert(viewController :self,title: "You are no longer Logged in this device. Please Login again to access.", message: "", actionTitles: ["OK"], actions:[{action1 in
            CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
            self.logOutApi()
          },nil])
        }
      }
      else if responseDictionary["session_expired"] as? Bool == true {
        DispatchQueue.main.async {

          CustomProgressView.hideActivityIndicator()
          WarningDisplayViewController().customActionAlert(viewController :self,title: "Your session expired. Please Login again to access.", message: "", actionTitles: ["OK"], actions:[{action1 in
            CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
            self.logOutApi()
          },nil])
        }
      }
      else if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          //CustomProgressView.hideActivityIndicator()
        }
      } else {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
          // setting orientation ... videoplaying in full screeen mode

        }
        if let videos = responseDictionary["data"] as? [SubscriptionModel] {
          if videos.count == 0 {
            Application.shared.userSubscriptionStatus = false

          }
          else{
            Application.shared.userSubscriptionStatus = true
          }
          Application.shared.userSubscriptionsArray = videos
          self.collectionViewSelectedVideo(selectedVideoModel: self.video)

        }
      }
    }
  }
  func logOutApi() {
    var parameterDict: [String: String?] = [ : ]

    if let deviceid = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = deviceid
    }
    if let user_id = UserDefaults.standard.string(forKey:"user_id") {
      parameterDict["user_id"] = user_id
    }
    if let pubid = UserDefaults.standard.string(forKey:"pubid") {
      parameterDict["pubid"] = pubid
    }
    if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
      parameterDict["ipaddress"] = ipAddress
    }
    ApiCommonClass.logOutAction(parameterDictionary: parameterDict as? Dictionary<String, String>) { (result) -> () in
      print(result)
      if result {
        CustomProgressView.hideActivityIndicator()
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "login_status")
        UserDefaults.standard.removeObject(forKey: "first_name")
        UserDefaults.standard.removeObject(forKey: "skiplogin_status")
        UserDefaults.standard.removeObject(forKey: "access_token")
        Application.shared.userSubscriptionsArray.removeAll()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.navigationController?.pushViewController(nextViewController, animated: false)

      } else {
        WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
      }
    }

  }
  @objc private func playerPause(notification: Notification) {
    if isAdPlayback {
      adsManager.pause()
    }
    avPlayer?.pause()
  }
  @objc private func playerPlay(notification: Notification) {
    if isAdPlayback {
      adsManager.resume()
      avPlayer?.pause()
    }
    else {
      avPlayer?.play()
    }
  }


  // MARK: Main Functions
  func navigationTitle(){
    self.navigationItem.hidesBackButton = true
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = false
    UINavigationBar.appearance().backgroundColor = .black
    let newBackButton = UIButton(type: .custom)
    newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
    newBackButton.contentMode = .scaleAspectFit
    newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
    newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
    newBackButton.addTarget(self, action: #selector(VideoPlayingViewController.backAction), for: .touchUpInside)
    let item2 = UIBarButtonItem(customView: newBackButton)
    self.navigationItem.leftBarButtonItem = item2
    let imageView = UIImageView(image: UIImage(named: "ApplLogo"))
    imageView.contentMode = UIView.ContentMode.scaleAspectFit
    var titleView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      titleView = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 40))
    }
    imageView.frame = titleView.bounds
    titleView.addSubview(imageView)
    self.navigationItem.titleView = titleView
    navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
  }
  func seekToPlay(){
    if self.watchedDuration != 0  {
      let seekTime = CMTime(value: CMTimeValue((self.watchedDuration + 10) * 1000), timescale: 1000)
      avPlayer?.seek(to: seekTime)

    }
  }
  func castButtonSetup(){
    sessionManager = GCKCastContext.sharedInstance().sessionManager
    sessionManager.add(self)
    castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    // Used to overwrite the theme in AppDelegate.
    castButton.tintColor = ThemeManager.currentTheme().TabbarColor
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(castDeviceDidChange(notification:)),
                                           name: NSNotification.Name.gckCastStateDidChange,
                                           object: GCKCastContext.sharedInstance())
  }



  func setUpInitial() {
    self.playPauseButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true

    if self.video.video_name != nil {
      videoName = video.video_name!
      print("video name" , videoName)


    }
    else{
      videoName = "136754"
    }

    if self.video.ad_link != nil {
      addLink = self.video.ad_link!
    }
    if self.video.video_title != nil {
      metadata.setString(self.video.video_title!, forKey: kGCKMetadataKeyTitle)
      self.videoTitleLable.text = video.video_title
      self.navigationItem.title = video.video_title


    }
    if self.video.video_duration != nil {
      videoDuration = Double(video.video_duration!)!
    }
    if self.video.channel_id != nil {
      channelId = String(self.video.channel_id!)
    }
    if self.video.channel_name != nil {
      channelName = self.video.channel_name!
    }
    if self.video.video_id != nil {
      videoId = video.video_id!
    }
    if self.video.show_id != nil {
      showId = video.show_id!
    }
    if self.video.channel_name != nil {
      videoTitle = self.video.channel_name!
    }
    if  self.video.thumbnail != nil {

      metadata.addImage(GCKImage(url: URL(string: imageUrl + self.video.thumbnail!)!,
                                 width: 480,
                                 height: 360))
    }
    //    if let subtitle = self.video.subtitle {
    //      self.subtitleUrl = subtitle
    //    }
    if let category_name = self.video.category_name{
      if !category_name.isEmpty {
        var name = ""
        for categoryListArray in category_name {
          print(categoryListArray)
          name =  name + "," + (categoryListArray)
        }
        print(String(name.dropFirst()))
        self.categoryList = String(name.dropFirst())
      }
    }
    if addLink == "" {
      self.playPauseButton.isHidden = false
      self.videoPlaybackSlider.isHidden = false
    } else {
    }
    if reachability.connection != .none {
      if self.video.video_name != nil {
        if self.videoPlayFlag{
          self.videoPlayFlag = true
        }
        else{
          self.GenerateToken(flag: false)
        }
      }

    }
  }

  func replaceMacros() {
    let bundleID = Bundle.main.bundleIdentifier
    if bundleID != nil {
      let originalBundleIdString = bundleID
      let encodedBundleIdUrl = originalBundleIdString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
      addLink = addLink.replacingOccurrences(of: "[BUNDLE]", with: encodedBundleIdUrl!)
    } else {
      let originalBundleIdString = "com.ios.projectfortysix"
      let encodedBundleIdUrl = originalBundleIdString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
      addLink = addLink.replacingOccurrences(of: "[BUNDLE]", with: encodedBundleIdUrl!)
    }
    videoPlayerWidth = 640
    addLink = addLink.replacingOccurrences(of: "[WIDTH]", with: "\(videoPlayerWidth)")
    videoPlayerMacroHeight = 480
    addLink = addLink.replacingOccurrences(of: "[HEIGHT]", with: "\(videoPlayerMacroHeight)")
    let videoPlayingViewHeightInt = Int(videoPlayingViewHeight.constant)
    let videoPlayingViewWidthInt = Int(self.view.frame.width)
    addLink = addLink.replacingOccurrences(of: "[[PLAYER_HEIGHT]]", with: "\(videoPlayingViewHeightInt)")
    addLink = addLink.replacingOccurrences(of: "[PLAYER_WIDTH]", with: "\(videoPlayingViewWidthInt)")
    if UserDefaults.standard.string(forKey:"countryCode") != nil {
      let countryCode = UserDefaults.standard.string(forKey:"countryCode")
      addLink = addLink.replacingOccurrences(of: "[COUNTRY]", with: countryCode!)
    }
    if UserDefaults.standard.string(forKey:"userAgent") != nil {
      let userAgent = UserDefaults.standard.string(forKey:"userAgent")!
      let encodeduserAgent = String(format: "%@", userAgent.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink =  addLink.replacingOccurrences(of: "[USER_AGENT]", with: encodeduserAgent)
    }
    let UDID = UserDefaults.standard.string(forKey:"UDID")!
    addLink = addLink.replacingOccurrences(of: "[UUID]", with: UDID)
    if UserDefaults.standard.string(forKey:"IPAddress") != nil {
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      addLink = addLink.replacingOccurrences(of: "[IP_ADDRESS]", with:ipAddress)

    }
    if let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String{
      let originalAppNameString = displayName
      let encodedAppNameUrl = String(format: "%@", originalAppNameString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[APP_NAME]", with: encodedAppNameUrl)
    }
    else{
      let originalAppNameString = ""
      let encodedAppNameUrl = String(format: "%@", originalAppNameString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[APP_NAME]", with: encodedAppNameUrl)
    }



    if UserDefaults.standard.string(forKey:"latitude") != nil {
      let lattitude = UserDefaults.standard.string(forKey: "latitude")!
      addLink = addLink.replacingOccurrences(of: "[LATITUDE]", with: lattitude)
    }
    if UserDefaults.standard.string(forKey:"longitude") != nil {
      let longitude = UserDefaults.standard.string(forKey:"longitude")!
      addLink = addLink.replacingOccurrences(of: "[LONGITUDE]", with: longitude)
    }
    if UserDefaults.standard.string(forKey:"Idfa") != nil {
      let Idfa = UserDefaults.standard.string(forKey:"Idfa")!
      addLink = addLink.replacingOccurrences(of: "[DEVICE_IFA]", with: Idfa)
    }
    if UserDefaults.standard.string(forKey:"city") != nil {
      let city = UserDefaults.standard.string(forKey:"city")!
      addLink = addLink.replacingOccurrences(of: "[CITY]", with: city)
    }
    if UserDefaults.standard.string(forKey:"Geo_Type") != nil {
      let Geo_Type = UserDefaults.standard.string(forKey:"Geo_Type")!
      addLink = addLink.replacingOccurrences(of: "[GEO_TYPE]", with: Geo_Type)
    }

    addLink = addLink.replacingOccurrences(of: "[GDPR]", with: "0")
    addLink = addLink.replacingOccurrences(of: "[AUTOPLAY]", with: "1")
    addLink = addLink.replacingOccurrences(of: "[GDPR]", with: "0")
    if videoDescription != "" {
      let encodedvideoDescription = String(format: "%@",videoDescription.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[DESCRIPTION]", with: encodedvideoDescription)
    }
    let originalDeviceType = "iOS"
    let encodedDeviceType = String(format: "%@",originalDeviceType.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    addLink = addLink.replacingOccurrences(of: "[DEVICE_TYPE]", with: encodedDeviceType)
    let originalDevicemake = "Apple"
    let encodedDevicemake = String(format: "%@",originalDevicemake.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    addLink = addLink.replacingOccurrences(of: "[DEVICE_MAKE]", with: encodedDevicemake)
    let deviceModel = UserDefaults.standard.string(forKey:"deviceModel")!
    let encodedDeviceModel = String(format: "%@", deviceModel.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    addLink = addLink.replacingOccurrences(of: "[DEVICE_MODEL]", with:encodedDeviceModel)
    let deviceId = UserDefaults.standard.string(forKey:"UDID")!
    addLink = addLink.replacingOccurrences(of: "[DEVICE_ID]", with:deviceId)
    addLink = addLink.replacingOccurrences(of: "[VIDEO_ID]", with:String(videoId))
    addLink = addLink.replacingOccurrences(of: "[CHANNEL_ID]", with:channelId)
    if video.video_duration != nil {
      addLink = addLink.replacingOccurrences(of: "[TOTAL_DURATION]", with: video.video_duration!)
    }
    if UserDefaults.standard.string(forKey:"region") != nil {
      let Region = UserDefaults.standard.string(forKey:"region")!
      let encodedRegion = String(format: "%@",Region.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

      addLink = addLink.replacingOccurrences(of: "[REGION]", with: encodedRegion)
    }
    addLink = addLink.replacingOccurrences(of: "[SHOW_ID]", with:String(showId))

    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    addLink = addLink.replacingOccurrences(of: "[USER_ID]", with:user_id)
    if UserDefaults.standard.string(forKey:"CARRIER") != nil {
      let carrier = UserDefaults.standard.string(forKey:"CARRIER")
      let encodedCarrier = String(format: "%@", carrier!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[CARRIER]", with: encodedCarrier)
    }
    if UserDefaults.standard.string(forKey:"NETWORK") != nil {
      let network = UserDefaults.standard.string(forKey:"NETWORK")!
      let encodedNetwork = String(format: "%@", network.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[NETWORK]", with:encodedNetwork)
    }
    if UserDefaults.standard.string(forKey:"appVersion") != nil {
      let appVersion = UserDefaults.standard.string(forKey:"appVersion")!
      addLink = addLink.replacingOccurrences(of: "[APP_VERSION]", with:appVersion)
    }
    if UserDefaults.standard.string(forKey:"TYPE") != nil {
      let type = UserDefaults.standard.string(forKey:"TYPE")!
      addLink = addLink.replacingOccurrences(of: "[TYPE]", with:type)
    }
    if video.video_duration != nil {
      addLink = addLink.replacingOccurrences(of: "[DURATION]", with:video.video_duration!)
    }
    addLink = addLink.replacingOccurrences(of: "[DNT]", with:""  + "0")
    addLink = addLink.replacingOccurrences(of: "[VPAID]", with:""  + "0")
    addLink = addLink.replacingOccurrences(of: "[VPAID]", with:"" + "0")
    addLink = addLink.replacingOccurrences(of: "[PL]", with:"" + "0")
    addLink = addLink.replacingOccurrences(of: "[LOCSOURCE]", with:"2")
    addLink = addLink.replacingOccurrences(of: "[DEVICE_ORIGIN]", with:"IA")
    addLink = addLink.replacingOccurrences(of: "[CACHEBUSTER]", with:"AA")
    if UserDefaults.standard.string(forKey:"languageId") != nil {
      let languageId = UserDefaults.standard.string(forKey:"languageId")!
      addLink = addLink.replacingOccurrences(of: "[LANGUAGE]", with:languageId)
    }
    if video.category_name != nil{
      if let category_name = self.video.category_name{
        if !category_name.isEmpty {
          var name = ""
          for categoryListArray in category_name {
            print(categoryListArray)
            name =  name + "," + (categoryListArray)

          }
          let keywords = String(name.dropFirst())
          let encodedAppStoreUrl = keywords.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
          addLink = addLink.replacingOccurrences(of: "[KEYWORDS]", with:encodedAppStoreUrl)

          print("encoded url",encodedAppStoreUrl)

        }
      }
      if let category_id = self.video.category_id{
        if !category_id.isEmpty {
          var name = ""
          for categoryListArray in category_id {
            print(categoryListArray)
            name =  name + "," + String(categoryListArray)

          }
          let ids = String(name.dropFirst())
          let encodedAppStoreUrl = ids.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
          addLink = addLink.replacingOccurrences(of: "[CATEGORIES]", with:encodedAppStoreUrl)

          print("encoded url",encodedAppStoreUrl)

        }
      }

    }
    let originalAppstoreString = ""
    let encodedAppStoreUrl = originalAppstoreString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    addLink = addLink.replacingOccurrences(of: "[APP_STORE_URL]", with: encodedAppStoreUrl)

    if UserDefaults.standard.string(forKey:"currentTimeStamp") != nil {
      let currentTimeStamp = UserDefaults.standard.string(forKey:"currentTimeStamp")!
      addLink = addLink.replacingOccurrences(of: "[CACHEBUSTER]", with:currentTimeStamp)
    }
    print("addLink",addLink)


  }
  var ipaddress:String?
  func getIPAddress() -> String {
    do { let ipAddress = try String(contentsOf: URL.init(string: "https://api.ipify.org")!, encoding: String.Encoding.utf8)
      print("IP AddRess : ", ipAddress)
      ipaddress = ipAddress


    } catch { print(error) }
    return ipaddress!

  }

  func setUpContentPlayer() {

    print("setup content player")
    self.playerControlsView.isHidden = false
    self.activityIndicatorView.isHidden = false
    self.activityIndicatorView.startAnimating()
    videoStartTime = getCurrentDate()
    let contentUrl = URL(string: String(format:videoName))
    let headers = ["token": token]
    let asset: AVURLAsset = AVURLAsset(url: contentUrl!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
    let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
    avPlayer = AVPlayer(playerItem: playerItem)
    contentPlayerLayer = AVPlayerLayer(player: avPlayer)
    contentPlayerLayer?.backgroundColor = UIColor.clear.cgColor
    if videoPlayFlag{
      avPlayer?.play()
    }
    self.observer = avPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main) {
      [weak self] time in
      do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
      } catch let error {
        print("Error in AVAudio Session\(error.localizedDescription)")
      }
      if self!.subtitleIsOn {
        self?.subTitleLabel.text = ApiCommonClass.searchSubtitles(self?.parsedPayload, time.seconds)
      } else {
        self?.subTitleLabel.text = nil
      }
      //        if self?.avPlayer?.timeControlStatus == ==AVPlayerTimeControlStatusPaused
      if self?.avPlayer?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
        if let isPlaybackLikelyToKeepUp = self?.avPlayer?.currentItem?.isPlaybackLikelyToKeepUp {
          if  isPlaybackLikelyToKeepUp == false {
            print(isPlaybackLikelyToKeepUp)
            self?.activityIndicatorView.isHidden = false
            self?.activityIndicatorView.startAnimating()
            self?.playPauseButton.isHidden = true
          } else {
            if self?.fromContinueWatching == true{
              self?.seekToPlay()
              self?.fromContinueWatching = false

            }
            if self?.fromHomeScreen == true{
              self?.seekToPlay()
              self?.fromHomeScreen = false
            }
            if self!.watchUpdateFlag == false {
              self!.videoStartEvent()
              self?.watchUpdateFlag = true
              if Application.shared.CastSessionStart {
                self!.switchToRemotePlayback()
              }
            }
            if (self!.videoPlaybackSlider.isHidden){
              self?.playPauseButton.isHidden = true
            } else {
              self?.playPauseButton.isHidden = false
            }
            if self!.isbackActionPerformed {
              self!.avPlayer?.pause()
            }
            self?.activityIndicatorView.stopAnimating()
          }
        }
      }
    }
    NotificationCenter.default.addObserver(forName:NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: avPlayer!.currentItem, queue:nil){ [weak avPlayer] notification in
      // Make sure we don't call contentComplete as a result of an ad completing.
      if (notification.object as! AVPlayerItem) == avPlayer?.currentItem {
        self.playerDidFinish()
        if self.adsLoader != nil {
          self.adsLoader.contentComplete()
        }
      }
    }
    if addLink == "" {
      self.playPauseButton.isHidden = true
      self.videoPlaybackSlider.isHidden = true
      self.durationLabel.isHidden = true
      self.startDurationLabel.isHidden = true
      self.forwardButton.isHidden = true
      self.subTitleButton.isHidden =  true
      self.backwardButton.isHidden = true
    } else {
      self.playPauseButton.isHidden = true
      self.videoPlaybackSlider.isHidden = true
      self.durationLabel.isHidden = true
      self.startDurationLabel.isHidden = true
      self.forwardButton.isHidden = true
      self.subTitleButton.isHidden =  true
      self.backwardButton.isHidden = true
    }
    self.YouMayAlsoLikeLabel.isHidden = true
    contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.videoPlayingView.frame.size.width , height: videoPlayerHeight )
    if videoPlayingView.layer.sublayers?.filter({$0 is AVPlayerLayer}) != nil {
      let previousLayer = videoPlayingView.layer.sublayers?.filter({$0 is AVPlayerLayer}).first
      videoPlayingView.layer.replaceSublayer(previousLayer!, with: contentPlayerLayer!)
    }
    else{
      videoPlayingView.layer.addSublayer(contentPlayerLayer!)

    }
    adDisplayContainer = IMAAdDisplayContainer(adContainer: videoPlayingView, companionSlots: nil)
    contentPlayerLayer?.videoGravity=AVLayerVideoGravity.resizeAspect
    // Create content playhead
    contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: avPlayer)
    NotificationCenter.default.addObserver(forName:NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: avPlayer!.currentItem, queue:nil){ [weak avPlayer] notification in
      // Make sure we don't call contentComplete as a result of an ad completing.
      if (notification.object as! AVPlayerItem) == avPlayer?.currentItem {
        if self.adsLoader != nil {
          self.adsLoader.contentComplete()
        }
      }

    }
    playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
    playPauseButton.titleLabel?.text = ""
    playPauseButton.imageView?.image = UIImage.init(named: "play")
    videoPlaybackSlider.minimumValue = 0
    // let duration: CMTime = playerItem.asset.duration
    videoPlaybackSlider.maximumValue = 1
    videoPlaybackSlider.isContinuous = false
    videoPlaybackSlider.selectedBarColor = ThemeManager.currentTheme().UIImageColor
    videoPlaybackSlider.unselectedBarColor = UIColor.black.withAlphaComponent(0.6)
    videoPlaybackSlider.addTarget(self, action: #selector(playbackSliderValueChanged), for: .valueChanged)
    durationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    durationLabel.layer.cornerRadius = 5
    durationLabel?.layer.masksToBounds = true
    startDurationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    startDurationLabel.layer.cornerRadius = 5
    startDurationLabel?.layer.masksToBounds = true
    playerControlsView.backgroundColor = UIColor.clear

    self.videoPlaybackSlider.value = 0
    self.startDurationLabel.text = "00:00"

    self.durationLabel.text = formatMinuteSeconds(videoDuration)
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
    avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (progressTime) -> Void in
      let seconds = CMTimeGetSeconds(progressTime)
      let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
      let minutesString = String(format: "%02d", Int(seconds / 60))
      self.startDurationLabel.text = "\(minutesString):\(secondsString)"
      if Int((seconds.truncatingRemainder(dividingBy: 60))) ==  0 && Int(seconds) != 0 {
        if Int(seconds) == self.currentPlayerTime{  // for pop03 during ad midroll
          self.currentPlayerTime = Int(seconds)
          print("currentPlayerTime",self.currentPlayerTime)
        }
        else{
          self.videoPlayingEvent()
          self.currentPlayerTime = Int(seconds)
          print("currentPlayerTime videoplaying",self.currentPlayerTime)
        }
      }
      //lets move the slider thumb
      if(self.isSlidding == true) {
        self.isSlidding = false
      } else {
        if let duration = self.avPlayer?.currentItem?.duration {
          let durationSeconds = CMTimeGetSeconds(duration)
          self.videoPlaybackSlider.value = Float(seconds / durationSeconds)
          //            print(self?.avplayer?.currentItem?.presentationSize)
          print("presentation size",self.avPlayer?.currentItem?.presentationSize)
        }
      }
    }
    if adPositionsArray.count != 0 {
      self.videoPlaybackSlider.markPositions = adPositionsArray
    }

    if playerItem.asset.isPlayable{
      print("isPlayable")
      self.errorMessageLabel.isHidden = true
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
      playerControlsView.addGestureRecognizer(tap)
      playerControlsView.isUserInteractionEnabled = true
    }else{
      print("NotPlayable")
      self.activityIndicatorView.stopAnimating()
      self.errorMessageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
      self.errorMessageLabel.layer.cornerRadius = 5
      self.errorMessageLabel.layer.masksToBounds = true
      self.errorMessageLabel.isHidden = false
      self.playerControlsView.isUserInteractionEnabled = false
    }

    self.getSimilarVideos()

  }


  @IBAction func subTitleAction(_ sender: Any) {
    dummyarray.removeAll()
    let dummyList = subtitleModel.from(listArray)

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let pvc = storyboard.instantiateViewController(withIdentifier: "SubtitleVc") as! SubtitleViewController

    pvc.modalPresentationStyle = UIModalPresentationStyle.custom
    pvc.transitioningDelegate = self



    if !subtitleListArray.isEmpty{
      self.dummyarray.append(dummyList!)
      pvc.subtitleListArray = dummyarray + self.subtitleListArray
    }

    pvc.selectedRow = self.selectedIndex
    pvc.subtileOn = self
    self.present(pvc, animated: true, completion: nil)

  }
  func showSubtitle(urlString :String?,index: Int?) {
    print("url string",urlString)
    print("subtile show")
    self.subtitleUrl = urlString!
    self.subtitleIsOn = true
    self.selectedIndex = index!
    self.parseSubTitle(Url: self.subtitleUrl)

  }
  func hideSubtitle(index:Int?) {
    print("index")

    self.subtitleIsOn = false
    self.selectedIndex = index!

  }
  func parseSubTitle(Url: String){
    let urlString = Url
    ApiCommonClass.parseSrtFile(urlString: urlString) { (responseDictionary: Dictionary) in
      if let response = responseDictionary["data"] as? String{
        print(response)
        self.subtitleIsOn = true
        self.parsedPayload =  ApiCommonClass.parseSubRip(response)
      }
    }
  }
  @objc func hideview(){
    self.playPauseButton.isHidden = true
    self.fullScreenButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true
    self.durationLabel.isHidden = true
    self.startDurationLabel.isHidden = true
    self.forwardButton.isHidden = true
    self.backwardButton.isHidden = true
    if !subtitleListArray.isEmpty{
      self.subTitleButton.isHidden =  true
    }
    self.hidevideoController = true
  }
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    if !self.activityIndicatorView.isAnimating{
      if isAdPlayback {
        self.fullScreenButton.isHidden = true
      }else {
        if hidevideoController {
          if self.normalScreenButtonflag {
            //          self.volumeControlView.isHidden = false
          }
          self.playPauseButton.isHidden = false
          self.fullScreenButton.isHidden = false
          self.videoPlaybackSlider.isHidden = false
          self.durationLabel.isHidden = false
          self.startDurationLabel.isHidden = false
          self.hidevideoController = false
          if !subtitleListArray.isEmpty{
            self.subTitleButton.isHidden =  false
          }
          self.forwardButton.isHidden = false
          self.backwardButton.isHidden = false
          self.perform(#selector(hideview), with: nil, afterDelay: 2)
          //self.BackButton.isHidden = false
        } else {
          self.playPauseButton.isHidden = true
          self.fullScreenButton.isHidden = true
          self.videoPlaybackSlider.isHidden = true
          self.durationLabel.isHidden = true
          self.startDurationLabel.isHidden = true
          self.hidevideoController = true
          if self.normalScreenButtonflag {
            //          self.volumeControlView.isHidden = true
          }
          self.forwardButton.isHidden = true
          if !subtitleListArray.isEmpty{
            self.subTitleButton.isHidden =  true
          }
          self.backwardButton.isHidden = true
          //  self.BackButton.isHidden = true
        }
      }
    }
  }
  var isSlidding = false
  @objc func playbackSliderValueChanged() {
    self.isSlidding = true
    if let duration = avPlayer?.currentItem?.duration {
      let totalSeconds = CMTimeGetSeconds(duration)
      let value = Float64(videoPlaybackSlider.value) * totalSeconds
      let seekTime = CMTime(value: Int64(value), timescale: 1)
      avPlayer?.seek(to: seekTime)
    }
    if isPlaying {
      avPlayer?.play()
    } else {
      avPlayer?.pause()
    }

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

  func gotoFullScreen() {
    self.playPauseButton.isHidden = true
    self.fullScreenButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true
    self.durationLabel.isHidden = true
    self.startDurationLabel.isHidden = true
    self.forwardButton.isHidden = true
    self.backwardButton.isHidden = true
    self.fullScreenButton.setImage(UIImage(named: "icon_minimize"), for: .normal)
    //    self.volumeControlView.isHidden = false
    tabBarController?.tabBar.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
    self.normalScreenButtonflag = true
    self.YouMayAlsoLikeLabel.isHidden = true;   navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    let screenSize = UIScreen.main.bounds
    let screenHeight = screenSize.height
    let screenWidth = screenSize.width
    self.videoPlayerHeight = screenWidth
    AutoPlayingViewHeight.constant = screenWidth
    videoPlayingViewHeight.constant = screenWidth
    playerControlViewHeight?.constant = screenWidth
    self.videoPlayingView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight )
    self.playerControlsView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    self.AutoPlayingView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

    adDisplayContainer = IMAAdDisplayContainer(adContainer: videoPlayingView, companionSlots: nil)
    if  contentPlayerLayer == nil {
      contentPlayerLayer = AVPlayerLayer(player: avPlayer)
      contentPlayerLayer?.backgroundColor = UIColor.clear.cgColor
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      videoPlayingView.layer.addSublayer(contentPlayerLayer!)
    }else{
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect

  }
  func gotoNormalScreen() {
    self.playPauseButton.isHidden = true
    self.fullScreenButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true
    self.durationLabel.isHidden = true
    self.startDurationLabel.isHidden = true
    self.forwardButton.isHidden = true
    self.backwardButton.isHidden = true
    //    self.volumeControlView.isHidden = true
    self.YouMayAlsoLikeLabel.isHidden = false
    self.fullScreenButton.setImage(UIImage(named: "fullNormalButttton"), for: .normal)

    tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.isTranslucent = true
    self.normalScreenButtonflag = false
    navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
    let screenSize = UIScreen.main.bounds
    let screenWidth = screenSize.width

    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      videoPlayingViewHeight?.constant = 450
      playerControlViewHeight?.constant = 450
      AutoPlayingViewHeight?.constant = 450
      videoPlayerHeight = 450

    } else {
      videoPlayingViewHeight?.constant = 250
      playerControlViewHeight?.constant = 250
      AutoPlayingViewHeight?.constant = 250
      videoPlayerHeight = 250
    }
    self.videoPlayingView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: videoPlayingViewHeight.constant )
    self.playerControlsView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width  , height: videoPlayingViewHeight.constant )
    self.AutoPlayingView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width  , height: videoPlayingViewHeight.constant )
    if contentPlayerLayer != nil {
      contentPlayerLayer!.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width  , height: videoPlayingViewHeight.constant )
      contentPlayerLayer!.frame =  self.videoPlayingView.frame
      contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
    }


  }
  @objc func playPauseAction() {
    if !(Application.shared.CastSessionStart) {
      if isPlaying {
        avPlayer?.pause()
        self.VideoPauseEvent()
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
      } else {
        avPlayer?.play()
        self.VideoResumeEvent()
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
      }
      isPlaying = !isPlaying
    }
  }


  @IBAction func fullScreenAction(_ sender: UIButton) {
    var value = UIInterfaceOrientation.portrait.rawValue
    self.YouMayAlsoLikeLabel.isHidden = true
    //    self.volumeControlView.isHidden = true

    if(sender.isSelected) {

      sender.isSelected = false
      tabBarController?.tabBar.isHidden = false
      //      self.volumeControlView.isHidden = true
      self.navigationController?.navigationBar.isHidden = false
      self.normalScreenButtonflag = false
      self.navigationController?.navigationBar.isTranslucent = false
      navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
      if let delegate = UIApplication.shared.delegate as? AppDelegate {
        delegate.restrictRotation = .portrait
      }
      UIDevice.current.setValue(value, forKey: "orientation")
      videoPlayerHeight = 250
      videoPlayingViewHeight.constant = videoPlayerHeight
      playerControlViewHeight.constant = videoPlayerHeight
      AutoPlayingViewHeight.constant = videoPlayerHeight
      self.videoPlayingView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.videoPlayingViewHeight.constant )
      self.playerControlsView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: self.videoPlayingViewHeight.constant)
      self.AutoPlayingView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: self.videoPlayingViewHeight.constant)
      adDisplayContainer = IMAAdDisplayContainer(adContainer: videoPlayingView, companionSlots: nil)
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:videoPlayingViewHeight.constant )
      print("content player  frame", contentPlayerLayer?.frame)
      print("video player  frame", videoPlayingView?.frame)
      print("videoPlayingViewHeight ", videoPlayingViewHeight.constant)
      print("videoPlayerHeight ", videoPlayerHeight)
      print("playerControlViewHeight ", playerControlViewHeight)
    } else {
      //      self.volumeControlView.isHidden = true
      sender.isSelected = true
      tabBarController?.tabBar.isHidden = false
      //      self.volumeControlView.isHidden = true
      self.navigationController?.navigationBar.isHidden = false
      self.normalScreenButtonflag = false
      self.navigationController?.navigationBar.isTranslucent = false
      navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
      if let delegate = UIApplication.shared.delegate as? AppDelegate {
        delegate.restrictRotation = .landscapeRight
      }
      value = UIInterfaceOrientation.landscapeRight.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
      videoPlayerHeight = self.view.frame.size.height
      videoPlayingViewHeight.constant = self.view.frame.size.height
      videoPlayingViewHeight.constant = self.view.frame.size.height
      AutoPlayingViewHeight.constant = self.view.frame.size.height
      let screenSize = UIScreen.main.bounds
      let screenWidth = screenSize.width
      let screenHeight = screenSize.height
      self.videoPlayingView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight )
      self.playerControlsView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight )
      self.AutoPlayingView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight )
      print("content player  frame", contentPlayerLayer?.frame)
      print("video player  frame", videoPlayingView?.frame)
      print("videoPlayingViewHeight ", videoPlayingViewHeight.constant)
      print("videoPlayerHeight ", videoPlayerHeight)
      print("playerControlViewHeight ", playerControlViewHeight)
      adDisplayContainer = IMAAdDisplayContainer(adContainer: videoPlayingView, companionSlots: nil)
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight )
      contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
    }
  }

  func didClickDropDown(flag: Bool) {
    dropDownflag = flag
    self.moreVideosCollectionView.reloadData()
  }
  func didClickProducerName(producerName: String) {
    let videoPlayerController = storyboard!.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
    videoPlayerController.videoName = "ProducerName"
    videoPlayerController.ProducerName = self.video.producer!
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
  }

  func didClickTheme(ThemeId: String) {


  }
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let firstTouch = touches.first {
      let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
      view.isUserInteractionEnabled = true
      playerControlsView.isUserInteractionEnabled = true
      if hitView === playerControlsView {
      } else {
      }
    }
  }
  func setTabBarVisible(visible: Bool, animated: Bool) {

    if (isTabBarVisible == visible) { return }

    // get a frame calculation ready
    let frame = self.tabBarController?.tabBar.frame
    let height = frame?.size.height
    let offsetY = (visible ? -height! : height)

    // zero duration means no animation
    let duration: TimeInterval = (animated ? 0.3 : 0.0)

    //  animate the tabBar
    if frame != nil {
      UIView.animate(withDuration: duration) {
        self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
        return
      }
    }
  }

  var isTabBarVisible: Bool {
    return (self.tabBarController?.tabBar.frame.origin.y ?? 0) < self.view.frame.maxY
  }

  func hideMopPubRectBanner(){
    self.isPresentController = false
  }

  @objc func changeTitle() {
    if !videoPlayingeventValue {
      self.videoPlayingeventValue = true
    }
  }
  //  func startCounter(){
  //    self.countTimer = Timer.scheduledTimer(timeInterval: 10.0 ,
  //                                           target: self,
  //                                           selector: #selector(self.changeTitle),
  //                                           userInfo: nil,
  //                                           repeats: true)
  //  }


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




  // MARK: Api methods
  func startCounter(){
    print("startCounter")
    self.perform(#selector(getVideoAutoPlay), with: nil, afterDelay: 2)
  }
  @objc func getVideoAutoPlay(){
    print("getVideoAutoPlay")

    autoPlayVideomodel.removeAll()
    var parameterDict: [String: String?] = [ : ]
    parameterDict["vid"] = String(video.video_id!)

    ApiCommonClass.GetAutoPlayAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          self.isAdComplete = false

          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.autoPlayVideomodel.removeAll()
        self.autoPlayVideomodel = responseDictionary["data"] as! [VideoModel]
        if self.autoPlayVideomodel.count == 0 {
          DispatchQueue.main.async {
            self.isAdComplete = false

            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.isAdComplete = true

            self.autoPlayvideovideo = self.autoPlayVideomodel[0]


          }
        }
      }
    }
  }
  func getSimilarVideos() {
    videos.removeAll()
    var parameterDict: [String: String?] = [ : ]
    parameterDict["video_id"] = String(showId)
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
            self.moreVideosCollectionView.isHidden = true
            self.YouMayAlsoLikeLabel.isHidden = true
            self.moreVideosCollectionView.isHidden = true
            CustomProgressView.hideActivityIndicator()
            // self.noResultView.isHidden = false

            //            if self.video.premium_flag == 0 {
            //            self.bannerView.load(GADRequest())
            //            }
          }
        } else {
          DispatchQueue.main.async {
            // self.noResultView.isHidden = true
            self.YouMayAlsoLikeLabel.isHidden = false
            self.moreVideosCollectionView.dataSource = self
            self.moreVideosCollectionView.delegate = self
            self.moreVideosCollectionView.reloadData()

            if self.interstitial_status == 0 || self.mobpub_interstitial_status == 0 {
              CustomProgressView.hideActivityIndicator()
            }
            self.moreVideosCollectionView.isHidden = false
            //            if self.video.premium_flag == 0 {
            //            self.bannerView.load(GADRequest())
            //            }
          }
        }
      }
    }
  }


  // checking user have subcription or not
  // if true then function call to video subscription
  // if false call to subscription VC for choose price
  // alert popup if guest user login
  func collectionViewSelectedVideo(selectedVideoModel : VideoModel) {
    self.video = selectedVideoModel
    getSelectedVideo(indexpath: video.video_id!)
  }
  func getSelectedVideo(indexpath: Int) {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    videos.removeAll()
    self.dropDownflag = true
    var parameterDict: [String: String?] = [ : ]
    parameterDict["vid"] = String(indexpath)
    parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    ApiCommonClass.GetSelectedVideo(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          self.mainView.isHidden = true
          WarningDisplayViewController().noResultview(view : self.view,title: "No Video Found")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.videos.removeAll()
        self.videos = responseDictionary["data"] as! [VideoModel]
        if self.videos.count == 0 {
          DispatchQueue.main.async {
            self.mainView.isHidden = true
            WarningDisplayViewController().noResultview(view : self.view,title: "No Video Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.video = self.videos[0]
            if let subtitleListArray = self.videos[0].subtitles{
              self.subtitleListArray = subtitleListArray
              print("subtitles",subtitleListArray)
            }
            self.AutoPlayingView.isHidden = true
            Application.shared.selectedVideoModel = self.video
            self.playerControlsView.isHidden = false
            if self.video.premium_flag == 1 || self.video.payper_flag == 1 || self.video.rental_flag == 1 || self.video.free_video == true {
              if Application.shared.userSubscriptionStatus {
                self.getVideoSubscriptions(video_id: self.video.video_id!)
              } else {
                if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
                  DispatchQueue.main.async {
                      CustomProgressView.hideActivityIndicator()
                    if self.video.free_video!{
                      self.initialView()
                    }
                    else{
                      WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to \n Purchase this Subscription", message: "", actionTitles: ["Cancel","Login","Subscribe Now"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                          self.MoveTOLoginPage()
                          },{action3 in self.MoveTORegisterPage()},nil])
                    }
                  }
                }
                else{
                  self.checkForFreeVideo()
                  //                      self.isPresentController = false
                }
              }
            }
            else {
              CustomProgressView.hideActivityIndicator()
              if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
                DispatchQueue.main.async {
                    WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to \n Purchase this Subscription", message: "", actionTitles: ["Cancel","Login","Register"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                        self.MoveTOLoginPage()
                    },{action3 in self.MoveTORegisterPage()},nil])
                }
              }
              else{
                self.initialView()
              }
            }
          }
        }
      }
    }
  }
  // Function to check whether video is Free video or subscription
  func checkForFreeVideo(){
    if self.video.free_video! && (self.video.premium_flag == 1 || self.video.payper_flag == 1 || self.video.rental_flag == 1){
      print("alert popup")
      self.initialView()
    }
    else if self.video.free_video! && (self.video.premium_flag == 0 || self.video.payper_flag == 0 || self.video.rental_flag == 0){
      self.initialView()
    }
    else{
      CustomProgressView.hideActivityIndicator()
      self.getFreeUserSubscription()
    }
  }

  func LoginAction(){
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
    self.navigationController?.pushViewController(nextViewController, animated: false)

  }
  func getFreeUserSubscription(){
    let subscriptionController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
    subscriptionController.videoId  = self.video.video_id!
    subscriptionController.isFromVideoPlayingPage = true
    subscriptionController.subscriptionDelegate = self
    self.navigationController?.pushViewController(subscriptionController, animated: false)
  }

  func initialView(){
    self.isPresentController = true
    if fromNotification == true {
      self.didSelectNonPremiumVideo()

    } else {
      self.didSelectNonPremiumVideo()

    }
    //    self.volumeControlView.isHidden = true
    self.playPauseButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true
    self.durationLabel.isHidden = true
    self.forwardButton.isHidden = true
    self.subTitleButton.isHidden =  true
    self.backwardButton.isHidden = true
    self.startDurationLabel.isHidden = true
    self.fullScreenButton.isHidden = true
    fullScreenValue = 0
    self.mainView.isHidden = false
  }
  func didSelectNonPremiumVideo() {
    CustomProgressView.hideActivityIndicator()
    ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
      DispatchQueue.main.async {
        if let val = responseDictionary["error"] {
          WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
        } else {
          self.token = responseDictionary["Channels"] as! String
          if Application.shared.userSubscriptionStatus{
            if self.subscribedUser{
              self.videoPlayFlag = true
              self.setupPopupForContinueWatching()
            }
            else{
              self.videoPlayFlag = false
              self.setupPopupForContinueWatching()
            }

          }
          else{
            self.videoPlayFlag = false
            self.setupPopupForContinueWatching()
          }

        }
      }
    }
  }

  @objc func  playVideoWithoutAd(){
    self.setUpInitial()
    self.setUpContentPlayer()
    print("playVideoWithoutAd")
  }
  @objc func  setupPlayerView(){
    self.setUpInitial()
    self.setUpContentPlayer()
    self.setUpAdsLoader()
    self.requestAds()
    self.replaceMacros()
    print("setupPlayerView")

  }

  func cancelAlertAction(){
    self.navigationController?.popViewController(animated: false)
    //        self.navigationController?.popToRootViewController(animated: false) // return to home
  }
  func MoveTOLoginPage() {
    let loginController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController // move to login page from guest user                                                                                                                       login
    loginController.guestUserDelegate = self
    loginController.guestUserLogedIn = true
    loginController.backDelegate = self

    self.present(loginController, animated: true, completion: nil)
  }
  func MoveTORegisterPage() {
    self.getFreeUserSubscription()
//    let registerController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
    // move to register page after                                                                                                                               guest user login
//    registerController.isFromSubscriptionPage = true
//    registerController.backDelegate = self
//    self.present(registerController, animated: true, completion: nil)
  }
  func notificationSelectedVideo(selectedVideoId : Int,premium_flag : Int) {
    self.videoNotificationId = selectedVideoId
    if premium_flag == 1 {
      if Application.shared.userSubscriptionStatus {
        self.getVideoSubscriptions(video_id: selectedVideoId)
      } else {
        isPresentController = false
        CustomProgressView.hideActivityIndicator()
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
        watchListController.videoId  = selectedVideoId
        watchListController.isFromVideoPlayingPage = true
        watchListController.subscriptionDelegate = self
        self.navigationController?.pushViewController(watchListController, animated: false)
        //self.present(watchListController, animated: true, completion: nil)
      }
    } else {
      CustomProgressView.hideActivityIndicator()
      self.initialView()
    }
  }

  func GenerateToken(flag : Bool) {
    ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
      DispatchQueue.main.async {
        if let val = responseDictionary["error"] {
          WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
        } else {
          self.token = responseDictionary["Channels"] as! String
          // self.metadata.setString(self.token, forKey: )
          //  metadata.setString(self.video.video_title!, forKey: kGCKMetadataKeyTitle)
          if ((self.interstitial_status == 0) || (flag == true )) {
            self.setUpContentPlayer()
            self.setUpAdsLoader()
            self.requestAds()
          }
        }
      }
    }
  }

  func updateWatchList() {

    var parameterDict: [String: String?] = [ : ]
    parameterDict["video_id"] = String(videoId)
    parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["device_type"] = "ios-phone"
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    ApiCommonClass.updateWatchList(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async { }
      } else { }
    }
  }

  @objc func contentDidFinishPlaying(_ notification: Notification) {
    if (notification.object as! AVPlayerItem) == avPlayer?.currentItem {
      if adsLoader != nil {
        adsLoader.contentComplete()
      }
    }
  }
  // function to check whether the user subcribe the video or not
  //if true  then play video  (call itself)
  // if false then go to subscription  VC then return to videplaying VC through delegate
  // common checking to both user and guest user
  func getVideoSubscriptions(video_id: Int){
    var parameterDict: [String: String?] = [ : ]
    parameterDict["vid"] = String(video_id)
    parameterDict["uid"] = UserDefaults.standard.string(forKey:"user_id")!
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    ApiCommonClass.getvideoSubscriptions(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
          let delegate = UIApplication.shared.delegate as? AppDelegate
          delegate!.loadTabbar()
        }
      } else {
        DispatchQueue.main.async {
          if let videos = responseDictionary["Channels"] as? [VideoSubscriptionModel] {
            if videos.count == 0 {
              if Application.shared.userSubscriptionStatus{
                let subscriptionModel = Application.shared.userSubscriptionsArray
                for subscriptionModel in subscriptionModel {
                  let subscriptionid = subscriptionModel.subscription_type_id
                  if (subscriptionid == 3 || subscriptionid == 4 ) {
                    self.subscribedUser = true
                    break
                  } else {
                    self.subscribedUser = false
                  }
                }
                self.checkForFreeVideo()
              }
              else{
                self.checkForFreeVideo()
              }

            } else {
              CustomProgressView.hideActivityIndicator()

              let subscriptionModel = Application.shared.userSubscriptionsArray
              for subscriptionModel in subscriptionModel {
                let subscriptionid = subscriptionModel.sub_id
                if  (videos.contains(where: {$0.subscription_id == subscriptionid})) {
                  self.subscribedUser = true
                  break
                } else {
                  self.subscribedUser = false
                }
              }
              if self.subscribedUser {
                self.didPurchaseSubscription()
              } else {
                self.checkForFreeVideo()

              }
            }
          }
        }
      }
    }
  }
  // play video after checking the subscription
  // function initialView()
  func didPurchaseSubscription() {
    self.subscribedUser = true
    ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
      DispatchQueue.main.async {
        if let val = responseDictionary["error"] {
          WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
        } else {
          self.token = responseDictionary["Channels"] as! String
          self.initialView()
        }
      }
    }
  }
  //
  //  func didSelectNonPremiumVideo() {
  //    ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
  //      DispatchQueue.main.async {
  //        if let val = responseDictionary["error"] {
  //          WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
  //        } else {
  //          self.token = responseDictionary["Channels"] as! String
  ////            self.setupPlayerView()
  //            // continue watching implementation
  //            if self.fromContinueWatching {
  //                self.continueWatchingView.isHidden = false
  //                self.popupView.isHidden = false
  //            }
  //            else{
  //                self.continueWatchingView.isHidden = true
  //                self.popupView.isHidden = true
  //                self.setupPlayerView()
  //            }
  //        }
  //      }
  //    }
  //  }
  func setupPopupForContinueWatching(){
    if self.fromContinueWatching {
      self.continueWatchingView.isHidden = false
      self.popupView.isHidden = false
    }
    else{
      self.continueWatchingView.isHidden = true
      self.popupView.isHidden = true

      if self.videoPlayFlag{
        self.playVideoWithoutAd()
      }
      else{
        self.setupPlayerView()
      }
    }
  }
  @IBAction func continueAction(_ sender: Any) {
    self.fromContinueWatching = true
    self.continueWatchingView.isHidden = true
    self.popupView.isHidden = true
    if self.videoPlayFlag{
      self.playVideoWithoutAd()
    }
    else{
      self.setupPlayerView()
    }
  }
  @IBAction func playAction(_ sender: Any) {
    self.fromContinueWatching = false
    self.continueWatchingView.isHidden = true
    self.popupView.isHidden = true
    if self.videoPlayFlag{
      self.playVideoWithoutAd()
    }
    else{
      self.setupPlayerView()
    }
  }
  @IBAction func closeButtonAction(_ sender: Any) {
    self.fromContinueWatching = false
    self.continueWatchingView.isHidden = true
    self.popupView.isHidden = true
    if self.videoPlayFlag{
      self.playVideoWithoutAd()
    }
    else{
      self.setupPlayerView()
    }
  }

  @objc func  playVideoAfterSubscription(){
    ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
      DispatchQueue.main.async {
        if let val = responseDictionary["error"] {
          WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
        } else {
          self.token = responseDictionary["Channels"] as! String
          print("playVideoAfterSubscription")
          if self.fromContinueWatching {
            self.continueWatchingView.isHidden = false
            self.popupView.isHidden = false

          }
          else{
            self.continueWatchingView.isHidden = true
            self.popupView.isHidden = true

            self.setupPlayerView()
          }
          //                    self.setupPlayerView()
        }
      }
    }
  }
  @objc func playVideo(){
    self.setUpInitial()
    self.setUpContentPlayer()
    self.setUpAdsLoader()
    self.requestAds()
    self.replaceMacros()
  }

  func videoStartEvent() {
    print("POP02")
    var parameterDict: [String: String?] = [ : ]
    let currentDate = Int(Date().timeIntervalSince1970)
    parameterDict["timestamp"] = String(currentDate)
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    if let device_id = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = device_id
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["event_type"] = "POP02"
    if let app_id = UserDefaults.standard.string(forKey: "application_id") {
      parameterDict["app_id"] = app_id
    }
    if let videoName = self.video.video_title {
      parameterDict["video_title"] = videoName
    }
    if let video_id = self.video.video_id {
      parameterDict["video_id"] = String(video_id)
    }
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }
    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
    parameterDict["category"] = self.categoryList
    ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
        }
      } else {
        DispatchQueue.main.async {

        }
      }
    }
    self.startCounter()
  }
  func videoPlayingEvent() {
    print("POP03")
    var parameterDict: [String: String?] = [ : ]
    let currentDate = Int(Date().timeIntervalSince1970)
    parameterDict["timestamp"] = String(currentDate)
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    if let device_id = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = device_id
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

    parameterDict["event_type"] = "POP03"
    if let app_id = UserDefaults.standard.string(forKey: "application_id") {
      parameterDict["app_id"] = app_id
    }
    if let videoName = self.video.video_title {
      parameterDict["video_title"] = videoName
    }
    if let video_id = self.video.video_id {
      parameterDict["video_id"] = String(video_id)
    }
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }

    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
    parameterDict["category"] = self.categoryList
    if let video_time = avPlayer?.currentTime().seconds {
      let time = Int(video_time)
      parameterDict["video_time"] = String(time)
      print("time",time)
    }
    print("pop03",parameterDict)

    ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
        }
      } else {
        DispatchQueue.main.async {
        }
      }
    }
  }
  func VideoPauseEvent() {
    print("POP04")
    var parameterDict: [String: String?] = [ : ]
    let currentDate = Int(Date().timeIntervalSince1970)
    parameterDict["timestamp"] = String(currentDate)
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    if let device_id = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = device_id
    }
    parameterDict["event_type"] = "POP04"
    if let app_id = UserDefaults.standard.string(forKey: "application_id") {
      parameterDict["app_id"] = app_id
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

    if let videoName = self.video.video_title {
      parameterDict["video_title"] = videoName
    }
    if let video_id = self.video.video_id {
      parameterDict["video_id"] = String(video_id)
    }
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }
    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
    parameterDict["category"] = self.categoryList
    if let video_time = avPlayer?.currentTime().seconds {
      let time = Int(video_time)
      parameterDict["video_time"] = String(time)
      print("time",time)
    }
    print("pop04",parameterDict)
    ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
        }
      } else {
        DispatchQueue.main.async {
        }
      }
    }
  }
  func VideoResumeEvent() {
    print("POP09")
    var parameterDict: [String: String?] = [ : ]
    let currentDate = Int(Date().timeIntervalSince1970)
    parameterDict["timestamp"] = String(currentDate)
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    if let device_id = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = device_id
    }
    parameterDict["event_type"] = "POP09"
    if let app_id = UserDefaults.standard.string(forKey: "application_id") {
      parameterDict["app_id"] = app_id
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

    if let videoName = self.video.video_title {
      parameterDict["video_title"] = videoName
    }
    if let video_id = self.video.video_id {
      parameterDict["video_id"] = String(video_id)
    }
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }
    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
    parameterDict["category"] = self.categoryList
    if let video_time = avPlayer?.currentTime().seconds {
      let time = Int(video_time)
      parameterDict["video_time"] = String(time)
      print("time",time)
    }
    print("pop09",parameterDict)
    ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
        }
      } else {
        DispatchQueue.main.async {
        }
      }
    }
  }
  func VideoEndEvent() {
    var parameterDict: [String: String?] = [ : ]
    let currentDate = Int(Date().timeIntervalSince1970)
    parameterDict["timestamp"] = String(currentDate)
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    if let device_id = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = device_id
    }
    parameterDict["event_type"] = "POP05"
    if let app_id = UserDefaults.standard.string(forKey: "application_id") {
      parameterDict["app_id"] = app_id
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

    if let videoName = self.video.video_title {
      parameterDict["video_title"] = videoName
    }
    if let video_id = self.video.video_id {
      parameterDict["video_id"] = String(video_id)
    }
    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
    parameterDict["category"] = self.categoryList
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }
    if let video_time = avPlayer?.currentTime().seconds {
      let time = Int(video_time)
      parameterDict["video_time"] = String(time)
      print("time",time)
    }
    print("pop05",parameterDict)
    ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
        }
      } else {
        DispatchQueue.main.async {
        }
      }
    }
  }

  func videoPlayingError(error_code:String?,error_message:String?) {
    var parameterDict: [String: String?] = [ : ]
    let currentDate = Int(Date().timeIntervalSince1970)
    parameterDict["timestamp"] = String(currentDate)
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    if let device_id = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = device_id
    }
    parameterDict["event_type"] = "POP08"
    if let app_id = UserDefaults.standard.string(forKey: "application_id") {
      parameterDict["app_id"] = app_id
    }
    if let videoName = self.video.video_title {
      parameterDict["video_title"] = videoName
    }
    if let video_id = self.video.video_id {
      parameterDict["video_id"] = String(video_id)
    }
    if let error_code = error_code {
      parameterDict["error_code"] = error_code
    }
    if let error_message = error_message {
      parameterDict["error_message"] = error_message
    }
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
    parameterDict["category"] = self.categoryList
    print("param pop08",parameterDict)
    ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
        }
      } else {
        DispatchQueue.main.async {
        }
      }
    }
  }

  @objc func playerDidFinish() {
    print("Video Finished")
    self.VideoEndEvent()
    if isAdComplete == false{


    }
    else{
      print("isAdComplete",isAdComplete)
      self.playerControlsView.isHidden = true
      self.AutoPlayingView.isHidden = false
      if autoPlayvideovideo.thumbnail != nil{
        self.autoPlayImageView.sd_setImage(with: URL(string: imageUrl + autoPlayvideovideo.thumbnail!),placeholderImage:UIImage(named: "landscape_placeholder"))
      }
      else{
        self.autoPlayImageView.image = UIImage(named: "landscape_placeholder")
      }
      if autoPlayvideovideo.video_title != nil{

        self.upNextLabel.text = autoPlayvideovideo.video_title


      }
      self.perform(#selector(playAutoVideo), with: nil, afterDelay: 6)



    }

  }
  @objc func playAutoVideo(){
    self.watchUpdateFlag = false

    self.getSelectedVideo(indexpath: self.autoPlayvideovideo.video_id!)
  }
  @objc func playerDidFinishPlaying(note: NSNotification) {
    print("Video Finished")
    self.VideoEndEvent()
  }
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  // MARK: - IMAAdsLoaderDelegate

  func setUpAdsLoader() {
    adsLoader = IMAAdsLoader(settings: nil)
    adsLoader.delegate = self
  }

  func requestAds() {
    // Create ad display container for ad rendering.
    adDisplayContainer = IMAAdDisplayContainer(adContainer: videoPlayingView, companionSlots: nil)
    // Create an ad request with our ad tag, display container, and optional user context.
    let request = IMAAdsRequest(
      adTagUrl: addLink,
      adDisplayContainer: adDisplayContainer,
      contentPlayhead: contentPlayhead,
      userContext: nil)
    adsLoader.requestAds(with: request)
  }

  func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    adsManager = adsLoadedData.adsManager
    adsManager.delegate = self
    // Create ads rendering settings and tell the SDK to use the in-app browser.
    let adsRenderingSettings = IMAAdsRenderingSettings()
    //adsRenderingSettings.uiElements = [IMAUiElementType.elements_AD_ATTRIBUTION]
    adsRenderingSettings.webOpenerPresentingController = self
    // Initialize the ads manager.
    adsManager.initialize(with: adsRenderingSettings)
    var positionsArray = [Float]()
    adsManager.adCuePoints.forEach { point in
      let percentageAdBreak = ((point as! Double) / videoDuration) * 100
      positionsArray.append(Float(percentageAdBreak))
    }
    self.videoPlaybackSlider.markColor = UIColor.yellow
    self.videoPlaybackSlider.markWidth = 2.0
    self.videoPlaybackSlider.markPositions = positionsArray
    self.videoPlaybackSlider.reDraw()

  }

  func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
    self.isAdPlayback = false
    self.playPauseButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true
    self.durationLabel.isHidden = true
    self.startDurationLabel.isHidden = true
    self.forwardButton.isHidden = true
    self.subTitleButton.isHidden =  true
    self.backwardButton.isHidden = true
    self.videoPlayingError(error_code: String(format: "%d", adErrorData.adError.code.rawValue), error_message: String(format: "%@", adErrorData.adError.message))
    let topController = UIApplication.topViewController()
    let top = topController as! UIViewController
    let vc = VideoPlayingViewController()
    if top is VideoPlayingViewController {
      print("topcontroller5",topController)
      self.avPlayer?.play()
      //do something if it's an instance of that class
    }
    else{
      print("topcontroller error",topController)
      self.avPlayer?.pause()
    }
  }

  // MARK: - IMAAdsManagerDelegate

  func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {

    print("AdsManager playback \(isAdPlayback)")
    print("AdsManager event \(event.typeString!)")
    if event.type == IMAAdEventType.LOADED {
      // When the SDK notifies us that ads have been loaded, play them.
      self.playPauseButton.isHidden = true
      self.videoPlaybackSlider.isHidden = true
      self.durationLabel.isHidden = true
      self.startDurationLabel.isHidden = true
      self.forwardButton.isHidden = true
      self.subTitleButton.isHidden =  true
      self.backwardButton.isHidden = true
      self.activityIndicatorView.stopAnimating()
      let topController = UIApplication.topViewController()
      let top = topController as! UIViewController
      let vc = VideoPlayingViewController()
      if top is VideoPlayingViewController {
        print("topcontroller5",topController)
        adsManager.start()
        //do something if it's an instance of that class
      }
      else{
        print("topcontroller error",topController)
        self.avPlayer?.pause()
        adsManager.pause()
      }

      //self.fullScreenButton.isHidden = true
    }
    if event.type == IMAAdEventType.STARTED{
      print("AdsManager event \(event.typeString!)")

    }
    if event.type == IMAAdEventType.COMPLETE {
      print("AdsManager event \(event.typeString!)")
      self.playPauseButton.isHidden = true
      self.videoPlaybackSlider.isHidden = true
      self.durationLabel.isHidden = true
      self.startDurationLabel.isHidden = true
      self.fullScreenButton.isHidden = true
      self.forwardButton.isHidden = true
      self.subTitleButton.isHidden =  true
      self.backwardButton.isHidden = true
      let topController = UIApplication.topViewController()
      let top = topController as! UIViewController
      let vc = VideoPlayingViewController()
      if top is VideoPlayingViewController {
        print("topcontroller5",topController)
        //do something if it's an instance of that class
      }
      else{
        print("topcontroller error",topController)
        self.avPlayer?.pause()
      }
      //      self.avPlayer?.play()
    }
    if event.type == IMAAdEventType.ALL_ADS_COMPLETED {
      print("AdsManager event \(event.typeString!)")
      self.playPauseButton.isHidden = true
      self.videoPlaybackSlider.isHidden = true
      self.durationLabel.isHidden = true
      self.startDurationLabel.isHidden = true
      self.forwardButton.isHidden = true
      self.subTitleButton.isHidden =  true
      self.backwardButton.isHidden = true
      self.fullScreenButton.isHidden = true
      let topController = UIApplication.topViewController()
      let top = topController as! UIViewController
      let vc = VideoPlayingViewController()
      if top is VideoPlayingViewController {
        print("topcontroller5",topController)
        //do something if it's an instance of that class
      }
      else{
        print("topcontroller error",topController)
        self.avPlayer?.pause()
      }
    }
  }
  func adsManager(_ adsManager: IMAAdsManager!, adDidProgressToTime mediaTime: TimeInterval, totalTime: TimeInterval) {
    print("add progress")
  }
  func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
    print("AdsManager Error \(error.type)")
    print("AdsManager Error \(error.code)")
    print("AdsManager Error \(error.debugDescription)")
    print("AdsManager Error \(error.hashValue)")
    print("AdsManager Error \(String(describing: error.message))")
    self.videoPlayingError(error_code: String(describing:error.code.rawValue), error_message: (String(describing: error.message)))
    self.isAdPlayback = false
    self.playPauseButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true
    self.durationLabel.isHidden = true
    self.startDurationLabel.isHidden = true
    self.subTitleButton.isHidden =  true
    self.forwardButton.isHidden = true
    self.backwardButton.isHidden = true
    let topController = UIApplication.topViewController()
    let top = topController as! UIViewController
    let vc = VideoPlayingViewController()
    if top is VideoPlayingViewController {
      print("topcontroller5",topController)
      self.avPlayer?.play()
      //do something if it's an instance of that class
    }
    else{
      print("topcontroller error",topController)
      self.avPlayer?.pause()
    }
  }
  func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
    self.isAdPlayback = true
    print("content pause")
    self.playPauseButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true
    self.durationLabel.isHidden = true
    self.startDurationLabel.isHidden = true
    self.forwardButton.isHidden = true
    self.subTitleButton.isHidden =  true
    self.backwardButton.isHidden = true
    self.avPlayer?.pause()
    self.VideoPauseEvent()

  }
  func adsManagerAdDidStartBuffering(_ adsManager: IMAAdsManager!) {
    print("Buffering")
  }
  func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
    print("content resume")
    // The SDK is done playing ads (at least for now), so resume the content.
    self.isAdPlayback = false
    self.playPauseButton.isHidden = true
    self.videoPlaybackSlider.isHidden = true
    self.durationLabel.isHidden = true
    self.startDurationLabel.isHidden = true
    self.forwardButton.isHidden = true
    self.subTitleButton.isHidden =  true
    self.backwardButton.isHidden = true
    let topController = UIApplication.topViewController()
    let top = topController as! UIViewController
    let vc = VideoPlayingViewController()

    if top is VideoPlayingViewController {
      print("topcontroller5",topController)

      self.avPlayer?.play()
      self.VideoResumeEvent()
      //do something if it's an instance of that class
    }
    else{
      print("topcontroller error",topController)
      self.avPlayer?.pause()
    }
  }

  // MARK: - GCKRequestDelegate

  func requestDidComplete(_ request: GCKRequest) {
    print("request \(Int(request.requestID)) completed")
  }

  func request(_ request: GCKRequest,
               didFailWithError error: GCKError) {
    print("request \(Int(request.requestID)) didFailWithError \(error)")
  }

  func request(_ request: GCKRequest,
               didAbortWith abortReason: GCKRequestAbortReason) {
    print("request \(Int(request.requestID)) didAbortWith reason \(abortReason)")
  }

  // MARK: GCKRemoteMediaClientListener
  func sessionManager(_: GCKSessionManager,
                      didStart session: GCKCastSession) {
    print("sessionManager didStartSession: \(session)")

    // Add GCKRemoteMediaClientListener.
    Application.shared.CastSessionStart = true
    //        self.castvideoUrl = self.videoName
    print("casting video start session",self.videoName)
    switchToRemotePlayback()

    avPlayer?.pause()
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
  }

  func sessionManager(_: GCKSessionManager,
                      didResumeSession session: GCKSession) {
    print("sessionManager didResumeSession: \(session)")

    Application.shared.CastSessionStart = true
    // Add GCKRemoteMediaClientListener.
    session.remoteMediaClient?.add(self)
    switchToRemotePlayback()
    avPlayer?.play()
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
  }

  func sessionManager(_: GCKSessionManager,
                      didEnd session: GCKSession,
                      withError error: Error?) {
    print("sessionManager didEndSession: \(session)")

    // Remove GCKRemoteMediaClientListener.
    print("casting video end session",self.videoName)
    Application.shared.CastSessionStart = false
    avPlayer?.play()
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
  }

  func sessionManager(_: GCKSessionManager,
                      didFailToStart session: GCKSession,
                      withError error: Error) {
    print("sessionManager didFailToStartSessionWithError: \(session) error: \(error)")
    session.remoteMediaClient?.remove(self)
    Application.shared.CastSessionStart = false
    avPlayer?.play()
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
  }

  func  switchToRemotePlayback() {
    let jsonObject: [String: Any] = [
      "token": self.token
    ]
    GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()

    //let videoName = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
    if self.videoName != "" {
      let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: URL(string: self.videoName)!)
      print("currentlyCastingVideo",self.videoName)

      mediaInfoBuilder.streamType = GCKMediaStreamType.none
      mediaInfoBuilder.contentType = "application/x-mpegurl"
      mediaInfoBuilder.metadata = metadata
      mediaInfoBuilder.streamDuration = TimeInterval(videoDuration)
      mediaInfoBuilder.customData = jsonObject
      mediaInformation = mediaInfoBuilder.build()
      let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
      mediaLoadRequestDataBuilder.mediaInformation = mediaInformation
      if let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(with: mediaLoadRequestDataBuilder.build()) {
        print("inner switch")

        request.delegate = self
      }
    }
    Application.shared.CastSessionStart = false
    sessionManager.currentCastSession?.remoteMediaClient?.add(self)

    self.avPlayer?.pause()
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)

  }

  func sendMessage(_ message: String?) {
    print("Sending message: \(message ?? "")")
    messageChannel?.sendTextMessage(message!, error: nil)
  }

  func castChannel(_ channel: CastMessageChannel?, didReceiveMessage message: String?) {
    print("print")
  }
  func formatMinuteSeconds(_ totalSeconds: Double) -> String {
    let secondsString = String(format: "%02d", Int(totalSeconds .truncatingRemainder(dividingBy: 60)))
    let minutesString = String(format: "%02d", Int(totalSeconds / 60))
    return "\(minutesString):\(secondsString)"
  }
  @objc func tapFunction(sender:UITapGestureRecognizer) {
    self.didClickProducerName(producerName:  self.video.producer!)
  }
  @objc func castDeviceDidChange(notification _: Notification) {
    if GCKCastContext.sharedInstance().castState != GCKCastState.noDevicesAvailable {
      // Display the instructions for how to use Google Cast on the first app use.
      GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce(with: castButton)
    }
  }

}

extension VideoPlayingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  // MARK: Collectionview
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videos.count
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5.0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
    if videos[indexPath.row].logo != nil{
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
    if videos[indexPath.row].premium_flag == 0 {
      cell.premiumImage.isHidden = true
      cell.premiumImage.backgroundColor = ThemeManager.currentTheme().UIImageColor
    } else {
      cell.premiumImage.isHidden = true
    }
    cell.videoName.isHidden = false
    if videos[indexPath.row].video_flag != nil {
      if videos[indexPath.row].video_flag == 1 {
        cell.PartNumber.isHidden = false
      } else {
        cell.PartNumber.isHidden = true
      }
    } else {
      cell.PartNumber.isHidden = true
    }
    cell.liveLabel.isHidden = true
    cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
    return cell
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {

    var height = CGFloat()
    let width = (self.view.frame.size.width) / 2 - 10//some width
    height = (9 * width) / 16
    return CGSize(width: width, height: height + 30);
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let token = observer {
      self.avPlayer?.removeTimeObserver(token)
      observer = nil
    }
    self.contentPlayerLayer?.removeFromSuperlayer()
    self.playerControlsView.isHidden = true
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PausePlayer"), object: nil)
    DispatchQueue.main.async {
      self.contentPlayerLayer?.backgroundColor = UIColor.black.cgColor
      self.avPlayer?.isMuted = true
      self.avPlayer?.isMuted = true
      if self.adsManager != nil {
        self.adsManager?.destroy()
      }
      if self.avPlayer != nil {
        print("av player not nil")
      }
      if self.countTimer != nil {
        self.countTimer.invalidate()
      }
      self.avPlayer = nil
      self.avPlayer?.pause()
      self.moreVideosCollectionView.isHidden = true
      self.watchUpdateFlag = false
      let video = self.videos[indexPath.row]
      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
      viewController.categoryModel = video
      viewController.fromVideoPlaying = true
      self.navigationController?.pushViewController(viewController, animated: false)
    }
  }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
  return input.rawValue
}

extension Notification.Name {
  static let myNotification = Notification.Name("postNotifi")
}

extension VideoPlayingViewController : UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return bottomViewPresentationController(presentedViewController: presented, presenting: presenting)
  }
}

class bottomViewPresentationController : UIPresentationController {
  override var frameOfPresentedViewInContainerView: CGRect {
    get {
      guard let theView = containerView else {
        return CGRect.zero
      }

      return CGRect(x: 0, y: theView.bounds.height - theView.bounds.height/3, width: theView.bounds.width, height:theView.bounds.height/3 )
    }
  }
}


//    @objc func  playVideoAfterSubscription(){
//
//    self.setupPlayerView()
//
//    if self.fromContinueWatching {
//        self.continuwWatchingPopupView.isHidden = false
//    }else{
//        self.continuwWatchingPopupView.isHidden = true
//        self.playVideo()
//    }
//  }
