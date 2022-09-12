//
//  LoginViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 22/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import PopupDialog
import Firebase
import ADCountryPicker
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import AuthenticationServices

class RegisterViewController: UIViewController,UITextFieldDelegate,LoginButtonDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
         return self.view.window!
    }
    var facebook_id : String?
        var fb_email : String?
       var fb_name : String?

       var apple_id : String?
        var apple_email : String?
       var apple_name : String?
    
    var userDetail = [VideoModel]()
    var guestUserLogedIn = false

    
    weak var guestUserDelegate: videoPlayingDelegate!
     var isFromFbLogin = false
    var isFromAppleLogin = false

    var fbName : String?
    var fbEmail : String?
    var fbId : String?
    var appleName : String?
    var appleEmail : String?
    var appleId : String?

    @IBOutlet weak var loginViaFb: FBLoginButton!{
        didSet{
//            self.loginViaFb.isHidden = false
        }
    }
    
    @IBOutlet weak var signUpOutlet: UIButton! {
        didSet {
            self.signUpOutlet.backgroundColor =  ThemeManager.currentTheme().TabbarColor
            self.signUpOutlet.layer.cornerRadius = 20.0
            
        }
    }
    
    @IBOutlet weak var showPassword: UIButton!
    
    @IBOutlet weak var contentView: UIView! {
        didSet{
            self.contentView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
            
        }
    }
    @IBOutlet weak var passwordText: UITextField! {
        didSet {
//            passwordText.setBottomBorder()
            passwordText.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            passwordText.textColor = ThemeManager.currentTheme().textfeildColor
            passwordText.tintColor = ThemeManager.currentTheme().UIImageColor
            
        }
    }
    
    @IBOutlet weak var emailText: UITextField! {
        didSet {
//            emailText.setBottomBorder()
            
            emailText.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            emailText.tintColor = ThemeManager.currentTheme().UIImageColor
            emailText.textColor = ThemeManager.currentTheme().textfeildColor
        }
    }

  @IBOutlet weak var confirmEmailText: UITextField!{
    didSet {
        confirmEmailText.attributedPlaceholder = NSAttributedString(string: "Confirm Email",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        confirmEmailText.tintColor = ThemeManager.currentTheme().UIImageColor
        confirmEmailText.textColor = ThemeManager.currentTheme().textfeildColor
    }
}

    @IBOutlet weak var phoneEntryView: UIView! {
        didSet {
            phoneEntryView.layer.backgroundColor = ThemeManager.currentTheme().CgColor
            phoneEntryView.layer.masksToBounds = false
            phoneEntryView.layer.shadowColor = UIColor.gray.cgColor
            phoneEntryView.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
            phoneEntryView.layer.shadowOpacity = 1.0
            phoneEntryView.layer.shadowRadius = 0.0
        }
    }
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet {
            phoneTextField.backgroundColor = .clear
            phoneTextField.attributedPlaceholder = NSAttributedString(string: "Phone Number",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            phoneTextField.textColor = ThemeManager.currentTheme().textfeildColor
            phoneTextField.tintColor = ThemeManager.currentTheme().UIImageColor
            
            phoneTextField.delegate = self
        }
    }
    
  @IBOutlet weak var HaveCouponLabel: UILabel!

  @IBOutlet weak var CouponText: UITextField!{
    didSet {
//            emailText.setBottomBorder()

        CouponText.attributedPlaceholder = NSAttributedString(string: "",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        CouponText.tintColor = ThemeManager.currentTheme().UIImageColor
        CouponText.textColor = ThemeManager.currentTheme().textfeildColor
    }
}


  @IBOutlet weak var countryCodeButton: UIButton! {
        didSet {
            self.countryCodeButton.setTitleColor(ThemeManager.currentTheme().textfeildColor, for: .normal)
            if UserDefaults.standard.string(forKey: "countryCode") == nil {
                selectedCountryCode = "+1"
                UserDefaults.standard.set("US", forKey: "c_code")
                countryCodeButton.setTitle(selectedCountryCode, for: .normal)
            } else {
                if let selectedCountryCode = picker.getDialCode(countryCode: UserDefaults.standard.string(forKey: "countryCode")!) {
                    UserDefaults.standard.set(UserDefaults.standard.string(forKey: "countryCode"), forKey: "c_code")
                    countryCodeButton.setTitle(selectedCountryCode, for: .normal)
                } else {
                    selectedCountryCode = "+1"
                    UserDefaults.standard.set("US", forKey: "c_code")
                    countryCodeButton.setTitle(selectedCountryCode, for: .normal)
                }
            }
            countryCodeButton.addTarget(self, action:#selector(countryButtonClicked), for: .touchUpInside)
        }
    }
    @IBOutlet weak var NameText: UITextField! {
        didSet {
//            NameText.setBottomBorder()
            NameText.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            NameText.textColor = ThemeManager.currentTheme().textfeildColor
            NameText.tintColor = ThemeManager.currentTheme().UIImageColor
            NameText.autocapitalizationType = .sentences
            
        }
    }
    
    @IBOutlet weak var loginOutlet: UIButton! {
        didSet {
            self.loginOutlet.setTitleColor(ThemeManager.currentTheme().UIImageColor, for: .normal)
        }
    }
    
    @IBOutlet weak var logoImage: UIImageView!{
        didSet{
            self.logoImage.image = UIImage(named: ThemeManager.currentTheme().logoImage)
        }
    }
    @IBOutlet weak var alreadyLoginLabel: UILabel!
    @IBOutlet weak var closeButton: UIImageView!
    let picker = ADCountryPicker(style: .grouped)
    
    var reachability = Reachability()!
    var phoneNumber = String()
    var c_code = String()
    var isFromSubscriptionPage = false
    var isFromLogin = false
   var isFromAccountScreen = false
    var isFromVideoDeails = false

    var iconClick: Bool = true
       var iconClickS: Bool = true
    var selectedCountryCode = String()
    var userDetails = [userModel]()
    weak var backDelegate:VideoCheckingDelegate?
    
    
    // MARK: Main Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
      self.CouponText.isHidden = true

      let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))

      HaveCouponLabel.addGestureRecognizer(guestureRecognizer)

        self.passwordText.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if isFromAccountScreen{
        }
        else{
            setupProviderLoginView()
        }
        if isFromSubscriptionPage {
            self.navigationController?.navigationBar.isHidden = false
            self.loginOutlet.isHidden = true
            self.alreadyLoginLabel.isHidden = true
            self.closeButton.isHidden = false
            
        }
        else if isFromAccountScreen{
            self.navigationController?.navigationBar.isHidden = false
            self.loginOutlet.isHidden = true
            self.alreadyLoginLabel.isHidden = true
            self.closeButton.isHidden = false
        }
        else if isFromLogin{
            self.closeButton.isHidden = false
        } else {
            self.navigationController?.navigationBar.isHidden = true
            self.loginOutlet.isHidden = false
            self.alreadyLoginLabel.isHidden = false
            self.closeButton.isHidden = true
        }
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: passwordText.frame.height - 1, width: view.frame.width - 50, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        passwordText.borderStyle = UITextField.BorderStyle.none
        passwordText.layer.addSublayer(bottomLine)
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0.0, y: emailText.frame.height - 1, width: view.frame.width - 50, height: 1.0)
        bottomLine1.backgroundColor = UIColor.white.cgColor
        emailText.borderStyle = UITextField.BorderStyle.none
        emailText.layer.addSublayer(bottomLine1)
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: NameText.frame.height - 1, width: view.frame.width - 50, height: 1.0)
        bottomLine2.backgroundColor = UIColor.white.cgColor
        NameText.borderStyle = UITextField.BorderStyle.none
        NameText.layer.addSublayer(bottomLine2)
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0.0, y: CouponText.frame.height - 1, width: view.frame.width - 50, height: 1.0)
        bottomLine3.backgroundColor = UIColor.white.cgColor
        CouponText.borderStyle = UITextField.BorderStyle.none
        CouponText.layer.addSublayer(bottomLine3)
        let bottomLine4 = CALayer()
        bottomLine4.frame = CGRect(x: 0.0, y: confirmEmailText.frame.height - 1, width: view.frame.width - 50, height: 1.0)
        bottomLine4.backgroundColor = UIColor.white.cgColor
        confirmEmailText.borderStyle = UITextField.BorderStyle.none
        confirmEmailText.layer.addSublayer(bottomLine4)

        if isFromAppleLogin{
            
            NameText.attributedPlaceholder = NSAttributedString(string: " ",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            emailText.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.NameText.text = appleName
            
            self.emailText.text = appleEmail
            self.apple_id = appleId
            
        }
        if isFromFbLogin{
            NameText.attributedPlaceholder = NSAttributedString(string: " ",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            emailText.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.NameText.text = fbName
            self.emailText.text = fbEmail
            self.facebook_id = fbId
        }
        self.navigationItem.backBarButtonItem?.title = ""
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        closeButton.addGestureRecognizer(tap)
        closeButton.isUserInteractionEnabled = true
        picker.delegate = self
      let buttonText = NSAttributedString(string: "Register with Facebook")
        loginViaFb.setAttributedTitle(buttonText, for: .normal)
      if let token = AccessToken.current,
             !token.isExpired {
        let loginManager = LoginManager()
               loginManager.logOut()
               print("logout")
             // User is logged in, do work such as go to next view controller.
         }

      loginViaFb.permissions = ["public_profile", "email"]
      loginViaFb.delegate = self
    }
    
//   func setupProviderLoginView() {
//       if #available(iOS 13.0, *) {
//           print("ios 13")
//       let authorizationButton = ASAuthorizationAppleIDButton()
//       authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//          self.view.addSubview(authorizationButton)
//
//           self.view.addConstraintsWithFormat(format: "H:|-80-[v0(250)]", views: authorizationButton)
//           self.view.addConstraintsWithFormat(format: "V:|-\(loginViaFb.frame.origin.y + loginViaFb.frame.height + 60 )-[v0]", views: authorizationButton)
//           authorizationButton.contentHorizontalAlignment = .center
//
//       }
//   }
    func setupProviderLoginView() {
        if #available(iOS 13.2, *) {
            print("ios 13")
            let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .white)
            authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            self.view.addSubview(authorizationButton)
            let screenRect = UIScreen.main.bounds
            let screenWidth = screenRect.size.width
            let screenHeight = screenRect.size.height
            
            authorizationButton.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .top, relatedBy: .equal, toItem: self.loginViaFb, attribute: .bottom, multiplier: 1, constant: 16))
            
            
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: screenWidth - 160))
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 80))
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 80))
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 30))
            authorizationButton.contentHorizontalAlignment = .center
            
            
            
            
            
        }
        
    }

    @objc func labelClicked(_ sender: Any) {
          print("UILabel clicked")
      self.HaveCouponLabel.text = "Coupon code:"
      self.HaveCouponLabel.textColor = ThemeManager.currentTheme().textfeildColor
      self.HaveCouponLabel.tintColor = ThemeManager.currentTheme().UIImageColor
      self.CouponText.isHidden = false

    }

    @objc func handleAuthorizationAppleIDButtonPress() {
         if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
                      let request = appleIDProvider.createRequest()
                      request.requestedScopes = [.fullName, .email]
                      
                      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                      authorizationController.delegate = self
                      authorizationController.presentationContextProvider = self
                      authorizationController.performRequests()
                  
        }
       
    }
    @available(iOS 13.0, *)
       @available(iOS 13.0, *)
       func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
              print("Auth error")
              // Handle error.
          }
    @available(iOS 13.0, *)
        @available(iOS 13.0, *)
       
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            print("didcomplete")
        self.apple_email = ""
        self.apple_id = ""
        self.apple_name = ""
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                // Create an account in your system.
              let userIdentifier = appleIDCredential.user
                self.apple_id = userIdentifier
                 if let fullName = appleIDCredential.fullName{
                       print(fullName)
                 }
                 if let name = appleIDCredential.fullName?.givenName{
                     self.apple_name = name
                     print(name)
                 }
                 if let email = appleIDCredential.email{
                     print(email)
                     self.apple_email = email
                     print(email)
                 }
                 
                 self.AppleapiCall()

                // For the purpose of this demo app, store the `userIdentifier` in the keychain.
    //            self.saveUserInKeychain(userIdentifier)
    //
    //            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
    //            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            
            case let passwordCredential as ASPasswordCredential:
            
                // Sign in using an existing iCloud Keychain credential.
                let username = passwordCredential.user
                let password = passwordCredential.password
                
                // For the purpose of this demo app, show the password credential as an alert.
                DispatchQueue.main.async {
    //                self.showPasswordCredentialAlert(username: username, password: password)
                }
                
            default:
                break
            }
        }
       
    @IBAction func loginToFbController(_ sender: Any) {
        print("fb sign up action ")

    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("fb sign up action didCompleteWith")
        if let error = error {
             print(error.localizedDescription)
             return
           }
        
        guard let accessToken = FBSDKLoginKit.AccessToken.current else { return }
        let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                      parameters: ["fields": "email, name"],
                                                      tokenString: accessToken.tokenString,
                                                      version: nil,
                                                      httpMethod: .get)
        graphRequest.start { (connection, resultLogin, error) -> Void in
            if error == nil {
                self.fb_email = ""
                       self.facebook_id = ""
                       self.fb_name = ""
                print("result \(resultLogin ?? "ghhjg")")
                 let response = resultLogin as! Dictionary<String, AnyObject>
               
                if response["id"]  != nil{
                     self.facebook_id = (response["id"] as! String)
                    print("facebookId",self.facebook_id as Any)

                }
                if response["email"]  != nil{
                    self.fb_email = (response["email"] as! String)
                     print("fb_email",self.fb_email as Any)
                }
                else{
                    self.fb_email = ""
                    print("fb_email",self.fb_email as Any)
                }
                if response["name"]  != nil{
                    self.fb_name = (response["name"] as! String)
                     print("fb_name",self.fb_name as Any)
                }
                else{
                    self.fb_name = ""
                    print("fb_name",self.fb_name as Any)
                }
                self.FbapiCall()
            }
            else {
                print("error \(error)")
            }
        }
    }
    
    func FbapiCall() {
        userDetails.removeAll()
        print("fbLoginApiCall")
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        var parameterDict: [String: String?] = [ : ]
        if self.fb_email != nil{
            parameterDict["email"] = self.fb_email
        }
        else{
            parameterDict["email"] = ""
        }
        
        
        parameterDict["login_type"] = "facebook"
        if self.facebook_id != nil{
            parameterDict["facebook_id"] = self.facebook_id
        }
        else{
            parameterDict["facebook_id"] = ""
        }
        parameterDict["first_name"] = self.fb_name
        parameterDict["last_name"] = ""
        
        print("parameterDict",parameterDict)
        
        ApiCommonClass.RegisterWithFB(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                                DispatchQueue.main.async {
                                    print("error")
            
                                    CustomProgressView.hideActivityIndicator()
            
                                }
                            }
            else{
                if responseDictionary["statuscode"] as! Int == 200{
                    self.userDetail = responseDictionary["Channels"] as! [VideoModel]
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.userDetail[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetail[0].first_name, forKey: "first_name")
                            UserDefaults.standard.set(self.userDetail[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            if UserDefaults.standard.string(forKey:"access_token") == nil {
                              self.getTokenForAuthentication()
                            }
                            else{
                                self.app_Install_Launch()

                            }
                            if self.guestUserLogedIn == true {
                                CustomProgressView.hideActivityIndicator()
                                Application.shared.guestRegister = true
                                self.getUserSubscription()
                            }
                            else {
                                CustomProgressView.hideActivityIndicator()

        //                        self.getToken()
                                if self.isFromAccountScreen{
                                    self.dismiss(animated: false, completion: {
                                        let delegate = UIApplication.shared.delegate as? AppDelegate
                                        delegate!.loadTabbar()
                                    })
                                }
                                else{
                                    let delegate = UIApplication.shared.delegate as? AppDelegate
                                    delegate!.loadTabbar()
                                }
                            }
                            
                        }
                }
                if responseDictionary["statuscode"] as! Int == 204{
                    CustomProgressView.hideActivityIndicator()

                    self.showAlertForLinkingAccount()
                }
            }
           

        }
        
    }
    func AppleapiCall() {
           print("AppleLoginApiCall")
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        var parameterDict: [String: String?] = [ : ]
        
        
        if self.apple_email != nil{
            parameterDict["email"] = self.apple_email
            
        }
        else{
            parameterDict["email"] = ""
        }
        
        if self.apple_name != nil{
            
            parameterDict["first_name"] = self.apple_name
            parameterDict["last_name"] = ""
            
        }
        else{
            parameterDict["first_name"] = ""
        }
        parameterDict["login_type"] = "apple"
        if self.apple_id != nil{
            parameterDict["apple_id"] = self.apple_id
        }
        else{
            parameterDict["apple_id"] = ""
        }
        
          
        ApiCommonClass.RegisterWithFB(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                                DispatchQueue.main.async {
                                    print("error")
                                    WarningDisplayViewController().customActionAlert(viewController :self,title: responseDictionary["message"] as? String, message: "", actionTitles: ["OK"], actions:[{action1 in self.showAlert()
                                                       },nil])
                                    CustomProgressView.hideActivityIndicator()
            
                                }
                            }
            else{
                if responseDictionary["statuscode"] as! Int == 200{
                    self.userDetail = responseDictionary["Channels"] as! [VideoModel]
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.userDetail[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetail[0].first_name, forKey: "first_name")
                            UserDefaults.standard.set(self.userDetail[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            if UserDefaults.standard.string(forKey:"access_token") == nil {
                              self.getTokenForAuthentication()
                            }
                            else{
                                self.app_Install_Launch()

                            }
                            if self.guestUserLogedIn == true {
                                CustomProgressView.hideActivityIndicator()
                                Application.shared.guestRegister = true
                                self.getUserSubscription()
                            }
                            else {
                                CustomProgressView.hideActivityIndicator()

        //                        self.getToken()
                                if self.isFromAccountScreen{
                                    self.dismiss(animated: false, completion: {
                                        let delegate = UIApplication.shared.delegate as? AppDelegate
                                        delegate!.loadTabbar()
                                    })
                                }
                                else{
                                    let delegate = UIApplication.shared.delegate as? AppDelegate
                                    delegate!.loadTabbar()
                                }
                            }
                            
                        }
                }
                if responseDictionary["statuscode"] as! Int == 204{
                    CustomProgressView.hideActivityIndicator()

                    self.showAlertForLinkingAccountApple()
                }
            }
           

        }
           
    }
    func showAlertForLinkingAccount(){
        WarningDisplayViewController().customActionAlert(viewController :self,title: "Do you want to link your Facebook account?", message: "", actionTitles: ["No","Yes"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                               self.linkSocialAccountApiCall()
                           },nil])
    }
    func showAlertForLinkingAccountApple(){
              WarningDisplayViewController().customActionAlert(viewController :self,title: "Do you want to link your Apple Account?", message: "", actionTitles: ["No","Yes"], actions:[{action1 in self.cancelAlertActionApple()},{action2 in
                                     self.linkSocialAccountApiCallApple()
                                 },nil])
          }
    func cancelAlertAction(){
        WarningDisplayViewController().customActionAlert(viewController :self,title: "\(fb_email ?? "jgy") is already registered with KICCTV. Please Login.", message: "", actionTitles: ["OK"], actions:[{action1 in self.showAlert()},nil])
    }
    func cancelAlertActionApple(){
        WarningDisplayViewController().customActionAlert(viewController :self,title: "\(apple_email ?? "jgy") is already registered with KICCTV. Please Login.", message: "", actionTitles: ["OK"], actions:[{action1 in self.showAlert()},nil])
    }
    func showAlert(){
        print("dissmiss link fb")
    }
    func linkSocialAccountApiCall(){
        print("linkSocialAccountApiCall")
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        var parameterDict: [String: String?] = [ : ]
        if self.fb_email != nil{
            parameterDict["email"] = self.fb_email
        }
        else{
            parameterDict["email"] = ""
        }
        if self.fb_name != nil{
            parameterDict["first_name"] = self.fb_name
        }
        else{
            parameterDict["first_name"] = ""
        }
        parameterDict["last_name"] = ""
        parameterDict["login_type"] = "facebook"
        if self.facebook_id != nil{
            parameterDict["facebook_id"] = self.facebook_id
        }
        else{
            parameterDict["facebook_id"] = ""
        }
       
        print("parameterDict",parameterDict)
      
        ApiCommonClass.linkSocialMediaAccount(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    print("error")
                    
                    CustomProgressView.hideActivityIndicator()
                    
                }
            }
            else{
                if responseDictionary["statuscode"] as! Int == 200{
                    self.userDetail = responseDictionary["Channels"] as! [VideoModel]
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.userDetail[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetail[0].first_name, forKey: "first_name")
                            UserDefaults.standard.set(self.userDetail[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            if UserDefaults.standard.string(forKey:"access_token") == nil {
                              self.getTokenForAuthentication()
                            }
                            else{
                                self.app_Install_Launch()

                            }
                            if self.guestUserLogedIn == true {
                                CustomProgressView.hideActivityIndicator()
                                Application.shared.guestRegister = true
                                self.getUserSubscription()
                            }
                            else {
                                CustomProgressView.hideActivityIndicator()

        //                        self.getToken()
                                if self.isFromAccountScreen{
                                    self.dismiss(animated: false, completion: {
                                        let delegate = UIApplication.shared.delegate as? AppDelegate
                                        delegate!.loadTabbar()
                                    })
                                }
                                else{
                                    let delegate = UIApplication.shared.delegate as? AppDelegate
                                    delegate!.loadTabbar()
                                }
                            }
                            
                        }
                }
                else{
                    if responseDictionary["message"] != nil{
                        let message = responseDictionary["message"]
                        ToastView.shared.short(self.view, txt_msg: message as! String)

                    }
                }
            }
           

        }
    }
  
    func getTokenForAuthentication() {
         ApiCommonClass.getToken { (responseDictionary: Dictionary) in
             if responseDictionary["error"] != nil {
                 ToastView.shared.short(self.view, txt_msg: "Server error")
              // ToastView.shared.short(self.view, txt_msg: responseDictionary["error"] as! String)
             } else {
                 DispatchQueue.main.async {
                     self.app_Install_Launch()
             }
         }
     }
     }
    func app_Install_Launch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }

      parameterDict["device_type"] = "iOS"
      if let longitude = UserDefaults.standard.string(forKey:"longitude") {
        parameterDict["longitude"] = longitude
      }
      if let latitude = UserDefaults.standard.string(forKey: "latitude"){
        parameterDict["latitude"] = latitude
      }
      if let country = UserDefaults.standard.string(forKey:"country"){
        parameterDict["country"] = country
      }
      if let city = UserDefaults.standard.string(forKey:"city"){
        parameterDict["city"] = city
      }
      if let userAgent = UserDefaults.standard.string(forKey:"userAgent"){
           parameterDict["ua"] = userAgent
         }
      if let IPAddress = UserDefaults.standard.string(forKey:"IPAddress") {
        parameterDict["ip_address"] = IPAddress
      }
     
      if let advertiser_id = UserDefaults.standard.string(forKey:"Idfa"){
        parameterDict["advertiser_id"] = advertiser_id
      }
      else{
            parameterDict["advertiser_id"] = "00000000-0000-0000-0000-000000000000"
          }
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
         parameterDict["width"] =  String(format: "%.3f",UIScreen.main.bounds.width)
         parameterDict["height"] = String(format: "%.3f",UIScreen.main.bounds.height)
         parameterDict["device_make"] = "Apple"
        parameterDict["device_model"] = UserDefaults.standard.string(forKey:"deviceModel")
         if (UserDefaults.standard.string(forKey: "first_name") != nil){
          parameterDict["user_name"] = UserDefaults.standard.string(forKey: "first_name")
         }
      if let user_email = UserDefaults.standard.string(forKey: "user_email"){
       parameterDict["user_email"] = user_email
      }
       
      if let publisherid = UserDefaults.standard.string(forKey: "pubid") {
        parameterDict["publisherid"] = publisherid
      }
      
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
     
      if (UserDefaults.standard.string(forKey:"skiplogin_status") == "false") {
  //    if (UserDefaults.standard.string(forKey: "user_email") != nil){
  //     parameterDict["user_email"] = UserDefaults.standard.string(forKey: "user_email")
  //    }
  //
      if (UserDefaults.standard.string(forKey: "phone") != nil){
       parameterDict["user_contact_number"] = UserDefaults.standard.string(forKey: "phone")
      }
          
      }
        print("param for device api",parameterDict)

      ApiCommonClass.analayticsAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            print("device api success")
          }
        }
      }
    }
    func getToken() {
         ApiCommonClass.getToken { (responseDictionary: Dictionary) in
             if responseDictionary["error"] != nil {
                 ToastView.shared.short(self.view, txt_msg: "Server error")
              // ToastView.shared.short(self.view, txt_msg: responseDictionary["error"] as! String)
             } else {
                 DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                         let delegate = UIApplication.shared.delegate as? AppDelegate
                                                         delegate!.loadTabbar()
                     
                 
             }
         }
     }
     }
    
    func linkSocialAccountApiCallApple(){
        print("linkSocialAccountAppleApiCall")
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        var parameterDict: [String: String?] = [ : ]
        if self.apple_email != nil{
            parameterDict["email"] = self.apple_email
        }
        else{
            parameterDict["email"] = ""
        }

        parameterDict["last_name"] = ""

        parameterDict["login_type"] = "apple"
        if self.apple_id != nil{
            parameterDict["apple_id"] = self.apple_id
        }
        else{
            parameterDict["apple_id"] = ""
        }
        
        if self.apple_name != nil{
            parameterDict["first_name"] = self.apple_name
        }
        else{
            parameterDict["first_name"] = ""
        }
        
        print("parameterDict",parameterDict)
        ApiCommonClass.linkSocialMediaAccount(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    print("error")
                    
                    CustomProgressView.hideActivityIndicator()
                    
                }
            }
            else{
                if responseDictionary["statuscode"] as! Int == 200{
                    self.userDetail = responseDictionary["Channels"] as! [VideoModel]
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.userDetail[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetail[0].first_name, forKey: "first_name")
                            UserDefaults.standard.set(self.userDetail[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            if UserDefaults.standard.string(forKey:"access_token") == nil {
                              self.getTokenForAuthentication()
                            }
                            else{
                                self.app_Install_Launch()

                            }
                            if self.guestUserLogedIn == true {
                                CustomProgressView.hideActivityIndicator()
                                Application.shared.guestRegister = true
                                self.getUserSubscription()
                            }
                            else {
                                CustomProgressView.hideActivityIndicator()

        //                        self.getToken()
                                if self.isFromAccountScreen{
                                    self.dismiss(animated: false, completion: {
                                        let delegate = UIApplication.shared.delegate as? AppDelegate
                                        delegate!.loadTabbar()
                                    })
                                }
                                else{
                                    let delegate = UIApplication.shared.delegate as? AppDelegate
                                    delegate!.loadTabbar()
                                }
                            }
                            
                        }
                }
                else{
                    if responseDictionary["message"] != nil{
                        let message = responseDictionary["message"]
                        ToastView.shared.short(self.view, txt_msg: message as! String)

                    }
                }
            }
           

        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        print("logout")
    }
    @IBAction func showPasswordAction(_ sender: Any) {
        passwordText.isSelected = !showPassword.isSelected
        
//        passwordText.isSelected = !showPassword.isSelected
        
        
        //                      passwordText.isSecureTextEntry = false
        if(iconClick == true) {
            passwordText.isSecureTextEntry = false
            showPassword.setImage(UIImage(named: "eye-closedorginal"), for: .normal)
            
        } else {
            passwordText.isSecureTextEntry = true
            showPassword.setImage(UIImage(named: "icon_eyepen"), for: .normal)
        }
        iconClick = !iconClick
        
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
//      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
  }

  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      reachability.stopNotifier()
      NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
  }
    @objc func countryButtonClicked() {
        picker.showCallingCodes = true
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    // back to videoDetails page  from intermediate guest user login
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isFromLogin{
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate!.loadTabbar()
        }
        else if isFromVideoDeails{
            let delegate = UIApplication.shared.delegate as? AppDelegate
                       delegate!.loadTabbar()
        }
        else if isFromAccountScreen{
            self.dismiss(animated: true, completion: nil)
        }
        else{
        self.dismiss(animated: true, completion: nil)
//        self.backDelegate!.loadAfterIntermediateLogin()
        }
    }
    //back to videoDetails page after registration from guest.
    func dismiss() {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: nil)
             self.backDelegate!.loadAfterIntermediateLogin()
            
        })
    }

    func closeRegisterScreen() {
      
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: nil)
//             self.backDelegate!.loadAfterIntermediateLogin()

        })
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
            AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
            print("Network not reachable")
        }
    }
    @IBAction func signUpAction(_ sender: Any) {
        signUp()
    }
    @IBAction func LoginAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if isFromSubscriptionPage {
            self.dismiss(animated: false, completion: {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                nextViewController.isFromSubscriptionPage = true
                UIApplication.topViewController()?.present(nextViewController, animated: true, completion: nil)
            })
        }
        else if isFromAccountScreen{
            self.dismiss(animated: false, completion: {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                nextViewController.isFromSubscriptionPage = true
                UIApplication.topViewController()?.present(nextViewController, animated: true, completion: nil)
            })
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            self.navigationController?.pushViewController(nextViewController, animated: false)
        }
    }
    func isValidEmail(testStr:String) -> Int {
        if  testStr.isEmpty{
            return 1
        }else{
            print("validate emilId: \(testStr)")
            let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: testStr)
            if result == true{
                return 2
            }else{
                return 3
            }
            
        }
    }
    //  func signUp(){
    //     OTPverificationViewController.showOTPviewController(viewController: self,isFromRegister : true)
    //  }
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"


    func signUp() {
       let lettersAndSpacesCharacterSet = CharacterSet.letters.union(.whitespaces).inverted
        let password = passwordText.text!

        if (NameText.text?.isEmpty)! {
            WarningDisplayViewController().customAlert(viewController:self, messages: "Enter Name")
        }
         
        else if  NameText.text?.rangeOfCharacter(from: lettersAndSpacesCharacterSet) != nil {
             WarningDisplayViewController().customAlert(viewController:self, messages: "Numbers and special characters are not allowed for user name.")
        }// true

//       else if  NameText.text?.range(of: ".*[^A-Za-z].*", options: .regularExpression) != nil {
////           WarningDisplayViewController().customAlert(viewController:self, messages: "User name should contain only characters")
//       }
        else if NameText.text!.isReallyEmpty || NameText.text == "              " {
            WarningDisplayViewController().customAlert(viewController:self, messages: "User name must start with letter")
        }
        else if (isValidEmail(testStr:emailText!.text! ) == 1) {
            WarningDisplayViewController().customAlert(viewController:self, messages: "Enter Email")
        } else if(isValidEmail(testStr:emailText!.text! ) == 3) {
            WarningDisplayViewController().customAlert(viewController:self, messages: "Invalid Email")
        }
        else if(confirmEmailText.text?.isEmpty)! {
          WarningDisplayViewController().customAlert(viewController:self, messages: "Please confirm Email")
        }
      else if(emailText.text != confirmEmailText.text){
          WarningDisplayViewController().customAlert(viewController:self, messages: "Email doesn't match")
        }
        else if (passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            WarningDisplayViewController().customAlert(viewController:self, messages: "Enter Password")
        }
       
        else if (passwordText.text!.contains(" ")) {
                      WarningDisplayViewController().customAlert(viewController:self, messages: "Space is not allowed in password")
                  }
        else if (passwordText.text!.count < 6) {
            WarningDisplayViewController().customAlert(viewController:self, messages: "Password should contain minimum of 6 characters")
        }
//        else if ((passwordText.text?.trimmingCharacters(in: .whitespaces)) != nil){
//            WarningDisplayViewController().customAlert(viewController:self, messages: "Space is not allowed in Password ")
//        }
            else {
//            phoneNumber = countryCodeButton.titleLabel!.text! + phoneTextField.text!
            // phoneNumber = "+919999999999"
            // Auth.auth().settings!.isAppVerificationDisabledForTesting = true
//            UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
            if  reachability.connection != .none {
                CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
                register()
//                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
//                    if let error = error {
//                        CustomProgressView.hideActivityIndicator()
//                        Application.showAlert(onViewController: self, title: "There was an error \n sending the SMS code", message: error.localizedDescription, actionTitle: "OK", cancelButton: false, handler: nil)
//                        return
//                    }
//                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//                    DispatchQueue.main.async {
//                        CustomProgressView.hideActivityIndicator()
//                        OTPverificationViewController.showOTPviewController(viewController: self,isFromRegister : true)
//                    }
//                }
            } else {
                AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
            }
        }
    }
    func validate(value: String) -> Bool {
               let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
               let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
               let result = phoneTest.evaluate(with: value)
               return result
           }
