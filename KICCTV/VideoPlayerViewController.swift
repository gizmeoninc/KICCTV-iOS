//
//  VideoPlayerViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 21/02/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import GoogleInteractiveMediaAds
import FBSDKShareKit
import FacebookShare
import SummerSlider

class VideoPlayerViewController: UIViewController, IMAAdsManagerDelegate, IMAAdsLoaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {

  // MARK: IBOutlets and IBActions

  @IBOutlet weak var facebookShareButton: UIButton!
  @IBOutlet weak var companionView: UIView!
  @IBOutlet weak var publisherImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBAction func backAction(_ sender: Any)
  {
    // self.dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
  }
  @IBOutlet weak var videoView: UIView!
  @IBOutlet weak var publisherNameLabel: UILabel!
  @IBOutlet weak var videoTagLabel: UILabel!
  @IBOutlet weak var videoCountLabel: UILabel!
  @IBOutlet weak var moreVideosByLabel: UILabel!
  @IBOutlet weak var moreVideosCollectionView: UICollectionView!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var videoViewHieght: NSLayoutConstraint!
  @IBOutlet weak var videoTagLabelWidth: NSLayoutConstraint!
  @IBOutlet weak var contentViewHieght: NSLayoutConstraint!
  @IBOutlet weak var playerControlsView: UIView!
  @IBOutlet weak var normalScreenButton: UIButton!
  @IBOutlet weak var normalScreenButtonWidth: NSLayoutConstraint!
  @IBOutlet weak var fullscreenButton: UIButton!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var videoPlaybackSlider: SummerSlider!
  // MARK: Property declaration
  var videos = [VideoModel]()
  let playerViewController = AVPlayerViewController()
  var avPlayer: AVPlayer? = AVPlayer()
  var contentPlayerLayer: AVPlayerLayer?
  var observer: Any!
  var video: VideoModel!
  // IMA SDK handles.
  var contentPlayhead: IMAAVPlayerContentPlayhead?
  var adsLoader: IMAAdsLoader!
  var adsManager: IMAAdsManager?
  var companionSlot: IMACompanionAdSlot?
  // Tracking for play/pause.
  var isAdPlayback = false
  let playerItem: AVPlayerItem? = nil
  var videoHeight = CGFloat()
  var adPositionsArray = Array<Float>()
  // MARK: Main methods
  override func viewDidLoad() {
    super.viewDidLoad()
    initialView()
    publisherImageView?.sd_setImage(with: URL(string: String(format:"%@/%@", publisherImagePath ,video.user_image!)), placeholderImage: UIImage(named: "menu.png"))
    publisherImageView?.layer.cornerRadius = (publisherImageView?.frame.size.height)!/2
    getMoreVideos()
    //titleLabel.text = video.video_title
    //descriptionLabel.text = video.video_description

    // Do any additional setup after loading the view.
    setUpContentPlayer()
    //        setUpAdsLoader()
    //        //facebookShareButton.addTarget(self, action: #selector(shareToFacebook), for: .touchUpInside) //<- use `#selector(...)`
    //        setUpIMA()
    //        requestAdsWithTag(video.ad_link)
  }

