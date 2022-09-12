//
//  AppDelegate.swift
//  MyVideoApp
//
//  Created by Gizmeon on 14/02/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import AdSupport
import CoreData
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import IQKeyboardManagerSwift
import SwiftyStoreKit
import GoogleCast
import Reachability
import WebKit
import Firebase
import FBSDKCoreKit
import AppTrackingTransparency

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate,MessagingDelegate,UNUserNotificationCenterDelegate,GCKLoggerDelegate,WKUIDelegate {

    var webView = WKWebView(frame: CGRect.zero)
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var deviceID = ""
    var fcm_token = ""
    var modeOfScreen = ""
    var rewarded_status = Int()
    var fromNotification = false
    var restrictRotation:UIInterfaceOrientationMask = UIInterfaceOrientationMask.all
    let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
    let kDebugLoggingEnabled = true
    var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);
    var reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        deviceID = UserSession.getDeviceIdentifierFromKeychain()
        UserDefaults.standard.set(deviceID, forKey: "UDID")
        let currentDate = Int(Date().timeIntervalSince1970)
        let session_id = String(currentDate) + deviceID
        UserDefaults.standard.set(session_id, forKey: "session_id")
        print("session_id",session_id)
        let appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
        UserDefaults.standard.set(appVersion, forKey: "appVersion")
//        if #available(iOS 14, *) {
//            if !UserDefaults.standard.bool(forKey: "requestTrackingAuthorization") {
//              UserDefaults.standard.setValue(true, forKey: "requestTrackingAuthorization")
//              self.requestPermission()
//            }
//        }else{
//            UserDefaults.standard.set(identifierForAdvertising(), forKey: "Idfa")
//        }
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
           if error == nil {
            UserDefaults.standard.set(result, forKey: "userAgent")
          }
           else{
            UserDefaults.standard.set("iphone6s", forKey: "userAgent")

           }
        }
        if UserDefaults.standard.string(forKey:"userAgent") == nil{
            UserDefaults.standard.set("iphone6s", forKey: "userAgent")
        }
        UserDefaults.standard.set(UIDevice.modelName, forKey: "deviceModel")
        UserDefaults.standard.set(UIDevice.current.model, forKey: "TYPE")
        FirebaseApp.configure() 
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        UserDefaults.standard.setValue("false", forKey: "fromTerminate")
        UserDefaults.standard.setValue("false", forKey: "fromBackground")

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        self.rewarded_status = 0
        UserDefaults.standard.set(rewarded_status, forKey: "rewarded_status")

        application.registerForRemoteNotifications()
        if UserDefaults.standard.object(forKey : "changeMode") != nil {
            modeOfScreen = UserDefaults.standard.object(forKey : "changeMode") as! String
            if modeOfScreen == "NormalMode"  {
                ThemeManager.applyTheme(theme: .theme1)
                UserDefaults.standard.set("NormalMode", forKey: "changeMode")
            } else {
                ThemeManager.applyTheme(theme: .theme2)
                UserDefaults.standard.set("", forKey: "changeMode")
            }
        } else {
            ThemeManager.applyTheme(theme: .theme2)
            UserDefaults.standard.set("NightMode", forKey: "changeMode")
        }

        Messaging.messaging().delegate = self
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            print("  location denied")
        }
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
      //Google Cast
      // Set your receiver application ID.
        let criteria = GCKDiscoveryCriteria(applicationID: "A2844572")
        let options = GCKCastOptions(discoveryCriteria: criteria)
        options.physicalVolumeButtonsWillControlDeviceVolume = true
        options.suspendSessionsWhenBackgrounded = false
        let launchOption = GCKLaunchOptions()
        launchOption.androidReceiverCompatible = true
        options.launchOptions = launchOption
        GCKCastContext.setSharedInstanceWith(options)

      // Configure widget styling.
      // Theme using UIAppearance.
      //UINavigationBar.appearance().barTintColor = .lightGray
      let colorAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
      UINavigationBar().titleTextAttributes = colorAttributes
      GCKUICastButton.appearance().tintColor = ThemeManager.currentTheme().TabbarColor

      // Theme using GCKUIStyle.
      let castStyle = GCKUIStyle.sharedInstance()
      // Set the property of the desired cast widgets.
      castStyle.castViews.deviceControl.buttonTextColor = ThemeManager.currentTheme().TabbarColor
      // Refresh all currently visible views with the assigned styles.
      castStyle.apply()

      // Enable default expanded controller.
      GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true

      // Enable logger.
      GCKLogger.sharedInstance().delegate = self

      // Set logger filter.
      let filter = GCKLoggerFilter()
      filter.minimumLevel = .error
      GCKLogger.sharedInstance().filter = filter

      // Wrap main view in the GCKUICastContainerViewController and display the mini controller.
      let appStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let navigationController = appStoryboard.instantiateViewController(withIdentifier: "MainNavigation")
      let castContainerVC = GCKCastContext.sharedInstance().createCastContainerController(for: navigationController)
      castContainerVC.miniMediaControlsItemEnabled = true
      // Color the background to match the embedded content
      castContainerVC.view.backgroundColor = .white

      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = castContainerVC
      window?.makeKeyAndVisible()
      if let launchOptions = launchOptions,let url = launchOptions[.url] as? URL {
        NotificationApi.scheme(url: url)
      }
      return true
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("url schema", url.absoluteString)
        let host = url.host //red
        print("url host", host)
        ApplicationDelegate.shared.application(
               app,
               open: url,
               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
           )
        if let scheme = url.scheme,
           
            scheme.localizedCaseInsensitiveCompare("com.adventuresportstv") == .orderedSame,
            let view = url.host {
             print("scheme")
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
          if let showId = parameters["showId"] {
            if  UserDefaults.standard.string(forKey:"user_id") != nil {
            Application.shared.deepLink_ShowID = showId
            Application.shared.isFromDeepLink = true
            if Application.shared.existingSession {
              NotificationApi.moveToController()
            }
           }
          }
        }
        // Determine who sent the URL.
