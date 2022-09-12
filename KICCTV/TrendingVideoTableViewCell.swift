//
//  TrendingVideoTableViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 06/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
protocol TrendingVideoTableViewCellDelegate:class {
    func didSelectTrending(passModel :VideoModel)
  
}

class TrendingVideoTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var flag = true
    @IBOutlet weak var topGradientView: UIView!
    
  @IBOutlet weak var treandingVideoCollecctionView: UICollectionView!
  weak var delegate: TrendingVideoTableViewCellDelegate!
  var channelType = ""
  var featuredVideos: [VideoModel]? {
    didSet{
      treandingVideoCollecctionView.reloadData()
    

          self.layoutIfNeeded()
    }
  }
    var width = CGFloat()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      treandingVideoCollecctionView.register(UINib(nibName: "TrendingVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "trendingCollectionCell")
        treandingVideoCollecctionView.register(UINib(nibName: "FilmCollectionViewcell", bundle: nil), forCellWithReuseIdentifier: "FilmCollectionCell")
      treandingVideoCollecctionView.delegate = self
      treandingVideoCollecctionView.dataSource = self
      treandingVideoCollecctionView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor

        featuredVideos = []
        if channelType == "FilmOfTheDay"{
        }
        else{
            startTimer()

        }
        treandingVideoCollecctionView.isPagingEnabled = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  // Mark Functions
  @objc func scrollToNextCell(){
    //get Collection View Instance
    treandingVideoCollecctionView.isPagingEnabled = true
    let cellSize = CGSize(width: frame.width, height: 230.0)
    //get current content Offset of the Collection view
    let contentOffset = treandingVideoCollecctionView.contentOffset;
    
    
    //scroll to next cell
    if self.treandingVideoCollecctionView.contentSize.width <= self.treandingVideoCollecctionView.contentOffset.x + cellSize.width {
        self.treandingVideoCollecctionView.scrollRectToVisible(CGRect(x: 0 , y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false)
    }else {
        self.treandingVideoCollecctionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width , y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false)
    }

    


   
}
  func startTimer() {
    Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(TrendingVideoTableViewCell.scrollToNextCell), userInfo: nil, repeats: true);
  }
  
  // MARK: Collectionview
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if channelType == "FilmOfTheDay"{
        if featuredVideos!.count > 0{
            return 1
        }
        else{
            return 0
        }
    }
    else{
        return featuredVideos!.count
    }
  }
    
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if channelType == "FilmOfTheDay"{
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
    else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCollectionCell", for: indexPath as IndexPath) as! TrendingVideoCollectionViewCell
        if featuredVideos![indexPath.row].logo_thumb != nil {
            cell.trendingImageLogo.sd_setImage(with: URL(string: ((featuredVideos![indexPath.row].logo_thumb)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        } else {
            cell.trendingImageLogo.image = UIImage(named: "landscape_placeholder")
        }
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        cell.sizeWidth = frame.width
        cell.pageController.numberOfPages = featuredVideos!.count
        cell.pageController.isHidden = true
        cell.pageController.currentPage = indexPath.row
        cell.pageNumberLabel.text = "\(indexPath.row + 1) . \(featuredVideos!.count)"
        if let category_name = self.featuredVideos![indexPath.row].category_name{
          if !category_name.isEmpty {
            var name = ""
            for categoryListArray in category_name {
              print(categoryListArray)
                if name.isEmpty {
                    name = (categoryListArray)
                }
                else{
                    name =  name + " • " + (categoryListArray)

                }

            }
            let keywords = String(name)
            cell.categoryLabel.text = keywords
           print("encoded url",keywords)

          }
        }

        if  featuredVideos![indexPath.row].show_name != nil {
            cell.showName.text = featuredVideos![indexPath.row].show_name?.uppercased()
        } else {
            cell.showName.text = ""
        }
        return cell


      
    }
    
   
}
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if channelType == "FilmOfTheDay"{
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {

            let width = (frame.width )
            let height1 = width * 9 / 16
            return CGSize(width: width, height: height1)
        } else {
            let width = (frame.width - 2)
            let height = frame.height
            return CGSize(width: width, height: height)
        }
    }else{
        let width = (UIScreen.main.bounds.width)
        let height = width * 9 / 16
        return CGSize(width:width , height: height)

    }
    
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     delegate.didSelectTrending(passModel: featuredVideos![indexPath.item])
}

 
}



class GradientView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        gradientLayer.colors = [UIColor.white.cgColor,UIColor.red.withAlphaComponent(0.5).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.addSublayer(gradientLayer)
    }
}
