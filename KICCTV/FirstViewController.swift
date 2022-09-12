//
//  FirstViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 14/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import GoogleInteractiveMediaAds
import FBSDKShareKit
import FacebookShare
import SummerSlider
import SDWebImage
import SideMenu
class FirstViewController: UIViewController, IMAAdsManagerDelegate, IMAAdsLoaderDelegate,UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  // MARK: -Outlets
  
  @IBOutlet weak var titleViewTopConstaint: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var liveStreamView: UIView!
  @IBOutlet weak var videoPlaybackSlider: SummerSlider!
  @IBOutlet weak var fullscreenButton: UIButton!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var videoView: UIView!
  @IBOutlet weak var companionView: UIView!
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var videotableviewHeight: NSLayoutConstraint!
  @IBOutlet weak var videoListingTableview: UITableView!
  
  @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
  // MARK: Property declaration
  var videos = [VideoModel]()
  var popularVideos = [VideoModel]()
  var channelVideos = [VideoModel]()
  let playerViewController = AVPlayerViewController()
  var avPlayer: AVPlayer? = AVPlayer()
  var contentPlayerLayer: AVPlayerLayer?
  var observer: Any!
  var video: VideoModel!
  var contentPlayhead: IMAAVPlayerContentPlayhead?
  var adsLoader: IMAAdsLoader!
  var adsManager: IMAAdsManager?
  var companionSlot: IMACompanionAdSlot?
  // Tracking for play/pause.
  var isAdPlayback = false
  let playerItem: AVPlayerItem? = nil
  var videoHeight = CGFloat()
  var adPositionsArray = Array<Float>()
  var first = false
  override func viewDidLoad() {
   super.viewDidLoad()
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
    let value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    
    
     setupSideMenu()
    getHomePopularVideos()
    getAllChannels()
    getHomeVideos()
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "background")
    self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
    }
  override func viewWillDisappear(_ animated: Bool) {
    avPlayer?.pause()
  }
  fileprivate func setupSideMenu() {
      // Define the menus
    SideMenuManager.default.menuWidth = view.frame.width - 100
    SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
   // SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
    //SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        // Set up a cool background image for demo purposes
    SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }

  func setUpContentPlayer() {
        //  let contentUrl = URL(string: String(format:"%@/%@",videoPath ,video.video_name!))
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
     videoHeight = 352
      videoViewHeight?.constant = 352
    } else {
      videoViewHeight?.constant = 252
      videoHeight = 252
//      videoViewHieght.constant = self.view.frame.size.width*0.32
    }
    print(videos[0].live_link)
    let contentUrl = URL(string: String(format: videos[0].live_link!))
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
//           if  isPlaybackLikelyToKeepUp == false{
//           CustomProgressView.showActivityIndicator(userInteractionEnabled:true)
//
//           //Here start the activity indicator inorder to show buffering
//           }else{
//           //stop the activity indicator
//           CustomProgressView.hideActivityIndicator()
//           }
//          print("isPlaybackLikelyToKeepUp: ", isPlaybackLikelyToKeepUp)
//          //do what ever you want with isPlaybackLikelyToKeepUp value, for example, show or hide a activity indicator.
        }
      }
    }
    
    // Size, position, and display the AVPlayer.
    contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: videoHeight )
    videoView.layer.addSublayer(contentPlayerLayer!)
    // Create content playhead
    //        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: avPlayer)
    videoView.bringSubview(toFront: fullscreenButton)
     videoView.bringSubview(toFront: durationLabel)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(VideoPlayerViewController.contentDidFinishPlaying(_:)),
      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
      object: avPlayer!.currentItem)
    durationLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
    durationLabel.layer.cornerRadius = 5
    durationLabel?.layer.masksToBounds = true
    self.durationLabel.text = "00:00"
    avPlayer?.play()
    avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (progressTime) -> Void in
      let seconds = CMTimeGetSeconds(progressTime)
      let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
      let minutesString = String(format: "%02d", Int(seconds / 60))
      print("\(minutesString):\(secondsString)")
      self.durationLabel.text = "\(minutesString):\(secondsString)"
      //lets move the slider thumb
      if let duration = self.avPlayer?.currentItem?.duration {
        print(duration)
        let durationSeconds = CMTimeGetSeconds(duration)
        //self.videoPlaybackSlider.value = Float(seconds / durationSeconds)
        //self.videoPlaybackSlider.setValue(Float(minutesString)!, animated: true)
       // print(self.videoPlaybackSlider.value)
        
      }
    }
  }
   // MARK: Button Actions
  
  @IBAction func fullScreenAction(_ sender: UIButton) {
    if(sender.isSelected){
      sender.isSelected = false
      
      if let delegate = UIApplication.shared.delegate as? AppDelegate {
        delegate.restrictRotation = .portrait
      }
      let value = UIInterfaceOrientation.portrait.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
         titleViewTopConstaint.constant = 20
      titleViewHeight.constant = 60
      //self.contentViewHieght.constant = CGFloat(self.videos.count) * 150 + self.videoViewHieght.constant + videoPlayingViewHeight.constant
   
      videoViewHeight.constant = videoHeight
      self.scrollView.isScrollEnabled = true
      
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: videoViewHeight.constant)
      videoView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: videoViewHeight.constant )
      print("Frame: ", videoView.frame)
      
     contentPlayerLayer?.videoGravity=AVLayerVideoGravityResizeAspect
    }else{
      first = true
      sender.isSelected = true
      if let delegate = UIApplication.shared.delegate as? AppDelegate {
        delegate.restrictRotation = .landscapeRight
      }
      let value = UIInterfaceOrientation.landscapeRight.rawValue
      UIDevice.current.setValue(value, forKey: "orientation")
      //  videoPlayerControllerHeight.constant = self.view.frame.size.height
      scrollView.setContentOffset(.zero, animated: true)
      videoViewHeight.constant = self.view.frame.size.height
      self.scrollView.isScrollEnabled = false
      //self.contentViewHieght.constant = videoPlayingViewHeight.constant
      titleViewTopConstaint.constant = 0
      titleViewHeight.constant = 0
      videoView.frame.size.height = self.view.frame.height
      
    //  contentPlayerLayer!.frame.size.height = self.view.frame.height
        videoView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: videoViewHeight.constant)
      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: videoViewHeight.constant)
     
    print("Frame: ", videoView.frame)
      // moreVideosLabel.isHidden = true
      // moreVideosCollectionView.isHidden = true
      
    contentPlayerLayer?.videoGravity=AVLayerVideoGravityResizeAspect
    }
    
  }

  @IBAction func goToChannelList(_ sender: Any) {
    
    let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "ChannelList") as! ChannelListViewController
  //  videoPlayerController.video = popularVideos[indexPath.item]
    
    //self.present(videoPlayerController, animated: true, completion: nil)
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
  }
  // MARK: Api methods
  //Get Channel Videos
  func getHomeVideos() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    ApiCommonClass .getHome { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.videos = responseDictionary["Channels"] as! [VideoModel]
        print(self.videos)
        if self.videos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {

            CustomProgressView.hideActivityIndicator()
            self.setUpContentPlayer()
            self.setUpAdsLoader()
            //        //facebookShareButton.addTarget(self, action: #selector(shareToFacebook), for: .touchUpInside) //<- use `#selector(...)`
            self.setUpIMA()
            self.requestAdsWithTag(self.videos[0].ad_link)
          }
        }
      }
    }
  }
  func getHomePopularVideos() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    ApiCommonClass .getHomePopularVideos { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.popularVideos = responseDictionary["Channels"] as! [VideoModel]
        print("^^^^^^^^^^^^^^^^^^^^6")
        print(self.popularVideos)
             print("^^^^^^^^^^^^^^^^^^^^6")
        if self.popularVideos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.videoListingTableview.reloadData()
            CustomProgressView.hideActivityIndicator()
          
          }
        }
      }
    }
  }
  
  func getAllChannels() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    var parameterDict: [String: String?] = [ : ]
    parameterDict["channel_id"] = "1"
    print(parameterDict)
    ApiCommonClass .getAllChannels (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.channelVideos = responseDictionary["Channels"] as! [VideoModel]
        print(self.channelVideos)
        if self.channelVideos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.videoListingTableview.reloadData()
            CustomProgressView.hideActivityIndicator()
            
          }
        }
      }
    }
  }
  @IBAction func menuAction(_ sender: Any) {
   // SJSwiftSideMenuController.toggleLeftSideMenu()
  }
  // MARK: TableView
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     if indexPath.section == 0 {
    return 320
     }else{
       return 320
    }
  }
  func numberOfSections(in tableView: UITableView) -> Int {
     return 2
  }
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
    return 1
     }else{
       return 1
    }
   
  }
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 if indexPath.section == 0 {
    let cell = tableView.dequeueReusableCell(withIdentifier: "popularcell", for: indexPath) as! HomePopVideoTableViewCell
    cell.selectionStyle = .none
      cell.popCollectionView.tag = 1
  //  cell.videoCollectionviewHeight.constant = 300
    cell.popCollectionView.reloadData()
    
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as! HomeChannelTableViewCell
  cell.selectionStyle = .none
  cell.homeChannelCollection.tag = 2
//  cell.channelCollectionviewHeight.constant = 300
  cell.homeChannelCollection.reloadData()
      return cell
  }
  }
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
  }
    // MARK: Collectionview
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView.tag == 1{
      return popularVideos.count
    }else{
      return channelVideos.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView.tag == 1
    {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCollectionViewCell", for: indexPath as IndexPath) as! HomePopCollectionViewCell
      
      cell.homePopVideoImage.sd_setImage(with: URL(string: imageUrl + popularVideos[indexPath.row].thumbnail!),
                           placeholderImage:UIImage(named: "no-image02"))
      cell.homePopVideoName.text = popularVideos[indexPath.row].video_title
          cell.homePopVideoNumber.text = popularVideos[indexPath.row].video_tag
     cell.backgroundColor = UIColor.clear
   //cell.videoNameView.layer.cornerRadius = 8.0
       cell.homePopVideoNumber.layer.cornerRadius = 5.0
       cell.homePopVideoNumber.backgroundColor = UIColor.groupTableViewBackground
      cell.videoNameView.layer.backgroundColor = UIColor.white.cgColor
      cell.videoNameView.layer.shadowColor = UIColor.gray.cgColor
      cell.videoNameView.layer.shadowOpacity = 1
      cell.videoNameView.layer.shadowOffset = CGSize.zero
      cell.videoNameView.layer.shadowRadius = 2
       cell.videoNameView.backgroundColor = UIColor.groupTableViewBackground
     // cell.imageview.layer.masksToBounds = true
      return cell
    }else{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCollectionViewCell", for: indexPath as IndexPath) as! HomeChannelCollectionViewCell
      
      cell.channelImages.sd_setImage(with: URL(string: imageUrl + channelVideos[indexPath.row].logo!),
                                         placeholderImage:UIImage(named: "no-image02"))
      cell.channelimageName.text = channelVideos[indexPath.row].channel_name
     
  //    cell.homePopVideoNumber.text = popularVideos[indexPath.row].video_tag
       cell.backgroundColor = UIColor.clear
      //cell.channelview.layer.cornerRadius = 8.0
      cell.channelview.layer.backgroundColor = UIColor.white.cgColor
      cell.channelview.layer.shadowColor = UIColor.gray.cgColor
      cell.channelview.layer.shadowOpacity = 1
      cell.channelview.layer.shadowOffset = CGSize.zero
      cell.channelview.layer.shadowRadius = 2
      cell.channelview.backgroundColor = UIColor.groupTableViewBackground
      // cell.imageview.layer.masksToBounds = true
     
      return cell
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView.tag == 1
    {
      
      
      return 20.0
    }else{
      return 20.0
    }
    
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.tag == 1
    {
      return CGSize(width: 200.0, height: 250.0)


    }else{
  return CGSize(width: 200.0, height:250.0)

    }
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView.tag == 1
    {
   
    let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! PopularVideoPlayerViewController
       avPlayer?.pause()
    videoPlayerController.video = popularVideos[indexPath.item]
   
    //self.present(videoPlayerController, animated: true, completion: nil)
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
    }else{
      let video = channelVideos[indexPath.row].channel_name
       avPlayer?.pause()
      let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "channelVedioPlayer") as! ChannelViewController
      videoPlayerController.video = channelVideos[indexPath.item]
      //self.present(videoPlayerController, animated: true, completion: nil)
      self.navigationController?.pushViewController(videoPlayerController, animated: false)


    }
  }
  // MARK: IMA SDK methods
  func setUpAdsLoader() {
    adsLoader = IMAAdsLoader(settings: nil)
    adsLoader.delegate = self
       videoView.bringSubview(toFront: fullscreenButton)
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
       videoView.bringSubview(toFront: fullscreenButton)
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
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}
extension FirstViewController: UISideMenuNavigationControllerDelegate {
  
  func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
    print("SideMenu Appearing! (animated: \(animated))")
  
  }
  
  func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
    print("SideMenu Appeared! (animated: \(animated))")
  }
  
  func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
    print("SideMenu Disappearing! (animated: \(animated))")
  }
  
  func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
    print("SideMenu Disappeared! (animated: \(animated))")
  }
  
}
