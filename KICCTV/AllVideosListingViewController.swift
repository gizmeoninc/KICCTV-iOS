//
//  AllVideosListingViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 06/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import SideMenu

class AllVideosListingViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var allVideosCollectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var youtubeVideostableView: UITableView!
    @IBOutlet weak var buttonselectionView: UIView!
    @IBOutlet weak var buttonSelectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var channelsButton: UIButton!
    @IBOutlet weak var youtubeChannelsButton: UIButton!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    var videoName = ""
    var ProducerName = ""
    var reachability = Reachability()!
    var categoryVideos = [VideoModel]()
    var popularVideos = [VideoModel]()
    var channelVideos = [VideoModel]()
    var liveVideos = [VideoModel]()
    var showVideos = [VideoModel]()
    var watchList = [VideoModel]()

    var dynamicVideos = [showByCategoryModel]()
    var youtubeVideos = [youtubeModel]()
    var indexpathRow = Int()
    var fromTab = Bool()
    var currentX:CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonselectionView.backgroundColor = ThemeManager.currentTheme().UIImageColor
//        if (videoName == "LiveNow" || videoName == "Channel") {
//            self.buttonSelectionViewHeight.constant = 45
//            self.mainScrollView.isScrollEnabled = true
//            self.buttonselectionView.isHidden = false
//        }else {
        self.buttonSelectionViewHeight.constant = 0
            self.mainScrollView.isScrollEnabled = false
            self.buttonselectionView.isHidden = true
        //}
        channelsButton.setTitleColor(ThemeManager.currentTheme().UIImageColor, for: .normal)
        contentViewWidth.constant = UIScreen.main.bounds.width * 2
        mainScrollView.contentOffset.x = 0
        self.youtubeVideostableView.register(UINib(nibName: "YoutubeVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "youTubeTableViewCell")
         self.youtubeVideostableView.separatorStyle = .none
        self.youtubeVideostableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
         self.allVideosCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
         self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
         self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
         self.mainScrollView.backgroundColor = ThemeManager.currentTheme().backgroundColor
          mainScrollView.delegate = self
         self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
         self.navigationController?.navigationBar.isHidden = false
         self.tabBarController?.tabBar.isHidden = false
         self.navigationItem.hidesBackButton = false
         DispatchQueue.main.async
            {
                var frame = self.buttonselectionView.frame
                frame.origin.x = frame.origin.x + (self.mainScrollView.contentOffset.x - self.currentX) / 3
                self.buttonselectionView.frame = frame
                self.currentX = self.mainScrollView.contentOffset.x
        }
        initialView()

    }
    
    @objc func back(sender: UIBarButtonItem) {
     navigationController?.popViewController(animated: true)
    }
    
    func initialView() {
          allVideosCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
        if videoName == "NewReleases" {
            self.navigationItem.title = "New Releases"
            getHomeNewArrivals()
        } else if videoName == "Channel" {
            self.navigationItem.title = "Channels"
            getTrendingChannels()
        } else if videoName == "Categories" {
            self.navigationItem.title = "Categories"
            getCategoryVideos()
        } else if videoName == "Dynamic" {
            getCategoryVideosByid()
//             getDynamicHomeVidos()
        }
        else if videoName == "MyList" {
            self.navigationItem.title = "My List"

           getWatchlist()
//             getDynamicHomeVidos()
       }
        else if videoName == "partner" {
//              self.navigationItem.title = "Back"
                    getPartnerVideos()
               }
        else if videoName == "LiveNow" {
             self.navigationItem.title = "Live Videos"
             getLiveVideos()
        } else if videoName == "PopularShows" {
             self.navigationItem.title = "Popular Shows"
             getshows()
        } else if videoName == "ProducerName" {
            self.navigationItem.title = ProducerName
          getProducerBasedShows()
        } else if videoName == "FreeShows" {
          self.navigationItem.title = "Free Videos"
          self.getFreeshows()
        }
        else{
        }
        navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
    }
    
    @objc func showSideMenu(sender: UIBarButtonItem) {
       present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        
        CustomProgressView.hideActivityIndicator()
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
        delegate.restrictRotation = .portrait
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        
    }
    
    // MARK: Newtork connection checking
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else {
            return
        }
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            let serachController = self.storyboard?.instantiateViewController(withIdentifier: "noNetwork") as! NoNetworkDisplayViewController
            self.navigationController?.pushViewController(serachController, animated: false)
        }
    }
    // MARK:Button Actions
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func channelViewButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.mainScrollView.contentOffset.x = 0
        }, completion: nil)
    }
    
    @IBAction func youtubeViewButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.mainScrollView.contentOffset.x = UIScreen.main.bounds.width
        }, completion: nil)
    }
    // MARK:Api Methods
