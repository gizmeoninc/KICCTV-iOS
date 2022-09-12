//
//  AllCategoryViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 04/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import SideMenu

class AllCategoryViewController: UIViewController,SideMenuDelegate {
  
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
  @IBOutlet weak var categoriesCollectionView: UICollectionView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var menuButton: UIButton!
  
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.isHidden = true
        }
    }
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var synopsisLabel: UILabel!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {

             self.synopsisLabel.font = UIFont.init(name: "Poppins-SemiBold", size: 25)
            } else {
             
            }
            synopsisLabel.isHidden = true
        }
    }
    @IBOutlet weak var topGradientView: UIView!{
        didSet{
           if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            topGradientView.setDianamicGradientBackground(colorTop:UIColor.clear , colorBottom:UIColor.black.withAlphaComponent(0.8), height: 420 )
           } else {
            topGradientView.setDianamicGradientBackground(colorTop:UIColor.clear , colorBottom:UIColor.black.withAlphaComponent(0.8), height: 230 )
           }
        }
    }
    @IBOutlet weak var topGradientViewHeght: NSLayoutConstraint!
    var reachability = Reachability()!
  var Categories = [VideoModel]()
  var categoryModel: VideoModel!
  var categoryId = Int()
  var categoryTitle = ""
    var categoryName : String?

   var dynamicVideoId : Int?
  var fromCategories = false
  var fromVideoPlaying = false
    var fromPartner = false
  var fromHomeVC = false
    var titleImage = String()
    var synopsis = String()
    var offsetValue = 0
    var isOffsetChanged = true
      var maxArrayCount = 0
    var offsetOnceCalledForLazyLoading = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.categoriesCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.categoriesCollectionView.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    self.navigationController?.navigationBar.isHidden = false
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
    WarningDisplayViewController().noResultView.isHidden = true

    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        let width = UIScreen.main.bounds.width
        let height = 9 * width / 16
        
     

    } else {
            imageViewHeight.constant = 230
            topGradientViewHeght.constant = 230

    }
    initialView()
    if reachability.connection != .none {
      if fromCategories {
        getCategoryVideosByid()
      }
      else if fromHomeVC{
        getCategoryVideosByid()
      }
        else if fromPartner{
            getPartnerVideos()
        }
      else {
        getShowVideos()
      }
    }
  }
  
  func initialView() {
    categoriesCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
    if fromCategories {
      if fromVideoPlaying {
        self.navigationItem.title = categoryTitle
      }else {
        self.navigationItem.title = categoryModel.categoryname
      }
    }
    else if fromHomeVC{
        self.navigationItem.title = categoryName
    }
    else if fromPartner{
        self.navigationItem.title = categoryModel.name
    }
    else {
      self.navigationItem.title = categoryModel.show_name
    }
  }
  
  @objc func back(sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func btnOpenSearch(){
    let serachController = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! HomeSearchViewController
    serachController.type = "video"
    serachController.categoryId = String(categoryModel.categoryid!)
    self.navigationController!.pushViewController(serachController, animated: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    reachability.stopNotifier()
    CustomProgressView.hideActivityIndicator()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupSideMenu()
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
    self.tabBarController?.tabBar.isHidden = false
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
      print("Network not reachable")
    }
  }
    func cancelAlertAction(){
        self.navigationController?.popToRootViewController(animated: false) // return to home
    }
    func MoveTOLoginPage() {
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController // move to login page from guest user                                                                                                                       login
        loginController.isFromSideMenu = true
        self.navigationController?.pushViewController(loginController, animated: true)
    }
  // MARK: setupSideMenu
  fileprivate func setupSideMenu() {
    
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "sidemenu") as! SideMenuViewController
    vc.progressdelegates = self
    let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: vc)
    SideMenuManager.default.menuFadeStatusBar = false
    SideMenuManager.default.menuWidth = view.frame.width - 100
    SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
  }
  
  @objc func showSideMenu(sender: UIBarButtonItem) {
    present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
  }
    func didSelectActivation() {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
                DispatchQueue.main.async {
                    WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see Live", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                            self.MoveTOLoginPage()
                        },nil])
                }
            }
            else{
                guard let tabbarController = self.tabBarController else { return }
                TVActivationVC.showActivationPopup(viewController: tabbarController)
                
            }
       
    }
  func didSelectWatchList() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
  }
  func didSelectMyVideos() {
    let myVideosController = self.storyboard?.instantiateViewController(withIdentifier: "liveTab") as! LiveTabViewController
      self.navigationController?.pushViewController(myVideosController, animated: false)
  }
  func didSelectSchedule() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "scheduleController") as! ScheduleViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
  }
  func didSelectLanguage() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "updatelanguage") as! UpdateLanguageListViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
  }
  func didSelectContactUs() {
    guard let tabbarController = self.tabBarController else { return }
    ContactUSViewController.showFromContactUs(viewController: tabbarController)
  }
  func didSelectPremium() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionListnew") as! subscriptionListViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
  }