  func setUpContentPlayer() {
    //        let contentUrl = URL(string: String(format:"%@/%@",videoPath ,video.video_name!))
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      videoHeight = 300
      videoViewHieght?.constant = 300
    } else {
      videoViewHieght?.constant = 202
      videoHeight = 202
      // videoViewHieght.constant = self.view.frame.size.width*0.32
    }
    let contentUrl = URL(string: String(format: "https://s3.amazonaws.com/aes-encrypted-playlists/bumblebee/encrypted-play-list.m3u8"))
    //        let contentUrl = URL(string: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8")
    //        let contentUrl = URL(string: String(format:"%@",video.video_name!))
    let headers = ["token": "1234"]
    let asset: AVURLAsset = AVURLAsset(url: contentUrl!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
    let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
    avPlayer = AVPlayer(playerItem: playerItem)
    // Create a player layer for the player.
    contentPlayerLayer = AVPlayerLayer(player: avPlayer)
    contentPlayerLayer?.videoGravity=AVLayerVideoGravityResizeAspectFill
    self.observer = avPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 600), queue: DispatchQueue.main) {
      [weak self] time in
      if self?.avPlayer?.currentItem?.status == AVPlayerItemStatus.readyToPlay {
        if let isPlaybackLikelyToKeepUp = self?.avPlayer?.currentItem?.isPlaybackLikelyToKeepUp {
          /*  if  isPlaybackLikelyToKeepUp == false{
           CustomProgressView.showActivityIndicator(userInteractionEnabled:true)

           //Here start the activity indicator inorder to show buffering
           }else{
           //stop the activity indicator
           CustomProgressView.hideActivityIndicator()
           }*/
          print("isPlaybackLikelyToKeepUp: ", isPlaybackLikelyToKeepUp)
          //do what ever you want with isPlaybackLikelyToKeepUp value, for example, show or hide a activity indicator.
        }
      }
    }

    // Size, position, and display the AVPlayer.
    contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: videoHeight )
    videoView.layer.addSublayer(contentPlayerLayer!)
    // Create content playhead
      contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: avPlayer)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(VideoPlayerViewController.contentDidFinishPlaying(_:)),
      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
      object: avPlayer!.currentItem)
    playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
    playPauseButton.titleLabel?.text = ""
    playPauseButton.imageView?.image = UIImage.init(named: "play-1")
    videoPlaybackSlider.minimumValue = 0
    // let duration: CMTime = playerItem.asset.duration
    videoPlaybackSlider.maximumValue = 1
    videoPlaybackSlider.isContinuous = false
    videoPlaybackSlider.selectedBarColor = UIColor().sliderGreenColor()
    videoPlaybackSlider.unselectedBarColor = UIColor.black.withAlphaComponent(0.6)
    videoPlaybackSlider.addTarget(self, action: #selector(playbackSliderValueChanged), for: .valueChanged)
    durationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    durationLabel.layer.cornerRadius = 5
    durationLabel?.layer.masksToBounds = true
    playerControlsView.backgroundColor = UIColor.clear
    self.videoPlaybackSlider.value = 0
    self.durationLabel.text = "00:00"
    avPlayer?.play()
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
    avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (progressTime) -> Void in
      let seconds = CMTimeGetSeconds(progressTime)
      let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
      let minutesString = String(format: "%02d", Int(seconds / 60))
      print("\(minutesString):\(secondsString)")
      self.durationLabel.text = "\(minutesString):\(secondsString)"
      //lets move the slider thumb
      if let duration = self.avPlayer?.currentItem?.duration {
        let durationSeconds = CMTimeGetSeconds(duration)
        self.videoPlaybackSlider.value = Float(seconds / durationSeconds)
      }
    }
  }
  public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutableRawPointer) {
    if object is AVPlayerItem {
      switch keyPath {
      case "playbackBufferEmpty":
        print("playbackBufferEmpty")
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
      // Show loader
      case "playbackLikelyToKeepUp":
        print("playbackLikelyToKeepUp")
        CustomProgressView.hideActivityIndicator()
      // Hide loader
      case "playbackBufferFull":
        print("playbackBufferFull")
        CustomProgressView.hideActivityIndicator()
      // Hide loader
      case .none:
        print("none")
      case .some(_):
        print("some")
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var isPlaying = true
  @IBAction func normalScreenAction(_ sender: Any) {
    let value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    videoViewHieght.constant = videoHeight
    contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: videoViewHieght.constant)
    contentPlayerLayer?.videoGravity=AVLayerVideoGravityResizeAspect
  }
  @IBAction func fullScreenAction(_ sender: Any) {
    let value = UIInterfaceOrientation.landscapeRight.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    videoViewHieght.constant = self.view.frame.size.height
    contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: videoViewHieght.constant )
    contentPlayerLayer?.videoGravity=AVLayerVideoGravityResizeAspect
  }
  func playPauseAction() {
    if isPlaying {
      avPlayer?.pause()
      playPauseButton.setImage(UIImage(named: "play-1"), for: .normal)
    } else {
      avPlayer?.play()
      playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
    }
    isPlaying = !isPlaying
  }
  func playbackSliderValueChanged() {
    print(videoPlaybackSlider.value)
    if let duration = avPlayer?.currentItem?.duration {
      let totalSeconds = CMTimeGetSeconds(duration)
      let value = Float64(videoPlaybackSlider.value) * totalSeconds
      let seekTime = CMTime(value: Int64(value), timescale: 1)
      avPlayer?.seek(to: seekTime)
    }
    if avPlayer!.rate == 0 {
      avPlayer?.play()
    } else {
      avPlayer?.pause()
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    avPlayer!.pause()
    // Don't reset if we're presenting a modal view (e.g. in-app clickthrough).
    //        if ((navigationController!.viewControllers as NSArray).index(of: self) == NSNotFound) {
    //            if (adsManager != nil) {
    //                adsManager!.destroy()
    //                adsManager = nil
    //            }
    //            avPlayer = nil
    //        }
    self.videoPlaybackSlider.value = 0
    self.durationLabel.text = "00:00"
    super.viewWillDisappear(animated)
  }
  func initialView() {
    self.navigationController?.isNavigationBarHidden = true
    backButton?.imageView?.image = AppHelper.imageScaledToSize(image: UIImage(named: "backarrow")!, newSize: CGSize(width: 20, height: 30))
    moreVideosCollectionView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellWithReuseIdentifier: "ChannelCell")
    moreVideosCollectionView.isScrollEnabled = false
    let string = String(format: "%@ - %@", video.video_title!, video.video_description!)
    let boldString = String(format: " - %@", video.video_description!)
    //cell.videoLabel?.text = String(format:"%@ | %@", attributedString, normalString)
    let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSFontAttributeName : UIFont.init(name: FontBold, size: 15) as Any])
    let boldFontAttribute: [NSAttributedStringKey: Any] = [NSFontAttributeName as NSString: UIFont.init(name: FontRegular, size: 15) as Any]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute as [String: Any], range: range)
    titleLabel?.attributedText = attributedString
    videoTagLabel?.text = video.video_tag
   // videoCountLabel?.text = video.view_count
    videoTagLabelWidth?.constant = (videoTagLabel?.intrinsicContentSize.width)!+8
    videoTagLabel?.layer.cornerRadius = 3
    videoTagLabel?.layer.masksToBounds = true

    let string2 = String(format: "More Videos by %@", video.first_name!)
    let boldString2 = String(format: "%@", video.first_name!)
    let attributedString2 = NSMutableAttributedString(string: string2,
                                                      attributes: [NSFontAttributeName: UIFont.init(name: FontRegular, size: 15) as Any])
    let boldFontAttribute2: [NSAttributedStringKey: Any] = [NSFontAttributeName as NSString: UIFont.init(name: FontBold, size: 15) as Any]
    let range2 = (string2 as NSString).range(of: boldString2)
    attributedString2.addAttributes(boldFontAttribute2 as [String: Any], range: range2)
    moreVideosByLabel?.attributedText = attributedString2
    let string3 = String(format: "By %@", video.first_name!)
    let boldString3 = String(format: "%@", video.first_name!)
    let attributedString3 = NSMutableAttributedString(string: string3,
                                                      attributes: [NSFontAttributeName: UIFont.init(name: FontRegular, size: 15) as Any])
    let boldFontAttribute3: [NSAttributedStringKey: Any] = [NSFontAttributeName as NSString: UIFont.init(name: FontBold, size: 15) as Any]
    let range3 = (string3 as NSString).range(of: boldString3)
    attributedString3.addAttributes(boldFontAttribute3 as [String: Any], range: range3)
    publisherNameLabel?.attributedText = attributedString3
  }
  // MARK: IMA SDK methods
  func setUpAdsLoader() {
    adsLoader = IMAAdsLoader(settings: nil)
    adsLoader.delegate = self
  }
  // Initialize ad display container.
  func createAdDisplayContainer() -> IMAAdDisplayContainer {
    // Create our AdDisplayContainer. Initialize it with our videoView as the container. This
    // will result in ads being displayed over our content video.
    if companionView != nil {
      return IMAAdDisplayContainer(adContainer: videoView, companionSlots: [companionSlot!])
    } else {
      return IMAAdDisplayContainer(adContainer: videoView, companionSlots: nil)
    }
  }
  // Register companion slots.
  func setUpCompanions() {
    companionSlot = IMACompanionAdSlot(
      view: companionView,
      width: Int32(companionView.frame.size.width),
      height: Int32(companionView.frame.size.height))
  }
  // Initialize AdsLoader.
  func setUpIMA() {
    if adsManager != nil {
      adsManager!.destroy()
    }
    adsLoader.contentComplete()
    adsLoader.delegate = self
    if companionView != nil {
      setUpCompanions()
    }
  }
  // Request ads for provided tag.
  func requestAdsWithTag(_ adTagUrl: String!) {
    // Create an ad display container for ad rendering.
    var adDisplayContainer = IMAAdDisplayContainer(adContainer: videoView, companionSlots: nil)
    // Create a content playhead so the SDK can track our content for VMAP and ad rules.
    // createContentPlayhead()
    logMessage("Requesting ads")
    // Create an ad request with our ad tag, display container, and optional user context.
    let request = IMAAdsRequest(
      adTagUrl: adTagUrl,
      adDisplayContainer: adDisplayContainer,
      contentPlayhead: contentPlayhead,
      userContext: nil)
    adsLoader!.requestAds(with: request)
  }
  // Notify IMA SDK when content is done for post-rolls.
  @objc func contentDidFinishPlaying(_ notification: Notification) {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if ((notification.object as? AVPlayerItem) == avPlayer!.currentItem) {
      adsLoader.contentComplete()
    }
  }
  // MARK: AdsLoader Delegates
  func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    adsManager = adsLoadedData.adsManager
    adsManager!.delegate = self
    // Create ads rendering settings to tell the SDK to use the in-app browser.
    let adsRenderingSettings = IMAAdsRenderingSettings()
    adsRenderingSettings.webOpenerPresentingController = self
    // Initialize the ads manager.
    adsManager!.initialize(with: adsRenderingSettings)
    NSLog("\(String(describing: adsManager))")
    NSLog("\(adsLoadedData!)")
    NSLog("\(String(describing: adsManager))")
    adPositionsArray = adsManager?.adCuePoints as! [Float]
    for value in (adsManager?.adCuePoints)! {
      print(value)
      NSLog("\(value)")
    }
  }
  func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
    // Something went wrong loading ads. Log the error and play the content.
    logMessage("Error loading ads: \(String(describing: adErrorData.adError.message))")
    isAdPlayback = false
    avPlayer!.play()
  }

  // MARK: AdsManager Delegates

  func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
    logMessage("AdsManager event \(event.typeString!)")
    switch event.type {
    case IMAAdEventType.LOADED:
      adsManager.start()
    case IMAAdEventType.PAUSE:
      print("pause")
    case IMAAdEventType.RESUME:
      print("resume")
    case IMAAdEventType.TAPPED:
      print("Ad tapped")
    case IMAAdEventType.SKIPPED:
      print("Ad skipped")
      print(event.adData)
    default:
      break
    }
  }
  func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
    // Something went wrong with the ads manager after ads were loaded. Log the error and play the
    // content.
    logMessage("AdsManager error: \(error.message!)")
    isAdPlayback = false
    avPlayer!.play()
  }
  func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
    // The SDK is going to play ads, so pause the content.
    isAdPlayback = true
    avPlayer!.pause()
  }
  func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
    // The SDK is done playing ads (at least for now), so resume the content.
    isAdPlayback = false
    avPlayer!.play()
  }
  // MARK: Utility methods
  func logMessage(_ log: String!) {
    // consoleView.text = consoleView.text + ("\n" + log)
    NSLog(log)
    //        if (consoleView.text.characters.count > 0) {
    //            let bottom = NSMakeRange(consoleView.text.characters.count - 1, 1)
    //            consoleView.scrollRangeToVisible(bottom)
    //        }
  }
  // MARK: facebook share
  @objc func shareToFacebook() {
    let shareContent = LinkShareContent(url: URL(string: String(format:"%@/%@", videoPath, video.video_name!))!)
    // shareContent.contentURL = URL(string: String(format:"%@/%@",videoPath ,video.video_name))
    let shareDialog = ShareDialog(content: shareContent)
    shareDialog.mode = .native
    shareDialog.failsOnInvalidData = true
    shareDialog.completion = { result in
      // Handle share results
    }
    try? shareDialog.show()
  }
  // MARK: Collectionview methods
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videos.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: ChannelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
    let video = videos[indexPath.item]
    cell.thumbnail?.sd_setImage(with:URL(string: String(format: "%@/%@",thumbNailPath ,video.thumbnail!)), placeholderImage: UIImage(named: "menu"))
    let string = String(format: "%@ | %@", video.video_title!, video.video_description!)
    let boldString = String(format: " | %@", video.video_description!)
    //cell.videoLabel?.text = String(format:"%@ | %@", attributedString, normalString)
    let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSFontAttributeName : UIFont.init(name: FontBold, size: 15) as Any])
    let boldFontAttribute: [NSAttributedStringKey: Any] = [NSFontAttributeName as NSString: UIFont.init(name: FontRegular, size: 15) as Any]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute as [String: Any], range: range)
    cell.videoLabel?.attributedText = attributedString
    cell.videoLabel?.textColor = UIColor().commonTextColor()
    cell.keywordLabel?.text = video.video_tag?.uppercased()
    cell.durationLabel?.text = video.video_duration
    cell.keywordLabelWidth?.constant = (cell.keywordLabel?.intrinsicContentSize.width)!+8
    cell.keywordLabel?.layer.cornerRadius = 3
    cell.keywordLabel?.layer.masksToBounds = true
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let video = videos[indexPath.item]
    let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "Player") as! VideoPlayerViewController
    videoPlayerController.video = video
    self.navigationController?.pushViewController(videoPlayerController, animated: true)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      return CGSize(width: (UIScreen.main.bounds.size.width-40)/2, height: 340)
    } else {
      //return CGSize(width: (UIScreen.main.bounds.size.width-82)/2, height: 180)
      return CGSize(width: UIScreen.main.bounds.size.width-32, height: 255)
    }
  }
  //    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
  //        return UIInterfaceOrientationMask.portrait
  //    }
  // MARK: Api methods
  //Get Channel Videos
  func getMoreVideos() {
    //CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    var parameterDict: [String: String?] = [ : ]
  //  parameterDict["video_id"] = String(video.video_id)
   parameterDict["publisher_id"] = "video.user_id"
    ApiCommonClass.getMoreVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in

      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          //CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.videos = responseDictionary["Channels"] as! [VideoModel]
        if self.videos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found" , messageType: "1", delegate: self)
          }
        } else {
          DispatchQueue.main.async {
            self.moreVideosCollectionView.reloadData()
            self.contentViewHieght.constant = CGFloat(self.videos.count) * 255 + self.videoViewHieght.constant + 254
          }
        }
      }
    }
  }
}
