//
//  PoppoPlayer.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 31/07/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import AVKit

protocol PoppoPlayerDelegate: class {
  func fullScreenPressed()
}

class PoppoPlayer: UIView, UIGestureRecognizerDelegate {
  var player = AVPlayer()
  var playerLayer = AVPlayerLayer() {
    didSet {
      playerLayer.frame = bounds
      playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
  }
  //    var observer:Any!
  weak var delegate: PoppoPlayerDelegate?
  var controlsHidden = false
  var tappedValue: Int = 1
  @IBOutlet var contentView: UIView!{
    didSet {
      contentView.backgroundColor = .black
    }
  }
  @IBOutlet weak var playerView: UIView! {
    didSet {
      playerView.backgroundColor = .clear
    }
  }
  @IBOutlet weak var controlsView: UIView! {
    didSet {
      controlsView.backgroundColor = .clear
    }
  }
  @IBOutlet weak var backgroundView: UIView! {
    didSet {
      backgroundView.backgroundColor = .black
      backgroundView.isHidden = false
    }
  }
  @IBOutlet weak var centerView: UIView!
  @IBOutlet weak var loader: UIActivityIndicatorView! {
    didSet {
      loader.startAnimating()
    }
  }
  @IBOutlet weak var playButton: UIButton! {
    didSet {
      playButton.isHidden = true
      playButton.setImage(UIImage(named: "play"), for: .normal)
    }
  }
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var progressBar: UISlider!{
    didSet {
      progressBar.minimumTrackTintColor = .blue
      progressBar.maximumTrackTintColor = .clear
      progressBar.value = 0
      progressBar.addTarget(self, action: #selector(playbackSliderValueChanged), for: .valueChanged)
    }
  }
  @IBOutlet weak var bufferBar: UIProgressView! {
    didSet {
      bufferBar.progressTintColor = .white
      bufferBar.trackTintColor = .clear
      bufferBar.progress = 0
    }
  }
  @IBOutlet weak var progressDurationLabel: UILabel!
  @IBOutlet weak var fullScreenButton: UIButton! {
    didSet {
      fullScreenButton.addTarget(self, action: #selector(fullScreenButtonPressed), for: .touchUpInside)
    }
  }
  var isPlaying = false
  var videoType = ""
  @IBAction func playPauseAction(_ sender: Any) {
    if isPlaying {
      self.pause()
      //            self.player.pause()
      //            playButton.setImage(UIImage(named: "play"), for: .normal)
    } else {
      if ScreenRecordingDetector.shared.isRecording() {
        AppHelper.showAlertMessage(vc: UIApplication.topViewController()!, title: "WARNING", message: "Please stop video recording to play PoppoTV")
      } else {
        self.resume()
      }
      //            if self.videoType == "VOD"{
      //
      //                self.findTappedValue()
      //
      //            }
      //            self.player.play()
      //            playButton.setImage(UIImage(named: "pause"), for: .normal)
    }
    //        isPlaying = !isPlaying
  }


  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  private func commonInit() {
    Bundle.main.loadNibNamed("PoppoPlayer", owner: self, options: nil)
    self.addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.playerView.layer.addSublayer(playerLayer)
    self.playerLayer.player = self.player
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.videoTapped(_:)))
    tapGesture.delegate = self
    controlsView.addGestureRecognizer(tapGesture)
  }
  func pause() {
    self.player.pause()
    playButton.setImage(UIImage(named: "play"), for: .normal)
    self.isPlaying = false

  }
  func resume() {
    if self.videoType == "VOD" {
      self.findTappedValue()
    }
    self.player.play()
    playButton.setImage(UIImage(named: "pause"), for: .normal)
    self.isPlaying = true

  }

  func load(url: URL) {
    let headers = ["token": "1234"]
    let _: AVURLAsset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
    let playerItem = AVPlayerItem(url: URL(string: "https://content.uplynk.com/channel/e1e04b2670174e93b5d5499ee73de095.m3u8?ad=perpetualmedia")!)
    //        let playerItem:AVPlayerItem = AVPlayerItem(asset: asset)
    player.replaceCurrentItem(with: playerItem)
    playerLayer = AVPlayerLayer(player: player)
    self.playerView.layer.insertSublayer(playerLayer, at: 0)
    self.bringSubviewToFront(controlsView)
    self.sendSubviewToBack(playerView)
    //        self.insertSubview(<#T##view: UIView##UIView#>, at: <#T##Int#>)
    player.play()

    player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (progressTime) -> Void in
      if let currentItem = self.player.currentItem {
        if self.videoType == "" {
          self.checkVideoType()
        }
        if currentItem.status == AVPlayerItem.Status.readyToPlay {
          if currentItem.isPlaybackLikelyToKeepUp {
            //                        print("Playing ")
            if ScreenRecordingDetector.shared.isRecording() {
              self.pause()
              AppHelper.showAlertMessage(vc: UIApplication.topViewController()!, title: "WARNING", message: "Please stop video recording to play PoppoTV")
            }
            //                        else{
            //                            self.resume()
            //                        }
            self.hideLoader()
            //                       self.controlsHidden = false
          } else if currentItem.isPlaybackBufferEmpty {
            //                        print("Buffer empty - show loader")
            self.showLoader()
            //                        self.controlsHidden = true
          } else if currentItem.isPlaybackBufferFull {
            //                        print("Buffer full - hide loader")
            self.hideLoader()
            //                        self.controlsHidden = false
          } else {
            //                        print("Buffering ")
            self.showLoader()
            //                        self.controlsHidden = true
          }
        } else if currentItem.status == AVPlayerItem.Status.failed {
          //                    print("Failed ")
        } else if currentItem.status == AVPlayerItem.Status.unknown {
          //                    print("Unknown ")
          self.showLoader()
          //                    self.controlsHidden = true

        }
      } else {
        print("avPlayer.currentItem is nil")
      }
      if self.videoType == "LIVE" {
        self.progressBar.isHidden = true
        self.progressDurationLabel.isHidden = true
        self.bufferBar.isHidden = true
      } else if self.videoType == "VOD" {
        let seconds = CMTimeGetSeconds(progressTime)
        let secondsValue = Int(seconds .truncatingRemainder(dividingBy: 60))
        let minutesValue = Int(seconds / 60)
        let secondsString = String(format: "%02d", secondsValue)
        let minutesString = String(format: "%02d", minutesValue)
        self.progressDurationLabel.text = "\(minutesString):\(secondsString)"
        //            let time = self.getLiveDuration()
        //            print("TIME: ", time)
        //lets move the slider thumb
        if let duration = self.player.currentItem?.duration {
          let durationSeconds = CMTimeGetSeconds(duration)
          self.progressBar.value = Float(seconds / durationSeconds)
          if !self.controlsHidden && minutesValue + secondsValue == self.tappedValue + 3 {
            self.hideControls()
            self.controlsHidden = true
          }
        }
        if let range = self.player.currentItem?.loadedTimeRanges.first?.timeRangeValue {
          let startTime = CMTimeGetSeconds(range.start)
          let loadedDuration = CMTimeGetSeconds(range.duration)
          let duration = CMTimeGetSeconds((self.player.currentItem?.duration)!)
          self.bufferBar.progress = Float( (startTime+loadedDuration) / duration)
        }
      }
    }
  }
  private func checkVideoType() {
    if let playbackType = self.player.currentItem?.accessLog()?.events.first?.playbackType {
      videoType = playbackType
    }
  }
  private func showLoader() {
    if self.loader.isHidden {
      self.loader.startAnimating()
      self.playButton.isHidden = true
      self.loader.isHidden = false
    }
  }
  private func hideLoader() {
    if !self.loader.isHidden {
      self.loader.stopAnimating()
      self.playButton.isHidden = false
      self.playButton.setImage(UIImage(named: "pause"), for: .normal)
      self.loader.isHidden = true
    }
  }
  private func showControls() {
    //        self.controlsView.isHidden = false
    self.backgroundView.backgroundColor = .black
    self.progressBar.setThumbImage(UIImage(named: ""), for: .normal)
    self.playButton.isHidden = false
    self.progressDurationLabel.isHidden = false
    self.fullScreenButton.isHidden = false
    //        self.controlsHidden = false
  }

