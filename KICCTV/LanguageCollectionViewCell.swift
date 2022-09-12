//
//  LanguageCollectionViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 11/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit

class LanguageCollectionViewCell: UICollectionViewCell {

  func toggleSelected() {
      languageIcon.frame =   CGRect(x: 16, y: 40, width: frame.width - 32, height: frame.height - 60)
      languageNAme.textColor = UIColor.red
      selectionView.isHidden = false
      self.selectionView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
      selectedImage.isHidden = false
  }
  func defaultSelected(value : Bool){
    if(value){
       languageIcon.frame =   CGRect(x: 16, y: 40, width: frame.width - 32, height: frame.height - 60)
       selectedImage.image = UIImage(named: "favorite")
    } else {
      languageIcon.frame =   CGRect(x: 8.0, y: 37.0, width: frame.width - 16, height: frame.height - 50)
      selectedImage.image = UIImage(named: "avorite-filled")
    }
  }
  @IBOutlet weak var laanguageView: UIView!
  @IBOutlet weak var selectedImage: UIImageView!
  @IBOutlet weak var selectionView: UIView!
  @IBOutlet weak var languageButton: UIButton!
  @IBOutlet weak var languageIcon: UIImageView!
  @IBOutlet weak var languageNAme: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
    selectedImage.isHidden = false
    laanguageView.layer.cornerRadius = 8.0
    laanguageView.layer.masksToBounds = true
        // Initialization code
    }

}