//           let sendingAppID = options[.sourceApplication]
//           print("source application = \(sendingAppID ?? "Unknown")")
//
//           // Process the URL.
//           guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
//               let albumPath = components.path,
//               let params = components.queryItems else {
//                   print("Invalid URL or album path missing")
//                   return false
//           }
//
//           if let photoIndex = params.first(where: { $0.name == "index" })?.value {
//               print("albumPath = \(albumPath)")
//               print("photoIndex = \(photoIndex)")
//               return true
//           } else {
//               print("Photo index missing")
//               return false
//           }
        return true
    }

    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {

    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
      print("fcmToken",deviceTokenString)
              Messaging.messaging().apnsToken = deviceToken
  }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        fcm_token = fcmToken
        print("fcmToken1",fcm_token)
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
      if let showId = userInfo["showId"] as? String{
        if  UserDefaults.standard.string(forKey:"user_id") != nil {
        Application.shared.deepLink_ShowID = showId
        Application.shared.isFromDeepLink = true
        if Application.shared.existingSession {
          NotificationApi.moveToController()
        }
       }
      }
    }
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler: @escaping () -> Void) {
    print(response.notification.request.content.userInfo)
    if let showId = response.notification.request.content.userInfo["showid"] as? String{
      if  UserDefaults.standard.string(forKey:"user_id") != nil {
      Application.shared.deepLink_ShowID = showId
      Application.shared.isFromDeepLink = true
      if Application.shared.existingSession {
        NotificationApi.moveToController()
      }
     }
    }
    

//    if let channelID =  response.notification.request.content.userInfo["eventKey"] as? Int ,let premium_Flag = response.notification.request.content.userInfo["premiumFlag"] as? Int{
//      if  UserDefaults.standard.string(forKey:"user_id") != nil {
//       Application.shared.isFromChannelNotification = true
//        Application.shared.notificationpremiumFlag = premium_Flag
//        Application.shared.notificationchannelId = channelID
//       if Application.shared.existingSession {
//        NotificationApi.moveToChannelController(channelID: channelID, premium_Flag: premium_Flag)
//       }
//    }
//  }
  completionHandler()
}
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }

    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        return result
    }
    func loadTabbar(){

        let tabbarController = HomeTabBarViewController()

        // Create Tab one
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabOne =  storyboard.instantiateViewController(withIdentifier: "demofirst") as! HomeViewController
        //let tabOne = HomeViewController()
        let tabOneBarItem = UITabBarItem(title: "Home", image: UIImage(named: "TabBarOneHome"), selectedImage: UIImage(named: "TabBarOneHome"))
        tabOne.tabBarItem = tabOneBarItem
        let nav1 = UINavigationController(rootViewController: tabOne)
        UITabBar.appearance().tintColor = ThemeManager.currentTheme().ThemeColor

        // Create Tab two

        let tabTwo = storyboard.instantiateViewController(withIdentifier: "Search") as! HomeSearchViewController
        let tabBarItem2 = UITabBarItem(title: "Explore", image: UIImage(named: "TVExcelSearchImage"), selectedImage: UIImage(named: "TVExcelSearchImage"))
        tabTwo.type = "video"
//        tabTwo.fromNewReleaseTab = true
        tabTwo.tabBarItem = tabBarItem2
        let nav2 = UINavigationController(rootViewController: tabTwo)
//        let tabThree = storyboard.instantiateViewController(withIdentifier: "liveTab") as! LiveTabViewController
//        let tabBarItem3 = UITabBarItem(title: "Live", image: UIImage(named: "TabBarFourLive"), selectedImage: UIImage(named: "TabBarFourLive"))
//        tabThree.tabBarItem = tabBarItem3
//        let nav3 = UINavigationController(rootViewController: tabThree)
        // Create Tab four
        var tabFour = UIViewController()
        if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
            tabFour = storyboard.instantiateViewController(withIdentifier: "MyAccountVc") as! MyAccountVC

        }
        else{
            tabFour = storyboard.instantiateViewController(withIdentifier: "TransparentVc") as! TransparentVc

        }

            let tabBarItem4 = UITabBarItem(title: "Account", image: UIImage(named: "ic_account"), selectedImage: UIImage(named: "ic_account"))
             tabFour.tabBarItem = tabBarItem4
   

       
        let nav4 = UINavigationController(rootViewController: tabFour)

        tabbarController.viewControllers = [nav1, nav2, nav4]

        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()

    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard let currentLocation = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler:
            {(placemarks, error) in
                //CLGeocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                guard let currentLocPlacemark = placemarks?.first else { return }
                UserDefaults.standard.set(currentLocPlacemark.isoCountryCode, forKey: "countryCode")
                print("country",UserDefaults.standard.set(currentLocPlacemark.isoCountryCode, forKey: "countryCode"))
                //UserDefaults.standard.set("CX", forKey: "countryCode")
        })
        locationManager.stopUpdatingLocation()
        getIPAddressandlocation()
   getAddressFromLatLon(pdblLatitude: "\(Double((locValue.latitude)))", withLongitude: "\(Double((locValue.longitude)))")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location denied call")
        ApiCommonClass.getIpandlocation { (responseDictionary: Dictionary) in
             if responseDictionary["error"] != nil {
               CustomProgressView.hideActivityIndicator()
             } else{
               DispatchQueue.main.async {
                 print("location ip")
               }
             }
           }
        
    }
    func getIpandlocation1() {
   
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.restrictRotation
    }
    func requestPermission() {
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")

                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                    print("idebtifier idfa",ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                    print("idebtifier idfa",ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")
                case .restricted:
                    print("Restricted")
                    print("idebtifier idfa",ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")
                @unknown default:
                    print("Unknown")
                    print("idebtifier idfa",ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")
                }
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
              })
            
        }
        
    }
    func identifierForAdvertising() -> String? {
        // Check whether advertising tracking is enabled
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }

        // Get and return IDFA
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    func getLoginStatus() {

        let user_id =  UserDefaults.standard.string(forKey:"user_id")!
        var parameterDict: [String: String?] = [ : ]
        parameterDict["user_id"] = user_id
        if  fcm_token != "" {
            parameterDict["fcm_token"] = fcm_token
        }else {
            parameterDict["fcm_token"] = ""
        }
        ApiCommonClass.getGustUserStaus (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                }
            } else {
                let data = responseDictionary["Channels"] as! [VideoModel]
                let validity = data[0].validity
                if validity == 1 {
                    self.loadTabbar()
                }else {
                    UserDefaults.standard.set("false", forKey: "login_status")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewControlleripad : UIViewController = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
                    if let navigationController = self.window?.rootViewController as? UINavigationController
                    {
                        navigationController.pushViewController(initialViewControlleripad, animated: false)

                    }
                }
                DispatchQueue.main.async {

                }
            }
        }
    }
    var ipaddress:String?
    func getIPAddressandlocation()  {
        ApiCommonClass.getIpandlocation { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                   UserDefaults.standard.set("103.71.169.219", forKey: "IPAddress")
                   UserDefaults.standard.set("IN", forKey: "countryCode")
                  CustomProgressView.hideActivityIndicator()
                } else{
                  DispatchQueue.main.async {
                   
                  }
                }
              }
     
    }

    func getIPAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
