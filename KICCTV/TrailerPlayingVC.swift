//
//  TrailerPlayingVC.swift
//  Mongol
//
//  Created by GIZMEON on 26/03/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
import Reachability
import AVFoundation
import AVKit
import Reachability
import SummerSlider
class TrailerPlayingVC: UIViewController {
   
    
   
    var reachability = Reachability()!
    var videos = [VideoModel]()
      var autoPlayVideomodel = [VideoModel]()

      var categoryModel : VideoModel!

    let playerViewController = AVPlayerViewController()
    var avPlayer: AVPlayer? = AVPlayer()
    var contentPlayerLayer: AVPlayerLayer?
    var observer: Any!
    var video: VideoModel!
      var isAdComplete=false
      var autoPlayvideovideo: VideoModel!

  
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
    var sampleArray = Array<Float>()
    var videoDescription = ""
      var isFromSub = false

    var fullScreenValue = Int()
    var videoPlayerWidth = Int()
    var videoPlayerMacroHeight = Int()
    var btnLeftMenu : UIButton = UIButton()
    var hidevideoController = true
    var normalScreenButtonflag = false
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
    @IBOutlet weak var mainView: UIView!{
        didSet {
          self.mainView.isHidden = true
            self.mainView.backgroundColor = .clear
        }
      }

    @IBOutlet weak var videoPlayingView: UIView!
    @IBOutlet weak var videoPlayingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var playerControlsView: UIView!
    @IBOutlet weak var startDurationLabel: UILabel!
    @IBOutlet weak var videoPlaybackSlider: SummerSlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!{
        didSet{
          self.activityIndicatorView.color = ThemeManager.currentTheme().UIImageColor
        }
      }
    @IBOutlet weak var forwardButton: UIButton!{
        didSet{
          self.forwardButton.addTarget(self, action: #selector(TrailerPlayingVC.forwardVideo), for: .touchUpInside)

        }
      }
    @IBOutlet weak var backwardButton: UIButton!{
        didSet{
          self.backwardButton.addTarget(self, action: #selector(TrailerPlayingVC.rewindVideo), for: .touchUpInside)
        }
      }
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationTitle()

        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
          videoPlayerHeight = 450
          videoPlayingViewHeight?.constant = 450

        } else {
          videoPlayingViewHeight?.constant = 250

          videoPlayerHeight = 250
        }
        initialView()
        self.getVideoToken()
        
    }
    override func viewWillAppear(_ animated: Bool) {
     
      super.viewWillAppear(animated)
      self.navigationController?.navigationBar.isHidden = false
      self.tabBarController?.tabBar.isHidden = true
      NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
      do {
        try reachability.startNotifier()
      } catch {
        print("could not start reachability notifier")
      }
        // setting orientation ... videoplaying in full screeen mode
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.restrictRotation = .landscapeRight
        }
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
//        videoPlayingViewHeight.constant = screenSize.height

