//
//  AllChannelsTabViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 21/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import SideMenu

class AllChannelsTabViewController: UIViewController, SideMenuDelegate,UIScrollViewDelegate,InternetConnectivityDelegate{



  @IBOutlet weak var channelCollectionView: UICollectionView!
  @IBOutlet weak var buttonSelectionView: UIView!
  @IBOutlet weak var channelButton: UIButton!
  @IBOutlet weak var youtubeButton: UIButton!
  @IBOutlet weak var mainScrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var youtubetableView: UITableView!
  @IBOutlet weak var channelView: UIView!
  @IBOutlet weak var youtubeChannelView: UIView!
  @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
  @IBOutlet weak var buttonSelectionViewHeight: NSLayoutConstraint!

  var channelVideos = [VideoModel]()
    var categoryVideos = [categoryModel]()

  var reachability = Reachability()!
  var currentX:CGFloat = 0.0
  var youtubeVideos = [youtubeModel]()
  var fromNewReleaseTab = Bool()
    var fromCategories = Bool()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.channelCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor

    if reachability.connection != .none {
      if UserDefaults.standard.string(forKey:"user_id") != nil {
        if fromNewReleaseTab {
          self.getHomeNewArrivals()
        } else {
           
          self.getCategoryVideos()
            
        }
      }
    }
    setupInitial()

  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    reachability.stopNotifier()
    CustomProgressView.hideActivityIndicator()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
    self.navigationController?.navigationBar.isHidden = false
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do {
      try reachability.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = false
    self.setupSideMenu()

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
      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "noNetwork") as! NoNetworkDisplayViewController
      viewController.delegate = self
      self.navigationController?.pushViewController(viewController, animated: false)
      print("Network not reachable")
    }
  }
  // MARK: SideMenu Delegate Methods
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



  func didSelectSchedule() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "scheduleController") as! ScheduleViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
  }
  func didSelectContactUs() {
    guard let tabbarController = self.tabBarController else { return }
    ContactUSViewController.showFromContactUs(viewController: tabbarController)
  }
   func didSelectPremium() {
     let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionListnew") as! subscriptionListViewController
     SubscriptionHelperClass().getUserSubscriptions()

     self.navigationController?.pushViewController(watchListController, animated: false)
   }
  func didSelectLanguage() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "updatelanguage") as! UpdateLanguageListViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
  }
  func didSelectFavorites() {
      if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
             DispatchQueue.main.async {
                 WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to see Favorites", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
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
  // MARK: Button Actions
  @IBAction func channelButtonAction(_ sender: Any) {
    UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
      self.mainScrollView.contentOffset.x = 0
    }, completion: nil)
  }

  @IBAction func youtubeButtonAction(_ sender: Any) {
    UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
      self.mainScrollView.contentOffset.x = UIScreen.main.bounds.width
    }, completion: nil)
  }
  @objc func btnOpenSearch() {
    let serachController = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! HomeSearchViewController
    serachController.type = "channel"
    self.navigationController!.pushViewController(serachController, animated: false)
  }

  // MARK: Main Functions
  func setupInitial() {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
    let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))

    self.navigationController?.navigationBar.isHidden = false
    self.channelCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    navigationItem.leftBarButtonItem?.tintColor = ThemeManager.currentTheme().UIImageColor
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
    self.navigationItem.hidesBackButton = true
    let newBackButton = UIBarButtonItem(image: UIImage(named: "TVExcelsideMenuBar")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(HomeViewController.showSideMenu(sender:)))
    newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
    self.navigationItem.leftBarButtonItem = newBackButton