  private func hideControls() {
    //        self.controlsView.isHidden = true
    self.backgroundView.backgroundColor = .clear
    self.progressBar.setThumbImage(UIImage(), for: .normal)
    self.playButton.isHidden = true
    self.progressDurationLabel.isHidden = true
    self.fullScreenButton.isHidden = true
    //        self.controlsHidden = true
  }
  @objc private func videoTapped(_ sender: UITapGestureRecognizer) {
    if self.videoType == "VOD"{
      print("Tapped")
      print(controlsHidden)
      if controlsHidden {
        self.findTappedValue()
        self.showControls()
      } else {
        self.hideControls()
      }
      controlsHidden = !controlsHidden
    }
  }
  @objc private func playbackSliderValueChanged() {
    //        print(progressBar.value)
    if let duration = self.player.currentItem?.duration {
      if progressBar.value > bufferBar.progress {
        self.showLoader()
      }
      let totalSeconds = CMTimeGetSeconds(duration)
      let value = Float64(progressBar.value) * totalSeconds
      let seekTime = CMTime(value: Int64(value), timescale: 1)
      self.player.seek(to: seekTime)
    }

  }
  @objc private func fullScreenButtonPressed() {
    self.delegate?.fullScreenPressed()
  }
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view is UISlider {
      return false
    }
    return true
  }
  private func findTappedValue() {
    let duration = self.player.currentItem?.duration
    let durationSeconds = CMTimeGetSeconds(duration!)
    let seconds = self.progressBar.value * Float(durationSeconds)
    let secondsValue = Int(seconds .truncatingRemainder(dividingBy: 60))
    let minutesValue = Int(seconds / 60)
    self.tappedValue = secondsValue + minutesValue
  }
    func getLiveDuration() -> Float {
   var result : Float = 0.0;

   if let items = player.currentItem?.seekableTimeRanges {

   if(!items.isEmpty) {
   let range = items[items.count - 1]
   let timeRange = range.timeRangeValue
   let startSeconds = CMTimeGetSeconds(timeRange.start)
   let durationSeconds = CMTimeGetSeconds(timeRange.duration)
   result = Float(startSeconds + durationSeconds)
   //
   //                print("startSeconds: ", startSeconds)
   //                print("durationSeconds: ", durationSeconds)
   //                print("result: ", result)
   }

   }
   return result;
   }
}
