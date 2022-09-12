//
//  SelectLanguageViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 11/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
class SelectLanguageViewController: UIViewController {

  @IBOutlet weak var nextOutlet: UIButton!
  @IBOutlet weak var languageCollectionView: UICollectionView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var topBarView: UIView!
  @IBOutlet weak var backButton: UIButton!
  var languageList = [VideoModel]()
  var selectedArray = [Int]()
  var selectedLanguage = ""
  var selectedLanguage1 = Int()
  var reachability = Reachability()!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.languageCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.topBarView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    languageCollectionView.allowsMultipleSelection = true;
    self.tabBarController?.tabBar.isHidden = true
    initialView()

    getToken()
    // Do any additional setup after loading the view.
  }
  func initialView() {
    languageCollectionView.register(UINib(nibName: "LanguageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "languageCell")
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

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
      print("Network not reachable")
    }
  }
  // MARK: Api methods
  func getToken() {
    //  CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    ApiCommonClass.getToken { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
        CustomProgressView.hideActivityIndicator()

      } else {
        DispatchQueue.main.async {
          self.getLanguageList()
          CustomProgressView.hideActivityIndicator()
        }
      }
    }
  }

  func getLanguageList() {
    //CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    self.languageList.removeAll()
    ApiCommonClass.getLanguages { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.languageList = responseDictionary["data"] as! [VideoModel]
        print(self.languageList)
        if self.languageList.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.languageCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
  func setLanguage(langugeId : String) {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    var parameterDict: [String: String?] = [ : ]
    parameterDict["lang_list"] = langugeId
    parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    print(parameterDict)
    ApiCommonClass.setLanguagePriority (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
          CustomProgressView.hideActivityIndicator()
        }
      } else {

        //    self.userDetails = responseDictionary["Channels"] as! [VideoModel]
        DispatchQueue.main.async {
          //          UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
          //          UserDefaults.standard.set("true", forKey: "login_status")

          let delegate = UIApplication.shared.delegate as? AppDelegate
          delegate!.loadTabbar()

          //          let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "demofirst") as! HomeViewController
          //          self.navigationController?.pushViewController(videoPlayerController, animated: false)

        }
      }
    }
  }
  @IBAction func backAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func nextAction(_ sender: Any) {
    for i in 0..<languageList.count{
      if languageList[i].status == "true"{
        selectedArray.append(languageList[i].language_id!)
        selectedLanguage = selectedLanguage + "," + String(languageList[i].language_id!)
      }

    }
    if  selectedLanguage != "" {
      let result = String(selectedLanguage.dropFirst())
      UserDefaults.standard.set(result, forKey: "languageId")
      setLanguage(langugeId : result)
    }else{
      WarningDisplayViewController().customAlert(viewController : self ,messages :"Please Select Language")
    }

  }
}
// MARK: Collectionview methods