//    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
//    imageView.contentMode = .scaleAspectFit
//    //let image = UIImage(named: ThemeManager.currentTheme().navigationControllerLogo)
//    imageView.image = AppHelper.imageScaledToSize(image: UIImage(named: ThemeManager.currentTheme().navigationControllerLogo)!, newSize: CGSize(width: 120, height: 50))
    navigationItem.title = "Categories"

    channelCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
    channelCollectionView.delegate = self
    channelCollectionView.dataSource = self
    self.view.addSubview(navigationBar)
    self.refreshControlAction()
  }
  func gotoOnline() {
    if fromNewReleaseTab {
      self.getHomeNewArrivals()
    } else {
      self.getCategoryVideos()
    }
  }
  func refreshControlAction() {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = ThemeManager.currentTheme().UIImageColor
    refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
    if #available(iOS 10.0, *) {
      channelCollectionView.refreshControl = refreshControl
    } else {
      channelCollectionView.addSubview(refreshControl)
    }
  }
  @objc func doSomething(refreshControl: UIRefreshControl) {
//    if fromNewReleaseTab {
//      self.getHomeNewArrivals()
//    } else {
//      self.getCategoryVideos()
//    }
    refreshControl.endRefreshing()
  }


  // MARK: API Calls
  func getAllLiveVideos() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    ApiCommonClass.getHomePopularVideos { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          WarningDisplayViewController().noResultview(view : self.view,title: "Coming Soon")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.channelVideos = responseDictionary["Channels"] as! [VideoModel]
        if self.channelVideos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "Coming Soon")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.channelCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
            //self.getYoutubeVideos()
          }
        }
      }
    }
  }
  func getAllChannels() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    ApiCommonClass.getHomePopularVideos { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.channelVideos = responseDictionary["Channels"] as! [VideoModel]
        if self.channelVideos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.channelCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
            //self.getYoutubeVideos()

          }
        }

      }
    }
  }
  func getHomeNewArrivals() {
//    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
//    ApiCommonClass.getHomeNewArrivals { (responseDictionary: Dictionary) in
//      if responseDictionary["error"] != nil {
//        DispatchQueue.main.async {
//          WarningDisplayViewController().noResultview(view : self.view,title: "Coming Soon")
//          CustomProgressView.hideActivityIndicator()
//        }
//      } else {
//        self.channelVideos = responseDictionary["data"] as! [VideoModel]
//        if self.channelVideos.count == 0 {
//          DispatchQueue.main.async {
//            WarningDisplayViewController().noResultview(view : self.view,title: "Coming Soon")
//            CustomProgressView.hideActivityIndicator()
//          }
//        } else {
//          DispatchQueue.main.async {
//            self.channelCollectionView.reloadData()
//            CustomProgressView.hideActivityIndicator()
//            //self.getYoutubeVideos()
//          }
//        }
//      }
//    }
  }
  func getCategoryVideos() {
    self.channelVideos.removeAll()
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    ApiCommonClass.getCategories { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          WarningDisplayViewController().noResultview(view : self.view,title: "Coming Soon")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.channelVideos = responseDictionary["categories"] as! [VideoModel]
        if self.channelVideos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "Coming Soon")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.channelCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
            //self.getYoutubeVideos()
          }
        }
      }
    }
  }
  func getYoutubeVideos() {
    ApiCommonClass.getYTVOD { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        DispatchQueue.main.async {
          self.youtubeVideos = responseDictionary["Channels"] as! [youtubeModel]
          self.youtubetableView.reloadData()
          CustomProgressView.hideActivityIndicator()
        }
      }
    }
    CustomProgressView.hideActivityIndicator()
  }
}
extension AllChannelsTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if fromCategories{
        print("channelvideos",channelVideos.count)
        return channelVideos.count
    }
    else{
    return channelVideos.count
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
    cell.videoImage.layer.cornerRadius = 8.0
    cell.videoImage.layer.masksToBounds = true
    if fromNewReleaseTab {

      cell.videoImage.sd_setImage(with: URL(string: ((showUrl1 + channelVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
      cell.videoName.text = channelVideos[indexPath.row].video_title
      cell.videoName.isHidden = true
    }
    else if fromCategories {
        
        if channelVideos[indexPath.row].image != nil {
            if channelVideos[indexPath.row].image == ""{
                if channelVideos[indexPath.row].categoryname != nil {
                    cell.videoName.text = channelVideos[indexPath.row].categoryname
                    cell.videoView.backgroundColor = .darkGray
                    cell.videoImage.isHidden = true
                }
                else {
                    cell.videoName.text = " "
                    cell.videoView.backgroundColor = .darkGray
                    cell.videoImage.isHidden = true
                }
            }
            else{
                cell.videoImage.sd_setImage(with: URL(string: ((imageUrl + channelVideos[indexPath.row].image!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                cell.videoName.isHidden = true
                cell.videoImage.isHidden = false
            }
            
        }
        else{
            if channelVideos[indexPath.row].categoryname != nil {
                cell.videoName.text = channelVideos[indexPath.row].categoryname
                cell.videoView.backgroundColor = .darkGray
                cell.videoImage.isHidden = true
                }
            else {
                cell.videoName.text = " "
                cell.videoView.backgroundColor = .darkGray
                cell.videoImage.isHidden = true
                
            }
        }
      
    } else {
      if channelVideos[indexPath.row].image != nil {

        cell.videoImage.sd_setImage(with: URL(string: ((imageUrl + channelVideos[indexPath.row].image!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        cell.videoName.isHidden = true
        
      } else {
        cell.videoName.text = channelVideos[indexPath.row].categoryname
        cell.videoView.backgroundColor = .darkGray
//        cell.videoImage.image = UIImage(named: "lightGrayColor")
       
      }
    }
    cell.layer.cornerRadius = ((self.view.frame.size.width - 30) / 3 / 2)
    cell.layer.masksToBounds = true
    cell.layer.borderColor = ThemeManager.currentTheme().TabbarColor.cgColor
           cell.videoName.isHidden = false
    cell.layer.borderWidth = 3
    cell.PartNumber.isHidden = true
    cell.liveLabel.isHidden = true
    cell.backgroundColor = ThemeManager.currentTheme().grayImageColor
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if fromNewReleaseTab {
      let video = channelVideos[indexPath.item]
      let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
      videoPlayerController.categoryModel = video
      self.navigationController?.pushViewController(videoPlayerController, animated: false)
    }
    
    else {
      let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "allCategories") as! AllCategoryViewController
      videoPlayerController.fromCategories = true
        videoPlayerController.fromPartner = false
      videoPlayerController.categoryModel = channelVideos[indexPath.item]
      self.navigationController?.pushViewController(videoPlayerController, animated: false)
    }
  }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if fromNewReleaseTab {
      let width = (self.view.frame.size.width-30) / 3//some width
      var height = CGFloat()
      height = (3 * width) / 2
      return CGSize(width: width, height: height)
    } else {
      let width = (self.view.frame.size.width - 30) / 3
      var height = CGFloat()
      height = (self.view.frame.size.width - 30) / 3
      return CGSize(width: width, height: height)
    }
  }
}
extension AllChannelsTabViewController: UITableViewDelegate, UITableViewDataSource {
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
    cell.youtubeImageView.image = UIImage(named: "placeHolder400*600")
    cell.youtubeImageView.sd_setImage(with: URL(string: (( youtubeVideos[indexPath.row].thumbnail!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder400*600"))
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
