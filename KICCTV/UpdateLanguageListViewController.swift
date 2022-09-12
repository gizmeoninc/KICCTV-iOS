//
//  UpdateLangugeListViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 16/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Reachability

class UpdateLanguageListViewController: UIViewController {

  @IBOutlet weak var userLanguageTableView: UITableView!{
    didSet {
       self.userLanguageTableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
  }

  var userLanguages = [languageList]()
  var selectedArray = [Int]()
  var selectedLanguage = ""
  var selectedLanguage1 = Int()
  var reachability = Reachability()!
  var isFromHomeAndRegister = Bool()

  override func viewDidLoad() {
    super.viewDidLoad()
    CustomProgressView.hideActivityIndicator()
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    setupInitial()
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
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
  //MARK: Main API

  func setupInitial() {
    let nib =  UINib(nibName: "UpdatedTableViewCell", bundle: nil)
    userLanguageTableView.register(nib, forCellReuseIdentifier: "langageSelection")
    self.navigationController?.navigationBar.isHidden = false
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
    self.navigationItem.title = "Select Language"
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
    let doneButton = UIBarButtonItem( barButtonSystemItem: .done, target: self, action: #selector(submitLanguage))
    self.navigationItem.rightBarButtonItem  = doneButton
    doneButton.tintColor = ThemeManager.currentTheme().UIImageColor
    if isFromHomeAndRegister {
      self.navigationItem.hidesBackButton = true
      self.navigationItem.backBarButtonItem?.title = ""
      self.tabBarController?.tabBar.isHidden = true
    } else {
      self.navigationItem.hidesBackButton = false
      self.navigationItem.backBarButtonItem?.title = ""
      self.tabBarController?.tabBar.isHidden = false
    }
    if  UserDefaults.standard.string(forKey:"access_token") != nil {
       if self.isFromHomeAndRegister {
         if self.reachability.connection != .none {
           self.getLanguageList()
        }
      } else {
        if self.reachability.connection != .none {
          self.getUserLanguages()
        }
      }
    } else {
      self.getToken()
    }
  }
  @IBAction func backAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  @objc func submitLanguage(){
//    for i in 0..<userLanguages.count{
//      if userLanguages[i].selected == true{
//        selectedArray.append(userLanguages[i].language_id!)
//        selectedLanguage = selectedLanguage + "," + String(userLanguages[i].language_id!)
//      }
//    }
//    if  selectedLanguage != "" {
//      let result = String(selectedLanguage.dropFirst())
//      UserDefaults.standard.set(result, forKey: "languageId")
//      setLanguage(langugeId : result)
//    }else{
//      WarningDisplayViewController().customAlert(viewController : self ,messages :"Please Select Language")
//    }
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
  // MARK: Api Calls
  func getToken() {
    ApiCommonClass.getToken { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        CustomProgressView.hideActivityIndicator()
      } else {
        DispatchQueue.main.async {
          if self.isFromHomeAndRegister {
            if self.reachability.connection != .none {
              self.getLanguageList()
            }
          } else {
            if self.reachability.connection != .none {
              self.getUserLanguages()
            }
          }
        }
      }
    }
  }
  func getUserLanguages() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    ApiCommonClass.getuserLanguages { (responseDictionary: Dictionary) in
      if responseDictionary["error"] != nil {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.userLanguages = responseDictionary["data"] as! [languageList]
        if self.userLanguages.count == 0 {
          DispatchQueue.main.async {
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.userLanguageTableView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
  func getLanguageList() {
    self.userLanguages.removeAll()
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    ApiCommonClass.getLanguages { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.userLanguages = responseDictionary["data"] as! [languageList]
        print(self.userLanguages)
        if self.userLanguages.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.userLanguageTableView.reloadData()
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
        if responseDictionary["Channels"] != nil {
          Application.shared.langugeIdList = langugeId
          DispatchQueue.main.async {
            if  self.isFromHomeAndRegister {
              let delegate = UIApplication.shared.delegate as? AppDelegate
              delegate!.loadTabbar()
            }else {
              WarningDisplayViewController().customActionAlert(viewController :self,title: "Languages updated", message: "", actionTitles: ["Ok"], actions:[{action1 in
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate!.loadTabbar()
                },{action2 in
                }, nil])
              CustomProgressView.hideActivityIndicator()
            }
          }
        }
      }
    }
  }
}

extension UpdateLanguageListViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userLanguages.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "langageSelection", for: indexPath) as! UpdatedTableViewCell
    cell.backgroundColor = UIColor.clear
    cell.tintColor = ThemeManager.currentTheme().UIImageColor
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      cell.languageName.font = cell.languageName.font.withSize(20)
    }
    cell.languageName.text = userLanguages[indexPath.row].audio_language_name
    cell.selectionStyle = .none
    if self.isFromHomeAndRegister {
        cell.accessoryType = .none
        userLanguages[indexPath.row].selected = false
    }else {
       if userLanguages[indexPath.row].selected == true {
          cell.accessoryType = .checkmark
         self.userLanguageTableView.selectRow(at:  IndexPath(row: indexPath.row, section: 0), animated: false, scrollPosition: .none)
       } else{
        cell.accessoryType = .none
       }
    }
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
    userLanguages[indexPath.row].selected = true
  }
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
     userLanguages[indexPath.row].selected = false
  }
}
