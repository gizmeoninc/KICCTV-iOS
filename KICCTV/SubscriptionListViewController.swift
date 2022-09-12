//
//  SubscriptionListViewController.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 10/07/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Reachability


class subscriptionListViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var selectedRow = 0
    var reachability = Reachability()!
    
    
    lazy var subscriptionListTableView : UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 90, width: self.view.frame.width, height: self.view.frame.height - 240), collectionViewLayout: UICollectionViewFlowLayout())
    lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel Subscription", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.frame = CGRect(x: 16, y: self.view.frame.height - 128, width: self.view.frame.width - 30, height: 40)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = ThemeManager.currentTheme().ThemeColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        subscriptionListTableView.dataSource = self
        subscriptionListTableView.delegate = self
        subscriptionListTableView.showsVerticalScrollIndicator = false
        subscriptionListTableView.register(subscriptionListTableViewCell.self, forCellWithReuseIdentifier: "SubscriptionListTableviewCell")
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            flowlayout.itemSize = CGSize(width: self.view.frame.width, height: 120)
        } else {
            flowlayout.itemSize = CGSize(width: self.view.frame.width, height: 100)
        }
        subscriptionListTableView.collectionViewLayout = flowlayout
        view.addSubview(subscriptionListTableView)
        view.addSubview(cancelButton)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpInitial()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        self.getUserSubscriptions()
    }
    func setUpInitial(){
        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Subscription List"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]

        let newBackButton = UIButton(type: .custom)
        newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
        newBackButton.contentMode = .scaleAspectFit
        newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
        newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
        newBackButton.addTarget(self, action: #selector(subscriptionListViewController.backAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: newBackButton)
        self.navigationItem.leftBarButtonItem = item2
        
        
        cancelButton.addTarget(self, action: #selector(CancelAction(sender:)), for: .touchUpInside)
        if Application.shared.userSubscriptionsArray.isEmpty {
            cancelButton.isHidden = true
            WarningDisplayViewController().noResultview(view : self.view,title: "No Active Subscription Found")
            subscriptionListTableView.isHidden = true
        }
        else {
            SubscriptionHelperClass().getUserSubscriptions()
            self.subscriptionListTableView.reloadData()
            cancelButton.isHidden = false
        }
    }
    
    @objc func backAction(_ sender: Any) {
      navigationController?.popViewController(animated: true)
    }
    
    // API call (getUserSubscription details regarding user subscription updated)
    func getUserSubscriptions(){
        ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
            if responseDictionary["forcibleLogout"] as? Bool == true {
              DispatchQueue.main.async {
                CustomProgressView.hideActivityIndicator()
                  WarningDisplayViewController().customActionAlert(viewController :self,title: "You are no longer Logged in this device. Please Login again to access.", message: "", actionTitles: ["OK"], actions:[{action1 in
                      CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
                      self.logOutApi()
                    },nil])
              }
            }
            else if  responseDictionary["session_expired"] as? Bool == true {
                DispatchQueue.main.async {
                  CustomProgressView.hideActivityIndicator()
                    WarningDisplayViewController().customActionAlert(viewController :self,title: "You are no longer Logged in this device. Please Login again to access.", message: "", actionTitles: ["OK"], actions:[{action1 in
                        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
                        self.logOutApi()
                      },nil])
                }

            }
           else if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                }
            } else {
                if let videos = responseDictionary["data"] as? [SubscriptionModel] {
                    if videos.count == 0 {
                        Application.shared.userSubscriptionStatus = false
                        
                    }
                    else{
                        Application.shared.userSubscriptionStatus = true
                    }
                    Application.shared.userSubscriptionsArray = videos
                    DispatchQueue.main.async {
                        CustomProgressView.hideActivityIndicator()
                        self.subscriptionListTableView.reloadData()
                    }
                    
                }
            }
        }
    }
    func logOutApi() {
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
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    self.navigationController?.pushViewController(nextViewController, animated: false)
                
            } else {
                WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
            }
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        CustomProgressView.hideActivityIndicator()
        self.dismiss(animated: false, completion: nil)
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
    
    
    // cancel button onClick
    // the function goes to appstore now
    // no other functionality implemented
    @objc func CancelAction(sender:UIButton){
        if Application.shared.userSubscriptionsArray[0].mode_of_payment == "ios-in-app" {
            print("tap working")
            guard let url = URL(string: "https://apps.apple.com/account/subscriptions") else { return }
            UIApplication.shared.open(url)
        } else {
            WarningDisplayViewController().customActionAlert(viewController :self,title: "", message:"No Matching Subscription found in your iTunes Account. Please check with your other platforms." , actionTitles: ["OK"], actions:[{action1 in
                }, nil])
            
        }
    }
    // adding protocol stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Application.shared.userSubscriptionsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionListTableviewCell", for: indexPath) as! subscriptionListTableViewCell
        
        if Application.shared.userSubscriptionsArray[indexPath.row].subscription_name != nil {
            cell.subscriptionDetailsLabel.text = Application.shared.userSubscriptionsArray[indexPath.row].subscription_name
            cell.subscriptionDetailsLabel.textColor = ThemeManager.currentTheme().sideMenuTextColor
        }
        
        if indexPath.item == selectedRow {
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            cell.clipsToBounds = true
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = ThemeManager.currentTheme().UIImageColor.cgColor
        } else {
            cell.layer.cornerRadius = 0
            cell.clipsToBounds = true
            cell.layer.borderWidth = 0.0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        if Application.shared.userSubscriptionsArray[indexPath.row].valid_to != nil {
            let validTo = Application.shared.userSubscriptionsArray[indexPath.row].valid_to
            let validToDate = Date().convertStringToDateValue(dateString: validTo!)
            cell.subscriptionDateLabel.text = "Subscription Valid Til : " + Date().dateInFormat(date: validToDate!)
            cell.subscriptionDateLabel.textColor = ThemeManager.currentTheme().sideMenuTextColor
        }
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRow = indexPath.item
        self.subscriptionListTableView.reloadData()
    }
    
}
extension Date {
    func convertStringToDateValue(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let s = dateFormatter.date(from: dateString) {
            return s
        } else {
            return nil
        }
    }
    func dateInFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
