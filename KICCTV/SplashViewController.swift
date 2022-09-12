//
//  SplashViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 05/02/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Reachability
import Firebase
class SplashViewController: UIViewController, InternetConnectivityDelegate {

    var window: UIWindow?
    @IBOutlet weak var LogoImage: UIImageView!

    @IBOutlet var mainView: UIView!
    var modechangevalue = true
    var fcmToken = ""
    var reachability = Reachability()!
    var force_update_required = ""
    var force_update_current_version = ""
    var force_update_store_url = ""
  var guestUserLogedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()



        //do something if it's an instance of that class
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black

        if UserDefaults.standard.string(forKey:"countryCode") != nil {
            print("call to ip and location  not")
            self.getPubid()
        }
        else{
            print("call to ip and location")
            getIPAddressandlocation()
        }



    }

    func getIPAddressandlocation()  {
        print("get to ip and location")

        ApiCommonClass.getIpandlocation { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                   UserDefaults.standard.set("103.71.169.219", forKey: "IPAddress")
                   UserDefaults.standard.set("IN", forKey: "countryCode")
                  CustomProgressView.hideActivityIndicator()
                } else{
                  DispatchQueue.main.async {
                      self.getPubid()
                  }
                }
              }

    }

    // check registration flag
    func getPubid(){
      ApiCommonClass.getPubId{ (responseDictionary: Dictionary) in
        if responseDictionary["pubid"] != nil {
            if UserDefaults.standard.string(forKey:"user_id") != nil {
                if UserDefaults.standard.string(forKey: "registration_mandatory_flag") == "1"{
                    if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
                      self.skipLogin()
                    }
                    else{
                        self.checkSubscription()
                    }

                }
                else{
                    self.checkSubscription()
                }
            } else {

              if  self.reachability.connection != .none {
                self.skipLogin()
              } else {
                AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
              }
            }
        }
        else{
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
    func checkSubscription(){
        if UserDefaults.standard.string(forKey: "subscription_mandatory_flag") == "1"{
            if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
                skipLogin()
            }
            else{
                getToken()
            }
        }
        else{
            getToken()
        }
    }
  func getDateAfterTenDays() -> String {
    let dateAftrTenDays =  (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let date = formatter.string(from: dateAftrTenDays)
    return date
  }
    func logOutdata() {
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
              self.gotoHome()

            } else {
                WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.restrictRotation = .portrait
        }
         self.navigationItem.backBarButtonItem?.title = ""

    }
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    func getToken() {

        print("getToken")
        ApiCommonClass.getToken { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                ToastView.shared.short(self.view, txt_msg: "Server error")
             // ToastView.shared.short(self.view, txt_msg: responseDictionary["error"] as! String)
            } else {
                DispatchQueue.main.async {
                    if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
                        self.getUserSubscriptions()

                    } else {
                      //  self.getLoginStatus()
                        let delegate = UIApplication.shared.delegate as? AppDelegate
                        delegate!.loadTabbar()
                    }
                }
            }
        }
    }
    func getUserSubscriptions() {
        ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
          if responseDictionary["forcibleLogout"] as? Bool == true {
            DispatchQueue.main.async {
              self.logOutdata()
            }
          }
            else if  responseDictionary["session_expired"] as? Bool == true {
              DispatchQueue.main.async {
                self.logOutdata()
              }
            }
          else if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                }
            } else {
                if let videos = responseDictionary["data"] as? [SubscriptionModel] {
                    if UserDefaults.standard.string(forKey: "subscription_mandatory_flag") == "1"{
                        if videos.count == 0 {
//                            Application.shared.userSubscriptionStatus = false
//                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
//                            self.navigationController?.pushViewController(nextViewController, animated: false)
                            Application.shared.userSubscriptionStatus = true
                            Application.shared.userSubscriptionsArray = videos
                            let delegate = UIApplication.shared.delegate as? AppDelegate
                            delegate!.loadTabbar()
                        } else {
                            Application.shared.userSubscriptionStatus = true
                            Application.shared.userSubscriptionsArray = videos
                            let delegate = UIApplication.shared.delegate as? AppDelegate
                            delegate!.loadTabbar()
                        }

                    }
                    else{
                        Application.shared.userSubscriptionStatus = true
                        Application.shared.userSubscriptionsArray = videos
                        let delegate = UIApplication.shared.delegate as? AppDelegate
                        delegate!.loadTabbar()
                    }



              }
            }
        }
    }