//    func isValidPassword() -> Bool {
//        // least one uppercase,
//        // least one digit
//        // least one lowercase
//        // least one symbol
//        //  min 8 characters total
//        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
//        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
//        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
//        return passwordCheck.evaluate(with: password)
//
//    }
    var userId = String()
    func gotoHome(){
//        self.dismiss()
//        getUserSubscription()
        self.dismiss(animated: true, completion: nil)
        let delegate = UIApplication.shared.delegate as? AppDelegate
                                        delegate!.loadTabbar()
    }
    func getUserSubscription(){
           self.dismiss(animated: true, completion: nil)

           self.guestUserDelegate.guestUserLogin()

       }
    func register() {
        DispatchQueue.main.async {
//            CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
            let UDID = UIDevice.current.identifierForVendor?.uuidString
            var parameterDict: [String: String?] = [ : ]
                    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
                    let pubid = UserDefaults.standard.string(forKey:"pubid")!
                    let device_type = "ios-phone"
                    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
                    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
                    let channelid = UserDefaults.standard.string(forKey:"channelid")!
                    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
            guard let email = self.emailText.text, let password = self.passwordText.text,let udid = UDID,let name = self.NameText.text  else {
                return
            }
//            self.phoneNumber = self.countryCodeButton.titleLabel!.text! + self.phoneTextField.text!
            if self.emailText.text != nil{
                let trimmedString = self.emailText!.text!.trimmingCharacters(in: .whitespaces)
                parameterDict["user_email"] = trimmedString.lowercased()

            }
            if !password.isEmpty{
                let trimmedString = password.trimmingCharacters(in: .whitespaces)
                parameterDict["password"] = trimmedString
            }
//            parameterDict["user_email"] = email.lowercased()
            UserDefaults.standard.set(parameterDict["user_email"] as Any?, forKey: "user_email")
//            parameterDict["password"] = password
            parameterDict["first_name"] = name
            parameterDict["last_name"] = ""

            
            if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
                parameterDict["ipaddress"] = ipAddress
            }
            if self.apple_id != nil{
                parameterDict["apple_id"] = self.apple_id

            }
            else{
                parameterDict["apple_id"] = "0"

            }
            if self.facebook_id != nil{
                parameterDict["facebook_id"] = self.facebook_id
                
            }
            else{
                parameterDict["facebook_id"] = "0"
                
            }
            parameterDict["device_id"] = udid
            parameterDict["device_type"] = "ios-phone"
            parameterDict["login_type"] = "gmail-login"
            parameterDict["verified"] = UserDefaults.standard.string(forKey: "verifiedNumber")
            parameterDict["c_code"] = self.c_code
            if let longitude = UserDefaults.standard.string(forKey:"longitude") {
              parameterDict["longitude"] = longitude
            }
            if let latitude = UserDefaults.standard.string(forKey: "latitude"){
              parameterDict["latitude"] = latitude
            }
            if let country = UserDefaults.standard.string(forKey:"country"){
              parameterDict["country"] = country
            }
            print("parameterDictionary",parameterDict)
               let encoder = JSONEncoder()
               encoder.outputFormatting = .prettyPrinted
               let data = try! encoder.encode(parameterDict)
             ApiCallManager.apiCallREST(mainUrl: RegisterApi, httpMethod: "POST", headers: ["Content-Type":"application/json","country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: data) { (responseDictionary: Dictionary) in
                var channelResponseArray = [userModel]()
                var channelResponse = Dictionary<String, AnyObject>()
            print("enter to ")
                guard let succes = responseDictionary["success"] as? NSNumber  else {
                  return
                }
//                guard let status = responseDictionary["status"] as? NSNumber  else {
//                  return
//                }
                if succes == 0{
                    DispatchQueue.main.async {
                        CustomProgressView.hideActivityIndicator()
                         
                        WarningDisplayViewController().customActionAlert(viewController :self,title:responseDictionary["message"] as! String, message: "", actionTitles: ["Ok"], actions:[{action1 in self.goToLogin()},nil])
                    }
                }
                else if succes == 1 {
                    DispatchQueue.main.async {
                        ToastView.shared.long(self.view, txt_msg: "OTP send to gmail please check spam ")
//                        PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneNumber, uiDelegate: nil) { (verificationID, error) in
//                       let dataArray = responseDictionary["user_id"] as AnyObject
////                        let  id = dataArray["user_id"] as AnyObject
//                            let  id = dataArray
//
//                        print(id)
//                       let x = id as! Int
//                             self.userId = String(x)
//
//                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//                        CustomProgressView.hideActivityIndicator()
//
////
////                            WarningDisplayViewController().customAlert(viewController:self, messages: "Otp send to email please check spam")
//
//                        }
//                      self.gotoOtpScreen()
                      UserDefaults.standard.set("true", forKey: "login_status")
                      UserDefaults.standard.set("false", forKey: "skiplogin_status")
                      CustomProgressView.hideActivityIndicator()
                      self.dismiss(animated: true, completion: nil)
                    }
                  }
               else if succes == 2{
                    DispatchQueue.main.async {
                        CustomProgressView.hideActivityIndicator()
//                        self.goToLogin()
//                         WarningDisplayViewController().customAlert(viewController:self, messages: "IAlready registered user")
// self.navigationController?.popToRootViewController(animated: false)
                        WarningDisplayViewController().customActionAlert(viewController :self,title: "Already registered user", message: "", actionTitles: ["Ok"], actions:[{action1 in self.goToLogin()},nil])
                    }
                }
                else {
                  channelResponse["error"]=responseDictionary["message"]
                }

            }

        }
    }
  func gotoOtpScreen(){
//      UIView.animate(withDuration: 0.15, animations: {
//                self.view.backgroundColor=UIColor.clear
//            }, completion:{ _ in
//                self.dismiss(animated: true, completion: {
                  print("goto otp vc")
                  OTPverificationViewController.showOTPviewController(viewController: self,isFromRegister : true, userId: self.userId)
//                })
//            })
//    UIView.animate(withDuration: 0.15, animations: {
//        self.view.backgroundColor=UIColor.clear
//    }, completion:{ _ in
//        self.dismiss(animated: false, completion: nil)
//    })
  }
    func goToLogin(){
//         WarningDisplayViewController().customAlert(viewController:self, messages: "IAlready registered user")
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//        self.navigationController?.pushViewController(nextViewController, animated: false)
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            if isFromAccountScreen{
        self.closeRegisterScreen()
            }
            else{
                self.dismiss()
            }
        
    }
       else{
        self.navigationController?.popViewController(animated: false)
//           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//                self.navigationController?.pushViewController(nextViewController, animated: false)
        }
    }
}
extension UITextField {
    func setBottomBorder() {
//        
        self.borderStyle = .none
        
        self.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.yellow.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
extension RegisterViewController: RegisterMenuDelegate {
    func didSelectRegisterSkip() {
        self.phoneNumber = ""
        self.c_code = ""
        Application.shared.guestRegister = true
        self.gotoHome()
    }
    func didSelectRegister(){
        navigationController?.popViewController(animated: false)
        Application.shared.guestRegister = false
        self.gotoHome()
    }
}
extension RegisterViewController: ADCountryPickerDelegate {
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        selectedCountryCode = dialCode
        countryCodeButton.setTitleColor(ThemeManager.currentTheme().textfeildColor, for: .normal)
        countryCodeButton.setTitle(selectedCountryCode, for: .normal)
        UserDefaults.standard.set(code, forKey: "c_code")
    }
}

extension String {
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
