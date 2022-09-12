//
//  PartnerViewController.swift
//  HappiTv
//
//  Created by GIZMEON on 14/10/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

class PartnerViewController: UIViewController,HomeVideoTableViewCellDelegate {
    
    
   
    
    
    
//    @IBOutlet weak var partnerImageViewHeight: NSLayoutConstraint!
//
//    @IBOutlet weak var partnerImageView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var partnerImage: UIImageView!
    
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    @IBOutlet weak var parnerImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var partnerImageWidth: NSLayoutConstraint!
    @IBOutlet weak var partnerCategoryTableview: UITableView!
    @IBOutlet weak var partnerDescription: UILabel!
    var Tableviewheight = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialView()
        getPartnerVideos()
    }
    var Categories = [VideoModel]()
     var categoryModel: VideoModel!
     var categoryId = Int()
     var categoryTitle = ""
    var titleImage = String()
    var partnerDescription1 = String()
 
    var partnerName = String()
    func initialView() {
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = AppHelper.imageScaledToSize(image: UIImage(named: ThemeManager.currentTheme().navigationControllerLogo)!, newSize: CGSize(width: 120, height: 50))
//        navigationItem.titleView = imageView
        
        navigationItem.rightBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
        self.navigationController?.navigationBar.isHidden = false
        let nib =  UINib(nibName: "HomeVideoTableViewCell", bundle: nil)
        partnerCategoryTableview.register(nib, forCellReuseIdentifier: "homecell")
        partnerCategoryTableview.backgroundColor = .black
        partnerDescription.backgroundColor = .black
        partnerDescription.textColor = UIColor.white
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
      if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        self.parnerImageHeight.constant = 400
        self.partnerImageWidth.constant = 400
        self.labelHeight.constant = 90
        self.mainViewWidth.constant = self.view.frame.width

        self.labelHeight.constant = 90
      } else {
        self.parnerImageHeight.constant = 150
        self.partnerImageWidth.constant = 150
        self.mainViewWidth.constant = self.view.frame.width
        self.labelHeight.constant = 30

      }

        
        
    }
    var dianamicVideos = [VideoModel]()
    var synopsisLabelHeight = CGFloat()

    var ShowData = [PartnerModel]()
        func getPartnerVideos() {
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            var font = UIFont.boldSystemFont(ofSize:16)
          CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
          Categories.removeAll()
          var parameterDict: [String: String?] = [ : ]
    //      if fromVideoPlaying {
    //        parameterDict["key"] = String(format: "%02d",categoryId)
    //      } else {
    //      }
            parameterDict["key"] = String(categoryModel.partner_id!)

          parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
          parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
          parameterDict["device_type"] = "ios-phone"
          parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
          parameterDict["language"] = Application.shared.langugeIdList
          ApiCommonClass.getPartnerByPartnerid(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            
           
            if responseDictionary["error"] != nil {
                  DispatchQueue.main.async {
                    self.partnerCategoryTableview.reloadData()
                    CustomProgressView.hideActivityIndicator()
                    WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                  }
                } else {
                CustomProgressView.hideActivityIndicator()
                if responseDictionary["partner_image"] != nil{
                    self.titleImage = responseDictionary["partner_image"] as! String
                     self.partnerImage.sd_setImage(with: URL(string: ((showUrl + self.titleImage).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                }
                 if responseDictionary["partner_description"] != nil{
                 
                             self.partnerDescription1 = responseDictionary["partner_description"] as! String
                    self.partnerDescription.text = self.partnerDescription1
                }
                if responseDictionary["partner_name"] != nil{
                            self.partnerName = responseDictionary["partner_name"] as! String
                     self.navigationItem.title = self.partnerName
                }
                if self.partnerDescription1 != nil {
                    let text = self.partnerDescription1
                    
                    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                        font = UIFont.boldSystemFont(ofSize: 18)
                    }
                    else{
                        font = UIFont.boldSystemFont(ofSize: 12)
                    }
                    self.synopsisLabelHeight = label.heightForLabel(text: text, font: font, width: self.view.frame.width - 30)
                    let labelText = NSMutableAttributedString.init(string: text)
                    if self.synopsisLabelHeight > 110 {
                        self.labelHeight.constant = 110
                        //                    self.partnerImageViewHeight.constant = 290
                        self.partnerDescription.text = text
                        
                        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                            self.partnerDescription.font = UIFont.boldSystemFont(ofSize: 18)
                        }
                        else{
                            _ = UIFont.boldSystemFont(ofSize: 14)
                        }
                        _ = UIColor().colorFromHexString("32a8a6")
                        DispatchQueue.main.async {
                            self.partnerDescription.addReadMoreString(to: self.partnerDescription)
                            //self.synopsisLabel.addTrailing(with: "...", moreText: "More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                        }
                        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
                        self.partnerDescription.isUserInteractionEnabled = true
                        self.partnerDescription.addGestureRecognizer(tap)
                    } else {
                        self.labelHeight.constant = self.synopsisLabelHeight
                    }
                    self.partnerDescription.attributedText = labelText
                } else {
                    self.labelHeight.constant = 0
                }

               
                
                self.dianamicVideos.removeAll()
                if responseDictionary["data"] != nil{
                    self.dianamicVideos = responseDictionary["data"] as! [VideoModel]
                    if self.dianamicVideos.count == 0 {
                        DispatchQueue.main.async {
                            self.partnerCategoryTableview.reloadData()
                            
                            self.partnerCategoryTableview.isHidden = false
                            CustomProgressView.hideActivityIndicator()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.partnerCategoryTableview.reloadData()
                            CustomProgressView.hideActivityIndicator()
                            self.partnerCategoryTableview.isHidden = false
                            
                            CustomProgressView.hideActivityIndicator()
                        }
                    }
                }
            }
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.Tableviewheight = CGFloat(500 * self.dianamicVideos.count)
            }
            else{
                self.Tableviewheight = CGFloat(200 * self.dianamicVideos.count)
            }
            self.mainViewHeight.constant = self.Tableviewheight + self.labelHeight.constant
            
            }
        }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
      labelHeight.constant = self.synopsisLabelHeight
      partnerDescription.lineBreakMode = .byWordWrapping
        partnerDescription.text = self.partnerDescription1
       self.mainViewHeight.constant = self.Tableviewheight + self.synopsisLabelHeight

        
    }
    func didSelectPopular(passModel: VideoModel) {
        print("didSelectPopular")
    }
    
    func didSelectCategory(passModel: VideoModel) {
        print("didSelectCategory")
    }
    
    func didSelectChannel(passModel: VideoModel) {
        print("didSelectChannel")
    }
    
    func didSelectDianamicVideos(passModel: VideoModel) {
        print("didSelectDianamicVideos")
    }
    
    func didSelectLiveNowVideos(passModel: VideoModel) {
        print("didSelectLiveNowVideos")
    }
    func didSelectEventLive(passModel: VideoModel) {
        
    }
    
    func didSelectNews(passModel: VideoModel) {
        
    }
    func didSelectUpcomingEvents(passModel: VideoModel) {
        
    }
    func didSelectEndedEvents(passModel: VideoModel) {
        
    }
    
    func didSelectShowVideos(passModel: VideoModel) {
        print("didSelectShowVideos")
        let video = passModel
          print("video id = \(video)")
        let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
        videoPlayerController.video = video
        self.navigationController?.pushViewController(videoPlayerController, animated: false)

    }
}





