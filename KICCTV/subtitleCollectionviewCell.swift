//
//  subtitleCollectionviewCell.swift
//  Discover
//
//  Created by GIZMEON on 03/06/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//


import Foundation
import UIKit
class subtitleCollectionviewCell: UICollectionViewCell {
    
    @IBOutlet weak var languageName: UILabel!
    @IBOutlet weak var checkButton: UIButton!{
        didSet{
            self.checkButton.isHidden = true
        }
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
    }
    override func layoutSubviews() {
      super.layoutSubviews()
      layoutIfNeeded()
     
    }
}