//    func didSelectActivation() {
//        guard let tabbarController = self.tabBarController else { return }
//        ActivationVC.showFromActivation(viewController: tabbarController)
//    }
  func didSelectFavorites() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
  }
  // MARK: Api methods
  func getCategoryVideos() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    Categories.removeAll()
    var parameterDict: [String: String?] = [ : ]
    if fromVideoPlaying {
      parameterDict["key"] = String(format: "%02d",categoryId)
    } else {
      parameterDict["key"] = String(categoryModel.categoryid!)
    }
    parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["language"] = Application.shared.langugeIdList
    ApiCommonClass.getvideoByCategory(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
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
            WarningDisplayViewController().noResultView.isHidden = true
            self.categoriesCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
    
   
    func getCategoryVideosByid() {
      var parameterDict: [String: String?] = [ : ]
      
       
        if fromVideoPlaying {
          parameterDict["key"] = String(format: "%02d",categoryId)
        }
        else if fromHomeVC{
            parameterDict["key"] = String(dynamicVideoId!)
        }
        else {
          parameterDict["key"] = String(categoryModel.categoryid!)
        }
      parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["language"] = Application.shared.langugeIdList
        
        print("offset value called",offsetValue)
        if isOffsetChanged{
            if offsetValue == 0{
                CustomProgressView.showActivityIndicator(userInteractionEnabled: true)

                parameterDict["offset"] = "0"
            }
            else{
                parameterDict["offset"] = String(offsetValue * 10)
            }
            offsetValue = offsetValue + 1

        }
       
      ApiCommonClass.getvideoByCategoryid(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
            if responseDictionary["banner"] != nil {
                self.titleImage = responseDictionary["banner"] as! String
                 self.imageView.sd_setImage(with: URL(string: ((showUrl + self.titleImage).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                self.imageView.isHidden = false
               
            }
            else{
                self.imageView.isHidden = true
                self.imageViewHeight.constant = 0
                self.topGradientViewHeght.constant = 0
            }
             if responseDictionary["synopsis"] != nil{
             
                self.synopsis = responseDictionary["synopsis"] as! String
                self.synopsisLabel.text = self.synopsis.uppercased()
                self.synopsisLabel.isHidden = false

            }
             else{
                self.synopsisLabel.isHidden = true
             }
            if responseDictionary["category_name"] != nil{
              let categoryName = responseDictionary["category_name"] as! String

                self.navigationItem.title = categoryName
            }
            
            
            
            
            
            if let data = responseDictionary["data"] as? [VideoModel]{
                if data.count > 0 {
                   
                    self.Categories.append(contentsOf: data)
                    DispatchQueue.main.async {
                      self.categoriesCollectionView.reloadData()
                      CustomProgressView.hideActivityIndicator()
                      self.categoriesCollectionView.isHidden = false
                      CustomProgressView.hideActivityIndicator()
                        self.offsetOnceCalledForLazyLoading = false
                    }
                }else{
                    if self.Categories.count == 0{
                        DispatchQueue.main.async {
                          self.categoriesCollectionView.reloadData()
                            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                            self.maxArrayCount = self.Categories.count
                          CustomProgressView.hideActivityIndicator()
                          self.categoriesCollectionView.isHidden = false
                          CustomProgressView.hideActivityIndicator()
                        }
                    }
                    else{
                        self.maxArrayCount = self.Categories.count
                        CustomProgressView.hideActivityIndicator()
                        self.offsetOnceCalledForLazyLoading = false

                    }
                }
        }
          else{
              DispatchQueue.main.async {
//                self.videoListingTableview.reloadData()
                  WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                CustomProgressView.hideActivityIndicator()
                self.categoriesCollectionView.isHidden = false
                CustomProgressView.hideActivityIndicator()
              }
          }
            
            
            
            
            
            
            
            
            
//          self.Categories = responseDictionary["data"] as! [VideoModel]
//          if self.Categories.count == 0 {
//            DispatchQueue.main.async {
//              WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
//              CustomProgressView.hideActivityIndicator()
//                self.categoriesCollectionView.reloadData()
//            }
//          } else {
//            DispatchQueue.main.async {
////                self.navigationItem.title = self.categoryName
//              WarningDisplayViewController().noResultView.isHidden = true
//              CustomProgressView.hideActivityIndicator()
//                self.categoriesCollectionView.reloadData()
//
//            }
//          }
            
            
            
            
            
            
            
            
        }
      }
    }
 var ShowData = [ShowDetailsModel]()
    func getPartnerVideos() {
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
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
            if responseDictionary["data"] == nil{
                WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                 CustomProgressView.hideActivityIndicator()
            }
            else{
          self.ShowData = responseDictionary["data"] as! [ShowDetailsModel]
          if self.ShowData.count == 0 {
            DispatchQueue.main.async {
              WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
              CustomProgressView.hideActivityIndicator()
            }
          } else {
            DispatchQueue.main.async {
                if let showVideoListArray =  self.ShowData[0].videos {
                self.Categories = showVideoListArray
              WarningDisplayViewController().noResultView.isHidden = true
              self.categoriesCollectionView.reloadData()
              CustomProgressView.hideActivityIndicator()
            }
            }
          }
            }
        }
      }
    }
  
  func getShowVideos() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    Categories.removeAll()
    var parameterDict: [String: String?] = [ : ]
    parameterDict["show-id"] = String(categoryModel.show_id!)
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["language"] = Application.shared.langugeIdList
    ApiCommonClass.getShowVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
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
            WarningDisplayViewController().noResultView.isHidden = true
            self.categoriesCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
  func getPopularVideos() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    ApiCommonClass.getHomePopularVideos { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.Categories.removeAll()
        self.Categories = responseDictionary["Channels"] as! [VideoModel]
        if self.Categories.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
          
        }
        
      }
    }
  }
  // MARK:Button Actions
  ////
  @IBAction func backAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}
