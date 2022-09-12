//
//  SearchViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 30/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import CoreData
import SideMenu

class HomeSearchViewController: UIViewController,UISearchControllerDelegate,SideMenuDelegate {


    @IBOutlet weak var HeaderLabel: UILabel!{
        didSet{
            HeaderLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var serchListCollectionView: UICollectionView!
//    @IBOutlet weak var searchSuggestionTableView: UITableView!
    @IBOutlet weak var searchView: UIView?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var noresultView: UIView!
    var searchArray = [VideoModel]()
    var searchSuggestionArray = [String]()
    var type = ""
    var keyboardHeight = CGFloat()
    var serchHistoryArray = [String]()
    var serchHistoryArrayReverse = [String]()
    var channelSearchHistoryArray = [String]()
    var channelSearchHistoryArrayReverse = [String]()
    var reachability = Reachability()!
    let searchTableView: UITableView = UITableView()
    let searchSuggestionTableView: UITableView = UITableView()
    var searchListView = UIView()
    var searchString = ""
    var categoryId = ""
    var liveflag = ""
    private var myLabel : UILabel!
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
      super.viewDidLoad()
      self.searchTableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.searchListView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      //self.searchView!.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.noresultView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.serchListCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.searchSuggestionTableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
      self.navigationController?.navigationBar.isHidden = false
      self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      self.searchController.searchResultsUpdater = self
      self.searchController.delegate = self
      self.searchController.searchBar.delegate = self
      self.searchController.hidesNavigationBarDuringPresentation = false
      self.searchController.dimsBackgroundDuringPresentation = true
      self.searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.sizeToFit()
      searchController.searchBar.becomeFirstResponder()
      self.navigationItem.titleView = searchController.searchBar
      self.definesPresentationContext = true
        self.tabBarController?.tabBar.isHidden = false

      self.searchController.searchBar.placeholder = "Search"
//      setUpUI()
        self.createSearchTableView()

      
         self.retrieveData()
         if serchHistoryArray.count > 0 {
                serchHistoryArrayReverse = serchHistoryArray.reversed()
                searchTableView.reloadData()
//                searchSuggestionTableView.reloadData()
              }
     
    }
//    override func viewWillAppear(_ animated: Bool) {
//       self.navigationController?.navigationBar.isHidden = false
//       if let delegate = UIApplication.shared.delegate as? AppDelegate {
//         delegate.restrictRotation = .portrait
//       }
//       NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
//       do {
//         try reachability.startNotifier()
//       } catch {
//         print("could not start reachability notifier")
//       }
//
    var channelVideos = [VideoModel]()

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
                self.searchListView.isHidden = true
                self.noresultView.isHidden = true
                self.serchListCollectionView.isHidden = false
                self.serchListCollectionView.reloadData()
               
              CustomProgressView.hideActivityIndicator()
              //self.getYoutubeVideos()
            }
          }
        }
      }
    }
    func setUpUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        serchListCollectionView.register(UINib(nibName: "partnerDescriptionCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
        serchListCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")


//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
//        serchListCollectionView.collectionViewLayout = layout

//        self.serchListCollectionView.register(UINib(nibName: "SearchListCell", bundle: Bundle(for: SearchListCell.self)), forCellWithReuseIdentifier: "searchCell")

        self.noresultView.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
//        let newBackButton = UIBarButtonItem(image: UIImage(named: "TVExcelsideMenuBar")!.withRenderingMode(.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(HomeViewController.showSideMenu(sender:)))
//        newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
//        //let item3 = UIBarButtonItem(customView: logoButton)
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
//
//        self.navigationItem.leftBarButtonItem = newBackButton
//        setupSideMenu()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //get keyboard height
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        CustomProgressView.hideActivityIndicator()
        searchController.searchBar.text = ""
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
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
     }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
    self.tabBarController?.tabBar.isHidden = false

   
    self.setUpUI()
    self.retrieveData()
    self.getCategoryVideos()

    self.searchListView.isHidden = false
    self.serchListCollectionView.isHidden = true
    if serchHistoryArray.count > 0 {
      serchHistoryArrayReverse = serchHistoryArray.reversed()
        print("serachHisoryArrayCount",serchHistoryArray.count)
//        self.searchListView.isHidden = false

      searchTableView.reloadData()
    }
    else{
       self.searchListView.isHidden = true
    }
    CustomProgressView.hideActivityIndicator()
      self.navigationController?.navigationBar.isHidden = false
   
//    searchTableView.reloadData()
    }
    func createSearchTableView() {
        searchListView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight - 63))
        self.view.addSubview(searchListView)
        searchTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight - 63)
        let nib =  UINib(nibName: "SearchListTableViewCell", bundle: nil)

        searchTableView.register(nib, forCellReuseIdentifier: "searchcell")
        searchTableView.dataSource = self
        searchTableView.delegate = self

        self.searchListView.addSubview(searchTableView)
        self.searchTableView.separatorStyle = .none
    }

    func createSearchSuggestionTableView(){
        print("createsearchsuggestion")
        searchListView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight - 63))
        self.view.addSubview(searchListView)
        searchSuggestionTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight - 63)

        let nib1 =  UINib(nibName: "SearchSuggestionTableViewCell", bundle: nil)

        searchSuggestionTableView.register(nib1, forCellReuseIdentifier: "searchSuggestionCell")
        searchSuggestionTableView.dataSource = self
        searchSuggestionTableView.delegate = self