extension PartnerViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dianamicVideos.count
            
        }
        
          return 1
        
        
      }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "homecell", for: indexPath) as! HomeVideoTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
//            cell.homeButton.tag = indexPath.row
//            cell.homeButton.addTarget(self, action:#selector(self.allVideos(_:)), for:.touchUpInside)
//                cell.homeButton.setTitle(dianamicVideos[indexPath.row].show_name, for: UIControl.State.normal)
//                cell.channelType = "Partner"
//                cell.delegate = self
//            cell.rightArrowImageView.isHidden = true
//                let data = dianamicVideos[indexPath.row].videos
//                if (data?.count)! >= 10 {
//                    cell.channelArray = dianamicVideos[indexPath.row].videos
//                } else {
//                    cell.channelArray = dianamicVideos[indexPath.row].videos
//                }
//                cell.homeButton.isHidden = false
//        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//            cell.homeButton.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 25)
//          } else {
//            cell.homeButton.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 18)
//          }
//
        
            
            return cell
       
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if indexPath.section == 0 {
                return 500
                
            }
        } else {
            if indexPath.section == 0 {
                return 200
                
            }
        }
        return 200
    }
    
    @objc func allVideos(_ sender: UIButton) {
      
//        let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
//        videoPlayerController.videoName = "partner"
//        videoPlayerController.indexpathRow = sender.tag
//        videoPlayerController.partnerId = String(categoryModel.partner_id!)
//        self.navigationController?.pushViewController(videoPlayerController, animated: false)
        let video = dianamicVideos[sender.tag].videos![sender.tag]
                 let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
                 videoPlayerController.categoryModel = video
                 self.navigationController?.pushViewController(videoPlayerController, animated: false)
      
    }
        
}
