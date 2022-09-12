//
//  CategoryTableViewCell.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 25/02/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import UIKit

protocol CategoryTableViewCellDelegate:class {
  func didSelectCategory(passModel :VideoModel)

}

class CategoryTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet weak var categoryCollectionView: UICollectionView!
  weak var delegate: CategoryTableViewCellDelegate!
  var featuredVideos: [VideoModel]? {
    didSet{
      categoryCollectionView.reloadData()
      self.layoutIfNeeded()
    }
  }
    @IBOutlet weak var PartnerLabel: UILabel!{
        didSet{
          if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            PartnerLabel.font = UIFont.init(name: "Helvetica-Bold", size: 27)
          } else {
            PartnerLabel.font = UIFont.init(name: "Helvetica-Bold", size: 22)
          }
        }
    }
    override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    categoryCollectionView.register(UINib(nibName: "categoryCircleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCircleCollectionViewCell")
    categoryCollectionView.delegate = self
    categoryCollectionView.dataSource = self
    categoryCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    featuredVideos = []
         startTimer()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("count",featuredVideos?.count)
    return featuredVideos!.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCircleCollectionViewCell", for: indexPath as IndexPath) as! categoryCircleCollectionViewCell
    if let image = featuredVideos![indexPath.row].image {
    cell.videoImage.sd_setImage(with: URL(string: ((imageUrl + image).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
    }
    cell.layer.cornerRadius = 8
    cell.layer.masksToBounds = true
    cell.partnerDescriptionLabel.text = featuredVideos![indexPath.row].description
    cell.backgroundColor = ThemeManager.currentTheme().grayImageColor
      //cell.videoImage.image = UIImage(named: "placeHolder400*333")
      cell.videoName.text = featuredVideos![indexPath.row].name
        cell.videoImage.backgroundColor = .clear
      cell.videoName.isHidden = false
      if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        cell.videoName.font = UIFont.init(name: "Rockwell-Bold", size: 20)
      } else {
        cell.videoName.font = UIFont.init(name: "Rockwell-Bold", size: 16)
      }
      
    
    cell.layoutIfNeeded()
//    cell.videoImage.layer.masksToBounds = true
//    cell.videoImage.layer.borderWidth = 2
//    cell.videoImage.layer.borderColor = ThemeManager.currentTheme().UIImageColor.cgColor
//    cell.videoImage.layer.cornerRadius = cell.videoImage.bounds.width / 2
//    cell.videoImage.layer.cornerRadius = cell.videoImage.frame.height/2
    return cell
  }
     // Mark Functions
      @objc func scrollToNextCell(){
        //get Collection View Instance
        categoryCollectionView.isPagingEnabled = true
        let cellSize = CGSize(width: frame.width, height: 250.0)
        //get current content Offset of the Collection view
        let contentOffset = categoryCollectionView.contentOffset;
        //scroll to next cell
        if self.categoryCollectionView.contentSize.width <= self.categoryCollectionView.contentOffset.x + cellSize.width {
            self.categoryCollectionView.scrollRectToVisible(CGRect(x: 0 , y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false)
        }else {
            self.categoryCollectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width , y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
    }
      func startTimer() {
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(CategoryTableViewCell.scrollToNextCell), userInfo: nil, repeats: true);
      }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        return CGSize(width: self.frame.width/2, height: 350)
    } else {
      return CGSize(width: self.frame.width/2, height: 150)
    }
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate.didSelectCategory(passModel: featuredVideos![indexPath.item])
  }
}
