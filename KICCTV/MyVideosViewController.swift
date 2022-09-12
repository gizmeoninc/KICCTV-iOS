//
//  WatchListViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 11/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability

class MyVideosViewController: UIViewController {

  @IBOutlet weak var watchListCollectionView: UICollectionView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var backButton: UIButton!

  var watchList = [VideoModel]()
  var updatedWatchList = [VideoModel]()
  var reachability = Reachability()!
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

 // MARK: Main Functions
  func initialView() {
    watchListCollectionView.register(UINib(nibName: "watchLisCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "watchLisCollectionViewCell")
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
    self.navigationItem.title = "My Videos"
    getWatchList()
    let  longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
         watchListCollectionView.addGestureRecognizer(longPressGesture)
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
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    ApiCommonClass.getPayperviewVideos { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.watchList.removeAll()
        self.watchList = responseDictionary["Channels"] as! [VideoModel]
        if self.watchList.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultView.isHidden = true
            self.watchListCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
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
          WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.watchList.removeAll()
        self.watchList = responseDictionary["Channels"] as! [VideoModel]
        if self.watchList.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            WarningDisplayViewController().noResultView.isHidden = true
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
           ToastView.shared.short(self.view, txt_msg: "Unable to remove watchList")
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
             self.watchListCollectionView.reloadData()
           } else {
             UIApplication.shared.endIgnoringInteractionEvents()
             WarningDisplayViewController().noResultview(view : self.view, title:  "No Results Found")
           }
         }
       }
     }
   }
}
// MARK: Collectionview methods
extension MyVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return watchList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "watchLisCollectionViewCell", for: indexPath as IndexPath) as! watchLisCollectionViewCell
    cell.videoImage.sd_setImage(with: URL(string: showUrl + watchList[indexPath.row].thumbnail!),placeholderImage:UIImage(named: "landscape_placeholder"))
    cell.videoImage.layer.cornerRadius = 8.0
    cell.videoImage.layer.masksToBounds = true
    cell.videoImage.contentMode = .scaleAspectFill
    if fromwatchlist {
      if longPressedEnabled {
        cell.closeButton.isHidden = false
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
    let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
    videoPlayerController.video = video
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
    
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (self.view.frame.size.width-30) / 3//some width
    var height = CGFloat()
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      height = (3 * width) / 2 + 10
    } else {
      height = (3 * width) / 2 + 10
    }
    return CGSize(width: width, height: height);
  }
}
extension MyVideosViewController: watchListDelegate{
  func clickButton(arrayIndex: Int?) {

   DispatchQueue.main.async {
     WarningDisplayViewController().customActionAlert(viewController :self,title: "Are you sure to remove?", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
       },{action2 in
        self.removeData(arrayIndex: arrayIndex )
       }, nil])
   }
  }
}
