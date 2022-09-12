//
//  LiveTabViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 14/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//
import UIKit
import Reachability
import SideMenu

class LiveTabViewController: UIViewController, SideMenuDelegate,InternetConnectivityDelegate {

  var liveVideos = [VideoModel]()
  var reachability = Reachability()!
  
  @IBOutlet var contentView: UIView!{
    didSet{
      self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
  }
  @IBOutlet weak var liveVideoCollectionView: UICollectionView!{
    didSet{
      self.liveVideoCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //WarningDisplayViewController().noResultview(view : self.view,title: "Coming Soon")
    if reachability.connection != .none {
      self.getAllLiveVideos()
    }
    setInitial()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    CustomProgressView.hideActivityIndicator()
    reachability.stopNotifier()
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
      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "noNetwork") as! NoNetworkDisplayViewController
      viewController.delegate = self
      self.navigationController?.pushViewController(viewController, animated: false)
      print("Network not reachable")
    }
  }
  
  // MARK: setupSideMenu
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
    func cancelAlertAction(){
        self.navigationController?.popToRootViewController(animated: false) // return to home
    }
    func MoveTOLoginPage() {
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController // move to login page from guest user                                                                                                                       login
        loginController.isFromSideMenu = true
        self.navigationController?.pushViewController(loginController, animated: true)
    }
  func didSelectWatchList() {
     let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
       watchListController.fromwatchlist = true
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
  func didSelectPremium() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionListnew") as! subscriptionListViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
  }
  func didSelectContactUs() {
    guard let tabbarController = self.tabBarController else { return }
    ContactUSViewController.showFromContactUs(viewController: tabbarController)
  }
  func didSelectFavorites() {
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
    self.navigationController?.pushViewController(watchListController, animated: false)
   }
  // MARK: Main Function
  func setInitial() {
//    self.navigationItem.title = "NewReleases"
    
    
    self.navigationItem.hidesBackButton = true
    liveVideoCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
    let newBackButton = UIBarButtonItem(image: UIImage(named: "TVExcelBack")!.withRenderingMode(.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction))
    newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
    //let item3 = UIBarButtonItem(customView: logoButton)
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
    self.navigationItem.title = "Live"
    let search = UIBarButtonItem(image: UIImage(named: "TVExcelSearchImage")!.withRenderingMode(.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(AllCategoryViewController.btnOpenSearch))
    search.tintColor = ThemeManager.currentTheme().UIImageColor
    //self.navigationItem.rightBarButtonItem = search
  }
    @objc func backAction(){
        navigationController?.popViewController(animated: true)

    }
  func gotoOnline() {
    self.getAllLiveVideos()
  }
  func refreshControlAction() {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = ThemeManager.currentTheme().UIImageColor
    refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
    if #available(iOS 10.0, *) {
      liveVideoCollectionView.refreshControl = refreshControl
    } else {
      liveVideoCollectionView.addSubview(refreshControl)
    }
  }
  @objc func doSomething(refreshControl: UIRefreshControl) {
    self.getAllLiveVideos()
    refreshControl.endRefreshing()
  }
  // MARK: Button Actions
  @objc func btnOpenSearch() {
    let serachController = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! HomeSearchViewController
    serachController.type = "video"
    serachController.liveflag = "1"
    self.navigationController!.pushViewController(serachController, animated: false)
  }
  // MARK: API Calls
    func getAllLiveVideos() {
      CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
      ApiCommonClass.getAllChannels { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          self.liveVideos = responseDictionary["data"] as! [VideoModel]
          if self.liveVideos.count == 0 {
            DispatchQueue.main.async {
              WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
              CustomProgressView.hideActivityIndicator()
            }
          } else {
            DispatchQueue.main.async {
              self.liveVideoCollectionView.reloadData()
              CustomProgressView.hideActivityIndicator()
            }
          }
        }
      }
    }
  }
// MARK: Collectionview methods
extension LiveTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return liveVideos.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
    cell.videoImage.sd_setImage(with: URL(string: ((channelUrl + liveVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
    cell.videoImage.contentMode = .scaleAspectFill
    cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.white.cgColor
    cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
    cell.videoName.text = liveVideos[indexPath.row].channel_name
    cell.videoName.isHidden = true
    cell.liveLabel.isHidden = false
    cell.liveLabel.layer.cornerRadius = 4
    
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if liveVideos[indexPath.item].live_flag == 0 {
      ToastView.shared.short(self.view, txt_msg: "No Live Found")
    } else {
    let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "channelvideo") as! ChannelVideoViewController
    videoPlayerController.channelVideo = liveVideos[indexPath.item]
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
    }
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
   
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        let width = (self.view.frame.size.width-30) / 3//some width
        let height = (3 * width) / 2
        return CGSize(width: width, height: height)

    }else{
        let width = (self.view.frame.size.width-30) / 3//some width
        var height = CGFloat()
        height = (3 * width) / 2
        return CGSize(width: width, height: height)

    }
  }
}