//      searchSuggestionTableView.backgroundColor = .red
      self.searchListView.addSubview(searchSuggestionTableView)
        self.searchSuggestionTableView.separatorStyle = .none
    }
    
    // MARK: Api Calls
    @objc func getSearchResults(searchKeyword: String!) {
        channelVideos.removeAll()
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        ApiCommonClass.getHomeSearchResults(searchText: searchKeyword, searchType: type , category: categoryId,liveflag:liveflag) { (responseDictionary: Dictionary) in
             CustomProgressView.hideActivityIndicator()
            if  responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                  
                    self.searchListView.isHidden = true
                    self.noresultView.isHidden = false
                    self.serchListCollectionView.isHidden = true
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
                self.searchArray = responseDictionary["Channels"] as! [VideoModel]
                print(self.searchArray.count)
                if self.searchArray.count == 0 {
                    print("response dictionory empty array = \(responseDictionary)")
                    CustomProgressView.hideActivityIndicator()
                    DispatchQueue.main.async {
                        self.searchListView.isHidden = true
                        self.noresultView.isHidden = false
                        self.HeaderLabel.isHidden = true
                        self.serchListCollectionView.isHidden = true
                    }
                } else {
                    print("response dictionory = \(responseDictionary)")
                    CustomProgressView.hideActivityIndicator()
                    DispatchQueue.main.async {
                        self.searchListView.isHidden = true
                        self.noresultView.isHidden = true
                        self.serchListCollectionView.isHidden = false
                        self.serchListCollectionView.reloadData()
                    }
                }
            }
        }
    }

    @objc func getSearchSuggestion(searchKeyword: String!) {
      print("getsearchsuggestion")
        channelVideos.removeAll()
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        ApiCommonClass.getSearchSuggestion(searchText: searchKeyword, searchType: type , category: categoryId,liveflag:liveflag) { (responseDictionary: Dictionary) in
             CustomProgressView.hideActivityIndicator()
            if  responseDictionary["error"] != nil {
                DispatchQueue.main.async {

                    self.searchListView.isHidden = true
                    self.noresultView.isHidden = false
                    self.serchListCollectionView.isHidden = true
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
                self.searchSuggestionArray = responseDictionary["Channels"] as! [String]
                print(self.searchSuggestionArray.count)
                if self.searchSuggestionArray.count == 0 {
                    print("response dictionory empty array = \(responseDictionary)")
                    CustomProgressView.hideActivityIndicator()
                    DispatchQueue.main.async {
                        self.searchListView.isHidden = true
                        self.noresultView.isHidden = false
                        self.HeaderLabel.isHidden = true
                        self.serchListCollectionView.isHidden = true
                    }
                } else {
                    print("response dictionory = \(responseDictionary)")
                    CustomProgressView.hideActivityIndicator()
                    DispatchQueue.main.async {
                        self.searchListView.isHidden = false
                        self.noresultView.isHidden = true
                        self.serchListCollectionView.isHidden = true
                      self.searchTableView.isHidden = true
                        self.searchSuggestionTableView.isHidden = false
                        self.searchSuggestionTableView.reloadData()
//                        self.serchListCollectionView.reloadData()
                    }
                }
            }
        }
    }
}