//    func getUserSubscriptions(){
//        ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
//            if responseDictionary["error"] != nil {
//                DispatchQueue.main.async {
//                    //CustomProgressView.hideActivityIndicator()
//                }
//            } else {
//                if let videos = responseDictionary["data"] as? [SubscriptionModel] {
//                    if videos.count == 0 {
//                        Application.shared.userSubscriptionStatus = false
//
//                    }
//                    else{
//                        Application.shared.userSubscriptionStatus = true
//                    }
//                    Application.shared.userSubscriptionsArray = videos
//                    if UserDefaults.standard.string(forKey: "subscription_mandatory_flag") == "1"{
//                        if videos.count == 0{
//                             print("go to subscription screen")
//                        }
//                        else{
//                            let delegate = UIApplication.shared.delegate as? AppDelegate
//                                                                         delegate!.loadTabbar()
//                        }
//
//                    }
//                    else{
//                        let delegate = UIApplication.shared.delegate as? AppDelegate
//                                              delegate!.loadTabbar()
//                    }
//
//                }
//            }
//        }
//    }

    func getLoginStatus() {
        if UserDefaults.standard.string(forKey:"user_id") != nil {
            let user_id =  UserDefaults.standard.string(forKey:"user_id")!
            if  UserDefaults.standard.string(forKey:"fcmToken") != nil {
                fcmToken =  UserDefaults.standard.string(forKey:"fcmToken")!
            }
            var parameterDict: [String: String?] = [ : ]
            parameterDict["uid"] = user_id
            if  fcmToken != "" {
                parameterDict["fcm_token"] = fcmToken
            }else {
                parameterDict["fcm_token"] = ""
            }
            ApiCommonClass.getGustUserStaus (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("true", forKey: "skiplogin_status")
                        UserDefaults.standard.set("true", forKey: "login_status")
                        self.gotoHome()
//                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//                        self.navigationController?.pushViewController(nextViewController, animated: false)
                    }
                } else {
                    let data = responseDictionary["Channels"] as! [VideoModel]
                    let validity = data[0].validity
                    DispatchQueue.main.async {
                        if validity == 1 {

                            let delegate = UIApplication.shared.delegate as? AppDelegate
                            delegate!.loadTabbar()
                        }else {
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            UserDefaults.standard.set("false", forKey: "login_status")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewControlleripad : UIViewController = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
                            if let navigationController = self.window?.rootViewController as? UINavigationController
                            {
                                navigationController.pushViewController(initialViewControlleripad, animated: false)
                            }
                        }

                    }
                }
            }
        } else {
          self.gotoHome()
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//            self.navigationController?.pushViewController(nextViewController, animated: false)
        }
    }
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
            if UserDefaults.standard.string(forKey:"user_id") != nil {
            let serachController = self.storyboard?.instantiateViewController(withIdentifier: "noNetwork") as! NoNetworkDisplayViewController
            serachController.delegate = self
            serachController.fromSplash = true
            self.navigationController?.pushViewController(serachController, animated: false)
            print("Network not reachable")
            } else {
              self.gotoHome()
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//                self.navigationController?.pushViewController(nextViewController, animated: false)
            }
        }
    }
    func gotoOnline() {
        if modechangevalue {
            if UserDefaults.standard.string(forKey:"user_id") != nil {
                getToken()
            }else {
              self.gotoHome()
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//                self.navigationController?.pushViewController(nextViewController, animated: false)
            }
        } else {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate!.loadTabbar()
        }

    }
  func gotoHome(){
      self.dismiss(animated: true, completion: nil)
      let delegate = UIApplication.shared.delegate as? AppDelegate
                                      delegate!.loadTabbar()
  }
//    func getUserSubscriptions() {
//        ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
//            if responseDictionary["error"] != nil {
//                ToastView.shared.short(self.view, txt_msg: "Server error")
//            } else {
//                let token = responseDictionary["Channels"] as! String
//                DispatchQueue.main.async {
//                    UserDefaults.standard.set(token, forKey: "access_token")
//                    if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
//                        if  UserDefaults.standard.string(forKey:"login_status") == nil {
//                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//                            self.navigationController?.pushViewController(nextViewController, animated: false)
//                        }else {
//                            let delegate = UIApplication.shared.delegate as? AppDelegate
//                            delegate!.loadTabbar()
//                        }
//                    } else {
//                        self.getLoginStatus()
//                    }
//                }
//            }
//        }
//    }
}
extension SplashViewController: LoginMenuDelegate {

    func loadHome(){
//        navigationController?.popViewController(animated: false)
        Application.shared.guestRegister = false
        self.gotoHome()
      let subscriptionController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
      subscriptionController.isFromVideoPlayingPage = true
      self.navigationController?.pushViewController(subscriptionController, animated: false)
    }
}
protocol LoginMenuDelegate: class {
    func loadHome()
}

