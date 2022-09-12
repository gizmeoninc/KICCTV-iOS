//
//  ChannelVideoViewController.swift
//  PoppoTv
//
//  Created by Firoze Moosakutty on 26/04/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//
import UIKit
import AVFoundation
import AVKit
import GoogleInteractiveMediaAds
import SummerSlider
import SDWebImage
import Reachability
import SideMenu
import GoogleCast
import MarqueeLabel
import GoSwiftyM3U8
class ChannelVideoViewController: UIViewController, SubscriptionDelegate,GCKSessionManagerListener, GCKRemoteMediaClientListener, GCKRequestDelegate,CastMessageChannelDelegate {

  // MARK: -Outlets
    @IBOutlet weak var videoTitle: UILabel!{
        didSet{
            self.videoTitle.isHidden = true
            self.videoTitle.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {

             self.videoTitle.font = UIFont.init(name: "Poppins-SemiBold", size: 16)
            } else {
             
            }
        }

        }
    
    @IBOutlet weak var videoTitleWidth: NSLayoutConstraint!
    @IBOutlet weak var fullScreenBottomHeight: NSLayoutConstraint!
  @IBOutlet weak var contentView: UIView!{
    didSet{
      self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
  }
  @IBOutlet weak var videoView: UIView!{
    didSet{
      self.videoView.backgroundColor = UIColor.black
    }
  }
  @IBOutlet weak var noResultView: UIView!{
    didSet {
      self.noResultView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.noResultView.isHidden = true
    }
  }
  @IBOutlet weak var fullScreenButton: UIButton!{
    didSet{
      self.fullScreenButton.isHidden = true
    }
  }
        
    
    @IBOutlet weak var channelCollectionviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var YouMayLikeLabel: UILabel!{
        didSet{
          self.YouMayLikeLabel.isHidden = true
        }

    }
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
  @IBOutlet weak var channelCollectionView: UICollectionView!{
    didSet{
      self.channelCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.channelCollectionView.isHidden = true
    }
  }
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!{
    didSet {
      self.activityIndicatorView.color = ThemeManager.currentTheme().UIImageColor
      self.activityIndicatorView.isHidden = true
    }
  }

  @IBOutlet weak var liveLabel: UILabel!{
    didSet {
      self.liveLabel.layer.cornerRadius = 5
      self.liveLabel.clipsToBounds = true
        self.liveLabel.isHidden = true
    }
  }

  @IBOutlet weak var playPauseButton: UIButton!{
    didSet{
      self.playPauseButton.isHidden = true
    }
  }


  @IBOutlet weak var ChannelNameLabel: MarqueeLabel!{
    didSet{
      self.ChannelNameLabel.isHidden = true
    }
  }

  @IBOutlet weak var volumeControlView: UIView!{
    didSet{
      volumeControlView.layer.cornerRadius = 5.0
      volumeControlView.layer.borderWidth = 0.5
      volumeControlView.clipsToBounds = true
      volumeControlView.isHidden = true
    }
  }
  @IBOutlet weak var errorMessageLabel: UILabel!
  // MARK: Property declaration
  var featuredVideos = [LiveGuideModel]()
  var videos = [VideoModel]()
  var channelVideosArray = [VideoModel]()
  var Videos = [VideoModel]()
  let playerViewController = AVPlayerViewController()
  var avPlayer: AVPlayer? = AVPlayer()
  var contentPlayerLayer: AVPlayerLayer?
  var observer: Any!
  var video: VideoModel!
  var channelVideo: VideoModel!
  var contentPlayhead: IMAAVPlayerContentPlayhead?
  var adsLoader: IMAAdsLoader!
  var adsManager: IMAAdsManager!
  var companionSlot: IMACompanionAdSlot?
  var isAdPlayback = false
  var isLandscape = false
  var channelVideoLink = ""
  var hidevideoController = true
  var addLink = ""
  var videoId = ""
  var channelId: Int?
  var token = ""
  var channelName = ""
  var channelStartTime = ""
  var videoDuration = Int()
  var videoPlayerWidth = Int()
  var videoPlayerHeight = Int()
  let playerItem: AVPlayerItem? = nil
  var videoHeight = CGFloat()
  var adPositionsArray = Array<Float>()
  var reachability = Reachability()!
  var fromNotification = Bool()
  var channelNotificationId = Int()
  var interstitial_status = Int()
  var mobpub_interstitial_status = Int()
  var rewarded_status = Int()
  var isPresentController = true
  var subscribedUser = false
  var premium_flag = Int()
  var isbackActionPerformed = false
  var watchUpdateFlag = false
  var isPlaying = true
  var playingVideoTitle = [String]()
  var countTimer:Timer!
  var counter = 10
  var adDisplayContainer:IMAAdDisplayContainer?
  var rotationAngle : CGFloat!
  var liveShowRow = Int()
  var liveShowUpdated = false
  var startTime = Date()
  var endTime = Date()
  var timeStart = String()
  var timeEnd = String()
  private var castButton: GCKUICastButton!
  private var mediaInformation: GCKMediaInformation?
  private var sessionManager: GCKSessionManager!
  let metadata = GCKMediaMetadata()
  var messageChannel: CastMessageChannel?

    @IBOutlet weak var HeaderLabel: UILabel!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                HeaderLabel.font = UIFont.init(name: "Helvetica-Bold", size: 25)
            } else {
                HeaderLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
            }
          self.HeaderLabel.isHidden = true
            self.HeaderLabel.textColor = ThemeManager.currentTheme().UIImageColor
        }
    }
    
    @IBOutlet weak var videoNameLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black
    self.navigationTitle()
    self.castButtonSetup()
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      self.videoHeight = 500
      self.videoViewHeight?.constant =  500
        let width =  (UIScreen.main.bounds.width / 3 )
        let height = ( 3 * width ) / 2
        self.channelCollectionviewHeight.constant = height
        self.videoTitleWidth.constant = 250
    } else {
      self.videoViewHeight?.constant = 250
      self.videoHeight = 250
        self.channelCollectionviewHeight.constant = 240
        self.videoTitleWidth.constant = 150

    }
    

    channelCollectionView.register(UINib(nibName: "LiveGuideCollelctionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveGuideCollectionCell")
    channelCollectionView.register(UINib(nibName: "channelHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "channelHeader")
    self.collectionViewSelectedVideo()
    self.volumeControlView.isHidden = true
    Application.shared.isVideoPlaying = true
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    reachability.stopNotifier()
    if isAdPlayback == true || isAdPlayback == false {
      if adsManager != nil {
        adsManager?.destroy()
      }
    }
    if self.countTimer != nil {
      self.countTimer.invalidate()
    }
    self.isbackActionPerformed = true
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    //self.dismiss(animated: false)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PausePlayer"), object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlayPlayer"), object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RewardVideoPlayedinVideo"), object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LodMopPubAd"), object: nil)
    self.avPlayer?.pause()
    let value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = false
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do {
      try reachability.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
    if self.isbackActionPerformed {
      if channelVideoLink != "" {
        self.ChannelNameLabel.isHidden = true
        self.counter = 10
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        let contentUrl = URL(string: String(format: channelVideoLink))
        self.avPlayer?.play()
        self.isbackActionPerformed = false
        self.avPlayer?.replaceCurrentItem(with: AVPlayerItem(url: contentUrl!))
        self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                               target: self,
                                               selector: #selector(changeTitle),
                                               userInfo: nil,
                                               repeats: true)
      }
    }
    NotificationCenter.default.addObserver(self, selector: #selector(self.playerPause), name: NSNotification.Name(rawValue: "PausePlayer"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.playerPlay), name: NSNotification.Name(rawValue: "PlayPlayer"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(playVideoAfterAd), name: NSNotification.Name("RewardVideoPlayedinVideo"), object: nil)
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    if isPresentController {
      super.viewWillTransition(to: size, with: coordinator)
      let mopPubinterstitialVideoPlaying = UserDefaults.standard.bool(forKey: "MopPubinterstitialVideoPlaying")
      if mopPubinterstitialVideoPlaying == false  {
        if UIDevice.current.orientation.isLandscape {
          if !isLandscape {
            self.channelCollectionView.setContentOffset(.zero, animated: true)
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
  override func didReceiveMemoryWarning() {
    SDImageCache.shared.clearMemory()
    SDImageCache.shared.clearDisk()

  }


  @objc private func playerPause(notification: Notification) {
    avPlayer?.pause()
  }

  @objc private func playerPlay(notification: Notification) {
    avPlayer?.play()
  }
  @objc func playVideoAfterAd() {
    CustomProgressView.hideActivityIndicator()
    UserDefaults.standard.set(false, forKey: "MopPubinterstitialVideoPlaying")
    self.setUpContentPlayer()
    self.setUpAdsLoader()
    self.requestAds()
    // self.getVideoList()
  }

  @objc func playVideoAfterSubscription() {
    CustomProgressView.hideActivityIndicator()
    SetupChannelDetails()
  }

  @objc func castDeviceDidChange(notification _: Notification) {
    if GCKCastContext.sharedInstance().castState != GCKCastState.noDevicesAvailable {
      // Display the instructions for how to use Google Cast on the first app use.
      GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce(with: castButton)
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
      print("Network not reachable")
    }
  }
  // MARK: Button Actions
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    if isAdPlayback {
      self.fullScreenButton.isHidden = true
    }else {
      if hidevideoController {
        self.fullScreenButton.isHidden = false
        self.hidevideoController = false
        self.playPauseButton.isHidden = false
        self.liveLabel.isHidden = false

      } else {
        self.fullScreenButton.isHidden = true
        self.hidevideoController = true
        self.playPauseButton.isHidden = true
        self.liveLabel.isHidden = true

      }
    }
  }
  @IBAction func backAction(_ sender: Any) {
    self.isbackActionPerformed = true
    //self.avPlayer?.removeTimeObserver(observer)
    if self.countTimer != nil {
      self.countTimer.invalidate()
    }
    if fromNotification == true {
      UserDefaults.standard.set("false", forKey: "fromTerminate")
      NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "myNotification"), object: nil)
      navigationController?.popToRootViewController(animated: true)
    } else {
      if avPlayer != nil {
        avPlayer?.pause()
        avPlayer = nil
        navigationController?.popViewController(animated: true)
      }
    }
    Application.shared.isVideoPlaying = false
  }

  @available(iOS 10.0, *)

  @IBAction func fullScreenButton(_ sender: UIButton) {

    var value = UIInterfaceOrientation.portrait.rawValue
    if(sender.isSelected) {
      sender.isSelected = false
      tabBarController?.tabBar.isHidden = false
      self.navigationController?.navigationBar.isHidden = false
      self.navigationController?.navigationBar.isTranslucent = false
      navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.restrictRotation = .portrait
        }
      UIDevice.current.setValue(value, forKey: "orientation")
        videoViewHeight.constant = videoHeight
      self.videoView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  videoViewHeight.constant)
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  videoViewHeight.constant )
      contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
      if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//        fullScreenBottomHeight.constant = 20
      }
        if featuredVideos.count > 0{
            HeaderLabel.isHidden = false
        }
        
    } else {
      sender.isSelected = true
      tabBarController?.tabBar.isHidden = true
      self.navigationController?.navigationBar.isHidden = true
      navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.restrictRotation = .landscapeRight
        }
      value = UIInterfaceOrientation.landscapeRight.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
      let screenSize = UIScreen.main.bounds
      let screenWidth = screenSize.width
      let screenHeight = screenSize.height
        HeaderLabel.isHidden = true
      videoViewHeight.constant = self.view.frame.size.height
      self.videoView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight)
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width:screenWidth , height:  screenHeight  )
      contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
      if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//        fullScreenBottomHeight.constant = 50
      }
      contentPlayerLayer!.backgroundColor = UIColor.black.cgColor
    }
  }
  @objc func playPauseAction() {
    if !(Application.shared.CastSessionStart) {
      if isPlaying {
        avPlayer?.pause()
        self.channelPauseEvent()
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
      } else {
        avPlayer?.play()
        self.channelResumeEvent()
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
      }
      isPlaying = !isPlaying
    }
  }

  // MARK: Main Functions
  func navigationTitle(){
    self.navigationItem.hidesBackButton = true
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      let imageView = UIImageView(image: UIImage(named: "ApplLogo"))
//        let imageView = UIImageView(image: UIImage(named: "navigationLogo"))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
         var titleView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
         titleView = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 40))
        }

        
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
    let newBackButton = UIButton(type: .custom)
    newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
    newBackButton.contentMode = .scaleAspectFit
    newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
    newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
    newBackButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
    let item2 = UIBarButtonItem(customView: newBackButton)
    self.navigationItem.leftBarButtonItem = item2
  }
  func castButtonSetup(){
    sessionManager = GCKCastContext.sharedInstance().sessionManager
    sessionManager.add(self)
    castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    // Used to overwrite the theme in AppDelegate.
    castButton.tintColor = ThemeManager.currentTheme().UIImageColor
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(castDeviceDidChange(notification:)),
                                           name: NSNotification.Name.gckCastStateDidChange,
                                           object: GCKCastContext.sharedInstance())
  }


  func parseM3U8Data() {
    if channelVideoLink != "" {
      let replaceLiveLink = channelVideoLink.replacingOccurrences(of: "playlist", with: "playlist~360p", options: .literal, range: nil)
      let baseUrl = URL(string: replaceLiveLink)
      // let baseUrl = URL(string: "http://34.198.11.177:3002/1/playlist~360p.m3u8")
      let manager = M3U8Manager()
      let params = PlaylistOperation.Params(fetcher: nil, url: baseUrl!, playlistType: .master)
      let parserExtraParams = M3U8Parser.ExtraParams(customRequiredTags: nil, extraTypes: nil, linePostProcessHandler: nil) // optional
      let extraParams = PlaylistOperation.ExtraParams(parser: parserExtraParams) // optional
      let operationData = M3U8Manager.PlaylistOperationData(params: params, extraParams: extraParams)
      let playlistType =  MasterPlaylist.self
      manager.fetchAndParsePlaylist(from: operationData, playlistType: playlistType) { (result) in
        switch result {
        case .success(let playlist):
          let playlist = playlist.originalText
          self.extractChannelsFromRawString(playlist)
          break
        case .failure( _): break // handle the error
        case .cancelled: break  // handle cancelled
        }
      }
    }
  }
  func extractChannelsFromRawString(_ string: String){
    string.enumerateLines { line, shouldStop in
      if line.hasPrefix("#EXTINF:") {
        let infoLine = line.replacingOccurrences(of: "#EXTINF:", with: "")
        let infoItems = infoLine.components(separatedBy: ",")
        if let title = infoItems.last {
          self.playingVideoTitle.removeAll()
          self.playingVideoTitle.append(title)
          DispatchQueue.main.async {
            self.ChannelNameLabel.isHidden = false
            if !(self.ChannelNameLabel.text == self.playingVideoTitle.last) {
              self.ChannelNameLabel.text = self.playingVideoTitle.last
              self.videoNameLabel.text = self.playingVideoTitle.last
            }
          }
        }
      }
    }
  }
  func collectionViewSelectedVideo() {
    if channelVideo.premium_flag == 1 {
      if Application.shared.userSubscriptionStatus {
        self.getChannelSubscriptions(channel_id: channelVideo.channel_id!)
      } else {
        CustomProgressView.hideActivityIndicator()
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
        watchListController.channelId = channelVideo.channel_id!
        watchListController.isFromVideoPlayingPage = false
        watchListController.subscriptionDelegate = self
        self.navigationController?.pushViewController(watchListController, animated: false)
      }
    }  else {
      self.initialView()
    }
  }
  func notificationSelectedVideo(channel_id : Int,premium_flag : Int) {
    if premium_flag == 1 {
      if Application.shared.userSubscriptionStatus {
        self.getChannelSubscriptions(channel_id: channel_id)
      } else {
        CustomProgressView.hideActivityIndicator()
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
        watchListController.channelId = channel_id
        watchListController.isFromVideoPlayingPage = false
        watchListController.subscriptionDelegate = self
        self.navigationController?.pushViewController(watchListController, animated: false)
      }
    }  else {
      self.initialView()
    }
  }
  func initialView() {
    CustomProgressView.hideActivityIndicator()
    self.isPresentController = true
    //self.contentView.isHidden = false
    if fromNotification == true {
      getchannelHomeVideo(indexpath: channelNotificationId)
    } else {
      getchannelHomeVideo(indexpath: channelVideo.channel_id!)

    }
  }
  func SetupChannelDetails() {
    if video.channel_name != "" {
      self.navigationItem.title = video.channel_name
      channelName = self.video.channel_name!
      metadata.setString(self.channelName, forKey: kGCKMetadataKeyTitle)
    }
    if video.video_id != nil {
      self.videoId = "0"
    }
    if self.video.ad_link != nil {
      self.addLink = self.video.ad_link!
    }
    if let channel_id =  self.video.channel_id {
      self.channelId = channel_id
      videoId = "0"
    }
    if video.logo != nil {

      metadata.addImage(GCKImage(url: URL(string: imageUrl + self.video.logo!)!,
                                 width: 480,
                                 height: 360))
    }
    self.replaceMacros()
    if video.live_link != nil {
      self.channelVideoLink = video.live_link!
      if  reachability.connection != .none {
        self.setUpContentPlayer()
        self.setUpAdsLoader()
        self.requestAds()
      }
    } else {
      self.videoViewHeight.constant = 0
      self.getLiveGuide()
    }

  }

  func setUpContentPlayer() {
    self.activityIndicatorView.isHidden = false
    self.activityIndicatorView.startAnimating()
    channelStartTime = getCurrentDate()
    if  token != "" || token.isEmpty {
        let contentUrl = URL(string: String(format: channelVideoLink))
      let headers = ["token": token]
      let asset: AVURLAsset = AVURLAsset(url: contentUrl!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
      let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
      playerItem.addObserver(self, forKeyPath: "timedMetadata", options: [], context: nil)
      avPlayer = AVPlayer(playerItem: playerItem)
      // Create a player layer for the player.
      contentPlayerLayer = AVPlayerLayer(player: avPlayer)
      contentPlayerLayer?.backgroundColor = UIColor.clear.cgColor
      contentPlayerLayer?.videoGravity=AVLayerVideoGravity.resizeAspect
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
                self?.channelStartEvent()
                if Application.shared.CastSessionStart {
                  self!.switchToRemotePlayback()
                }
              }
              self?.activityIndicatorView.stopAnimating()
              if self!.isbackActionPerformed {
                self!.avPlayer?.pause()
              }
            }

          }
        }
      }
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: videoView.frame.size.width , height: videoHeight )
      videoView.layer.addSublayer(contentPlayerLayer!)
      videoView.bringSubviewToFront(fullScreenButton)
      videoView.bringSubviewToFront(liveLabel)
        videoView.bringSubviewToFront(videoTitle)
      videoView.bringSubviewToFront(volumeControlView)
      videoView.bringSubviewToFront(playPauseButton)
      videoView.bringSubviewToFront(ChannelNameLabel)
                  playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
                  playPauseButton.titleLabel?.text = ""
                  playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
      
      self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                             target: self,
                                             selector: #selector(changeTitle),
                                             userInfo: nil,
                                             repeats: false)

      avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (progressTime) -> Void in
        let seconds = CMTimeGetSeconds(progressTime)
        if Int((seconds.truncatingRemainder(dividingBy: 60))) ==  0 && seconds != 0 {
          self.channelPlayingEvent()
        }
      }
      //self.avPlayer?.play()
      if playerItem.asset.isPlayable{
           print("isPlayable")
           self.errorMessageLabel.isHidden = true
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
           videoView.addGestureRecognizer(tap)
           videoView.isUserInteractionEnabled = true
           ChannelNameLabel.type = .continuous
           ChannelNameLabel.animationCurve = .easeInOut
           ChannelNameLabel.fadeLength = 10.0
           ChannelNameLabel.leadingBuffer = 30.0
           ChannelNameLabel.trailingBuffer = 20.0
         }else{
           print("NotPlayable")
           self.activityIndicatorView.stopAnimating()
           self.errorMessageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
           self.errorMessageLabel.layer.cornerRadius = 5
           self.errorMessageLabel.layer.masksToBounds = true
           self.errorMessageLabel.isHidden = false
           self.videoView.isUserInteractionEnabled = false
         }
         self.getLiveGuide()
    }
  }
    
  func gotoFullScreen() {
    self.volumeControlView.isHidden = true
    self.playPauseButton.isHidden = true
    self.fullScreenButton.isHidden = true
    self.fullScreenButton.setImage(UIImage(named: "icon_minimize"), for: .normal)
    var value = UIInterfaceOrientation.portrait.rawValue
    value = UIInterfaceOrientation.landscapeRight.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    tabBarController?.tabBar.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
    navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    let screenSize = UIScreen.main.bounds
    let screenHeight = screenSize.height
    let screenWidth = screenSize.width
    videoViewHeight.constant = screenWidth
    self.videoView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    if  contentPlayerLayer == nil {
      contentPlayerLayer = AVPlayerLayer(player: avPlayer)
      contentPlayerLayer?.backgroundColor = UIColor.clear.cgColor
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      videoView.layer.addSublayer(contentPlayerLayer!)
    } else{
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
  }
  func gotoNormalScreen() {
    var value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")

    self.volumeControlView.isHidden = true
    self.playPauseButton.isHidden = true
    self.fullScreenButton.isHidden = true
  self.fullScreenButton.setImage(UIImage(named: "fullNormalButttton"), for: .normal)
    tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.isTranslucent = true
    navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
    let screenSize = UIScreen.main.bounds
    let screenWidth = screenSize.width
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      videoViewHeight?.constant = 450
    } else {
      videoViewHeight?.constant = 250
    }
    self.videoView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: videoViewHeight.constant )
    if contentPlayerLayer != nil {
      contentPlayerLayer!.frame = CGRect(x: 0, y: 0, width: screenWidth  , height: videoViewHeight.constant )
      contentPlayerLayer!.frame =  self.videoView.frame
      contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
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
    videoPlayerHeight = 480
    addLink = addLink.replacingOccurrences(of: "[HEIGHT]", with: "\(videoPlayerHeight)")
    let videoPlayingViewHeightInt = Int(videoViewHeight.constant)
    let videoPlayingViewWidthInt = Int(self.view.frame.width)
    addLink = addLink.replacingOccurrences(of: "[[PLAYER_HEIGHT]]", with: "\(videoPlayingViewHeightInt)")
    addLink = addLink.replacingOccurrences(of: "[PLAYER_WIDTH]", with: "\(videoPlayingViewWidthInt)")
    let countryCode = UserDefaults.standard.string(forKey:"countryCode")
    addLink = addLink.replacingOccurrences(of: "[COUNTRY]", with: countryCode!)
    let UDID = UserDefaults.standard.string(forKey:"UDID")!
    addLink = addLink.replacingOccurrences(of: "[UUID]", with: UDID)
    if UserDefaults.standard.string(forKey:"userAgent") != nil {
      let userAgent = UserDefaults.standard.string(forKey:"userAgent")!
      let encodeduserAgent = String(format: "%@", userAgent.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink =  addLink.replacingOccurrences(of: "[USER_AGENT]", with: encodeduserAgent)
    }
   
      if UserDefaults.standard.string(forKey:"IPAddress") != nil {
        let  IPAddress = UserDefaults.standard.string(forKey:"IPAddress")!
              addLink = addLink.replacingOccurrences(of: "[IP_ADDRESS]", with: IPAddress)
         
        
      }
      
      let originalAppNameString = "KICCTV"
      let encodedAppNameUrl = String(format: "%@", originalAppNameString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[APP_NAME]", with: encodedAppNameUrl)

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
      addLink = addLink.replacingOccurrences(of: "[CHANNEL_ID]", with:String(channelId!))
      if video.video_duration != nil {
        addLink = addLink.replacingOccurrences(of: "[TOTAL_DURATION]", with: video.video_duration!)
      }
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
      }
      let originalAppstoreString = "https://apps.apple.com/in/app/justwatchme-tv/id1577160113"
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

  @objc func changeTitle() {
    if counter != 0 {
      counter -= 1
      print(counter)
    } else {
      self.counter = 10

      if reachability.connection != .none {
        parseM3U8Data()
      }
    }
  }
  func maxdate(){

  }

  func channelStartEvent() {
    var parameterDict: [String: String?] = [ : ]
    let currentDate = Int(Date().timeIntervalSince1970)
    parameterDict["timestamp"] = String(currentDate)
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    if let device_id = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = device_id
    }
    parameterDict["event_type"] = "POP02"

    if let app_id = UserDefaults.standard.string(forKey: "application_id") {
      parameterDict["app_id"] = app_id
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

    parameterDict["video_id"] = "0"
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }
    if let channelName = self.video.channel_name {
      parameterDict["video_title"] = channelName
    }
   
    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
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

  func channelPlayingEvent() {
    var parameterDict: [String: String?] = [ : ]
    let currentDate = Int(Date().timeIntervalSince1970)
    parameterDict["timestamp"] = String(currentDate)
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    if let device_id = UserDefaults.standard.string(forKey:"UDID") {
      parameterDict["device_id"] = device_id
    }
    parameterDict["event_type"] = "POP03"
    if let app_id = UserDefaults.standard.string(forKey: "application_id") {
      parameterDict["app_id"] = app_id
    }
    parameterDict["video_id"] = "0"
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }
    if let channelName = self.video.channel_name {
      parameterDict["video_title"] = channelName
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
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
    
    func channelPauseEvent() {
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

      parameterDict["video_id"] = "0"
      if let channel_id = video.channel_id {
        parameterDict["channel_id"] = String(channel_id)
      }
      if let channelName = self.video.channel_name {
        parameterDict["video_title"] = channelName
      }
     
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
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
    func channelResumeEvent() {
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

      parameterDict["video_id"] = "0"
      if let channel_id = video.channel_id {
        parameterDict["channel_id"] = String(channel_id)
      }
      if let channelName = self.video.channel_name {
        parameterDict["video_title"] = channelName
      }
     
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
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
  func channelPlayingError(error_code:String?,error_message:String?) {
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
    parameterDict["video_id"] = "0"
    if let error_code = error_code {
      parameterDict["error_code"] = error_code
    }
    if let error_message = error_message {
      parameterDict["error_message"] = error_message
    }
    parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
    if let channel_id = video.channel_id {
      parameterDict["channel_id"] = String(channel_id)
    }
    if let channelName = self.video.channel_name {
      parameterDict["video_title"] = channelName
    }
    parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
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
    func getLiveGuide() {
          print("getLiveGuide")
        self.channelCollectionView.isHidden = true
         
          ApiCommonClass.getLiveGuide { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
              DispatchQueue.main.async {
                DispatchQueue.main.async {
                  self.noResultView.isHidden = false
                  self.fullScreenButton.isHidden = true
                }
              }
            } else {
              self.featuredVideos.removeAll()
              if let videos = responseDictionary["data"] as? [LiveGuideModel] {
                  //          self.featuredVideos = Array(videos.prefix(5))
                  self.featuredVideos = videos
                if self.featuredVideos.count == 0 {
                  DispatchQueue.main.async {
                   
                    self.channelCollectionView.isHidden = true
                    CustomProgressView.hideActivityIndicator()
                  }
                }else{
                    DispatchQueue.main.async {
     //                    self.videoListingTableview.reloadSections(0, with: .)
                      self.channelCollectionView.dataSource = self
                      self.channelCollectionView.delegate = self
                      self.channelCollectionView.reloadData()
                      self.channelCollectionView.isHidden = false
                      self.HeaderLabel.isHidden = false
                        CustomProgressView.hideActivityIndicator()
                        
                    }

                }

              }
             
            }
          }
        }

  // MARK: Api methods
  func getVideoList() {
    self.channelCollectionView.isHidden = true
    var parameterDict: [String: String?] = [ : ]
    parameterDict["channel_id"] = String(video.channel_id!)
    parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    ApiCommonClass.getvideoList(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          self.noResultView.isHidden = true
          self.fullScreenButton.isHidden = true
        }
      } else {
        self.Videos = responseDictionary["Channels"] as! [VideoModel]
        if self.Videos.count == 0 {
          DispatchQueue.main.async {
            self.noResultView.isHidden = true
            self.fullScreenButton.isHidden = true
          }
        } else {
          DispatchQueue.main.async {
            self.channelCollectionView.dataSource = self
            self.channelCollectionView.delegate = self
            self.channelCollectionView.reloadData()
            self.channelCollectionView.isHidden = false
          }
        }
      }
    }
  }
    func getchannelHomeVideo(indexpath: Int) {
      CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
      videos.removeAll()
      var parameterDict: [String: String?] = [ : ]
      parameterDict["vid"] = String(indexpath)
      parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["channel_id"] = UserDefaults.standard.string(forKey:"channelid")
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
     
      ApiCommonClass.Channelhome(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Video Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          self.videos = responseDictionary["data"] as! [VideoModel]
          if self.videos.count == 0 {
            DispatchQueue.main.async {
              self.YouMayLikeLabel.isHidden = true
              WarningDisplayViewController().noResultview(view : self.view,title: "No Video Found")
              CustomProgressView.hideActivityIndicator()
            }
          } else {
            DispatchQueue.main.async {
              self.video = self.videos[0]
                
                if self.video.now_playing != nil{
                    if self.video.now_playing?.video_title != nil{
                    self.videoTitle.text = self.video.now_playing?.video_title
                        self.videoTitle.isHidden = false
                    }
                    else{
                        self.videoTitle.isHidden = true
                    }

                }
                else{
                    self.videoTitle.isHidden = true
                }
              if (self.video.premium_flag == 0) {
                self.didSelectNonPremiumVideo()
              } else {
                self.playVideoAfterSubscription()
              }
            }
          }
        }
      }
    }

  func didSelectNonPremiumVideo(){
    ApiCommonClass.generateLiveToken { (responseDictionary: Dictionary) in
      DispatchQueue.main.async {
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            self.token = responseDictionary["Channels"] as! String
            self.SetupChannelDetails()
          }
        }
      }
    }
  }
  func GenerateLiveToken(flag : Bool) {
    ApiCommonClass.generateLiveToken { (responseDictionary: Dictionary) in
      DispatchQueue.main.async {
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          self.token = responseDictionary["Channels"] as! String
          if (self.channelVideo.premium_flag == 0) {
            if (self.interstitial_status == 0 || (flag == true )) {
              if self.video.live_link  != nil {
                self.setUpContentPlayer()
                self.setUpAdsLoader()
                self.requestAds()
              }
            }
          } else {
            self.setUpContentPlayer()
            self.setUpAdsLoader()
            self.requestAds()
          }
        }
      }
    }
  }
  func getChannelSubscriptions(channel_id : Int){
    var parameterDict: [String: String?] = [ : ]
    parameterDict["channel_id"] = String(channel_id)
    parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    ApiCommonClass.getchannelSubscriptions(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
          Application.shared.userSubscriptionVideoStatus = false
          let delegate = UIApplication.shared.delegate as? AppDelegate
          delegate!.loadTabbar()
        }
      } else {
        DispatchQueue.main.async {
          if let videos = responseDictionary["Channels"] as? [ChannelSubscriptionModel] {
            if videos.count == 0 {
              CustomProgressView.hideActivityIndicator()
              let delegate = UIApplication.shared.delegate as? AppDelegate
              delegate!.loadTabbar()
              Application.shared.userSubscriptionVideoStatus = false
            } else {
              let subscriptionModel = Application.shared.userSubscriptionsArray
              for subscriptionModel in subscriptionModel {
                let subscriptionid = subscriptionModel.sub_id
                if  (videos.contains(where: {$0.subscription_id == subscriptionid})) {
                  self.subscribedUser = true
                  print("subscribed")
                  break
                } else {
                  self.subscribedUser = false
                  print("subscribed Not Used")
                }
              }
              if self.subscribedUser {
                //self.setupInitial()
                self.didPurchaseSubscription()
              } else {
                CustomProgressView.hideActivityIndicator()
                let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
                watchListController.channelId = channel_id
                watchListController.isFromVideoPlayingPage = false
                watchListController.subscriptionDelegate = self
                self.navigationController?.pushViewController(watchListController, animated: false)
              }
            }
          }
        }
      }
    }
  }
  func didPurchaseSubscription() {
    ApiCommonClass.generateLiveToken { (responseDictionary: Dictionary) in
      DispatchQueue.main.async {
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            self.token = responseDictionary["Channels"] as! String
            self.initialView()
          }
        }
      }
    }
  }
  //MARK: - Cast Screen Delegate Method
  func castChannel(_ channel: CastMessageChannel?, didReceiveMessage message: String?) {
    if let message = message {
      let mesageData = String(format:"%@", message)
      print("cast Channel",mesageData)
    }
  }
  // MARK: GCKRemoteMediaClientListener
  func sessionManager(_: GCKSessionManager,
                      didStart session: GCKCastSession) {
    print("sessionManager didStartSession: \(session)")

    // Add GCKRemoteMediaClientListener.
    messageChannel = CastMessageChannel(namespace: "urn:x-cast:com.google.ads.ima.cast")
    messageChannel?.delegate = self
    session.add(messageChannel!)
    session.remoteMediaClient?.add(self)
    Application.shared.CastSessionStart = true
    switchToRemotePlayback()
    avPlayer?.pause()
    playPauseButton.setImage(UIImage(named: "play-1"), for: .normal)
  }

  func sessionManager(_: GCKSessionManager,
                      didResumeSession session: GCKSession) {
    print("sessionManager didResumeSession: \(session)")
    Application.shared.CastSessionStart = false
    // Add GCKRemoteMediaClientListener.
    session.remoteMediaClient?.add(self)
    avPlayer?.play()
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
  }

  func sessionManager(_: GCKSessionManager,
                      didEnd session: GCKSession,
                      withError error: Error?) {
    print("sessionManager didEndSession: \(session)")

    // Remove GCKRemoteMediaClientListener.
    session.remoteMediaClient?.remove(self)
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
    // GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    let jsonObject: [String: Any] = [
      "token": self.token
    ]
    if self.channelVideoLink != "" {
      let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: URL(string: self.channelVideoLink)!)
      mediaInfoBuilder.streamType = GCKMediaStreamType.none
      mediaInfoBuilder.contentType = "application/x-mpegurl"
      mediaInfoBuilder.metadata = metadata
      mediaInfoBuilder.customData = jsonObject
      mediaInformation = mediaInfoBuilder.build()
      let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
      mediaLoadRequestDataBuilder.mediaInformation = mediaInformation
      if let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(with: mediaLoadRequestDataBuilder.build()) {
        request.delegate = self
      }
      self.avPlayer?.pause()
      playPauseButton.setImage(UIImage(named: "play-1"), for: .normal)
    }

  }

  func sendMessage(_ message: String?) {
    print("Sending message: \(message ?? "")")
    messageChannel?.sendTextMessage(message!, error: nil)
  }

}
extension ChannelVideoViewController :IMAAdsManagerDelegate, IMAAdsLoaderDelegate {
  // MARK: - IMAAdsLoaderDelegate
  func setUpAdsLoader() {
    adsLoader = IMAAdsLoader(settings: nil)
    adsLoader.delegate = self
  }
  func requestAds() {
    // Create ad display container for ad rendering.
    adDisplayContainer = IMAAdDisplayContainer(adContainer: videoView, companionSlots: nil)
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

  }

