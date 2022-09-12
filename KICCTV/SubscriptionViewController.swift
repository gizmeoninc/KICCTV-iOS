//
//  SubscriptionViewController.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 13/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import WebKit
import StoreKit
import  Reachability

//protocol to check whether the video purchased or not
//definition in videoplaying controller
protocol SubscriptionDelegate: class {
    func didPurchaseSubscription()
}
// no need now
protocol VideoCheckingDelegate:class {
    func loadAfterIntermediateLogin()
}
class SubscriptionViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
    weak var delegate: VideoCheckingDelegate!

    @IBOutlet weak var continueButton: UIButton!{
        didSet{
            self.continueButton.layer.cornerRadius = 5
            self.continueButton.clipsToBounds = true
            self.continueButton.backgroundColor = ThemeManager.currentTheme().ThemeColor
            self.continueButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20.0)
        }
    }
    @IBOutlet weak var PackageCollectionView: UICollectionView! //to display subscription packages
    @IBOutlet weak var PremiumView: UIView!{
        didSet{
            self.PremiumView.backgroundColor = .black
        }
    }
    @IBOutlet weak var mainView: UIView!{
        didSet{
            self.mainView.isHidden = true
            self.mainView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        }
    }
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            self.loginButton.isHidden = true
            self.loginButton.setTitleColor(ThemeManager.currentTheme().UIImageColor, for: .normal)
        }
    }
    @IBOutlet weak var choosePackageLabel: UILabel!{
        didSet{
            self.choosePackageLabel.textColor = ThemeManager.currentTheme().UIImageColor
            self.choosePackageLabel.text = "Choose One Package"
        }
    }
    @IBOutlet weak var alreadyHaveAccountLabel: UILabel!

  @IBOutlet weak var segmentedControl: UISegmentedControl!

  @IBAction func segmentedControlAction(_ sender: Any) {
    print(segmentedControl.selectedSegmentIndex)
    self.PackageCollectionView.reloadData()
  }
  var webView : WKWebView!
    var reachability = Reachability()!
    let autoRenewableIsAtomic = true
    var channelId = Int()
    var videoId = Int()
