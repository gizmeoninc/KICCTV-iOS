//
//  SideMenuViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 07/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import SideMenu
import FBSDKLoginKit
import FacebookCore
import FacebookLogin

protocol SideMenuDelegate: class {
  func didSelectWatchList()
  func didSelectContactUs()
  func didSelectSchedule()
  func didSelectPremium()
    func didSelectActivation()

  func didSelectFavorites()
  func didSelectMyVideos()
}

class SideMenuViewController: UIViewController {

  @IBOutlet weak var logOutButton: UIButton!
  @IBOutlet weak var sideMenuTableView: UITableView!
  @IBOutlet weak var logoutView: UIView!
  @IBOutlet weak var logoutImageView: UIImageView!

    @IBOutlet weak var logoutAllView: UIView!
    
    
    @IBOutlet weak var logoutAllImageView: UIImageView!
    
    @IBOutlet weak var logoutAllButton: UIButton!
    var menu = [String]()
    var menuImage = ["TVExcelUser","TVExcelWatchHistory","TVExcelPrivacy", "TVExcelTermsAndCondition","icons8-tv","TVExcelContactUs"]
  weak var progressdelegates : SideMenuDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    self.navigationController!.navigationBar.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.logoutImageView.setImageColor(color: ThemeManager.currentTheme().UIImageColor)
     self.logoutAllImageView.setImageColor(color: ThemeManager.currentTheme().UIImageColor)
    if  UserDefaults.standard.string(forKey: "first_name") != nil {
      let firstName = UserDefaults.standard.string(forKey: "first_name")!
        menu = [firstName.capitalized,"My List","Privacy Policy","Terms and Conditions","TV Activation","Contact us"]
    } else {
      let firstName = "Hi User"
//         let firstName = UserDefaults.standard.string(forKey: "first_name")!
        menu = [firstName,"My List","Privacy Policy","Terms and Conditions","TV Activation","Contact us"]
    }
    self.logOutButton?.setTitleColor(ThemeManager.currentTheme().sideMenuTextColor, for: .normal)
    self.logoutAllButton?.setTitleColor(ThemeManager.currentTheme().sideMenuTextColor, for: .normal)
    self.logoutView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.logoutAllView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    //self.logOutButton.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    self.sideMenuTableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
//    if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
        self.logoutAllButton.isHidden = true
        self.logoutAllImageView.isHidden = true
//    }
    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
  }

  @IBAction func logOutAction(_ sender: Any) {
    DispatchQueue.main.async {
      WarningDisplayViewController().customActionAlert(viewController :self,title: "Do you want to exit?", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
        },{action2 in
          self.logOutdata()
        }, nil])
    }
  }

  func logOutdata(){
    UserDefaults.standard.removeObject(forKey: "user_id")
    UserDefaults.standard.removeObject(forKey: "login_status")
    UserDefaults.standard.removeObject(forKey: "first_name")
    UserDefaults.standard.removeObject(forKey: "skiplogin_status")
    UserDefaults.standard.removeObject(forKey: "access_token")
    Application.shared.userSubscriptionsArray.removeAll()
     let loginManager = LoginManager()
            LoginManager.init().logOut()
    

            loginManager.loginBehavior = .browser

            print("logout")
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
    self.navigationController?.pushViewController(nextViewController, animated: false)
  }
    
    
    
    @IBAction func logoutAllAction(_ sender: Any) {
       DispatchQueue.main.async {
         WarningDisplayViewController().customActionAlert(viewController :self,title: "Are you sure you want to Logout from All Devices?", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
           },{action2 in
             self.logOUtAll()
           }, nil])
       }
            
             
         }
     func logOUtAll() {
             var parameterDict: [String: String?] = [ : ]
               
             if let deviceid = UserDefaults.standard.string(forKey:"UDID") {
                 parameterDict["device_id"] = deviceid
             }
             if let user_id = UserDefaults.standard.string(forKey:"user_id") {
                 parameterDict["user_id"] = user_id
             }
             if let pubid = UserDefaults.standard.string(forKey:"pubid") {
                        parameterDict["pubid"] = pubid
             }
             if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
                 parameterDict["ipaddress"] = ipAddress
             }
    
                ApiCommonClass.logOutAllAction(parameterDictionary: parameterDict as? Dictionary<String, String>) { (result) -> () in
                 print(result)
                 if result {
                     UserDefaults.standard.removeObject(forKey: "user_id")
                     UserDefaults.standard.removeObject(forKey: "login_status")
                     UserDefaults.standard.removeObject(forKey: "first_name")
                     UserDefaults.standard.removeObject(forKey: "skiplogin_status")
                     UserDefaults.standard.removeObject(forKey: "access_token")
                     Application.shared.userSubscriptionsArray.removeAll()
                     let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                     let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                     self.navigationController?.pushViewController(nextViewController, animated: false)
                 } else {
                     WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
                 }
         }
         
     }
    
    
    
}
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menu.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SideMenuTableViewCell
    cell.selectionStyle = .none
    cell.backgroundColor = UIColor.clear
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      cell.sideMenuName.font = cell.sideMenuName.font.withSize(25)
    }
    cell.sideMenuName.textColor = ThemeManager.currentTheme().sideMenuTextColor
    cell.sideMenuName.text = menu[indexPath.row]
    cell.sideMenuImageView.image = UIImage(named: menuImage[indexPath.row])
    cell.sideMenuImageView.setImageColor(color: ThemeManager.currentTheme().UIImageColor)
    if indexPath.row == 0 {
      cell.selectionStyle = .none
    }else if indexPath.row == 1 {
      cell.selectionStyle = .none
    }
    cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      return 70
    } else {
    return 50
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    if indexPath.row == 1 {
//      dismiss(animated: true){
//        self.progressdelegates?.didSelectPremium()
//      }
//    } else
//        if indexPath.row == 1 {
//      dismiss(animated: true) {
//        self.progressdelegates?.didSelectFavorites()
//      }
//    } else
        if indexPath.row == 1 {
      dismiss(animated: true) {
        self.progressdelegates?.didSelectWatchList()
      }
    }
//    else if indexPath.row == 3 {
//      dismiss(animated: true) {
//        self.progressdelegates?.didSelectMyVideos()
//      }
//    }
    else if indexPath.row == 2 {
//           ToastView.shared.short(self.view, txt_msg: "Coming soon")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let watchListController = storyBoard.instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
          let url = Bundle.main.url(forResource: "DiscoverWisconsinPP", withExtension:"html")

          watchListController.webUrl = url!.absoluteString

        watchListController.titles = "Privacy Policy"
        self.navigationController?.pushViewController(watchListController, animated: false)
//      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//      let watchListController = storyBoard.instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
//      watchListController.webUrl = ThemeManager.currentTheme().PrivacyPolicyURL
//      watchListController.titles = "Privacy Policy"
//      self.navigationController?.pushViewController(watchListController, animated: false)
    }
    else if indexPath.row == 3 {
//        ToastView.shared.short(self.view, txt_msg: "Coming soon")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let watchListController = storyBoard.instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
          let url = Bundle.main.url(forResource: "DiscoverWisconsinPP", withExtension:"html")

          watchListController.webUrl = url!.absoluteString
        watchListController.titles = "Terms and Conditions"

        self.navigationController?.pushViewController(watchListController, animated: false)
//      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//      let watchListController = storyBoard.instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
//      watchListController.webUrl = ThemeManager.currentTheme().TermsAndConditionURL
//      watchListController.titles = "Terms and Conditions"
//
//      self.navigationController?.pushViewController(watchListController, animated: false)
    }
    else if indexPath.row == 4 {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            DispatchQueue.main.async {
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register or Login to use this feature.", message: "", actionTitles: ["Cancel","Login"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                        self.MoveTOLoginPage()
                    },nil])
            }
        }
        else{
            dismiss(animated: true) {
                self.progressdelegates?.didSelectActivation()
            }
           
//      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//      let watchListController = storyBoard.instantiateViewController(withIdentifier: "TvActivationVc") as! ActivationVC
//
//
//      self.navigationController?.pushViewController(watchListController, animated: false)
        }
    }
//    else if indexPath.row == 6 {
//      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//      let watchListController = storyBoard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
//      self.navigationController?.pushViewController(watchListController, animated: false)
//    }
        else if indexPath.row == 5 {
//            ToastView.shared.short(self.view, txt_msg: "Coming soon")

      dismiss(animated: true) {
        self.progressdelegates?.didSelectContactUs()
      }
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
}