        self.videoPlayingView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight )
        self.playerControlsView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight )
  //     playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
      NotificationCenter.default.addObserver(self, selector: #selector(self.playerPause), name: NSNotification.Name(rawValue: "PausePlayer"), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.playerPlay), name: NSNotification.Name(rawValue: "PlayPlayer"), object: nil)
    
      playPauseButton.imageView?.image = UIImage.init(named: "pause")
      self.avPlayer?.play()
    }
      

    override func viewWillDisappear(_ animated: Bool) {
      self.avPlayer?.pause()
    
      super.viewWillDisappear(animated)
      let value = UIInterfaceOrientation.portrait.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
     
      if avPlayer != nil {
        avPlayer?.pause()
      }
      reachability.stopNotifier()
      NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PausePlayer"), object: nil)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlayPlayer"), object: nil)
    }
    @objc private func playerPause(notification: Notification) {
      if isAdPlayback {
      }
      avPlayer?.pause()
    }
    @objc private func playerPlay(notification: Notification) {
      if isAdPlayback {
        avPlayer?.pause()
      }
      else {
        avPlayer?.play()
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
             
              isLandscape = true
            }
          } else {

            gotoFullScreen()
            
            isLandscape = true
            gotoNormalScreen()
           
            isLandscape = false
          }
        }
      }
    }
    func gotoFullScreen() {
      self.playPauseButton.isHidden = true
      self.videoPlaybackSlider.isHidden = true
      self.durationLabel.isHidden = true
      self.startDurationLabel.isHidden = true
      self.forwardButton.isHidden = true
      self.backwardButton.isHidden = true
      
  //    self.volumeControlView.isHidden = false
      tabBarController?.tabBar.isHidden = true
      self.navigationController?.navigationBar.isHidden = false
      self.normalScreenButtonflag = true
   
      let screenSize = UIScreen.main.bounds
      let screenHeight = screenSize.height
      let screenWidth = screenSize.width
      videoPlayingViewHeight.constant = screenWidth
      self.videoPlayingView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight )
      self.playerControlsView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
     
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
     
      self.videoPlaybackSlider.isHidden = true
      self.durationLabel.isHidden = true
      self.startDurationLabel.isHidden = true
      self.forwardButton.isHidden = true
      self.backwardButton.isHidden = true
  //    self.volumeControlView.isHidden = true
   
      tabBarController?.tabBar.isHidden = false
      self.navigationController?.navigationBar.isHidden = false
      self.navigationController?.navigationBar.isTranslucent = true
      self.normalScreenButtonflag = false
      navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
      let screenSize = UIScreen.main.bounds
      let screenWidth = screenSize.width
      if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        videoPlayingViewHeight?.constant = 450
      } else {
        videoPlayingViewHeight?.constant = 250
      }
      self.videoPlayingView.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: videoPlayingViewHeight.constant )
      self.playerControlsView.frame =  CGRect(x: 0, y: 0, width: screenWidth  , height: videoPlayingViewHeight.constant )
      if contentPlayerLayer != nil {
        contentPlayerLayer!.frame = CGRect(x: 0, y: 0, width: screenWidth  , height: videoPlayingViewHeight.constant )
        contentPlayerLayer!.frame =  self.videoPlayingView.frame
        contentPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
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
    func initialView(){
     
      self.playPauseButton.isHidden = true
      self.videoPlaybackSlider.isHidden = true
      self.durationLabel.isHidden = true
      self.forwardButton.isHidden = true
      self.backwardButton.isHidden = true
      self.startDurationLabel.isHidden = true
      self.mainView.isHidden = false
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
      newBackButton.addTarget(self, action: #selector(TrailerPlayingVC.backAction), for: .touchUpInside)
      let item2 = UIBarButtonItem(customView: newBackButton)
      self.navigationItem.leftBarButtonItem = item2
//      let imageView = UIImageView(image: UIImage(named: ThemeManager.currentTheme().navigationControllerLogo))
//  //    let imageView = UIImageView(image: UIImage(named: "navigationLogo"))
//          imageView.contentMode = UIView.ContentMode.scaleAspectFit
//           var titleView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
//      if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//           titleView = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 40))
//          }
//
//
//              imageView.frame = titleView.bounds
//              titleView.addSubview(imageView)
//          self.navigationItem.titleView = titleView
        if self.videoTitle != nil{
            self.navigationItem.title = videoTitle
        }
       
      navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
    }
    
   


    func getVideoToken() {
      ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
        DispatchQueue.main.async {
          if responseDictionary["error"] != nil {
          } else {
            self.token = responseDictionary["Channels"] as! String
            self.setUpContentPlayer()
          }
        }
      }
    }
    func setUpContentPlayer() {
  //    if let subtitleUrl = self.subtitleUrl {
  //      self.parseSubTitle(Url : subtitleUrl)
  //    }
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
        contentPlayerLayer?.isHidden = false
        contentPlayerLayer?.videoGravity=AVLayerVideoGravity.resizeAspect

        avPlayer?.play()
      self.observer = avPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main) {
        [weak self] time in
        do {
          try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch let error {
          print("Error in AVAudio Session\(error.localizedDescription)")
        }
  //      if self!.subtitleIsOn {
  //       self?.subTitleLabel.text = ApiCommonClass.searchSubtitles(self?.parsedPayload, time.seconds)
  //      } else {
  //       self?.subTitleLabel.text = nil
  //      }
        if self?.avPlayer?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
          if let isPlaybackLikelyToKeepUp = self?.avPlayer?.currentItem?.isPlaybackLikelyToKeepUp {
            if  isPlaybackLikelyToKeepUp == false {
              print(isPlaybackLikelyToKeepUp)
              self?.activityIndicatorView.isHidden = false
              self?.activityIndicatorView.startAnimating()
              self?.playPauseButton.isHidden = true
            } else {
              
              if (self!.videoPlaybackSlider.isHidden){
                   self?.playPauseButton.isHidden = true
              } else {
                self?.playPauseButton.isHidden = false
              }
              self?.activityIndicatorView.stopAnimating()
              if self!.isbackActionPerformed {
                self!.avPlayer?.pause()
              }
            }
          }
        }
      }
  //    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
      if addLink == "" {
        self.playPauseButton.isHidden = true
        self.videoPlaybackSlider.isHidden = true
        self.durationLabel.isHidden = true
        self.startDurationLabel.isHidden = true
        self.forwardButton.isHidden = true
  //       self.subTitleButton.isHidden =  true
        self.backwardButton.isHidden = true
      } else {
        self.playPauseButton.isHidden = true
        self.videoPlaybackSlider.isHidden = true
        self.durationLabel.isHidden = true
        self.startDurationLabel.isHidden = true
        self.forwardButton.isHidden = true
  //      self.subTitleButton.isHidden =  true
        self.backwardButton.isHidden = true
      }
        // Size, position, and display the AVPlayer.
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.restrictRotation = .landscapeRight
        }
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        videoPlayingViewHeight.constant = screenWidth
        self.videoPlayingView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight )
        self.playerControlsView.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight )
        contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight)
        videoPlayingView.layer.addSublayer(contentPlayerLayer!)
        contentPlayerLayer?.videoGravity=AVLayerVideoGravity.resizeAspect
        
        // Create content playhead
      // Size, position, and display the AVPlayer.
      // Create content playhead
      NotificationCenter.default.addObserver(forName:NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: avPlayer!.currentItem, queue:nil){ [weak avPlayer] notification in
        
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
        avPlayer?.play()
      }else{
        print("NotPlayable")
        self.activityIndicatorView.stopAnimating()
        self.errorMessageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.errorMessageLabel.layer.cornerRadius = 5
        self.errorMessageLabel.layer.masksToBounds = true
        self.errorMessageLabel.isHidden = false
        self.playerControlsView.isUserInteractionEnabled = false
      }


    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
      if !self.activityIndicatorView.isAnimating{
      if isAdPlayback {
      }else {
        if hidevideoController {
          if self.normalScreenButtonflag {
          }
          self.playPauseButton.isHidden = false
          self.videoPlaybackSlider.isHidden = false
          self.durationLabel.isHidden = false
          self.startDurationLabel.isHidden = false
          self.hidevideoController = false
  //         self.subTitleButton.isHidden =  false
          self.forwardButton.isHidden = false
          self.backwardButton.isHidden = false
          //self.BackButton.isHidden = false
        } else {
          self.playPauseButton.isHidden = true
          self.videoPlaybackSlider.isHidden = true
          self.durationLabel.isHidden = true
          self.startDurationLabel.isHidden = true
          self.hidevideoController = true
          if self.normalScreenButtonflag {
          }
          self.forwardButton.isHidden = true
          self.backwardButton.isHidden = true
        }
      }
      }
    }
    @objc func playPauseAction() {
      if !(Application.shared.CastSessionStart) {
        if isPlaying {
          avPlayer?.pause()
          playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
          avPlayer?.play()
          playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
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
    @objc func rewindVideo(){
        
            if let currentTime = avPlayer?.currentTime() {
              var newTime = CMTimeGetSeconds(currentTime) - 10.0
                if newTime <= 0 {
                    newTime = 0
                }
                avPlayer?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
            }
    }
    @objc func forwardVideo(){
        if let currentTime = avPlayer?.currentTime(), let duration = avPlayer?.currentItem?.duration {
          var newTime = CMTimeGetSeconds(currentTime) + 10.0
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            avPlayer?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    func formatMinuteSeconds(_ totalSeconds: Double) -> String {
      let secondsString = String(format: "%02d", Int(totalSeconds .truncatingRemainder(dividingBy: 60)))
      let minutesString = String(format: "%02d", Int(totalSeconds / 60))
      return "\(minutesString):\(secondsString)"
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
            
            self.navigationController?.popToRootViewController(animated: false)
          }
        } else {
          if self.isAdPlayback == true || self.isAdPlayback == false {
            
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
      

    }

}
