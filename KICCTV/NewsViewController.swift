//
//  NewsViewController.swift
//  KICCTV
//
//  Created by GIZMEON on 18/05/22.
//  Copyright © 2022 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class NewsViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!{
        didSet{
            self.mainView.backgroundColor =  ThemeManager.currentTheme().backgroundColor

        }
    }
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet{
            self.mainScrollView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        }
    }
    
    @IBOutlet weak var playIconHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newsHeadline: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var newsImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newsDescriptionLabel: UILabel!{
        didSet{
            newsDescriptionLabel.textColor = .white
            newsDescriptionLabel.backgroundColor = ThemeManager.currentTheme().backgroundColor
        }
    }
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var newsCollectionViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var playIcon: UIButton!{
        didSet{
            playIcon.isHidden = true
            self.playIcon.layer.cornerRadius = 16
            self.playIcon.clipsToBounds = true
            self.playIcon.layer.borderWidth = 1
            self.playIcon.tintColor = .white
              self.playIcon.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
           self.playIcon.backgroundColor = UIColor(white: 1, alpha: 0.3)
            playIcon.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var newsDescriptionHeight: NSLayoutConstraint!
    var isFromUpcomingEvents = false
    var DescriptionLabelHeight = CGFloat()

    var newsModel = [VideoModel]()
    var multipleNewsImageArray = [String?]()
    var tagArray = [String?]()
    var newsId : Int?
    var eventId : Int?

    var text = ""
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.newsCollectionView.register(UINib(nibName: "EpisodeListCell", bundle: nil), forCellWithReuseIdentifier: "EpisodeCell")
        self.newsCollectionView.delegate = self
        self.newsCollectionView.dataSource = self
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.newsCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.tagCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.newsCollectionView.collectionViewLayout = flowLayout

        navigationTitle()
        if isFromUpcomingEvents{
            getLinearEventDetails(id: eventId)
            self.playIcon.isHidden = true
        }
        else{
            getNewsDetails(id:newsId)

        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.tabBarController?.tabBar.isHidden = false
      self.navigationController?.navigationBar.isHidden = false
    }
    func navigationTitle(){
        
      self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.5)
      self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
      let newBackButton = UIButton(type: .custom)
      newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
      newBackButton.contentMode = .scaleAspectFit
      newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
      newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
        newBackButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
      let item2 = UIBarButtonItem(customView: newBackButton)
      self.navigationItem.leftBarButtonItem = item2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        imageView.image = AppHelper.imageScaledToSize(image: UIImage(named: ThemeManager.currentTheme().logoImage)!, newSize: CGSize(width: 50, height: 50))
        navigationItem.titleView = imageView
    }
    @objc func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @objc func playAction(_ sender: UIButton) {
        if let video = video{
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
        videoPlayerController.video = video

        self.navigationController?.pushViewController(videoPlayerController, animated: false)
        }
    }
    func getLinearEventDetails(id:Int?) {
      var parameterDict: [String: String?] = [ : ]
      parameterDict["event-id"] = String(id!)
      print("parameterDict",parameterDict)
          ApiCommonClass.GetLinearEvents(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
              WarningDisplayViewController().noResultview(view : self.view,title: "No show found")

            CustomProgressView.hideActivityIndicator()
          }
        } else {
         
          if let data = responseDictionary["data"] as? [VideoModel] {
              self.newsModel = data
              DispatchQueue.main.async{
                  if let images = self.newsModel[0].images{
                      self.multipleNewsImageArray = images
                      let width = (self.view.frame.width  / 2.3)
                        let height = (width * 9 ) / 16
                      self.newsCollectionViewHeight.constant = height
                      self.InitialView()

                  }
                  if let tags = self.newsModel[0].video_tags{
                      self.tagArray = tags

                  }
                  else{
                      self.tagCollectionViewHeight.constant = 0
                  }
                  
                  if let newsDescription  = self.newsModel[0].synopsis{
                       let text = newsDescription
                       self.text = newsDescription
                      let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: CGFloat.greatestFiniteMagnitude))
                      label.numberOfLines = 0
                      label.lineBreakMode = NSLineBreakMode.byWordWrapping
                      let font = UIFont.boldSystemFont(ofSize:16)
                      self.DescriptionLabelHeight = label.heightForLabel(text: text, font: font, width: self.view.frame.width - 30)
                      
                       let labelText = NSMutableAttributedString.init(string: text)
                      if self.DescriptionLabelHeight > 110 {
                          self.newsDescriptionHeight.constant = 110
                          self.newsDescriptionLabel.text = text
                         _ = UIFont.boldSystemFont(ofSize: 13)
                         _ = UIColor().colorFromHexString("5D87A0")
                         DispatchQueue.main.async {
                           self.newsDescriptionLabel.addReadMoreString(to: self.newsDescriptionLabel)
                           //self.synopsisLabel.addTrailing(with: "...", moreText: "More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                         }
                         let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
                          self.newsDescriptionLabel.isUserInteractionEnabled = true
                          self.newsDescriptionLabel.addGestureRecognizer(tap)
                       } else {
                           self.newsDescriptionHeight.constant = self.DescriptionLabelHeight
                       }
                       self.newsDescriptionLabel.attributedText = labelText
                     } else {
                       
                         self.newsDescriptionHeight.constant = 0
                     }
                  self.newsHeadline.text = self.newsModel[0].show_name
                  if let newsImage =  self.newsModel[0].logo_thumb{
                      let width = (self.view.frame.width)
                        let height = (width * 9 ) / 16
                      self.newsImageViewHeight.constant = height
                      self.newsImageView.sd_setImage(with: URL(string: (( newsImage).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                  }
                  else {
                      self.newsImageView.image = UIImage(named: "landscape_placeholder")
                      self.newsImageViewHeight.constant = 0
                  }
                  
                  
              }
              let Metadataheight =  self.newsDescriptionHeight.constant + self.newsImageViewHeight.constant +  self.tagCollectionViewHeight.constant + self.newsCollectionViewHeight.constant +  110
              self.mainViewHeight.constant = Metadataheight
              
          }
        }
      }
    }
    
    var video: VideoModel!
    func getNewsDetails(id:Int?) {
      var parameterDict: [String: String?] = [ : ]
        parameterDict["news-id"] = String(id!)

        ApiCommonClass.GetNewsDetails(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            CustomProgressView.hideActivityIndicator()
              WarningDisplayViewController().noResultview(view : self.view,title: "No news found")
              WarningDisplayViewController().noResultView.isHidden = false

          }
        } else {
         
          if let data = responseDictionary["data"] as? [VideoModel] {
              if data.count == 0{
                  WarningDisplayViewController().noResultview(view : self.view,title: "No news found")
                  WarningDisplayViewController().noResultView.isHidden = false
              }
              self.newsModel = data
              DispatchQueue.main.async{
                  if let images = self.newsModel[0].images{
                      self.multipleNewsImageArray = images
                      let width = (self.view.frame.width  / 2.3)
                        let height = (width * 9 ) / 16
                      self.newsCollectionViewHeight.constant = height + 60
                      self.InitialView()

                  }
                  if let tags = self.newsModel[0].video_tags{
                      if tags.count > 0{
                          self.tagArray = tags
                      }

                  }
                  if self.newsModel[0].videos!.count > 0{
                      self.playIcon.isHidden = false
                      if let videoModel = self.newsModel[0].videos?[0]{
                          self.video = videoModel
                      }
                  }
                  else{
                      self.playIcon.isHidden = true
                      self.playIconHeight.constant = 0
                  }
                  if let newsDescription  = self.newsModel[0].synopsis{
                       let text = newsDescription
                       self.text = newsDescription
                      let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: CGFloat.greatestFiniteMagnitude))
                      label.numberOfLines = 0
                      label.lineBreakMode = NSLineBreakMode.byWordWrapping
                      let font = UIFont.boldSystemFont(ofSize: 12)
                      self.DescriptionLabelHeight = label.heightForLabel(text: text, font: font, width: self.view.frame.width - 30)
                      let labelText = NSMutableAttributedString.init(string: text)
                      print("description height",self.DescriptionLabelHeight)
                      if self.DescriptionLabelHeight > 110 {
                          self.newsDescriptionHeight.constant = 110
                          self.newsDescriptionLabel.text = text
                         _ = UIFont.boldSystemFont(ofSize: 13)
                         _ = UIColor().colorFromHexString("5D87A0")
                         DispatchQueue.main.async {
                           self.newsDescriptionLabel.addReadMoreString(to: self.newsDescriptionLabel)
                           //self.synopsisLabel.addTrailing(with: "...", moreText: "More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                         }
                         let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
                          self.newsDescriptionLabel.isUserInteractionEnabled = true
                          self.newsDescriptionLabel.addGestureRecognizer(tap)
                       } else {
                           self.newsDescriptionHeight.constant = self.DescriptionLabelHeight
                       }
                      print("newsDescriptionHeight",self.newsDescriptionHeight)

                       self.newsDescriptionLabel.attributedText = labelText
                     } else {
                       
                         self.newsDescriptionHeight.constant = 0
                     }
                  self.newsHeadline.text = self.newsModel[0].show_name
                  if let newsImage =  self.newsModel[0].logo_thumb{
                      let width = (self.view.frame.width)
                        let height = (width * 9 ) / 16
                      self.newsImageViewHeight.constant = height
                      self.newsImageView.sd_setImage(with: URL(string: (( newsImage).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                  }
                  else {
                      self.newsImageView.image = UIImage(named: "landscape_placeholder")
                      self.newsImageViewHeight.constant = 0
                  }
                  WarningDisplayViewController().noResultView.isHidden = true

                  let Metadataheight =  self.newsDescriptionHeight.constant + self.newsImageViewHeight.constant +  self.tagCollectionViewHeight.constant + self.newsCollectionViewHeight.constant +  110
                  self.mainViewHeight.constant = Metadataheight

                  
              }
              
              
              
          }
            
            
        }
      }
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        self.newsDescriptionHeight.constant = self.DescriptionLabelHeight

      newsDescriptionLabel.lineBreakMode = .byWordWrapping
        newsDescriptionLabel.text = self.newsModel[0].synopsis!

        let Metadataheight =  self.newsDescriptionHeight.constant + self.newsImageViewHeight.constant +  self.tagCollectionViewHeight.constant + self.newsCollectionViewHeight.constant +  110
        self.mainViewHeight.constant = Metadataheight + 100
    }
    func InitialView(){
        self.tagCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self

        if tagArray.count > 0{
          let flowLayout = CustomFlowLayout()
          self.tagCollectionView.collectionViewLayout = flowLayout
            self.tagCollectionView.backgroundColor = .clear
            self.tagCollectionView.layoutIfNeeded()
            self.tagCollectionViewHeight.constant = 30
            tagCollectionView.reloadData()
        }
        if multipleNewsImageArray.count > 0{
            self.newsCollectionView.reloadData()

        }
    }
    func textWidth(text: String, font: UIFont?) -> CGFloat {
      let attributes = font != nil ? [NSAttributedString.Key.font: font!] : [:]
      return text.size(withAttributes: attributes).width
    }
}
extension NewsViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView{
            if tagArray.count > 0{
                return tagArray.count
            }
        }
        else{
            if self.multipleNewsImageArray.count > 0{
                return self.multipleNewsImageArray.count

            }
        }
       
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().ThemeColor
            if tagArray.count > 0{
                cell.categoryName = tagArray[indexPath.row]
            }
            self.tagCollectionViewHeight.constant = 40

        
            return cell
        }
        let cell: EpisodeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCollectionCell
        cell.imageView.layer.masksToBounds = true
        cell.imageView.contentMode = .scaleToFill
        let width = (view.frame.width  / 2.3)
          let height = (width * 9 ) / 16
        cell.imageHeight.constant = height
        self.newsCollectionViewHeight.constant = height
        if multipleNewsImageArray[indexPath.row] != nil {
            cell.imageView.sd_setImage(with: URL(string: (( multipleNewsImageArray[indexPath.row]!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        }
        else {
            cell.imageView.image = UIImage(named: "landscape_placeholder")
        }
        let Metadataheight =  self.newsDescriptionHeight.constant + self.newsImageViewHeight.constant +  self.tagCollectionViewHeight.constant + self.newsCollectionViewHeight.constant +  110
        self.mainViewHeight.constant = Metadataheight
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView{
            let width = self.textWidth(text: tagArray[indexPath.row]!, font: UIFont.systemFont(ofSize: 12)) + 30
            return CGSize(width: width , height: 30)
        }
        else{
            let width = (view.frame.width  / 2.3)
              let height = (width * 9 ) / 16
            return CGSize(width: width - 20, height: height)
        }
        
    }
    
}