print("ipaddres",firstAddr)
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!

        let lon: Double = Double("\(pdblLongitude)")!

        let latString = String(lat)
        let lonString = String(lon)

        UserDefaults.standard.set(latString, forKey: "latitude")
        UserDefaults.standard.set(lonString, forKey: "longitude")
        UserDefaults.standard.set("1", forKey: "Geo_Type")
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                }

                if placemarks != nil
                {

                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {

                        let pm = placemarks![0]
                        UserDefaults.standard.set(pm.administrativeArea  ?? "", forKey: "Region")
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                            if pm.country != nil {
                                addressString = addressString + pm.country! + ", "
                                UserDefaults.standard.set(pm.country, forKey: "country")
                                var location_city = ""
                                if(location_city != pm.locality!.trimmingCharacters(in: .whitespaces))
                                {
                                    location_city=pm.locality!.trimmingCharacters(in: .whitespaces)
                                    UserDefaults.standard.set(location_city, forKey: "city")
                                    DispatchQueue.main.async{
                                        //   self.GetBeeWatherDetails(district: pm.locality!, country: pm.country!)
                                    }
                                }
                            }

                        }

                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                          print("addess",addressString)

                    }
                }
        })
      

    }


    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if Application.shared.isVideoPlaying{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PausePlayer"), object: nil)

        }
        UserDefaults.standard.setValue("true", forKey: "fromBackground")
      //NotificationApi.app_backGround_Event()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
