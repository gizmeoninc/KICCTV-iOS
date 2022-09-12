//
//  watchLisCollectionViewCell.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 08/01/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import UIKit
protocol watchListDelegate:class {
  func clickButton(arrayIndex: Int?)
}
class watchLisCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoLabel: UILabel!{
        didSet{
            videoLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
    }
    
    
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var videoImage: UIImageView!
  weak var delegate: watchListDelegate!
  var arrayIndex: Int?
  override func awakeFromNib() {
        super.awakeFromNib()
    self.layoutIfNeeded()
    videoImage.layer.cornerRadius = 8
    videoImage.layer.masksToBounds = true

    }
  override func layoutSubviews() {
    super.layoutSubviews()
    layoutIfNeeded()
    videoImage.layer.cornerRadius = 8.208333333333336/2
    videoImage.layer.masksToBounds = true
  }
  func startAnimate() {
      let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
      shakeAnimation.duration = 0.05
      shakeAnimation.repeatCount = 4
      shakeAnimation.autoreverses = true
      shakeAnimation.duration = 0.2
      shakeAnimation.repeatCount = 99999

      let startAngle: Float = (-2) * 3.14159/180
      let stopAngle = -startAngle

      shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
      shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
      shakeAnimation.autoreverses = true
      shakeAnimation.timeOffset = 290 * drand48()

      let layer: CALayer = self.layer
      layer.add(shakeAnimation, forKey:"animate")
     // removeBtn.isHidden = false
  }
  func stopAnimate() {
      let layer: CALayer = self.layer
      layer.removeAnimation(forKey: "animate")
      self.closeButton.isHidden = true
  }
  @IBAction func closeButtonAction(_ sender: Any) {
    self.delegate.clickButton(arrayIndex :arrayIndex)
  }
}
