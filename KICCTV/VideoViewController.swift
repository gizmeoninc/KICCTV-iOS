//
//  VideoViewController.swift
//  MyVideoApp
//
//  Created by Gizmeon on 14/02/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Foundation

import GoogleInteractiveMediaAds
class VideoViewController: UIViewController, IMAAdsManagerDelegate, AVPictureInPictureControllerDelegate, IMAAdsLoaderDelegate {
  @IBOutlet weak var videoTitleLabel: UILabel!
  @IBOutlet weak var videoDescriptionLabel: UILabel!
  @IBOutlet weak var videoView: UIView!
  @IBOutlet weak var videoControls: UIToolbar!
  @IBOutlet weak var playheadButton: UIButton!
  @IBOutlet weak var playheadTimeText: UITextField!
  @IBOutlet weak var durationTimeText: UITextField!
  @IBOutlet weak var progressBar: UISlider!
  @IBOutlet weak var pictureInPictureButton: UIButton!
  @IBOutlet weak var companionView: UIView!
  @IBOutlet weak var consoleView: UITextView!
  @IBAction func backAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  // Input field for ad tag pop-up.
  @IBOutlet weak var tagInput: UITextField?
  // Tracking for play/pause.
  var isAdPlayback = false
  // Play/Pause buttons.
  var playBtnBG = UIImage(named: "play.png")
  var pauseBtnBG = UIImage(named: "pause.png")
  // Gesture recognizer for tap on video.
  var videoTapRecognizer: UITapGestureRecognizer?
  // PiP objects.
  var pictureInPictureController: AVPictureInPictureController?
  var pictureInPictureProxy: IMAPictureInPictureProxy?
  // IMA SDK handles.
  var contentPlayhead: IMAAVPlayerContentPlayhead?
  var adsLoader: IMAAdsLoader!
  var adsManager: IMAAdsManager?
  var companionSlot: IMACompanionAdSlot?
  // Content player handles.
  var video: ChannelVideos!
  var contentPlayer: AVPlayer?
  var contentPlayerLayer: AVPlayerLayer?
  var contentRateContext: UInt8 = 1
  var contentDurationContext: UInt8 = 2
  enum PlayButtonType: Int {
    case playButton = 0
    case pauseButton = 1
  }
  // MARK: Set-up methods
  // Set up the new view controller.
  override func viewDidLoad() {
    super.viewDidLoad()
    videoTitleLabel.text=video.video_title
    videoDescriptionLabel.text=video.video_description
    setUpContentPlayer()
    setUpIMA()
    requestAdsWithTag(video.ad_link)
    //        if (video.tag == "custom") {
    //            let tagPrompt = UIAlertController(
    //                title: "Ad Tag",
    //                message: nil,
    //                preferredStyle: UIAlertControllerStyle.alert)
    //            tagPrompt.addTextField(configurationHandler: addTextField)
    //            tagPrompt.addAction(
    //                UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
    //            tagPrompt.addAction(
    //                UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: tagEntered))
    //            present(tagPrompt, animated: true, completion: nil)
    //        } else {
    //            requestAdsWithTag(video.tag)
    //        }
  }
  // Handler when user clicks "OK" on the ad tag pop-up
  func tagEntered(_ alert: UIAlertAction!) {
    requestAdsWithTag(tagInput!.text)
  }
  // Used to create the text field in the language pop-up.
  func addTextField(_ textField: UITextField!) {
    textField.placeholder = ""
    tagInput = textField
  }
  override func viewWillDisappear(_ animated: Bool) {
    contentPlayer!.pause()
    // Don't reset if we're presenting a modal view (e.g. in-app clickthrough).
    if (navigationController!.viewControllers as NSArray).index(of: self) == NSNotFound {
      if adsManager != nil {
        adsManager!.destroy()
        adsManager = nil
      }
      contentPlayer = nil
    }
    super.viewWillDisappear(animated)
  }
  // Initialize the content player and load content.
  func setUpContentPlayer() {
    // Load AVPlayer with path to our content.
    let contentUrl = URL(string: String(format:"%@/%@", videoPath, video.video_name!))
    contentPlayer = AVPlayer(url: contentUrl!)
    // Playhead observers for progress bar.
    let controller: VideoViewController = self
    controller.contentPlayer?.addPeriodicTimeObserver(
      forInterval: CMTimeMake(1, 30),
      queue: nil,
      using: {(time: CMTime) -> Void in
        if self.contentPlayer != nil {
          let duration = controller.getPlayerItemDuration(self.contentPlayer!.currentItem!)
          controller.updatePlayheadWithTime(time, duration: duration)
        }
    })
    contentPlayer!.addObserver(
      self,
      forKeyPath: "rate",
      options: NSKeyValueObservingOptions.new,
      context: &contentRateContext)
    contentPlayer!.addObserver(
      self,
      forKeyPath: "currentItem.duration",
      options: NSKeyValueObservingOptions.new,
      context: &contentDurationContext)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(VideoViewController.contentDidFinishPlaying(_:)),
      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
      object: contentPlayer!.currentItem)
    //        // Set up fullscreen tap listener to show controls
    //        videoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(VideoViewController.showFullscreenControls(_:)))
    //        videoView.addGestureRecognizer(videoTapRecognizer!)
    // Create a player layer for the player.
    contentPlayerLayer = AVPlayerLayer(player: contentPlayer)
    contentPlayerLayer?.videoGravity=AVLayerVideoGravityResizeAspectFill
    // Size, position, and display the AVPlayer.
    contentPlayerLayer!.frame = videoView.layer.bounds
    videoView.layer.addSublayer(contentPlayerLayer!)
    // Create content playhead
    contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: contentPlayer)
    // Set ourselves up for PiP.
    pictureInPictureProxy = IMAPictureInPictureProxy(avPictureInPictureControllerDelegate: self);
    pictureInPictureController = AVPictureInPictureController(playerLayer: contentPlayerLayer!);
    if pictureInPictureController != nil {
      pictureInPictureController!.delegate = pictureInPictureProxy;
    }
    if !AVPictureInPictureController.isPictureInPictureSupported() &&
      pictureInPictureButton != nil {
      pictureInPictureButton.isHidden = true
    }
  }
  // Handler for keypath listener that is added for content playhead observer.
  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey: Any]?,
    context: UnsafeMutableRawPointer?) {
    if context == &contentRateContext && contentPlayer == object as? AVPlayer {
      updatePlayheadState(contentPlayer!.rate != 0)
    } else if (context == &contentDurationContext && contentPlayer == object as? AVPlayer) {
      updatePlayheadDurationWithTime(getPlayerItemDuration(contentPlayer!.currentItem!))
    }
  }
  // MARK: UI handlers
  // Handle clicks on play/pause button.
  @IBAction func onPlayPauseClicked(_ sender: AnyObject) {
    if !isAdPlayback {
      if contentPlayer!.rate == 0 {
        contentPlayer!.play()
      } else {
        contentPlayer!.pause()
      }
    } else {
      if playheadButton.tag == PlayButtonType.playButton.rawValue {
        adsManager!.resume()
        setPlayButtonType(PlayButtonType.pauseButton)
      } else {
        adsManager!.pause()
        setPlayButtonType(PlayButtonType.playButton)
      }
    }
  }
  // Updates play button for provided playback state.
  func updatePlayheadState(_ isPlaying: Bool) {
    setPlayButtonType(isPlaying ? PlayButtonType.pauseButton : PlayButtonType.playButton)
  }
  // Sets play button type.
  func setPlayButtonType(_ buttonType: PlayButtonType) {
    playheadButton.tag = buttonType.rawValue
    playheadButton.setImage(
      buttonType == PlayButtonType.pauseButton ? pauseBtnBG : playBtnBG,
      for: UIControlState())
  }
  // Called when the user seeks.
  @IBAction func playheadValueChanged(_ sender: AnyObject) {
    if !sender.isKind(of: UISlider.self) {
      return
    }
    if !isAdPlayback {
      let slider = sender as! UISlider
      contentPlayer!.seek(to: CMTimeMake(Int64(slider.value), 1))
    }
  }

  // Used to track progress of ads for progress bar.
  func adDidProgressToTime(_ mediaTime: TimeInterval, totalTime: TimeInterval) {
    let time = CMTimeMakeWithSeconds(mediaTime, 1000)
    let duration = CMTimeMakeWithSeconds(totalTime, 1000)
    updatePlayheadWithTime(time, duration: duration)
    progressBar.maximumValue = Float(CMTimeGetSeconds(duration))
  }
  // Get the duration value from the player item.
  func getPlayerItemDuration(_ item: AVPlayerItem) -> CMTime {
    var itemDuration = kCMTimeInvalid
    if (item.responds(to: #selector(getter: CAMediaTiming.duration))) {
      itemDuration = item.duration
    } else {
      if (item.asset.responds(to: #selector(getter: CAMediaTiming.duration))) {
        itemDuration = item.asset.duration
      }
    }
    return itemDuration
  }
  // Updates progress bar for provided time and duration.
  func updatePlayheadWithTime(_ time: CMTime, duration: CMTime) {
    if !CMTIME_IS_VALID(time) {
      return
    }
    let currentTime = CMTimeGetSeconds(time)
    if currentTime.isNaN {
      return
    }
    progressBar.value = Float(currentTime)
    playheadTimeText.text =
      NSString(format: "%d:%02d", Int(currentTime / 60), Int(currentTime.truncatingRemainder(dividingBy: 60))) as String
    updatePlayheadDurationWithTime(duration)
  }
  func updatePlayheadDurationWithTime(_ time: CMTime!) {
    if !time.isValid {
      return
    }
    let durationValue = CMTimeGetSeconds(time)
    if durationValue.isNaN {
      return
    }
    progressBar.maximumValue = Float(durationValue)
    durationTimeText.text = NSString(format: "%d:%02d", Int(durationValue / 60), Int(durationValue.truncatingRemainder(dividingBy: 60))) as String
  }
  @IBAction func videoControlsTouchStarted(_ sender: AnyObject) {
    NSObject.cancelPreviousPerformRequests(
      withTarget: self,
      selector: #selector(VideoViewController.hideFullscreenControls),
      object: self)
  }
  @IBAction func videoControlsTouchEnded(_ sender: AnyObject) {
    startHideControlsTimer()
  }
  func startHideControlsTimer() {
    Timer.scheduledTimer(
      timeInterval: 3,
      target: self,
      selector: #selector(VideoViewController.hideFullscreenControls),
      userInfo: nil,
      repeats: false)
  }
  @objc func hideFullscreenControls() {
    UIView.animate(withDuration: 0.5, animations: {() -> Void in self.videoControls.alpha = 0.0})
  }
  @IBAction func onPipButtonClicked(_ sender: AnyObject) {
    if pictureInPictureController!.isPictureInPictureActive {
      pictureInPictureController!.stopPictureInPicture()
    } else {
      pictureInPictureController!.startPictureInPicture()
    }
  }
  // MARK: IMA SDK methods
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
    logMessage("Requesting ads")
    // Create an ad request with our ad tag, display container, and optional user context.
    let request = IMAAdsRequest(
      adTagUrl: adTagUrl,
      adDisplayContainer: createAdDisplayContainer(),
      avPlayerVideoDisplay: IMAAVPlayerVideoDisplay(avPlayer: contentPlayer),
      pictureInPictureProxy: pictureInPictureProxy,
      userContext: nil)
    adsLoader.requestAds(with: request)
  }
  // Notify IMA SDK when content is done for post-rolls.
  @objc func contentDidFinishPlaying(_ notification: Notification) {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object as? AVPlayerItem) == contentPlayer!.currentItem {
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
  }
  func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
    // Something went wrong loading ads. Log the error and play the content.
    logMessage("Error loading ads: \(adErrorData.adError.message!)")
    isAdPlayback = false
    setPlayButtonType(PlayButtonType.pauseButton)
    contentPlayer!.play()
  }
  // MARK: AdsManager Delegates
  func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
    logMessage("AdsManager event \(event.typeString!)")
    switch (event.type) {
    case IMAAdEventType.LOADED:
      if pictureInPictureController == nil ||
        !pictureInPictureController!.isPictureInPictureActive {
        adsManager.start()
      }
    case IMAAdEventType.PAUSE:
      setPlayButtonType(PlayButtonType.playButton)
    case IMAAdEventType.RESUME:
      setPlayButtonType(PlayButtonType.pauseButton)
    case IMAAdEventType.TAPPED:
      //   showFullscreenControls(nil)
      print("Ad tapped")
      print("Ad ", event.ad)
      print("adData ", event.adData)
      print("description ", event.description)
      print("type ", event.type)
      print("typeString ", event.typeString)
    case IMAAdEventType.SKIPPED:
      print("Ad skipped")
      print(event.adData)
    default:
      break
    }
  }
  func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
    logMessage("AdsManager error: \(String(describing: error.message))")
    isAdPlayback = false
    setPlayButtonType(PlayButtonType.pauseButton)
    contentPlayer!.play()
  }
  func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
    // The SDK is going to play ads, so pause the content.
    isAdPlayback = true
    setPlayButtonType(PlayButtonType.pauseButton)
    contentPlayer!.pause()
  }
  func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
    // The SDK is done playing ads (at least for now), so resume the content.
    isAdPlayback = false
    setPlayButtonType(PlayButtonType.playButton)
    contentPlayer!.play()
  }
  // MARK: Utility methods
  func logMessage(_ log: String!) {
    NSLog(log)
  }
}
