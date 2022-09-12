//
//  ChannelListViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 19/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//


import UIKit
import GoogleInteractiveMediaAds
import SDWebImage
import FacebookLogin
import FacebookCore
import SJSwiftSideMenuController
import Reachability

class ChannelListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var channelCollectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var searchView: UIView!
  @IBOutlet weak var searchResultsTableView: UITableView!
  @IBOutlet weak var searchResultsView: UIView!
  @IBOutlet weak var searchResultsForLabel: UILabel!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var noOfResultsLabel: UILabel!
  @IBOutlet weak var searchResultsViewHeight: NSLayoutConstraint!
  let reachability = Reachability()!
  // MARK: IBActions
  @IBAction func clearAction(_ sender: Any) {
    searchResultsView.isHidden = true
    searchResultsViewHeight.constant = 0
  }
  @IBAction func searchAction(_ sender: Any) {
    if searchBar.text == "" {
      searchResultsView.isHidden = false
      searchResultsViewHeight.constant = 0
      channelCollectionView.isHidden = false
      searchResultsTableView.isHidden = true
    } else {
      searchResultsView.isHidden = false
      searchResultsViewHeight.constant = 44
      getSearchResults( searchKeyword: searchBar.text)
    }
  }
  @IBAction func menuAction(_ sender: Any) {
 //   SJSwiftSideMenuController.toggleLeftSideMenu()
    if searchResultsTableView.isHidden == false{
      searchResultsTableView.isHidden = true
      channelCollectionView.isHidden = false
      searchResultsView.isHidden = true
      searchResultsViewHeight.constant = 0
      searchBar.text = ""
      searchBar.endEditing(true)
    }
      
  }
  // MARK: - Property declaration
  var borderView =  CAShapeLayer()
  var searchButtonClicked = Bool()
  var searchBarClicked = Bool()
  // Storage point for videos.
  var videos = [VideoModel]()
  var searchArray = [VideoModel]()
  var adsLoader: IMAAdsLoader?
  var language: NSString!
  // MARK: Main methods
  // Set up the app.
  override func viewDidLoad() {
    super.viewDidLoad()
    initialView()
    // GetChannelVideos()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //declare this inside of viewWillAppear
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do {
      try reachability.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
  }
  func initialView() {
    self.navigationController?.isNavigationBarHidden = true
    menuButton.imageView?.image = AppHelper.imageScaledToSize(image: UIImage(named: "ic_splash_bg")!, newSize: CGSize(width: 20, height: 30))
    channelCollectionView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellWithReuseIdentifier: "ChannelCell")
    // customize search bar
    searchBar.placeholder = "Enter Text to Search"
    let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
    textFieldInsideSearchBar?.textColor = UIColor().searchBarTextColor()
    textFieldInsideSearchBar?.font = UIFont.init(name: FontBold, size: 15)
    textFieldInsideSearchBar?.returnKeyType = UIReturnKeyType.default
    let attributes = [
      NSForegroundColorAttributeName: UIColor().commonBackgroundColor(), NSFontAttributeName: UIFont(name: FontRegular, size: 15)! // Note the !
    ]
    textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString( string: "Enter Text to Search", attributes: attributes )
    searchBarClicked = false
    searchButton.isHidden = true
    contentView.layer.borderColor = UIColor ().commonBackgroundColor ().cgColor
    contentView.layer.borderWidth = 1.0
    let searchBarPath = UIBezierPath(roundedRect: searchView.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 7.5, height: 7.5))
    let searchBarMaskLayer = CAShapeLayer()
    searchBarMaskLayer.path = searchBarPath.cgPath
    searchBarMaskLayer.backgroundColor = UIColor().commonBackgroundColor().cgColor
    searchView.layer.mask = searchBarMaskLayer
    borderView.frame = searchView.bounds
    borderView.path = searchBarPath.cgPath
    borderView.strokeColor = UIColor().commonBackgroundColor().cgColor
    borderView.fillColor = nil
    borderView.lineWidth = 2
    searchView.layer.addSublayer(borderView)
    let nib =  UINib(nibName: "SearchResultsTableViewCell", bundle: nil)
    searchResultsTableView.register(nib, forCellReuseIdentifier: "SearchResultsTableViewCell")
    searchResultsTableView.isHidden = true
    channelCollectionView.isHidden = false
    searchResultsView.isHidden = true
    searchResultsViewHeight.constant = 0
  }
  func setupSearchResultsView() {
    let string = String(format: "Search Results for '%@'", searchBar.text!)
    let boldString = String(format: "'%@'",  searchBar.text!)
    let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSFontAttributeName : UIFont.init(name: FontMedium, size: 11) as Any])
    let boldFontAttribute: [NSAttributedStringKey: Any] = [NSFontAttributeName as NSString : UIFont.init(name: FontBold, size: 11) as Any]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute as [String: Any], range: range)
    searchResultsForLabel?.attributedText = attributedString
    let string2 = String(format: "%@ Results Found", String(searchArray.count))
    let boldString2 = String(format: "%@", String(searchArray.count))
    let attributedString2 = NSMutableAttributedString(string: string2,
                                                      attributes: [NSFontAttributeName : UIFont.init(name: FontMedium, size: 11) as Any])
    let boldFontAttribute2: [NSAttributedStringKey: Any] = [NSFontAttributeName as NSString : UIFont.init(name: FontBold, size: 11) as Any]
    let range2 = (string2 as NSString).range(of: boldString2)
    attributedString2.addAttributes(boldFontAttribute2 as [String: Any], range: range2)
    noOfResultsLabel?.attributedText = attributedString2
    searchButton.imageView?.image = AppHelper.imageScaledToSize(image: UIImage(named:"clear")!, newSize: CGSize(width: 10, height: 10))
    searchButton.imageView?.contentMode = .center
  }
  func setupSearchBar() {
    if searchBarClicked {
      let path = UIBezierPath(roundedRect: searchBar.bounds, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 5, height:  5))
      let maskLayer = CAShapeLayer()
      maskLayer.path = path.cgPath
      searchBar.layer.mask = maskLayer
    } else {
      let path = UIBezierPath(roundedRect: searchBar.bounds,
                              byRoundingCorners: [.topRight, .topLeft],
                              cornerRadii: CGSize(width: 5, height:  5))
      let maskLayer = CAShapeLayer()
      maskLayer.path = path.cgPath
      searchBar.layer.mask = maskLayer
    }
  }
  // MARK: Collectionview methods
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videos.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: ChannelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
    let video = videos[indexPath.item]
    
    cell.thumbnail?.sd_setImage(with: URL(string: channelUrl + videos[indexPath.row].logo!),
                                placeholderImage:UIImage(named: "ic_splash_bg"))
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      cell.thumbnailHeight?.constant = 255
    } else {
      cell.thumbnailHeight?.constant = 150
    }
 
  cell.videoLabel?.text = video.channel_name
    if video.live_flag == 1{
      cell.liveLabel.isHidden = false
        cell.liveLabel.layer.cornerRadius = 8.0
      cell.liveLabel.layer.masksToBounds = true
    }else{
       cell.liveLabel.isHidden = true
    
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let video = videos[indexPath.item]
    let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "Player") as! VideoPlayerViewController
    videoPlayerController.video = video
    //self.present(videoPlayerController, animated: true, completion: nil)
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {

    
    let width = (self.contentView.frame.size.width) / 2.2//some width
    var height = CGFloat()
     if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
       height = CGFloat(300.0)
     }else{
     height = CGFloat(200.0)
    }
   // let width = (self.view.frame.size.width - 12 * 3) / 2//some width
   //rat//let height = (width * 3.6 / 2.8  )//ratio
    return CGSize(width: width, height: height);
