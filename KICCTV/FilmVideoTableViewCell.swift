//
//  FilmVideoTableViewCell.swift
//  Justwatchme.tv
//
//  Created by GIZMEON on 28/09/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
//
//  TrendingVideoTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 06/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
protocol FilmVideoTableViewCellDelegate:class {
    func didSelectFilm(passModel :VideoModel)
  
}

class FilmVideoTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var flag = true
    
  @IBOutlet weak  var filmVideoCollecctionView: UICollectionView!
  weak var delegate: FilmVideoTableViewCellDelegate!
  var channelType = ""
  var featuredVideos: [VideoModel]? {
    didSet{
        filmVideoCollecctionView.reloadData()
    

          self.layoutIfNeeded()
    }
  }
    var width = CGFloat()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filmVideoCollecctionView.register(UINib(nibName: "FilmCollectionViewcell", bundle: nil), forCellWithReuseIdentifier: "FilmCollectionCell")
        filmVideoCollecctionView.dataSource = self
        filmVideoCollecctionView.delegate = self
        filmVideoCollecctionView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
        featuredVideos = []
        filmVideoCollecctionView.isPagingEnabled = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

  
  
  // MARK: Collectionview
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if featuredVideos!.count > 0{
            return 1
        }
        else{
            return 0
        }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCollectionCell", for: indexPath as IndexPath) as! FilmCollectionViewCell
        cell.gradientViewHeight.constant = 200
        print("width for cell",width)
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if featuredVideos![indexPath.row].logo_thumb != nil {
                cell.imageView.sd_setImage(with: URL(string: ((imageUrl + featuredVideos![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            } else {
                cell.imageView.image = UIImage(named: "landscape_placeholder")
            }

        } else {
            if featuredVideos![indexPath.row].logo != nil {
                cell.imageView.sd_setImage(with: URL(string: ((imageUrl + featuredVideos![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            } else {
                cell.imageView.image = UIImage(named: "landscape_placeholder")
            }
        }
       
        if  featuredVideos![indexPath.row].show_name != nil {
            let title = featuredVideos![indexPath.row].show_name!
            cell.showNameLabel.text? = title.uppercased()
        } else {
            cell.showNameLabel.text = ""
        }
        cell.headerLabel.text = "FILM OF THE WEEK"
        if let director = featuredVideos![indexPath.item].director,let year = featuredVideos![indexPath.item].year{
            cell.meatadataLabel.text = "\(director.uppercased())   \(year)"

        }
        if let synopsis = featuredVideos![indexPath.item].synopsis{
            cell.synopsisLabel.text = synopsis
        }
       return cell
}
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {

            let width = (frame.width )
            let height1 = width * 9 / 16
            return CGSize(width: width, height: height1)
        } else {
            let width = (frame.width - 2)
            let height = frame.height
            return CGSize(width: width, height: height)
        }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     delegate.didSelectFilm(passModel: featuredVideos![indexPath.item])
}

 
}