  func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
    isAdPlayback = false
    self.channelPlayingError(error_code: String(format: "%d", adErrorData.adError.code.rawValue), error_message: String(format: "%@", adErrorData.adError.message))
    avPlayer?.play()
  }

  // MARK: - IMAAdsManagerDelegate

  func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
    if event.type == IMAAdEventType.LOADED {
      // When the SDK notifies us that ads have been loaded, play them.
      avPlayer?.pause()
      self.activityIndicatorView.stopAnimating()
      adsManager.start()
      //self.fullScreenButton.isHidden = true
    }
    if event.type == IMAAdEventType.COMPLETE {
      print("AdsManager event \(event.typeString!)")
      avPlayer?.play()
    }
    if event.type == IMAAdEventType.ALL_ADS_COMPLETED {
      print("AdsManager event \(event.typeString!)")
      //self.fullScreenButton.isHidden = true
      avPlayer?.play()
    }
  }

  func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
    self.channelPlayingError(error_code: String(describing:error.code.rawValue), error_message: (String(describing: error.message)))
    isAdPlayback = false
    avPlayer?.play()
  }
  func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
    isAdPlayback = true
  }

  func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
    // The SDK is done playing ads (at least for now), so resume the content.
    isAdPlayback = false
    avPlayer?.play()
  }


}

