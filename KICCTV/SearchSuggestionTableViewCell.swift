//
//  SearchSuggestionTableViewController.swift
//  KICCTV
//
//  Created by Firoze Moosakutty on 28/06/22.
//  Copyright © 2022 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

class SearchSuggestionTableViewCell: UITableViewCell {
  @IBOutlet weak var searchSuggestionLabel:UILabel!

  @IBOutlet weak var magnifierImage: UIImageView!{
    didSet{
      magnifierImage.setImageColor(color: .darkGray)
    }
}

  @IBOutlet weak var arrowImage: UIImageView!{
    didSet{
        arrowImage.setImageColor(color: .darkGray)
    }
}

  override func awakeFromNib() {
          super.awakeFromNib()
        self.layoutIfNeeded()
          // Initialization code
      }
  override func layoutSubviews() {
  super.layoutSubviews()
  layoutIfNeeded()
//    print("Magnifier")
//    magnifierImage.tintColor = .white
//    arrowImage.tintColor = .white
     if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
         searchSuggestionLabel.font = UIFont(name: "Helvetica", size: 18)
     }
  }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }


  }