//  var VideoSubscriptionArray = [VideoSubscriptionModel]()
  var VideoSubscriptionArray : [VideoSubscriptionModel]?
    var ChannelSubscriptionArray = [ChannelSubscriptionModel]()
    var selectedIndex = 0
    var isFromVideoPlayingPage = false
    var symbol = String()
    var price = Float()
    var showId = Int()
    var Categories = [VideoModel]()
    var ShowData = [ShowDetailsModel]()
    var categoryModel : VideoModel!
    weak var subscriptionDelegate : SubscriptionDelegate?
    var skProducts = [SKProduct]()
    // here we set all in app purchase ids
    let productIds: Set<String> = ["com.basic.project46.monthly","com.standard.project46.monthly","com.premium.project46.monthly","com.basic.project46.yearly","com.standard.project46.yearly","com.premium.project46.yearly"]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
          delegate.restrictRotation = .portrait
        }
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.PackageCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        PackageCollectionView.register(UINib(nibName: "SubscriptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "subscriptionCell")
        self.NavigationTitle()
        self.premiumViewSetup()

//      segmentedControl.addTarget(self, action: #selector(segmentedControl.indexChanged(_:)), for: .valueChanged)

        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        SwiftyStoreKit.retrieveProductsInfo(productIds) { (result) in
            let products = result.retrievedProducts
            self.skProducts = Array(products)
            if UserDefaults.standard.string(forKey:"access_token") == nil {
                self.getToken()
            } else {
                if self.isFromVideoPlayingPage {
                    self.getVideoSubscriptions(video_id: self.videoId) // call function to display prices of selected videos
                } else {
                    self.getChannelSubscriptions(channelId: self.channelId)
                }        }
        }

    }


    // MARK: Api Calls
    func getToken() {
        ApiCommonClass.getToken { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                CustomProgressView.hideActivityIndicator()
            } else {
                DispatchQueue.main.async {
                    if self.isFromVideoPlayingPage {
                        self.getVideoSubscriptions(video_id: self.videoId)
                    } else {
                        self.getChannelSubscriptions(channelId: self.channelId)
                    }            }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        self.webView.sizeToFit()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
          delegate.restrictRotation = .portrait
        }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
        if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {    // checking guest user or not (changes in UI)
            self.loginButton.isHidden = true
            self.alreadyHaveAccountLabel.isHidden = true
            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
//            self.loginButton.isHidden = false
//            self.alreadyHaveAccountLabel.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
          delegate.restrictRotation = .portrait
        }
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    // function to convert price from $ to currency
    // @param productId , API - getVideoSubscription()
    // @param sKproducts, from Appstore subscriptions
    func getProductDetails(productId : String) -> String {
        var priceText = ""
        for product in skProducts {
            if productId == product.productIdentifier {
                let currencySymbol = product.priceLocale.currencySymbol ?? "$"
                let Price = product.price.doubleValue
                let text = String(format: "\(currencySymbol)%.2f\n", Price)
                priceText = text
//                let currencySymbol = product.priceLocale.currencySymbol ?? "$"
//                let Price = product.price.doubleValue
//                let text = String(format: "\(currencySymbol)%.2f\n", Price)
//                priceText = text
                break
            }
        }
        return priceText
    }

    //    call to login VC from subscription when login  as guest user
    //    @param isFromsubscriptionPage = true
    // no need now
    @IBAction func loginAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        nextViewController.isFromSubscriptionPage = true
        self.present(nextViewController, animated: true, completion: nil)
    }




    // call to Register VC when register as guest user
    // no need now
    @IBAction func continueButtonAction(_ sender: Any) {
      print("continue action")
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
          self.MoveTORegisterPage(isFromSubscriptionPage: true)
//            DispatchQueue.main.async {
//                WarningDisplayViewController().customActionAlert(viewController :self,title: "Please Register to \n Purchase this Subscription", message: "", actionTitles: ["Cancel","Ok","Login"], actions:[{action1 in
//                    },{action2 in
//                        self.MoveTORegisterPage(isFromSubscriptionPage: true)
//                    },{action3 in},nil])
//            }
        } else {
          print("not guest")
            if self.isFromVideoPlayingPage {
            if self.VideoSubscriptionArray?[self.selectedIndex].ios_keyword != "" {
                    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
              self.purchase((self.VideoSubscriptionArray?[self.selectedIndex].ios_keyword!)!, atomically: true)
                }else {
                    ToastView.shared.short(self.view, txt_msg: "Server Error")
                }
            } else {
                if self.ChannelSubscriptionArray[self.selectedIndex].ios_keyword! != ""{
                    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
                    self.purchase(self.ChannelSubscriptionArray[self.selectedIndex].ios_keyword!, atomically: true)
                }else {
                    ToastView.shared.short(self.view, txt_msg: "Server Error")
                }
            }
        }
    }

    @IBAction func backAction(_ sender: Any){
        if Application.shared.guestRegister {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate!.loadTabbar()
//            let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "demofirst") as! HomeViewController
//            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        } else {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }

    // MARK: Main Functions
    func NavigationTitle(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Choose One Package"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIButton(type: .custom)
        newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
        newBackButton.contentMode = .scaleAspectFit
        newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
        newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
        newBackButton.addTarget(self, action: #selector(SubscriptionViewController.backAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: newBackButton)
        self.navigationItem.leftBarButtonItem = item2
    }
    func premiumViewSetup(){

        PremiumView.backgroundColor = .black
        //      webView = WKWebView(frame: CGRect(x: 0, y: 0, width: PremiumView.frame.size.width - 35, height: PremiumView.frame.size.height - 10))
        let webConfiguration = WKWebViewConfiguration()
        //webView = WKWebView(frame: PremiumView.bounds, configuration: webConfiguration)
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: PremiumView.frame.size.width - 35, height: PremiumView.frame.height ))
        self.PremiumView.addSubview(webView)
        self.PremiumView.bringSubviewToFront(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isOpaque = false
    }
    func MoveTORegisterPage(isFromSubscriptionPage : Bool) {
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        watchListController.isFromSubscriptionPage = true
        self.present(watchListController, animated: true, completion: nil)
    }
    func MoveToPhoneVarification() {
        //CustomProgressView.hideActivityIndicator()
        GuestRegisterViewController.showFromGuestUser(viewController: self)
    }


    func GetSelectPremiumContent(SelectedIndexPath : Int) {
        selectedIndex = SelectedIndexPath
        if isFromVideoPlayingPage {

            choosePackageLabel.text = VideoSubscriptionArray?[selectedIndex].subscription_name

        } else {
            choosePackageLabel.text = VideoSubscriptionArray?[selectedIndex].subscription_name

        }
        self.PackageCollectionView.reloadData()
        if isFromVideoPlayingPage {
            let url = VideoSubscriptionArray?[selectedIndex].description
            if url != nil {
                webView?.loadHTMLString("<html><HEAD><meta name=\"viewport\" content=\"initial-scale=1.0, shrink-to-fit=no\"></HEAD><body style=\"background-color: black; font-size: 18; font-family: HelveticaNeue; color: #ffffff\">\(url!)</body></html>" , baseURL: nil)

            }
            self.mainView.isHidden = false
        } else {
            let url = ChannelSubscriptionArray[selectedIndex].description
            if url != nil {
                webView?.loadHTMLString("<html><HEAD><meta name=\"viewport\" content=\"initial-scale=1.0, shrink-to-fit=no\"></HEAD><body style=\"background-color: black; font-size: 18; font-family: HelveticaNeue; color: #ffffff\">\(url!)</body></html>" , baseURL: nil)
            }
            self.mainView.isHidden = false
        }
        //let request = NSURLRequest(url: url! as URL)
    }
    // MARK: Api Actions
    func checkPhoneVerification(){
        //CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
        ApiCommonClass.checkPhoneVerification { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                }
            } else {
                if let videos = responseDictionary["Channels"] as? [PhoneVerifiedModel] {
                    if videos.count == 0 {
                        //CustomProgressView.hideActivityIndicator()
                    } else {
                        if videos[0].phone_verified_flag == 1 {
                            if self.isFromVideoPlayingPage {
                              if self.VideoSubscriptionArray?[self.selectedIndex].ios_keyword! != "" {
                                self.purchase((self.VideoSubscriptionArray?[self.selectedIndex].ios_keyword!)!, atomically: true)
                                }else {
                                    ToastView.shared.short(self.view, txt_msg: "Server Error")
                                }
                            } else {
                                if self.ChannelSubscriptionArray[self.selectedIndex].ios_keyword! != ""{
                                    self.purchase(self.ChannelSubscriptionArray[self.selectedIndex].ios_keyword!, atomically: true)
                                }else {
                                    ToastView.shared.short(self.view, txt_msg: "Server Error")
                                }
                            }
                        } else {
                            self.MoveToPhoneVarification()
                        }
                    }
                }
            }
        }
    }
    // API call to get subscription packages
    //@param video_id,uid
    func getVideoSubscriptions(video_id: Int) {
        CustomProgressView.hideActivityIndicator()
        var parameterDict: [String: String?] = [ : ]
        parameterDict["vid"] = String(video_id)
        parameterDict["uid"] = UserDefaults.standard.string(forKey:"user_id")
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        ApiCommonClass.getvideoSubscriptions(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.loadTabbar()
                }
            } else {
                DispatchQueue.main.async {
                    if let videos = responseDictionary["Channels"] as? [VideoSubscriptionModel] {
                        if videos.count == 0 {
                            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                        } else {
                            self.VideoSubscriptionArray = videos
                            self.GetSelectPremiumContent(SelectedIndexPath : 0)
                        }
                    }
                }
            }
        }
    }
    func getChannelSubscriptions(channelId: Int) {
        var parameterDict: [String: String?] = [ : ]
        parameterDict["channel_id"] = String(channelId)
        parameterDict["uid"] = UserDefaults.standard.string(forKey:"user_id")
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        ApiCommonClass.getchannelSubscriptions(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.loadTabbar()
                }
            } else {
                DispatchQueue.main.async {
                    if let videos = responseDictionary["Channels"] as? [ChannelSubscriptionModel] {
                        if videos.count == 0 {
                            WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                        } else {
                            self.ChannelSubscriptionArray = videos
                            self.GetSelectPremiumContent(SelectedIndexPath : 0)
                        }
                    }
                }
            }
        }
    }
    //API call to update subscription transaction
    //API call to update subscription transaction
    func subscriptionTransaction(status: String,encryptedReceipt: String){
        //CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
        var parameterDict: [String: String?] = [ : ]
        parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["transaction_type"] = "1"
        parameterDict["status"] = status
        parameterDict["mode_of_payment"] = "ios-in-app"
        parameterDict["receiptid"] = encryptedReceipt
        if isFromVideoPlayingPage {
            if let subscription_id = VideoSubscriptionArray?[selectedIndex].subscription_id {
                parameterDict["subscription_id"] = String(subscription_id)
            }
            if let price = VideoSubscriptionArray?[selectedIndex].price {
                parameterDict["amount"] = String(price)
            }
            if let ios_keyword = VideoSubscriptionArray?[selectedIndex].ios_keyword {
                parameterDict["product_id"] = ios_keyword
            }
        } else {
            if let subscription_id = ChannelSubscriptionArray[selectedIndex].subscription_id {
                parameterDict["subscription_id"] = String(subscription_id)
            }
            if let price = ChannelSubscriptionArray[selectedIndex].price {
                parameterDict["amount"] = String(price)
            }
            if let ios_keyword = ChannelSubscriptionArray[selectedIndex].ios_keyword {
                parameterDict["product_id"] = ios_keyword
            }
        }
        ApiCommonClass.subscriptionTransaction(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                    if  status == "success" {
                        WarningDisplayViewController().customActionAlert(viewController :self,title: "Warning", message:"Your Subscription is processed /n Please wait for some time!" , actionTitles: ["Ok"], actions:[{action1 in
                            self.subscriptionTransaction(status: status, encryptedReceipt: encryptedReceipt)}, nil])
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if status == "success" {
                        SubscriptionHelperClass().getUserSubscriptions()
                        self.subscriptionDelegate?.didPurchaseSubscription()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let elementID = "mobile-bars-icon-pro"
        let removeElementIdScript = "document.getElementById('\(elementID)').style.display = \"none\";"
        webView.evaluateJavaScript(removeElementIdScript) { (response, error) in
        }
        //CustomProgressView.hideActivityIndicator()
    }
    //MARK:- IAP:-Delegate
    // to purchase package
    func purchase(_ purchase: String, atomically: Bool) {
        SwiftyStoreKit.purchaseProduct(purchase, quantity: 1,atomically: false) { (result) in
            switch result {
            case .success(let product):
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                self.didPurchased(product: product, restore: false)
                print("Purchase Success: \(product.productId)")
            case .error(let error):
                CustomProgressView.hideActivityIndicator()
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                // self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                case .clientInvalid: print("Not allowed to make the payment")
                // self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                //  self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                print(error.localizedDescription)
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                // self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                // self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                //self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                // self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                //  self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                default: print((error as NSError).localizedDescription)
                // self.subscriptionTransaction(status: "failed", encryptedReceipt: "")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Purchase failed", message:error.localizedDescription , actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                }
            }
        }
    }
    //    @IBAction func restorePurchases() {
    //
    //        NetworkActivityIndicatorManager.networkOperationStarted()
    //        SwiftyStoreKit.restorePurchases(atomically: true) { results in
    //            NetworkActivityIndicatorManager.networkOperationFinished()
    //
    //            for purchase in results.restoredPurchases {
    //                let downloads = purchase.transaction.downloads
    //                if !downloads.isEmpty {
    //                    SwiftyStoreKit.start(downloads)
    //                } else if purchase.needsFinishTransaction {
    //                    // Deliver content from server, then:
    //                    SwiftyStoreKit.finishTransaction(purchase.transaction)
    //                }
    //            }
    //            self.showAlert(self.alertForRestorePurchases(results))
    //        }
    //    }
    //

    #if os(iOS)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    #endif

    private func didPurchased(product: PurchaseDetails?, restore: Bool) {

        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let receiptData):
                CustomProgressView.hideActivityIndicator()
                let encryptedReceipt = receiptData.base64EncodedString()
                self.subscriptionTransaction(status: "success", encryptedReceipt: encryptedReceipt)
                print("Fetch receipt success")
            case .error(let error):
                CustomProgressView.hideActivityIndicator()
                switch error {
                case ReceiptError.networkError(let error):
                    if (error as NSError).code != 16 {
                        WarningDisplayViewController().customActionAlert(viewController :self,title: "Error", message: error.localizedDescription, actionTitles: ["Ok"], actions:[{action1 in
                            }, nil])
                    }
                default: print("")
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Error", message: error.localizedDescription, actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
                }
            }
        }
    }

}