print("applicationDidEnterBackground")
      bgTask = application.beginBackgroundTask(withName:"MyBackgroundTask", expirationHandler: {() -> Void in
        print("beginBackgroundTask")

          // Do something to stop our background task or the app will be killed
          application.endBackgroundTask(self.bgTask)
          self.bgTask = UIBackgroundTaskIdentifier.invalid
      })

      DispatchQueue.global(qos: .background).async {
        print("NotificationApi.app_backGround_Event")

          //make your API call here
        NotificationApi.app_backGround_Event()
      }
      // Perform your background task here
      print("The task has started")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        print("getTokenFromappDlegate")
//        self.getToken()
        print("applicationDidBecomeActive")
        if #available(iOS 14, *) {
            if !UserDefaults.standard.bool(forKey: "requestTrackingAuthorization") {
              UserDefaults.standard.setValue(true, forKey: "requestTrackingAuthorization")
              self.requestPermission()
            }
        }else{
            UserDefaults.standard.set(identifierForAdvertising(), forKey: "Idfa")
        }
        UserDefaults.standard.setValue("true", forKey: "fromBackground")
        if Application.shared.isVideoPlaying{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayPlayer"), object: nil)

        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")

       NotificationApi.app_terminate_Event()
        if #available(iOS 10.0, *) {
            print("#available(iOS 10.0")

            saveContext ()
        } else {
            print("#available(iOS 10.0 ) else")

            // Fallback on earlier versions
        }
    }

    func getToken() {
        ApiCommonClass.getToken { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
            } else {
            }
        }
    }
    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyVideoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
   func logMessage(_ message: String,
                  at _: GCKLoggerLevel,
                  fromFunction function: String,
                  location: String) {
     if kDebugLoggingEnabled {
      print("\(location): \(function) - \(message)")
     }
   }
  enum Network: String {
      case wifi = "en0"
      case cellular = "pdp_ip0"
  }
}

