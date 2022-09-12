//
//  MyAccountVC.swift
//  Mongol
//
//  Created by GIZMEON on 22/03/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
import Reachability
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
class MyAccountVC: UIViewController {
    var reachability = Reachability()!

    @IBOutlet weak var MyListButton: UIButton!
    @IBOutlet weak var SubscriptionButton: UIButton!
    
    @IBOutlet weak var AboutButton: UIButton!
    @IBOutlet weak var ContatUsButton: UIButton!
    @IBOutlet weak var TVActivationButton: UIButton!
    
    
    @IBOutlet weak var ProfileImageView: UIImageView!{
        didSet{
            self.ProfileImageView.layer.cornerRadius = ProfileImageView.frame.width / 2
            self.ProfileImageView.layer.masksToBounds = true
            self.ProfileImageView.setImageColor(color: .white)
        }
    }
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var VersionLabel: UILabel!{
        didSet{
           
        }
    }
    @IBOutlet weak var SignOutButton: UIButton!{
        didSet{
            self.SignOutButton.backgroundColor = ThemeManager.currentTheme().grayImageColor
            self.SignOutButton.layer.cornerRadius = 8
        }
    }
  var guestUserLogedIn: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationController?.navigationBar.isHidden = false

        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
//        CGFloat spacing = 10; // the amount of spacing to appear between image and title
//        tabBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
//        tabBtn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        MyListButton.imageEdgeInsets = UIEdgeInsets(top: 0, left:view.frame.width - 60, bottom: 0, right:0)
        MyListButton.tintColor = .white
        AboutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left:view.frame.width - 60, bottom: 0, right:0)
        AboutButton.tintColor = .white
        ContatUsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left:view.frame.width - 60, bottom: 0, right:0)
        ContatUsButton.tintColor = .white
        TVActivationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left:view.frame.width - 60, bottom: 0, right:0)
        TVActivationButton.tintColor = .white
        SubscriptionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left:view.frame.width - 60, bottom: 0, right:0)
        SubscriptionButton.tintColor = .white


//      SubscriptionButton.frame = CGRect(x:0,y:0,width: 0,height:0)

        if  UserDefaults.standard.string(forKey: "first_name") != nil {
          let firstName = UserDefaults.standard.string(forKey: "first_name")!
            UserNameLabel.text = firstName.capitalized
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let version = String(format:"KICCTV %@", appVersion!)
            self.VersionLabel.text = version
        }
      
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
          try reachability.startNotifier()
        } catch {
          print("could not start reachability notifier")
        }
        self.initialView()

    }
    override func viewWillDisappear(_ animated: Bool) {
      reachability.stopNotifier()
      NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
      self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func MyListBtnOnClick(_ sender: Any) {
        print("my list button clicked")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "watchList") as! WatchListViewController
          vc.fromwatchlist = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func SubscriptionOnClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionListnew") as! subscriptionListViewController
        SubscriptionHelperClass().getUserSubscriptions()

        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func AboutBtnOnClick(_ sender: Any) {
        print("About button clicked")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutusVC") as! AboutusViewController
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @IBAction func ContactusBtnOnclick(_ sender: Any) {
        print("contactus button clicked")
      let vc = ContactUSViewController()
      self.navigationController?.pushViewController(vc, animated: false)
//        guard let tabbarController = self.tabBarController else { return }
//        ContactUSViewController.showFromContactUs(viewController: tabbarController)
    }
    @IBAction func TVActivationOnclick(_ sender: Any) {
        guard let tabbarController = self.tabBarController else { return }
        TVActivationVC.showActivationPopup(viewController: tabbarController)
        
    }
    
    @IBAction func SignOutBtnOnclick(_ sender: Any) {
        print("signout button clicked")
        DispatchQueue.main.async {
          WarningDisplayViewController().customActionAlert(viewController :self,title: "Do you want to exit?", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
            },{action2 in
              self.logOutApi()
            }, nil])
        }
    }
    
    func logOutApi() {
        CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
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
   
               ApiCommonClass.logOutAction(parameterDictionary: parameterDict as? Dictionary<String, String>) { (result) -> () in
                print(result)
                if result {
                    CustomProgressView.hideActivityIndicator()
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
                  self.skipLogin()
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//                    self.navigationController?.pushViewController(nextViewController, animated: false)
                } else {
                    CustomProgressView.hideActivityIndicator()
                    WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
                }
        }
        
    }
  func skipLogin() {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    let deviceID =  UserDefaults.standard.string(forKey:"UDID")!
    print(deviceID)
    var parameterDict: [String: String?] = [ : ]
    parameterDict["device_id"] = deviceID
    ApiCommonClass.getGustUserId(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          CustomProgressView.hideActivityIndicator()
          WarningDisplayViewController().customActionAlert(viewController :self,title: "error", message: (val as! String), actionTitles: ["Ok"], actions:[{action1 in
            }, nil])
        }
      } else {
        if let val = responseDictionary["Channels"] {
          DispatchQueue.main.async {
            UserDefaults.standard.set(self.getDateAfterTenDays(), forKey: "guestloginafter10_date")
            UserDefaults.standard.set("true", forKey: "login_status")
            UserDefaults.standard.set("true", forKey: "skiplogin_status")
            UserDefaults.standard.set(responseDictionary["Channels"], forKey: "user_id")
            UserDefaults.standard.set("Guest User", forKey: "first_name")
            self.guestUserLogedIn = true
            Application.shared.userSubscriptionStatus = false
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate!.loadTabbar()


          }
        }
      }
    }
  }
  func getDateAfterTenDays() -> String {
    let dateAftrTenDays =  (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let date = formatter.string(from: dateAftrTenDays)
    return date
  }
    func initialView(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
        
        self.navigationItem.title = "Account"
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
}