extension HomeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if channelVideos.count > 0 {
            return channelVideos.count
        }
        else{
            return searchArray.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if channelVideos.count  > 0 {
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                let width = (self.view.frame.size.width) / 2 - 14//some width
                var height = CGFloat()
                height = ((9 * width) / 16)
                print("heightnormal",height)
                
                
                return CGSize(width: width, height: height);
                
            } else {
                let width = (self.view.frame.size.width) / 2 - 10//some width
                var height = CGFloat()
                height = (9 * width) / 16
                print("heightnormal",height)
                return CGSize(width: width, height: height + 30);
            }
        }
        else{
            
             if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                 let width = (self.view.frame.size.width) / 2 - 10 //some width
                                     var height = CGFloat()
                height = ((9 * width) / 16) 
                 print("height",height)

                 return CGSize(width: width, height: height + 30);

                  } else {
                      let width = (self.view.frame.size.width) / 2 - 10//some width
                      var height = CGFloat()
                      height = (9 * width) / 16
                      return CGSize(width: width, height: height + 30);

                  }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if channelVideos.count > 0 {
            let cell: SearchCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionCell
            cell.backgroundColor = ThemeManager.currentTheme().grayImageColor

            self.HeaderLabel.isHidden = false
            HeaderLabel.text = "Genres"
            cell.ImageView.layer.masksToBounds = true
            cell.ImageView.layer.cornerRadius = 4

            if channelVideos[indexPath.row].categoryname != nil{
                cell.titleLabel.text = channelVideos[indexPath.row].categoryname
                cell.videoTitleLabel.text = channelVideos[indexPath.row].categoryname
                cell.videoTitleLabel.numberOfLines = 2
                cell.titleLabel.numberOfLines = 2
                cell.titleLabel.isHidden = false
               
            }
            else{
                cell.titleLabel.text = ""
                cell.videoTitleLabel.isHidden = true
                cell.titleLabel.isHidden = true
            }
            if channelVideos[indexPath.row].banner != nil {
                cell.ImageView.isHidden = false
                cell.ImageView.sd_setImage(with: URL(string: ((showUrl1 + channelVideos[indexPath.row].banner!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                cell.videoTitleLabel.isHidden = true
                
            }
            else {
                cell.ImageView.image = UIImage(named: "landscape_placeholder")
                cell.ImageView.isHidden = true
                cell.titlelabelHeight.constant = 0
                cell.videoTitleLabel.isHidden = false
                cell.titleLabel.isHidden = true
            }
            
            return cell
        }
        else {
        let cell: SearchCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionCell
            cell.videoTitleLabel.isHidden = true
            cell.ImageView.isHidden = false
            cell.titleLabel.isHidden = false
            self.HeaderLabel.isHidden = true

        cell.ImageView.layer.masksToBounds = true
        cell.ImageView.contentMode = .scaleToFill
            cell.backgroundColor = ThemeManager.currentTheme().backgroundColor

        if searchArray[indexPath.item].video_id == nil{
            // it is a show
            if searchArray[indexPath.row].logo != nil {
                cell.ImageView.sd_setImage(with: URL(string: ((showUrl1 + searchArray[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            }
            else {
                cell.ImageView.image = UIImage(named: "landscape_placeholder")
            }
            if searchArray[indexPath.row].show_name != nil{
                cell.titleLabel.text = searchArray[indexPath.row].show_name
                cell.titlelabelHeight.constant = 20
            }
            else{
                cell.titleLabel.text = " "
            }
            
            //                      cell.episodeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        else{
            // it is a video
            if searchArray[indexPath.row].logo != nil {
                cell.ImageView.sd_setImage(with: URL(string: ((showUrl1 + searchArray[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            }
            else {
                cell.ImageView.image = UIImage(named: "landscape_placeholder")
            }
            //            cell.episodeLabel.isHidden = false
            if searchArray[indexPath.row].video_title != nil{
                cell.titleLabel.text = searchArray[indexPath.row].video_title
                cell.titlelabelHeight.constant = 20
            }
            else{
                cell.titleLabel.text = " "
                cell.titlelabelHeight.constant = 0
            }
            
        }
        
        
        return cell
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if channelVideos.count > 0{
            
            let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "allCategories") as! AllCategoryViewController
            videoPlayerController.fromCategories = true
              videoPlayerController.fromPartner = false
            videoPlayerController.categoryModel = channelVideos[indexPath.item]
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        }
        else{
            let video = searchArray[indexPath.item]
            
              
              if  searchArray[indexPath.item].video_id != nil {
                 
                 
                 let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
                 videoPlayerController.video = video
                  videoPlayerController.showId = searchArray[indexPath.item].show_id!
                 self.navigationController?.pushViewController(videoPlayerController, animated: false)
              }
              else{
                  let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
                  videoPlayerController.categoryModel = video
                  self.navigationController?.pushViewController(videoPlayerController, animated: false)
                  
              }
        }
    
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //searchBar.resignFirstResponder()
    }
    
    //// MARK: CoreData
    func createData() {
      if self.searchController.searchBar.text!.trimmingCharacters(in: .whitespaces) != "" {
        if type == "channel"{
            if #available(iOS 10.0, *) {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let userEntity = NSEntityDescription.entity(forEntityName: "ChannelSearch", in: managedContext)!
                let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
                if self.searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) != "" {
                user.setValue(self.searchController.searchBar.text, forKeyPath: "searchChannelText")
                    do {
                    try managedContext.save()
                    
                    } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }else {
            if #available(iOS 10.0, *) {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
                let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
                user.setValue(self.searchController.searchBar.text, forKeyPath: "searchText")
                do {
                    try managedContext.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            } else {
                // Fallback on earlier versions
            }
        }
      }
    }
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    func retrieveData() {
        if type == "channel" {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChannelSearch")
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    let value  = data.value(forKey: "searchChannelText") as! String
                    if !channelSearchHistoryArray.contains(value){
                        channelSearchHistoryArray.append(value)
                    }
                }
            } catch {
                print("Failed")
            }
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                let result = try managedContext.fetch(fetchRequest)
                if result.isEmpty{
                    serchHistoryArray.removeAll()
                }
                else{
                for data in result as! [NSManagedObject] {
                    let value  = data.value(forKey: "searchText") as! String
                    if !serchHistoryArray.contains(value){
                        serchHistoryArray.append(value)
                    }
                }
                }
                
            } catch {
                print("Failed")
            }
        }
    }

}
extension HomeSearchViewController:UISearchResultsUpdating  {
  func updateSearchResults(for searchController: UISearchController) {
  }
  


}
extension HomeSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text, !searchString.isEmpty {
            self.view.endEditing(true)
            searchBar.resignFirstResponder()
             if searchString.trimmingCharacters(in: .whitespaces) != "" {
                if reachability.connection != .none {
//                getSearchResults(searchKeyword:searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
                }
            }
        }
  }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        self.HeaderLabel.isHidden = true
        self.serchListCollectionView.isHidden = true
//        createSearchTableView()
        self.searchListView.isHidden = true
        createSearchSuggestionTableView()
//        self.searchSuggestionTableView.reloadData()

//        if serchHistoryArray.count > 0 {
//          serchHistoryArrayReverse = serchHistoryArray.reversed()
//           self.searchListView.isHidden = false
//            self.searchTableView.isHidden = false
//          searchTableView.reloadData()
//          searchSuggestionTableView.reloadData()
//        }
//        else{
//           self.searchListView.isHidden = true
//        }
       return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        DispatchQueue.main
            .async {
                self.searchArray.removeAll()
                self.noresultView.isHidden = true
                self.searchTableView.isHidden = true
                self.searchSuggestionTableView.isHidden = true
                self.serchListCollectionView.isHidden = false
                self.getCategoryVideos()
                searchBar.text = ""
            }
        
    }
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    createData()
  }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)! {
            searchArray.removeAll()
            self.noresultView.isHidden = true
            self.serchListCollectionView.isHidden = false
//            self.serchListCollectionView.reloadData()
//            self.searchSuggestionTableView.reloadData()
        } else {
            if let searchString = searchBar.text, searchString.count > 0 {
                if reachability.connection != .none {
                    DispatchQueue.main.async {
                       if searchString.trimmingCharacters(in: .whitespaces) != "" {
                       if searchString.count > 0 {
                        Timer.scheduledTimer(timeInterval: 1, target: self,
                                             selector: #selector(self.timerDidFire(timer:)), userInfo: nil, repeats: false)
                        }
                     }
                    }
                }
            }
        }
    }

//  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    print("textdidchange")
//      if (searchBar.text?.isEmpty)! {
//          searchArray.removeAll()
//          self.noresultView.isHidden = true
//          self.serchListCollectionView.isHidden = false
//          self.serchListCollectionView.reloadData()
//        print("if case")
//      } else {
//        print("else case")
//          if let searchString = searchBar.text, searchString.count > 0 {
//              if reachability.connection != .none {
//                  DispatchQueue.main.async {
//                     if searchString.trimmingCharacters(in: .whitespaces) != "" {
//                     if searchString.count > 1 {
//                      Timer.scheduledTimer(timeInterval: 1, target: self,
//                                           selector: #selector(self.timerDidFire1(timer:)), userInfo: nil, repeats: false)
//                      }
//                   }
//                  }
//              }
//          }
//      }
//  }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
         return true
    }

    func getHintsFromTextField(textField: UITextField) {
        print("Hints for textField: \(textField)")
    }
    
    @objc private func timerDidFire(timer: Timer) {
        //createData()
//        getSearchResults(searchKeyword:  self.searchController.searchBar.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        getSearchSuggestion(searchKeyword:  self.searchController.searchBar.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))

    }


    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return ((searchBar.text?.count ?? 0) + text.count - range.length > 30) ? false : true
    }
}



extension HomeSearchViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
      if tableView == searchSuggestionTableView{
        return 1

      }
      else{
        return 1
      }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

      if tableView == searchSuggestionTableView{
        return searchSuggestionArray.count
      }
      else{
          if type == "channel" {
              return channelSearchHistoryArrayReverse.count
          }else {
              return searchSuggestionArray.count
          }
      }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      if tableView == searchSuggestionTableView{
          let cell = tableView.dequeueReusableCell(withIdentifier: "searchSuggestionCell", for: indexPath) as! SearchSuggestionTableViewCell
        cell.searchSuggestionLabel.text = searchSuggestionArray[indexPath.row]
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        return cell
      }
      else{
          let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath) as! SearchListTableViewCell
//          if type == "channel" {
//            cell.searchLabel.text = channelSearchHistoryArrayReverse[indexPath.row]
//          } else {
//            cell.searchLabel.text = serchHistoryArrayReverse[indexPath.row]
//          }
          cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        return cell
      }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if tableView == searchSuggestionTableView{
        self.searchListView.isHidden = true
        self.noresultView.isHidden = true
        self.searchSuggestionTableView.isHidden = true
        self.serchListCollectionView.isHidden = false
        if type == "channel" {
               getSearchResults(searchKeyword: channelSearchHistoryArrayReverse[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        } else {
               getSearchResults(searchKeyword: searchSuggestionArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
            print(self.searchController.searchBar.text!.replacingOccurrences(of: " ", with: ""))
        }
//        createSearchTableView()
//        self.serchListCollectionView.reloadData()
//        getSearchSuggestion(searchKeyword: searchSuggestionArray[indexPath.row].description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
      }
      else{
        searchListView.isHidden = true
        if type == "channel" {
               getSearchResults(searchKeyword: channelSearchHistoryArrayReverse[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        } else {
          getSearchResults(searchKeyword: searchSuggestionArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
            print(self.searchController.searchBar.text!.replacingOccurrences(of: " ", with: ""))
        }
      }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return 50
        } else {
            return 45
        }
    }
}

extension UIView{
       func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
           clipsToBounds = true
           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
           gradientLayer.frame = self.bounds
           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
           gradientLayer.endPoint = CGPoint(x: 0, y: 1)
           print(gradientLayer.frame)
           self.layer.insertSublayer(gradientLayer, at: 0)
       }
   }
extension UIColor {

    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }

    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
