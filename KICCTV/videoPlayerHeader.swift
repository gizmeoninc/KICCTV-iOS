//
//  videoPlayerHeader.swift
//  PoppoTv
//
//  Created by Firoze Moosakutty on 27/04/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
protocol VideoheaderViewDelegate:class {
    func didClickDropDown(flag :Bool)
    func didClickProducerName(producerName:String)
    func didClickTheme(ThemeId: String)


}
class videoPlayerHeader: UICollectionReusableView {

  @IBOutlet weak var view: UIView!
  @IBOutlet weak var metaDataView: UIView!
  @IBOutlet weak var discriptionlabelHeight: NSLayoutConstraint!
  @IBOutlet weak var discriptionLabel: UILabel!
  @IBOutlet weak var dropDownButton: UIButton!
  @IBOutlet weak var programeLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var releseDateLabel: UILabel!
  @IBOutlet weak var producerName: UILabel!
  @IBOutlet weak var ThemeLabel: UILabel!
  @IBOutlet weak var AudioLabel: UILabel!
  @IBOutlet weak var SubtitleLabel: UILabel!
  @IBOutlet weak var MoreVideosLabel: UILabel!

  var pointsArr = Array<String>()
  var LabelDict: [String: NSRange?] = [ : ]

  var descriptionLabelHeight = CGFloat()
  weak var delegate: VideoheaderViewDelegate!
    var replacedString = ""
  override func awakeFromNib() {
    super.awakeFromNib()

       view.backgroundColor = .black
       //videoDiscriptionlabel.isHidden = false
        if Application.shared.selectedVideoModel.video_title != nil {
            programeLabel.text = Application.shared.selectedVideoModel.video_title!
        }
        if Application.shared.selectedVideoModel.resolution != nil {
          durationLabel.text = Application.shared.selectedVideoModel.resolution!

        }
        if Application.shared.selectedVideoModel.producer != nil {
     //     producerName.text =  self.Application.shared.selectedVideoModel.producer!
          let underlineAttribute = [NSAttributedString.Key.foregroundColor: UIColor().colorFromHexString("148ABF")]
          let underlineAttributedString = NSAttributedString(string: Application.shared.selectedVideoModel.producer!, attributes: underlineAttribute)
          producerName.attributedText = underlineAttributedString
        }
        if Application.shared.selectedVideoModel.year != nil {
          releseDateLabel.text = Application.shared.selectedVideoModel.year!
        }
        if Application.shared.selectedVideoModel.audio != nil {
          SubtitleLabel.text = Application.shared.selectedVideoModel.audio!
        }
        if Application.shared.selectedVideoModel.subtitle != nil {
          AudioLabel.text = Application.shared.selectedVideoModel.subtitle!
        }
        discriptionLabel.numberOfLines = 0
        discriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        let text  = "Synopsis\n" + Application.shared.selectedVideoModel.video_description!

        let amountText = NSMutableAttributedString.init(string: text)
        amountText.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                  NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor],
                                 range: NSMakeRange(0, 8))
        discriptionLabel.attributedText = amountText

        discriptionLabel.backgroundColor = ThemeManager.currentTheme().backgroundColor
        MoreVideosLabel.textColor = ThemeManager.currentTheme().UIImageColor
        MoreVideosLabel.text = "You may also like"

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        producerName.isUserInteractionEnabled = true
        producerName.addGestureRecognizer(tap)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
        ThemeLabel.isUserInteractionEnabled = true
        ThemeLabel.addGestureRecognizer(tapGesture)



    self.metaDataView.isHidden = false
    self.dropDownButton.isHidden = true

    }
  @IBAction func dropdownbutton(_ sender: UIButton) {
    if(sender.isSelected){
      sender.isSelected = false
      UIView.animate(withDuration:0.5, animations: {
        self.dropDownButton.transform = CGAffineTransform.identity
      })
      UIView.animate(withDuration:0.5, animations: {
        self.self.metaDataView.isHidden = true
        self.discriptionlabelHeight.constant =  0
      })
        delegate.didClickDropDown(flag: true)
    }else {
      sender.isSelected = true
      UIView.animate(withDuration:0.5, animations: {
        self.dropDownButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
      })
      let font = UIFont.systemFont(ofSize:12)
      descriptionLabelHeight = discriptionLabel.heightForLabel(text: discriptionLabel.text!, font: font, width: view.frame.width - 16) + 110
      UIView.animate(withDuration:0.5, animations: {
        self.discriptionlabelHeight.constant =   CGFloat(self.descriptionLabelHeight)
        self.metaDataView.isHidden = false
        self.discriptionLabel.text = "fdg"
      })
    delegate.didClickDropDown(flag: false)
    }
  }
 @objc func tapFunction(sender:UITapGestureRecognizer) {
    delegate.didClickProducerName(producerName: Application.shared.selectedVideoModel.producer!)

 }
  @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
//       if let label = gesture.view as? UILabel {
//         let underlineAttriString = NSMutableAttributedString(string: Application.shared.selectedVideoModel.theme!)
//        pointsArr = Application.shared.selectedVideoModel.theme!.components(separatedBy: ",")
//         pointsArr.forEach { point in
//           let range = (Application.shared.selectedVideoModel.theme! as NSString).range(of: point, options: .caseInsensitive)
//           underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
//           if gesture.didTapAttributedTextInLabel(label: label, inRange: range) {
//             //let result =   self.categoryVideos.filter({$0.category == "Movie"}).first?.categoryid
//             let String = self.LabelDict.filter({$0.value == range})
//             print(String)
//           }
//         }
//       }
     }
}
