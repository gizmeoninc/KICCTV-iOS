//
//  CategoryCollectionViewCell.swift
//  AUSFLIX
//
//  Created by GIZMEON on 08/11/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var fromFilter = false
    var categoryName: String? {
        didSet {
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    func updateUI() {
        categoryNameLabel.text = categoryName
        self.layer.cornerRadius  =  self.frame.height/2
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    func select(){
        self.backgroundColor = ThemeManager.currentTheme().ThemeColor
        self.categoryNameLabel.textColor = .white
       }

       func deselct(){
           self.backgroundColor = UIColor.lightGray
           self.categoryNameLabel.textColor = .black
       }
}
