//
//  WatchListViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 11/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import SideMenu


class WatchListViewController: UIViewController,SideMenuDelegate {

  @IBOutlet weak var watchListCollectionView: UICollectionView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var backButton: UIButton!

  var watchList = [VideoModel]()
  var updatedWatchList = [VideoModel]()
  var reachability = Reachability()!
    @IBOutlet weak var noResultView: UIView!{
        didSet{
            
            self.noResultView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        }
    }
    var fromwatchlist = false
  var longPressedEnabled = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = false
    WarningDisplayViewController().noResultView.isHidden = true
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.watchListCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
  }

  override func viewWillDisappear(_ animated: Bool) {
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    self.dismiss(animated: false, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
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
   
    self.initialView()
  }
    var isFromTab = false

 // MARK: Main Functions
  func initialView() {
    watchListCollectionView.register(UINib(nibName: "watchLisCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "watchLisCollectionViewCell")
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
    if fromwatchlist {
        
      self.navigationItem.title = "My List"
        let newBackButton = UIButton(type: .custom)
        newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
        newBackButton.contentMode = .scaleAspectFit
        newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
        newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
        newBackButton.addTarget(self, action: #selector(WatchListViewController.backAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: newBackButton)
        self.navigationItem.leftBarButtonItem = item2
        if  isFromTab{
            let newBackButton = UIBarButtonItem(image: UIImage(named: "TVExcelsideMenuBar")!.withRenderingMode(.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(HomeViewController.showSideMenu(sender:)))
            newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
            //let item3 = UIBarButtonItem(customView: logoButton)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)

            self.navigationItem.leftBarButtonItem = newBackButton
          
            
        }
        
      getWatchList()
      let  longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
      watchListCollectionView.addGestureRecognizer(longPressGesture)
        
    } else {
      self.navigationItem.title = "Favorites"
      getLikeList()
    }
    setupSideMenu()
  }
    fileprivate func setupSideMenu() {
       // Define the menus
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
//                ActivationVC.showFromActivation(viewController: tabbarController)
            }
       
    }
    func didSelectWatchList() {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            DispatchQueue.main.async {
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see your My List", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                        self.MoveTOLoginPage()
                    },nil])
            }
        }
        else{
      let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
        watchListController.fromwatchlist = true
      self.navigationController?.pushViewController(watchListController, animated: false)
        }
    }
    func didSelectMyVideos() {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            DispatchQueue.main.async {
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see Live", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                        self.MoveTOLoginPage()
                    },nil])
            }
        }
        else{
      let myVideosController = self.storyboard?.instantiateViewController(withIdentifier: "liveTab") as! LiveTabViewController
        self.navigationController?.pushViewController(myVideosController, animated: false)
        }
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
    func didSelectFavorites() {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
             DispatchQueue.main.async {
                 WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see your Favorites", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                         self.MoveTOLoginPage()
                     },nil])
             }
         }
        else{
      let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
      self.navigationController?.pushViewController(watchListController, animated: false)
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
// MARK: Button Functions
  @objc func longTap(_ gesture: UIGestureRecognizer){
    self.longPressedEnabled = true
    self.watchListCollectionView.reloadData()
  }
  @IBAction func backAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
    // MARK: Api methods
  func getWatchList() {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["type"] = ""
    print("parameterDict",parameterDict)
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        ApiCommonClass.getWatchList(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
//          WarningDisplayViewController().noResultview(view : self.view,title: "Oops!Your List is empty")
            self.noResultView.isHidden = false
            self.watchListCollectionView.isHidden = true
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.watchList.removeAll()
        self.watchList = responseDictionary["Channels"] as! [VideoModel]
        if self.watchList.count == 0 {
          DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
                       self.noResultView.isHidden = false
            self.watchListCollectionView.isHidden = true


          }
        }
         else {

          DispatchQueue.main.async {
            CustomProgressView.hideActivityIndicator()
            self.watchListCollectionView.isHidden = false
                        self.noResultView.isHidden = true

            self.watchListCollectionView.reloadData()
          }
        }
      }
    }
  }
  func getLikeList() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    ApiCommonClass.getLikeList { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          WarningDisplayViewController().noResultview(view : self.view,title: "Oops!Your List is empty")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.watchList.removeAll()
        self.watchList = responseDictionary["Channels"] as! [VideoModel]
        if self.watchList.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "Oops!Your List is empty")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultView.removeFromSuperview()
            self.watchListCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
   func removeData(arrayIndex: Int?){
     UIApplication.shared.beginIgnoringInteractionEvents()
     var parameterDict: [String: String?] = [ : ]
     parameterDict["show-id"] = String(format: "%d", watchList[arrayIndex!].show_id!)
     parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
     parameterDict["device_type"] = "ios-phone"
     parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
     parameterDict["watchlistflag"] = "0"
     parameterDict["deletestatus"] = "1"
     parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
     ApiCommonClass.WatchlistShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
       if responseDictionary["error"] != nil {
         DispatchQueue.main.async {
           UIApplication.shared.endIgnoringInteractionEvents()
           ToastView.shared.short(self.view, txt_msg: "Unable to remove My List")
         }
       } else {
         DispatchQueue.main.async {
           self.longPressedEnabled = false
           if let arrayIndex = arrayIndex {
             if !self.watchList.isEmpty{
             self.watchList.remove(at: arrayIndex)
             }
           }
           if !self.watchList.isEmpty {
            
             UIApplication.shared.endIgnoringInteractionEvents()
            self.noResultView.isHidden = true
            self.watchListCollectionView.isHidden = false
             self.watchListCollectionView.reloadData()
           } else {
             UIApplication.shared.endIgnoringInteractionEvents()
            self.watchListCollectionView.isHidden = true

                      self.noResultView.isHidden = false
//            self.watchListCollectionView.reloadData()

//             WarningDisplayViewController().noResultview(view : self.view, title:  "Oops!Your List ")
           }
         }
       }
     }
   }
    @objc func removeIem(sender:UIButton){
        remove(arrayIndex: sender.tag)
    }
    func remove(arrayIndex:Int?){
       DispatchQueue.main.async {
          WarningDisplayViewController().customActionAlert(viewController :self,title: "Are you sure to remove?", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
            },{action2 in
                self.removeData(arrayIndex: arrayIndex)
            }, nil])
        }
    }

}
// MARK: Collectionview methods
extension WatchListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return watchList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "watchLisCollectionViewCell", for: indexPath as IndexPath) as! watchLisCollectionViewCell
    if watchList[indexPath.row].logo != nil {
        cell.videoImage.sd_setImage(with: URL(string: showUrl1 + watchList[indexPath.row].logo!),placeholderImage:UIImage(named: "landscape_placeholder"))
    }
    else {
        cell.videoImage.image = UIImage(named: "landscape_placeholder")
    }
    if watchList[indexPath.row].show_name != nil {
        cell.videoLabel.text = watchList[indexPath.row].show_name?.uppercased()
    }
    else{
        cell.videoLabel.text = ""
    }
    cell.videoImage.layer.cornerRadius = 8.0
    cell.videoImage.layer.masksToBounds = true
    cell.videoImage.contentMode = .scaleAspectFill
    if fromwatchlist {
      if longPressedEnabled {
        cell.closeButton.isHidden = false
        cell.closeButton.addTarget(self, action: #selector(removeIem(sender:)), for: .touchUpInside)
        cell.closeButton.tag = indexPath.item
        cell.startAnimate()
      } else {
        cell.closeButton.isHidden = true
        cell.stopAnimate()
      }
    } else {
      cell.closeButton.isHidden = true
    }
    cell.delegate = self
    cell.arrayIndex = indexPath.row
    cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
    return cell
  }
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5.0
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let video = watchList[indexPath.item]
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
    viewController.categoryModel = video
    self.navigationController?.pushViewController(viewController, animated: false)
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
   
    
    var height = CGFloat()
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        let width = (self.view.frame.size.width) / 2 - 10//some width
        var height = CGFloat()
        height = ((9 * width) / 16)
        return CGSize(width: width, height: height + 30)

    } else {
        let width = (self.view.frame.size.width) / 2 - 10//some width
        height = (9 * width) / 16
        return CGSize(width: width, height: height + 30);

    }
}
}
extension WatchListViewController: watchListDelegate{
     func clickButton(arrayIndex: Int?) {

   DispatchQueue.main.async {
     WarningDisplayViewController().customActionAlert(viewController :self,title: "Are you sure to remove?", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
       },{action2 in
        self.removeData(arrayIndex: arrayIndex )
       }, nil])
   }
  }
}