//    }
  }
  // MARK: Api methods
  //Get Channel Videos
//  func getChannelVideos() {
//    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
//    ApiCommonClass .getChannels { (responseDictionary: Dictionary) in
//      if let val = responseDictionary["error"] {
//        DispatchQueue.main.async {
//          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
//          CustomProgressView.hideActivityIndicator()
//        }
//      } else {
//        self.videos = responseDictionary["Channels"] as! [VideoModel]
//        if self.videos.count == 0 {
//          DispatchQueue.main.async {
//            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
//            CustomProgressView.hideActivityIndicator()
//          }
//        } else {
//          DispatchQueue.main.async {
//            self.channelCollectionView.reloadData()
//            CustomProgressView.hideActivityIndicator()
//          }
//        }
//      }
//    }
//  }
  
  func getAllChannels() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    var parameterDict: [String: String?] = [ : ]
    parameterDict["channel_id"] = "1"
    print(parameterDict)
    ApiCommonClass .getAllChannels (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
              CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.videos = responseDictionary["Channels"] as! [VideoModel]
        print(self.videos)
        if self.videos.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.channelCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
            
          }
        }
      }
    }
  }
  @objc func getSearchResults(searchKeyword: String!) {
    // CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    ApiCommonClass .getSearchResults(searchText: searchKeyword) { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          //CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.searchArray = responseDictionary["Channels"] as! [VideoModel]
         print("^^^^^^^^^^^^^^^^^")
        print(self.searchArray)
         print("^^^^^^^^^^^^^^^^^")
        if self.searchArray.count == 0 {
          DispatchQueue.main.async {
            //WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found" , messageType: "1", delegate: self)
            //CustomProgressView.hideActivityIndicator()
            self.searchResultsTableView.reloadData()
          }
        } else {
          DispatchQueue.main.async {
            if self.searchButtonClicked {
              self.searchButtonClicked = false
              self.videos = self.searchArray
              self.channelCollectionView.reloadData()
              self.channelCollectionView.isHidden = false
              self.searchResultsTableView.isHidden = true
              self.setupSearchResultsView()
            } else {
              self.searchResultsTableView.reloadData()
              self.searchResultsTableView.isHidden = false
              self.channelCollectionView.isHidden = true
            }
            //CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
  func getSearchList() {
    ApiCommonClass.getSearchlist() { (_ responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          //CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.searchArray = responseDictionary["Channels"] as! [VideoModel]
        if self.searchArray.count == 0 {
          DispatchQueue.main.async {
            // WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found" , messageType: "1", delegate: self)
            //CustomProgressView.hideActivityIndicator()
            
          }
        } else {
          DispatchQueue.main.async {
            self.searchResultsTableView.reloadData()
            self.searchResultsTableView.isHidden = false
            self.channelCollectionView.isHidden = true
            //CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
  // MARK: Search bar methods
  public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBarClicked = true
    searchButton.isHidden = false
    borderView.strokeColor = UIColor().searchBarTextColor().cgColor
    contentView.layer.borderColor = UIColor().searchBarTextColor().cgColor
  }
  // called when text ends editing
  public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBarClicked = false
    borderView.strokeColor = UIColor().commonBackgroundColor().cgColor
    contentView.layer.borderColor = UIColor().commonBackgroundColor().cgColor
    if searchBar.text == "" {
      print("%%%%%%%%%%%%%%%%%%%%%%%")
        print("%%%%%%%%%%%%%%%%%%%%%%%")
      self.searchResultsTableView.isHidden = true
      self.channelCollectionView.isHidden = false
      searchButton.isHidden = true
    }
  }
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == "" {
     // getSearchList()
      getAllChannels()
    } else {
      DispatchQueue.main.async {
      
        self.getSearchResults(searchKeyword: searchText)
      }
    }
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  // called when cancel button pressed
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if searchBar.text == "" {
    } else {
    //  getChannelVideos()
      getAllChannels()
      searchBar.text = ""
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
     // getChannelVideos()
      getAllChannels()
      searchBar.text = ""
    case .cellular:
      print("Reachable via Cellular")
     // getChannelVideos()
      getAllChannels()
      searchBar.text = ""
    case .none:
      //AppHelper.showAlertMessage(vc: self, title: "", message: "Network connection lost!")
      AppHelper.showAppErrorWithOKAction(vc: self, title: "", message: "Network connection lost!", handler: nil)
      print("Network not reachable")
    }
  }
  // MARK: TableView
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 45
  }
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchArray.count
  }
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       Bundle.main .loadNibNamed("SearchResultsTableViewCell", owner: self, options: nil)
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as! SearchResultsTableViewCell

    let video = searchArray[indexPath.row]
    cell.channelName.text = video.channel_name
    if  video.logo != nil{
    cell.channelLogo.sd_setImage(with: URL(string: channelUrl + video.logo!),
                                 placeholderImage:UIImage(named: "menu"))
    }
 
    return cell
  }
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchButtonClicked = true
    searchResultsView.isHidden = false
    searchResultsViewHeight.constant = 44
  //  getSearchResults(searchKeyword: searchBar.text)
    searchBar.resignFirstResponder()
  }
 
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}