//    func getHomeNewArrivals() {
//
//       CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
//        ApiCommonClass.getHomePopularVideos { (responseDictionary: Dictionary) in
//            if responseDictionary["error"] != nil {
//                DispatchQueue.main.async {
//                    CustomProgressView.hideActivityIndicator()
//                }
//            } else {
//                self.popularVideos.removeAll()
//                self.popularVideos = responseDictionary["Channels"] as! [VideoModel]
//                if self.popularVideos.count == 0 {
//                    DispatchQueue.main.async {
//                          CustomProgressView.hideActivityIndicator()
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                      self.allVideosCollectionView.reloadData()
//                      CustomProgressView.hideActivityIndicator()
//                    }
//                }
//            }
//        }
//    }
    
   
  func getHomeNewArrivals() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    var parameterDict: [String: String?] = [ : ]
    parameterDict["type"] = ""
    print("parameterDict",parameterDict)
    ApiCommonClass.getHomeNewArrivals(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.popularVideos.removeAll()
        self.popularVideos = responseDictionary["data"] as! [VideoModel]
        if self.popularVideos.count == 0 {
          DispatchQueue.main.async {
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.allVideosCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
    func getWatchlist() {
      CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
      var parameterDict: [String: String?] = [ : ]
      parameterDict["type"] = ""
      print("parameterDict",parameterDict)
      ApiCommonClass.getWatchList(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          self.watchList.removeAll()
          self.watchList = responseDictionary["Channels"] as! [VideoModel]
          if self.watchList.count == 0 {
            DispatchQueue.main.async {
              CustomProgressView.hideActivityIndicator()
            }
          } else {
            DispatchQueue.main.async {
              self.allVideosCollectionView.reloadData()
              CustomProgressView.hideActivityIndicator()
            }
          }
        }
      }
    }
    var dianamicVideos1 = [VideoModel]()
    var partnerId = String()

       var ShowData = [PartnerModel]()
           func getPartnerVideos() {
             CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
             var parameterDict: [String: String?] = [ : ]
       
               parameterDict["key"] = partnerId

             parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
             parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
             parameterDict["device_type"] = "ios-phone"
             parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
             parameterDict["language"] = Application.shared.langugeIdList
             ApiCommonClass.getPartnerByPartnerid(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
               if responseDictionary["error"] != nil {
                     DispatchQueue.main.async {
                       
                       CustomProgressView.hideActivityIndicator()
                       
                     }
                   } else {
                     self.dianamicVideos1.removeAll()
                     self.dianamicVideos1 = responseDictionary["data"] as! [VideoModel]
                     if self.dianamicVideos1.count == 0 {
                       DispatchQueue.main.async {
                         CustomProgressView.hideActivityIndicator()
                         
                       }
                     } else {
                       DispatchQueue.main.async {
                        self.allVideosCollectionView.reloadData()
                         CustomProgressView.hideActivityIndicator()
                        self.navigationItem.title = self.dianamicVideos1[self.indexpathRow].show_name

                       }
                     }
                   }

             }
           }
       
    
    func getCategoryVideos() {
        
        CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
        ApiCommonClass.getCategories { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
                 self.categoryVideos.removeAll()
                self.categoryVideos = responseDictionary["data"] as! [VideoModel]
                if self.categoryVideos.count == 0 {
                    DispatchQueue.main.async {
                        CustomProgressView.hideActivityIndicator()
                    }
                } else {
                    DispatchQueue.main.async {
                    self.allVideosCollectionView.reloadData()
                        CustomProgressView.hideActivityIndicator()
                    }
                }
            }
        }
    }
    func getTrendingChannels() {
    
        CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
        ApiCommonClass.getPopularChannels { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
                     self.channelVideos.removeAll()
                self.channelVideos = responseDictionary["data"] as! [VideoModel]
                if self.channelVideos.count == 0 {
                    DispatchQueue.main.async {
                          CustomProgressView.hideActivityIndicator()
                    }
                } else {
                    DispatchQueue.main.async {
                       self.allVideosCollectionView.reloadData()
                       CustomProgressView.hideActivityIndicator()
                       // self.getYoutubeVideos()
                    }
                }
            }
        }
    }
    
    func getDynamicHomeVidos() {
//        CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
//        ApiCommonClass.getDianamicHomeVideos { (responseDictionary: Dictionary) in
//            if responseDictionary["error"] != nil {
//                DispatchQueue.main.async {
//                    CustomProgressView.hideActivityIndicator()
//                }
//            } else {
//                   self.dynamicVideos.removeAll()
//                self.dynamicVideos = responseDictionary["data"] as! [showByCategoryModel]
//                if self.dynamicVideos.count == 0 {
//                    DispatchQueue.main.async {
//                        CustomProgressView.hideActivityIndicator()
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                      self.navigationItem.title = self.dynamicVideos[self.indexpathRow].category_name
//                     self.allVideosCollectionView.reloadData()
//                        CustomProgressView.hideActivityIndicator()
//                    }
//                }
//            }
//        }
    }
    var Categories = [VideoModel]()
    var categoryModel: VideoModel!
    var dynamicVideoId : Int?
    var categoryName : String?
    func getCategoryVideosByid() {
      CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
      Categories.removeAll()
      var parameterDict: [String: String?] = [ : ]
      
        parameterDict["key"] = String(dynamicVideoId!)
      
      parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["language"] = Application.shared.langugeIdList
      ApiCommonClass.getvideoByCategoryid(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          self.Categories = responseDictionary["data"] as! [VideoModel]
          if self.Categories.count == 0 {
            DispatchQueue.main.async {
              WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
              CustomProgressView.hideActivityIndicator()
            }
          } else {
            DispatchQueue.main.async {
                self.navigationItem.title = self.categoryName
              WarningDisplayViewController().noResultView.isHidden = true
              self.allVideosCollectionView.reloadData()
              CustomProgressView.hideActivityIndicator()
            }
          }
        }
      }
    }