extension SubscriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    // MARK: Collectionview
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if segmentedControl.selectedSegmentIndex == 0{
        print("Monthly")
          if let vsarray = VideoSubscriptionArray?.filter({$0.subscription_type_name=="Monthly"}){
            return vsarray.count
          }

      }
      if segmentedControl.selectedSegmentIndex == 1{
        print("Yearly")
//        if isFromVideoPlayingPage {
          if let vsarray = VideoSubscriptionArray?.filter({$0.subscription_type_name=="Yearly"}){
            return vsarray.count
          }

      }
      return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriptionCell", for: indexPath as IndexPath) as! SubscriptionCollectionViewCell
      print("subscription typr",VideoSubscriptionArray?[indexPath.row].subscription_type_name)
      if segmentedControl.selectedSegmentIndex == 0{
        print("mm")
        if let vsarray = VideoSubscriptionArray?.filter({$0.subscription_type_name=="Monthly"}){
            let words = vsarray[indexPath.row].subscription_name!.components(separatedBy: " ")
          if(words.count < 2) {
                cell.packageName.text = vsarray[indexPath.row].subscription_name
            } else {
              let lastNameArray = words.prefix(words.count - 1)   //["Williams","Diaz"]: [String]
                cell.packageName.text = lastNameArray.joined(separator: " ")
            }
            if indexPath.row == selectedIndex {
                cell.mainView.layer.borderColor = ThemeManager.currentTheme().ThemeColor.cgColor
                // cell.packageName.text = VideoSubscriptionArray[indexPath.row].subscription_name
                cell.mainView.backgroundColor = .clear
            } else {
                cell.mainView.layer.borderColor = UIColor.gray.cgColor
                // cell.packageName.text = VideoSubscriptionArray[indexPath.row].subscription_name
                cell.mainView.backgroundColor = ThemeManager.currentTheme().backgroundColor
            }

          if vsarray[indexPath.row].ios_keyword != nil{

            let text = self.getProductDetails(productId: (vsarray[indexPath.row].ios_keyword!))

            cell.packagePrice.text = text

            cell.packageDuration.text = vsarray[indexPath.row].subscription_type_name
            cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
          }
          }


      }
      if (segmentedControl.selectedSegmentIndex == 1)
          {
        print("yy")

//        if isFromVideoPlayingPage {
          if let vsarray = VideoSubscriptionArray?.filter({$0.subscription_type_name=="Yearly"}){
            print("hi")
//          if VideoSubscriptionArray[indexPath.row].subscription_type_name == "Yearly"{
            let words = vsarray[indexPath.row].subscription_name!.components(separatedBy: " ")
            if(words.count < 2) {
              cell.packageName.text = vsarray[indexPath.row].subscription_name
            } else {
              let lastNameArray = words.prefix(words.count - 1)   //["Williams","Diaz"]: [String]
              cell.packageName.text = lastNameArray.joined(separator: " ")
            }
            if indexPath.row == selectedIndex {
                cell.mainView.layer.borderColor = ThemeManager.currentTheme().ThemeColor.cgColor
                // cell.packageName.text = VideoSubscriptionArray[indexPath.row].subscription_name
                cell.mainView.backgroundColor = .clear
            } else {
                cell.mainView.layer.borderColor = UIColor.gray.cgColor
                // cell.packageName.text = VideoSubscriptionArray[indexPath.row].subscription_name
                cell.mainView.backgroundColor = ThemeManager.currentTheme().backgroundColor
            }

            if vsarray[indexPath.row].ios_keyword != nil{

              let text = self.getProductDetails(productId: (vsarray[indexPath.row].ios_keyword!))

            cell.packagePrice.text = text

            cell.packageDuration.text = vsarray[indexPath.row].subscription_type_name
            cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
          }
          }

      }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = CGFloat()//some width
        width = (self.PackageCollectionView.frame.size.width - 25)/2
        let height = self.PackageCollectionView.frame.size.height //some width
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: width, height: height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        webView.loadHTMLString("", baseURL: Bundle.main.bundleURL)
        GetSelectPremiumContent(SelectedIndexPath : indexPath.row)
    }
}