// MARK: Collectionview methods
extension ChannelVideoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if featuredVideos.count > 0{
        return featuredVideos.count
    }
    else{
        return 0
    }
    
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "channelHeader", for: indexPath)
    header.backgroundColor = ThemeManager.currentTheme().backgroundColor
    return header
  }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveGuideCollectionCell", for: indexPath as IndexPath) as! LiveGuideCollectionViewCell
//        cell.backgroundColor = .red
      if featuredVideos.count == 0{
          
  //        self.LiveGuideButon.isHidden = true
      }
      else{
  //        self.LiveGuideButon.isHidden = false
      }
      let formatter = DateFormatter()
      formatter.timeZone = TimeZone.current
      formatter.dateFormat = "h:mm a"
      formatter.amSymbol = "AM"
      formatter.pmSymbol = "PM"
       let calendar = Calendar.current
      if featuredVideos[indexPath.row].starttime == nil && featuredVideos[indexPath.row].endtime == nil{
          cell.timeLabel.text  = ""
          cell.weekdayLabel.text = ""
      }
      else{
          self.startTime = convertStringTimeToDate(item: featuredVideos[indexPath.row].starttime!)
          
          self.timeStart = formatter.string(from: startTime)
          self.endTime = convertStringTimeToDate(item: featuredVideos[indexPath.row].endtime!)
          self.timeEnd = formatter.string(from: endTime)
          cell.weekdayLabel.text =  String(format:"%@-%@", timeStart,timeEnd)
          if  calendar.isDateInToday(startTime) {
                 cell.timeLabel.text = " "
             }
          else if  calendar.isDateInYesterday(startTime){
                  cell.timeLabel.text = " "
              }
          else {
              cell.timeLabel.text = self.GetFormatedDate(date_string: featuredVideos[indexPath.row].starttime!, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")

          }
      }
        if featuredVideos[indexPath.row].video_title != nil {
            cell.videoTitle.text = featuredVideos[indexPath.row].video_title
        }
        else{
            cell.videoTitle.text = ""
        }
        
      if featuredVideos[indexPath.row].thumbnail != nil {
  //        let now = Date()

         
          cell.trendingImageLogo.sd_setImage(with: URL(string: ((imageUrl + featuredVideos[indexPath.row].thumbnail!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
          
         
  //        cell.sheduleLabel.isHidden = true
      
      } else {
         cell.trendingImageLogo.image = UIImage(named: "landscape_placeholder")
          
      }
     
      cell.layer.masksToBounds = true
      cell.layoutIfNeeded()
      cell.featuredVideos = featuredVideos[indexPath.row]
      return cell
    }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //self.avPlayer?.removeTimeObserver(observer)
//    self.isbackActionPerformed = true
//    self.avPlayer?.pause()
//    if self.countTimer != nil {
//      self.countTimer.invalidate()
//    }
//    if (isAdPlayback == true) || (isAdPlayback == false) {
//      if avPlayer != nil {
//        avPlayer?.pause()
//      }
//    } else {
//      if avPlayer != nil {
//        avPlayer?.pause()
//      }
//    }
//    let video = Videos[indexPath.item]
//    let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
//    videoPlayerController.video = video
//    self.navigationController?.pushViewController(videoPlayerController, animated: false)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        let width =  (UIScreen.main.bounds.width / 3 )
        let height = ( 3 * width ) / 2
        return CGSize(width: width, height: height)
    } else {
        let width = (view.frame.width - 10)
        return CGSize(width: width/4, height: 240)
    }
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
}

