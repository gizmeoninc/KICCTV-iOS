//
//  CastCollectionViewCell.swift
//  Justwatchme.tv
//
//  Created by GIZMEON on 26/07/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import  UIKit
class CastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {

             self.name.font = UIFont.init(name: "Poppins-SemiBold", size: 20)
            } else {
             
            }
        }
    }
    @IBOutlet weak var role: UILabel!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {

             self.role.font = UIFont.init(name: "Poppins-SemiBold", size: 16)
            } else {
             
            }
        }
    }
    @IBOutlet weak var imageHeight: NSLayoutConstraint!{
        didSet{
           
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.imageHeight.constant =  300
            } else {
                self.imageHeight.constant = 136
                
            }
        }
    }
    override func awakeFromNib() {
      super.awakeFromNib()
    }
}
