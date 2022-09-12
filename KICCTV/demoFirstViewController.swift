//
//  demoFirstViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 29/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//
import UIKit
import SideMenu
import MapKit
import CoreLocation
import Reachability
class HomeViewController: UIViewController, CLLocationManagerDelegate,InternetConnectivityDelegate {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchResultsView: UIView!
    @IBOutlet weak var searchResultsForLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var noOfResultsLabel: UILabel!
    @IBOutlet weak var searchResultsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videoListingTableview: UITableView!
    var popularVideos = [VideoModel]()
    var channelVideos = [VideoModel]()
    var categoryVideos = [VideoModel]()
    var featuredVideos = [VideoModel]()
    var loactionIpArray = [VideoModel]()
    var tableviewTag = Int()
    var refreshFlag = Int()
    var trendingImage = [String]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey:"user_id") != nil {
            getToken()
        }
        setupSideMenu()
        initialView()
        refreshControlAction()
        if reachability.isReachable {
            if UserDefaults.standard.string(forKey:"access-token") != nil {
                
            }
        }
    }
    // MARK: Initial Methods
    func initialView() {
        trendingImage = ["ic_banner_three","ic_banner_two","ic_banner"]
        // self.navigationController?.isNavigationBarHidden = true
        let nib =  UINib(nibName: "HomeVideoTableViewCell", bundle: nil)
        videoListingTableview.register(nib, forCellReuseIdentifier: "homecell")
        let nib2 =  UINib(nibName: "TrendingVideoTableViewCell", bundle: nil)
        videoListingTableview.register(nib2, forCellReuseIdentifier: "trendingTableCell")
    }
    override func viewWillDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        // self.navigationController?.navigationBar.barTintColor = UIColor.red
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        if reachability.isReachable {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    
                    getIpandlocation()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                        UserDefaults.standard.set(countryCode, forKey: "countryCode")
                        
                    }
                }
            } else {
                print("Location services are not enabled")
            }
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
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
            serachController.delegate = self
            serachController.fromHome = true
            self.navigationController?.pushViewController(serachController, animated: false)
            print("Network not reachable")
        }
    }
    
    // MARK: Network Delegate
    func gotoOnline() {
        if reachability.isReachable {
            getFeaturedVideos()
        }
    }
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuWidth = view.frame.width - 100
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    func refreshControlAction() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        if #available(iOS 10.0, *) {
            videoListingTableview.refreshControl = refreshControl
        } else {
            videoListingTableview.addSubview(refreshControl)
            // Fallback on earlier versions
        }
    }
    @objc func doSomething(refreshControl: UIRefreshControl) {
        refreshFlag = 1
        getFeaturedVideos()
        getHomePopularVideos()
        getAllChannels()
        getCategoryVideos()
        refreshControl.endRefreshing()
    }
    func getHomePopularVideos() {
        if (refreshFlag != 1){
            // CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        }
        ApiCommonClass .getHomePopularVideos { (responseDictionary: Dictionary) in
            if let val = responseDictionary["error"] {
                DispatchQueue.main.async {
                }
            } else {
                if let videos = responseDictionary["Channels"] as? [VideoModel] {
                    self.popularVideos = Array(videos.prefix(10))
                }
                //                self.popularVideos = responseDictionary["Channels"] as! [VideoModel]
                print("popularVideos: ", self.popularVideos)
                print("count: ", self.popularVideos)
                
                if self.popularVideos.count == 0 {
                    DispatchQueue.main.async {
                    }
                } else {
                    DispatchQueue.main.async {
                        self.videoListingTableview.reloadData()
                    }
                }
                //self.getAllChannels()
                self.getTrendingChannels()
            }
        }
    }
    // MARK: Api Calls
    func getToken() {
        
        ApiCommonClass .getToken { (responseDictionary: Dictionary) in
            if let val = responseDictionary["error"] {
                
            } else {
                let token = responseDictionary["Channels"] as! String
                UserDefaults.standard.set(token, forKey: "access_token")
                DispatchQueue.main.async {
                    self.getFeaturedVideos()
                }
                
                print("^^^^^^^^^^")
                print(token)
                print("^^^^^^^^^^")
                
            }
        }
    }
    func getAllChannels() {
        if (refreshFlag != 1){
            //  CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        }
        var parameterDict: [String: String?] = [ : ]
        parameterDict["channel_id"] = "1"
        ApiCommonClass .getAllChannels (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if let val = responseDictionary["error"] {
                DispatchQueue.main.async {
                }
            } else {
                self.channelVideos = responseDictionary["Channels"] as! [VideoModel]
                if self.channelVideos.count == 0 {
                    DispatchQueue.main.async {
                    }
                } else {
                    DispatchQueue.main.async {
                        self.videoListingTableview.reloadData()
                        
                    }
                }
                self.getCategoryVideos()
            }
        }
    }
    func getTrendingChannels() {
        if (refreshFlag != 1){
            //  CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        }
        ApiCommonClass .getPopularChannels { (responseDictionary: Dictionary) in
            if let val = responseDictionary["error"] {
                DispatchQueue.main.async {
                }
            } else {
                self.channelVideos = responseDictionary["Channels"] as! [VideoModel]
                if self.channelVideos.count == 0 {
                    DispatchQueue.main.async {
                    }
                } else {
                    DispatchQueue.main.async {
                        self.videoListingTableview.reloadData()
                        
                    }
                }
                self.getCategoryVideos()
            }
        }
    }
    func getCategoryVideos() {
        if (refreshFlag != 1){
            // CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        }
        ApiCommonClass .getCategories { (responseDictionary: Dictionary) in
            if let val = responseDictionary["error"] {
                DispatchQueue.main.async {
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
                self.categoryVideos = responseDictionary["Channels"] as! [VideoModel]
                if self.categoryVideos.count == 0 {
                    DispatchQueue.main.async {
                        CustomProgressView.hideActivityIndicator()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.videoListingTableview.reloadData()
                        CustomProgressView.hideActivityIndicator()
                    }
                }
            }
        }
    }
    func getFeaturedVideos() {
        if (refreshFlag != 1){
            //  CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        }
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        ApiCommonClass .getFeaturedVideos { (responseDictionary: Dictionary) in
            if let val = responseDictionary["error"] {
                DispatchQueue.main.async {
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
                self.featuredVideos = responseDictionary["Channels"] as! [VideoModel]
                if self.featuredVideos.count == 0 {
                    DispatchQueue.main.async {
                    }
                } else {
                    DispatchQueue.main.async {
                        self.videoListingTableview.reloadData()
                    }
                }
                self.getHomePopularVideos()
            }
        }
    }
    func getIpandlocation() {
        let request = URLRequest(url: URL(string: "https://extreme-ip-lookup.com/json")!)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                print (json)
                //on main thread
                DispatchQueue.main.async {
                    let countryCode = json["country"] as! String
                    UserDefaults.standard.set(countryCode, forKey: "countryCode")
                    let lat = json["lat"] as! String
                    UserDefaults.standard.set(lat, forKey: "lattitude")
                    let lon = json ["lon"] as! String
                    UserDefaults.standard.set(lon, forKey: "longitude")
                    let IPAddress = json ["query"] as! String
                    UserDefaults.standard.set(IPAddress, forKey: "IPAddress")
                    let city = json ["city"] as! String
                    UserDefaults.standard.set(city, forKey: "city")
                    print(countryCode)
                    print(lat)
                    print(lon)
                    print(IPAddress)
                    
                }
                
            }catch{
                print("error\(error)")
            }
        }
        task.resume()
    }
    
    @IBAction func homeSearchAction(_ sender: Any) {
        let serachController = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! HomeSearchViewController
        self.navigationController!.pushViewController(serachController, animated: false)
    }
}
// MARK: Tableview
extension HomeViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trendingTableCell", for: indexPath) as! TrendingVideoTableViewCell
            cell.featuredVideos = featuredVideos
            // cell.treandingVideoCollecctionView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homecell", for: indexPath) as! HomeVideoTableViewCell
            //        cell.homevdeoCollectionView.showLoader()
            cell.selectionStyle = .none
            
            cell.backgroundColor = UIColor.clear
            cell.homeButton.tag = indexPath.row
            cell.homeButton.addTarget(self, action:#selector(self.allVideos(_:)), for:.touchUpInside)
            if indexPath.row == 0 {
                cell.channelType = "Popular"
                cell.channelArray = popularVideos
                cell.homeButton.setTitle( "Popular Videos", for: UIControl.State.normal)
            }
            else if indexPath.row == 1 {
                cell.channelType = "Category"
                cell.channelArray = categoryVideos
                cell.homeButton.setTitle( "Categories", for: UIControl.State.normal)
            }else{
                cell.channelType = "Channel"
                cell.channelArray = channelVideos
                cell.homeButton.setTitle( "More Channels", for: UIControl.State.normal)
            }
            return cell
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if indexPath.section == 0 {
                return 370
            } else {
                if indexPath.row == 1 {
                    return 260
                } else {
                    return 350
                }
            }
        } else {
            if indexPath.section == 0 {
                return 270
            } else {
                if indexPath.row == 1 {
                    return 160
                } else {
                    return 220
                }
            }
        }
    }
    @objc func allVideos(_ sender: UIButton) {
        if sender.tag == 0 {
            let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
            //  videoPlayerController.videos = popularVideos
            videoPlayerController.videoName = "Popular"
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
            
        } else if sender.tag == 1 {
            let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
            videoPlayerController.videoName = "Category"
            // videoPlayerController.videos = categoryVideos
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
            
        } else {
            let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "allVideos") as! AllVideosListingViewController
            videoPlayerController.videoName = "Channel"
            //  videoPlayerController.videos = channelVideos
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        }
        
    }
}
