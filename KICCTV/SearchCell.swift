//
//  SearchCell.swift
//  HappiTv
//
//  Created by GIZMEON on 03/11/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class SearchCell: UICollectionViewCell {
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var ImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    self.layoutIfNeeded()
    }
    override func layoutSubviews() {
      super.layoutSubviews()
      layoutIfNeeded()
      
    }
}