// MARK: Collectionview methods
extension AllCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if Categories.count > 0{
        return Categories.count

    }
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
   
    if fromCategories {
        if Categories[indexPath.row].logo != nil {
            cell.videoImage.sd_setImage(with: URL(string: showUrl1 + Categories[indexPath.row].logo!),placeholderImage:UIImage(named: "landscape_placeholder"))
        }
        else {
         cell.videoImage.image = UIImage(named: "landscape_placeholder")
       }
        if Categories[indexPath.row].show_name != nil{
            cell.videoName.text = Categories[indexPath.row].show_name
        }
        else{
            cell.videoName.text = ""
        }
//      if Categories[indexPath.row].is_free_video == true{
//             cell.freeTag.isHidden = true
//           }
//           else{
//             cell.freeTag.isHidden = false
//           }
      //  cell.videoImage.image = UIImage(named: "placeHolderImage")
      
    }
    else if fromHomeVC{
        if Categories.count > 0{
            if Categories[indexPath.row].logo != nil {
                cell.videoImage.sd_setImage(with: URL(string: showUrl1 + Categories[indexPath.row].logo!),placeholderImage:UIImage(named: "landscape_placeholder"))
            }
            else {
             cell.videoImage.image = UIImage(named: "landscape_placeholder")
           }
            if Categories[indexPath.row].show_name != nil{
                cell.videoName.text = Categories[indexPath.row].show_name
            }
            else{
                cell.videoName.text = ""
            }
//          if Categories[indexPath.row].is_free_video == true{
//                 cell.freeTag.isHidden = true
//               }
//               else{
//                 cell.freeTag.isHidden = false
//               }
        }
        
    }
    else if fromPartner{
        cell.videoImage.sd_setImage(with: URL(string: imageUrl + Categories[indexPath.row].logo!),placeholderImage:UIImage(named: "landscape_placeholder"))
    }
    else {

      cell.videoImage.sd_setImage(with: URL(string: imageUrl + Categories[indexPath.row].thumbnail!),placeholderImage:UIImage(named: "landscape_placeholder"))
    }
    cell.videoImage.contentMode = .scaleToFill
    cell.episodeLabel.isHidden = true
    cell.liveLabel.isHidden = true
    cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
    contentViewHeight.constant = categoriesCollectionView.contentSize.height + imageViewHeight.constant + 100
    return cell
  }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
                if  pos > 0 && pos > categoriesCollectionView.contentSize.height-50 - scrollView.frame.size.height && !offsetOnceCalledForLazyLoading{
                    offsetOnceCalledForLazyLoading = true

                    if maxArrayCount != 0 && (maxArrayCount==Categories.count){
                    }
                    else{
                        self.getCategoryVideosByid()
                    }
                }

    }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let video = Categories[indexPath.item]
    let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
    videoPlayerController.categoryModel = video
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
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
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