func getLiveVideos() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    ApiCommonClass.getAllLiveVideos { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
      DispatchQueue.main.async {
        CustomProgressView.hideActivityIndicator()
       }
     } else {
         self.liveVideos.removeAll()
      self.liveVideos = responseDictionary["data"] as! [VideoModel]
      if self.liveVideos.count == 0 {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        DispatchQueue.main.async {
          self.allVideosCollectionView.reloadData()
           CustomProgressView.hideActivityIndicator()
          //self.getYoutubeVideos()
        }
      }
    }
  }
}
    func getshows() {
       CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
       ApiCommonClass.getShows { (responseDictionary: Dictionary) in
       if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            CustomProgressView.hideActivityIndicator()
          }
       } else {
          self.showVideos.removeAll()
          self.showVideos = responseDictionary["Channels"] as! [VideoModel]
          if self.showVideos.count == 0 {
               DispatchQueue.main.async {
              }
          } else {
            DispatchQueue.main.async {
              self.allVideosCollectionView.reloadData()
              CustomProgressView.hideActivityIndicator()
            }
         }
      }
    }
  }
  func getFreeshows() {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["type"] = ""
    print("parameterDict",parameterDict)
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    ApiCommonClass.getFreeShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.showVideos.removeAll()
        self.showVideos = responseDictionary["data"] as! [VideoModel]
        if self.showVideos.count == 0 {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            self.allVideosCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
  func getProducerBasedShows() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    var parameterDict: [String: String?] = [ : ]
    parameterDict["producer"] = self.ProducerName
    parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["language"] = Application.shared.langugeIdList
    ApiCommonClass.getProducerBasedShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          WarningDisplayViewController().noResultview(view : self.view,title: "No Videos Found")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.showVideos.removeAll()
        self.showVideos = responseDictionary["data"] as! [VideoModel]
        if self.showVideos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Videos Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.allVideosCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
  func getYoutubeVideos() {
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        ApiCommonClass.getYTVOD { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
                DispatchQueue.main.async {
                    self.youtubeVideos = responseDictionary["Channels"] as! [youtubeModel]
                    self.youtubeVideostableView.reloadData()
                    CustomProgressView.hideActivityIndicator()
                    if (self.videoName == "LiveNow" || self.videoName == "Channel") {
                    }
                }
            }
        }
       CustomProgressView.hideActivityIndicator()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            var frame = buttonselectionView.frame
            frame.origin.x = frame.origin.x + (scrollView.contentOffset.x - currentX) / 2
            buttonselectionView.frame = frame
            currentX = scrollView.contentOffset.x
            if currentX  <= self.allVideosCollectionView.frame.width {
                self.channelsButton.setTitleColor(ThemeManager.currentTheme().UIImageColor, for: .normal)
                self.youtubeChannelsButton.setTitleColor(.darkGray, for: .normal)
            } else {
                self.channelsButton.setTitleColor(.darkGray, for: .normal)
                self.youtubeChannelsButton.setTitleColor(ThemeManager.currentTheme().UIImageColor, for: .normal)
        }
     }


}
// MARK: Collectionview methods
extension AllVideosListingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if videoName == "NewReleases" {
            return popularVideos.count
        }
        if videoName == "MyList" {
            return watchList.count
        }
        else if videoName == "Channel" {
            return channelVideos.count
        } else if videoName == "Categories"{
            return categoryVideos.count
        } else if videoName == "LiveNow" {
          return liveVideos.count
        }else if videoName == "PopularShows" {
          return showVideos.count
        } else if videoName == "ProducerName" {
          return showVideos.count
        } else if videoName == "FreeShows"{
           return showVideos.count
        }
        else if videoName == "partner" {
            if (dianamicVideos1.count) > 0 {
                          return dianamicVideos1[indexpathRow].videos!.count
                       } else {
                          return 1
                       }
            
        }else  {
            if (Categories.count) > 0 {
               return Categories.count
            } else {
               return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
        cell.videoImage.layer.cornerRadius = 8.0
        cell.videoImage.layer.masksToBounds = true
        cell.videoImage.contentMode = .scaleToFill

      if videoName == "FreeShows" {
        if showVideos[indexPath.row].show_name != nil{
            cell.videoName.text = showVideos[indexPath.row].show_name
        }
        else{
            cell.videoName.text = ""
            
        }
        if showVideos[indexPath.row].logo != nil {

          cell.videoImage.sd_setImage(with: URL(string: ((showUrl1 + showVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        } else {
          cell.videoImage.image = UIImage(named: "landscape_placeholder")
        }
        cell.videoName.isHidden = false
        cell.episodeLabel.isHidden = true
        cell.liveLabel.isHidden = true
        if showVideos[indexPath.row].premium_flag != nil {
          if showVideos[indexPath.row].premium_flag == 0 {
            cell.premiumImage.isHidden = true
          } else {
            cell.premiumImage.isHidden = true
          }
        }else {
          cell.premiumImage.isHidden = true
        }
      }else if videoName == "NewReleases" {
        if popularVideos[indexPath.row].show_name != nil{
            cell.videoName.text = popularVideos[indexPath.row].show_name
        }
        else{
            cell.videoName.text = ""
            
        }
          if popularVideos[indexPath.row].logo != nil {
            cell.videoImage.sd_setImage(with: URL(string: ((showUrl1 + popularVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
          } else {
             cell.videoImage.image = UIImage(named: "landscape_placeholder")
          }
        cell.episodeLabel.isHidden = true

            cell.videoName.isHidden = false
            cell.liveLabel.isHidden = true
            if popularVideos[indexPath.row].premium_flag != nil {
            if popularVideos[indexPath.row].premium_flag == 0 {
                cell.premiumImage.isHidden = true
            } else {
                cell.premiumImage.isHidden = true
            }
            }else {
               cell.premiumImage.isHidden = true
            }
        }else if videoName == "MyList" {
            
            if watchList[indexPath.row].show_name != nil{
                cell.videoName.text = watchList[indexPath.row].show_name
            }
            else{
                cell.videoName.text = ""
                
            }
              if watchList[indexPath.row].logo != nil {
                cell.videoImage.sd_setImage(with: URL(string: ((showUrl1 + watchList[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
              } else {
                 cell.videoImage.image = UIImage(named: "landscape_placeholder")
              }
            cell.episodeLabel.isHidden = true
                cell.liveLabel.isHidden = true
                if watchList[indexPath.row].premium_flag != nil {
                if watchList[indexPath.row].premium_flag == 0 {
                    cell.premiumImage.isHidden = true
                } else {
                    cell.premiumImage.isHidden = true
                }
                }else {
                   cell.premiumImage.isHidden = true
                }
            }
      else if videoName == "Channel" {
            if channelVideos[indexPath.row].show_name != nil{
                cell.episodeLabel.text = channelVideos[indexPath.row].show_name
            }
            else{
                cell.episodeLabel.text = ""
                
            }
            cell.videoImage.sd_setImage(with: URL(string: ((channelUrl + channelVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            if channelVideos[indexPath.row].live_flag == 1 {
                cell.liveLabel.isHidden = false
            }else {
                cell.liveLabel.isHidden = true
            }
            cell.videoName.text = channelVideos[indexPath.row].channel_name
            cell.videoName.isHidden = true
            cell.liveLabel.layer.cornerRadius = 8
            cell.liveLabel.layer.masksToBounds = true
            if channelVideos[indexPath.row].premium_flag != nil {
            if channelVideos[indexPath.row].premium_flag == 0 {
                cell.premiumImage.isHidden = true
            } else {
                cell.premiumImage.isHidden = true
            }
            } else {
                cell.premiumImage.isHidden = true
            }
        } else if videoName == "Categories" {
            print("from listing")
            if categoryVideos[indexPath.row].show_name != nil{
                cell.episodeLabel.text = categoryVideos[indexPath.row].show_name
            }
            else{
                cell.episodeLabel.text = ""
                
            }
//        cell.episodeLabel.isHidden = true

        if categoryVideos[indexPath.row].image != nil {
           cell.videoImage.sd_setImage(with: URL(string: ((imageUrl + categoryVideos[indexPath.row].image!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
           cell.videoName.isHidden = true
        } else {
          cell.videoName.text = categoryVideos[indexPath.row].categoryname
          cell.videoImage.image = UIImage(named: "lightGrayColor")
          cell.videoName.isHidden = false
        }
          cell.liveLabel.isHidden = true

      }else if videoName == "LiveNow" {
        cell.episodeLabel.isHidden = true

          cell.videoImage.sd_setImage(with: URL(string: ((channelUrl + liveVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
          cell.videoName.text = liveVideos[indexPath.row].channel_name
          cell.videoName.isHidden = true
          cell.liveLabel.isHidden = false
          cell.liveLabel.layer.cornerRadius = 8
          cell.liveLabel.layer.masksToBounds = true
          if liveVideos[indexPath.row].premium_flag != nil {
          if liveVideos[indexPath.row].premium_flag == 0 {
             cell.premiumImage.isHidden = true
          } else {
            cell.premiumImage.isHidden = true
          }
          }else {
            cell.premiumImage.isHidden = true
         }
        } else if videoName == "PopularShows" {
//        cell.episodeLabel.isHidden = true
            if showVideos[indexPath.row].show_name != nil{
                cell.episodeLabel.text = showVideos[indexPath.row].show_name
            }
            else{
                cell.episodeLabel.text = ""
                
            }
          cell.videoImage.sd_setImage(with: URL(string: ((showUrl + showVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))

          cell.videoName.text = showVideos[indexPath.row].show_name
          cell.videoName.isHidden = true
          cell.liveLabel.isHidden = true
          if showVideos[indexPath.row].premium_flag != nil {
          if showVideos[indexPath.row].premium_flag == 0 {
                cell.premiumImage.isHidden = true
          } else {
                cell.premiumImage.isHidden = true
          }
          } else {
             cell.premiumImage.isHidden = true
          }
        } else if videoName == "ProducerName" {
        print("from listing")
        cell.episodeLabel.isHidden = true


            cell.videoImage.sd_setImage(with: URL(string: ((imageUrl + showVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        //  cell.videoName.text = showVideos[indexPath.row].show_name
          cell.videoName.isHidden = true
          cell.liveLabel.isHidden = true
         cell.premiumImage.isHidden = true
      } else if videoName == "partner"{
        if  (dianamicVideos1.count) > 0 {
            if dianamicVideos1[indexpathRow].videos![indexPath.row].video_title != nil{
                cell.episodeLabel.text = dianamicVideos1[indexpathRow].videos![indexPath.row].video_title
            }
            cell.episodeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                      cell.videoImage.sd_setImage(with: URL(string: ((imageUrl + dianamicVideos1[indexpathRow].videos![indexPath.row].thumbnail!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            cell.videoName.text = dianamicVideos1[indexpathRow].show_name
            print("dianamicVideos1[indexpathRow].videos![indexPath.row].video_title",dianamicVideos1[indexpathRow].category_name)
                       cell.videoName.isHidden = true
                       cell.liveLabel.isHidden = true
                       if dianamicVideos1[indexpathRow].videos![indexPath.row].premium_flag != nil {
                       if dianamicVideos1[indexpathRow].videos![indexPath.row].premium_flag == 0 {
                           cell.premiumImage.isHidden = true
                       } else {
                           cell.premiumImage.isHidden = true
                       }
                       }else {
                            cell.premiumImage.isHidden = true
                       }
                   }
      }else {
        if Categories.count > 0{
//                cell.episodeLabel.isHidden =  true
                if Categories[indexPath.row].show_name != nil{
                    cell.videoName.text = Categories[indexPath.row].show_name
                }
                else{
                    cell.videoName.text = ""
                    
                }
                if Categories[indexPath.row].logo != nil{
                    cell.videoImage.sd_setImage(with: URL(string: ((showUrl1 + Categories[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                }
                cell.videoName.isHidden = false
                cell.liveLabel.isHidden = true
            cell.episodeLabel.isHidden = true

                
           
        }
      }
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        return cell
     
    }
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if videoName == "FreeShows" {
          let video = showVideos[indexPath.item]
          let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
          videoPlayerController.categoryModel = video
          self.navigationController?.pushViewController(videoPlayerController, animated: false)
        } else if videoName == "NewReleases" {
             let video = popularVideos[indexPath.item]
          let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
          videoPlayerController.categoryModel = video
          self.navigationController?.pushViewController(videoPlayerController, animated: false)
          }
        else if videoName == "MyList" {
            let video = watchList[indexPath.item]
         let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
         videoPlayerController.categoryModel = video
         self.navigationController?.pushViewController(videoPlayerController, animated: false)
         }
          else  if videoName == "Categories" {
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let videoPlayerController = storyboard.instantiateViewController(withIdentifier: "allCategories") as! AllCategoryViewController
              videoPlayerController.fromCategories = true
              videoPlayerController.categoryModel = categoryVideos[indexPath.item]
              self.navigationController?.pushViewController(videoPlayerController, animated: false)
          }else  if videoName == "ProducerName" {
            let video = showVideos[indexPath.item]
            let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
            videoPlayerController.categoryModel = video
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
          }
        else  if videoName == "partner" {
         if  (dianamicVideos1.count) > 0 {
          let video = dianamicVideos1[indexpathRow].videos![indexPath.item]
//                      print("video id = \(video)")
                    let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
                    videoPlayerController.video = video
            //          videoPlayerController.showId = categoryModel.show_id!
                    self.navigationController?.pushViewController(videoPlayerController, animated: false)
//          let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
//          videoPlayerController.categoryModel = video
//          self.navigationController?.pushViewController(videoPlayerController, animated: false)
        }
        }else {
            if  (Categories.count) > 0 {
            let video = Categories[indexPath.item]
            let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
            videoPlayerController.categoryModel = video
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
          }
        }
      }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        var height = CGFloat()
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let width = (self.view.frame.size.width) / 2 - 10//some width
            let height = (9 * width) / 16
            return CGSize(width: width, height: height + 30)

        } else {
            let width = (self.view.frame.size.width) / 2 - 10//some width
            height = (9 * width) / 16
            return CGSize(width: width, height: height + 30);

        }
        
    }
  
}
extension AllVideosListingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeVideos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "youTubeTableViewCell", for: indexPath) as! YoutubeVideoTableViewCell
        cell.selectionStyle = .none
        cell.youtubeImageView.contentMode = .scaleAspectFit
        cell.youtubeImageView.image = UIImage(named: "landscape_placeholder")
        cell.youtubeImageView.sd_setImage(with: URL(string: (( youtubeVideos[indexPath.row].thumbnail!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        cell.youtubeVideoDescription.text = youtubeVideos[indexPath.row].description
        cell.youtubeChannelName.text = youtubeVideos[indexPath.row].channel_name
        cell.youtubeVideoName.text = youtubeVideos[indexPath.row].name
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return 190
        } else {
             return 100
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      /*
        let youtubevideo = youtubeVideos[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoPlayerController = storyboard.instantiateViewController(withIdentifier: "youtubeVideoPlayer") as! YoutubeVideoViewController
        videoPlayerController.video = youtubevideo
        self.navigationController?.pushViewController(videoPlayerController, animated: false)
 */
    }
}


