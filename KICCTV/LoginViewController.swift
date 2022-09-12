//
//  LoginViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 23/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import Reachability
import Firebase
import Alamofire
import AuthenticationServices
import WebKit
import LocalAuthentication

//import FirebaseCrashlytics0128

protocol videoPlayingDelegate:class { // delegate for playing video after login from guest user
    func guestUserLogin()
}


class LoginViewController: UIViewController,UITextFieldDelegate,LoginButtonDelegate,ASAuthorizationControllerDelegate, WKNavigationDelegate, WKUIDelegate,ASAuthorizationControllerPresentationContextProviding{


    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
         return self.view.window!
    }

    var webUrl = ""
       var titles = ""
    var webView : WKWebView!
    @IBOutlet weak var signInwithAppleBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInOutlet: UIButton!{
        didSet{
               
            self.signInOutlet.backgroundColor = ThemeManager.currentTheme().TabbarColor
        }
    }
  @IBOutlet weak var emailText: UITextField!
  @IBOutlet weak var loginOutlet: UIButton!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var logoImage: UIImageView!
  {
    didSet{
      self.logoImage.image = UIImage(named: ThemeManager.currentTheme().logoImage)
    }
  }
    @IBOutlet weak var signInWithFBOutlet: FBLoginButton!
    @IBOutlet weak var skipLoginOutlet: UIButton!
  @IBOutlet weak var signFBButtonHeight: NSLayoutConstraint!
  @IBOutlet weak var orSignUpWithoutLabelHeight: NSLayoutConstraint!
  @IBOutlet weak var orSignUpLabel: UILabel!
  @IBOutlet weak var faceBookButtonViewHeight: NSLayoutConstraint!
  @IBOutlet weak var faceBookButtonView: UIView!
  @IBOutlet weak var newToLabel: UILabel!
  @IBOutlet weak var backButton: UIImageView!
  @IBOutlet weak var forgotPasswordOutLet: UIButton!
  @IBOutlet weak var logoImageHeight: NSLayoutConstraint!
//  {
//    didSet{
//    self.logoImageHeight.constant = 100
//    }
//  }
  var userDetails = [VideoModel]()
  var loginType = String()
  var FBemail = String()
  var FBId = String()
  var firstName = String()
  var lastName = String()
  var reachability = Reachability()!
  var isFromSubscriptionPage = false
    var isFromSideMenu = false
    var isfromDeails = false

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signInwithAppleBtn: UIButton!
    weak var guestUserDelegate: videoPlayingDelegate!
var guestUserLogedIn = false
    var isFromAccountScreen = false
    weak var backDelegate : VideoCheckingDelegate?
    var liveVideos = [VideoModel]()
    var showVideos = [VideoModel]()
    var channelVideos = [VideoModel]()
    var myString:NSString = "New to KICCTV?"
    var myMutableString = NSMutableAttributedString()

  // MARK: Main Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.faceBookButtonViewHeight.constant = 0
//    self.faceBookButtonView.isHidden = true
    let buttonText = NSAttributedString(string: "Continue with Facebook")
           signInWithFBOutlet.setAttributedTitle(buttonText, for: .normal)
//    self.signInWithFBOutlet.isHidden = false
    if let token = AccessToken.current,
           !token.isExpired {
        let loginManager = LoginManager()
        loginManager.logOut()
           // User is logged in, do work such as go to next view controller.
       }
    if isFromAccountScreen{
    }
    else{
        setupProviderLoginView()
    }

    signInWithFBOutlet.permissions = ["public_profile", "email"]
    signInWithFBOutlet.delegate = self

      self.contentView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
    self.view.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
      self.scrollView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
    
      self.loginOutlet.setTitleColor(.white, for: .normal)
    self.skipLoginOutlet.setTitleColor(.white, for: .normal)
    self.forgotPasswordOutLet.setTitleColor(.white, for: .normal)
    self.backButton.tintColor = ThemeManager.currentTheme().UIImageColor

    myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size: 17.0)!])
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().TabbarColor, range: NSRange(location:7,length:10))
   
    
       // set label Attribute
    self.newToLabel.attributedText = myMutableString
    self.newToLabel.isUserInteractionEnabled = true
    let signupTap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
    self.newToLabel.addGestureRecognizer(signupTap)
//    self.newToLabel.text = "New To \(ThemeManager.currentTheme().appName)?"
    self.emailText.attributedPlaceholder = NSAttributedString(string: "Email",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    self.passwordText.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    self.emailText.textColor = ThemeManager.currentTheme().textfeildColor
    self.passwordText.textColor = ThemeManager.currentTheme().textfeildColor
    self.emailText.tintColor = ThemeManager.currentTheme().UIImageColor
    self.passwordText.tintColor = ThemeManager.currentTheme().UIImageColor
    self.passwordText.delegate = self
//    self.emailText.setBottomBorder()
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0.0, y: emailText.frame.height - 1, width: view.frame.width - 50, height: 1.0)
    bottomLine.backgroundColor = UIColor.white.cgColor
    emailText.borderStyle = UITextField.BorderStyle.none
    emailText.layer.addSublayer(bottomLine)
    let bottomLine1 = CALayer()
    bottomLine1.frame = CGRect(x: 0.0, y: passwordText.frame.height - 1, width: view.frame.width - 50, height: 1.0)
    bottomLine1.backgroundColor = UIColor.white.cgColor
    passwordText.borderStyle = UITextField.BorderStyle.none
    passwordText.layer.addSublayer(bottomLine1)
//    self.passwordText.setBottomBorder()
    self.tabBarController?.tabBar.isHidden = true
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//      self.signInOutlet.layer.cornerRadius = 8.0
//    self.signInWithFBOutlet.layer.cornerRadius = 20.0
    if UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
      self.skipLoginOutlet.isHidden = true
    } else {
      self.skipLoginOutlet.isHidden = true
    }
    if guestUserLogedIn == true { // checking loged in as guest or not (changes in UI before and after intermediate login)
     self.navigationController?.navigationBar.isHidden = false
      self.newToLabel.isHidden = true
      self.skipLoginOutlet.isHidden = true
      self.loginOutlet.isHidden = true
      self.backButton.isHidden = false
      self.forgotPasswordOutLet.isHidden = false
    } else {
        if isFromAccountScreen{
            self.navigationController?.navigationBar.isHidden = true
            self.newToLabel.isHidden = false
            self.skipLoginOutlet.isHidden = true
            self.loginOutlet.isHidden = false
            self.backButton.isHidden = false
            self.forgotPasswordOutLet.isHidden = false
        }
        else{
      self.navigationController?.navigationBar.isHidden = true
      self.newToLabel.isHidden = false
      self.skipLoginOutlet.isHidden = false
      self.loginOutlet.isHidden = false
      self.backButton.isHidden = true
      self.forgotPasswordOutLet.isHidden = false
        }
    }
    
    self.navigationItem.backBarButtonItem?.title = ""
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    self.backButton.addGestureRecognizer(tap)
    self.backButton.isUserInteractionEnabled = true
//    if UserDefaults.standard.string(forKey: "registration_mandatory_flag") == "1"{
//        self.skipLoginOutlet.isHidden = true
//    }
//    else{
//        self.skipLoginOutlet.isHidden = false
//    }
//    if UserDefaults.standard.string(forKey: "subscription_mandatory_flag") == "1"{
//        self.orSignUpLabel.isHidden = true
//        self.skipLoginOutlet.isHidden = true
//    }
//    else{
//        self.orSignUpLabel.isHidden = false
//
//    }
    if isFromSideMenu{
        self.backButton.isHidden = false
        self.skipLoginOutlet.isHidden = true
    }
    if isfromDeails{
        self.backButton.isHidden = false
    }
  }

    func setupProviderLoginView() {
        if #available(iOS 13.0, *) {
            print("ios 13")
            signInwithAppleBtn.isHidden = true
            let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
            authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            self.view.addSubview(authorizationButton)
            let screenRect = UIScreen.main.bounds
            let screenWidth = screenRect.size.width
            let screenHeight = screenRect.size.height
            authorizationButton.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .top, relatedBy: .equal, toItem: self.logoImage, attribute: .bottom, multiplier: 1, constant: 30))
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: screenWidth - 160))
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 80))
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 80))
            view.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 30))
            authorizationButton.contentHorizontalAlignment = .center
            
        }
        signInwithAppleBtnHeight.constant = 0
        signInwithAppleBtn.removeFromSuperview()
        
        
        
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
                print("password credentioals")
//                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    @IBAction func signIntoApple(_ sender: Any) {
        print("sign into apple")
       

        UIApplication.shared.openURL(NSURL(string: "https://appleid.apple.com/auth/authorize?client_id=com.ios.happitv&redirect_uri=https://gethappi.tv/iosredirect&response_type=code&scope=name%20email&response_mode=form_post&state=STATE")! as URL)



    }
      
    @IBAction func signInWithFB(_ sender: Any) {
        print("fb sign in action")
    }
    var facebook_id : String?
     var fb_email : String?
    var fb_name : String?
    var apple_id : String?
        var apple_email : String?
       var apple_name : String?
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("fb sign in action didCompleteWith")
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
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let loginManager = LoginManager()
        LoginManager.init().logOut()
//        let deletepermission = GraphRequest(graphPath: "me/permissions/")
//
//        GraphRequest(graphPath: "me/permissions/", parameters: nil)
//        deletepermission.start(completionHandler: {(connection,result,error)-> Void in
//            print("the delete permission is \(result)")
//
//        })

        loginManager.loginBehavior = .browser

        print("logout")
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
                                    WarningDisplayViewController().customActionAlert(viewController :self,title: responseDictionary["message"] as? String, message: "", actionTitles: ["OK"], actions:[{action1 in self.showAlert()
                                                       },nil])
                                    CustomProgressView.hideActivityIndicator()
            
                                }
                            }
            else{
                if responseDictionary["statuscode"] as! Int == 200{
                    self.userDetails = responseDictionary["Channels"] as! [VideoModel]
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                            UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            if self.guestUserLogedIn == true {
                                CustomProgressView.hideActivityIndicator()
                                Application.shared.guestRegister = true
                                self.app_Install_Launch()

                                self.getUserSubscription()
                            }
                            else {
                                CustomProgressView.hideActivityIndicator()
                                self.getToken()
                               
                          
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
            
                                    CustomProgressView.hideActivityIndicator()
            
                                }
                            }
            else{
                if responseDictionary["statuscode"] as! Int == 200{
                    self.userDetails = responseDictionary["Channels"] as! [VideoModel]
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                            UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            if self.guestUserLogedIn == true {
                                CustomProgressView.hideActivityIndicator()
                                Application.shared.guestRegister = true
                                self.getUserSubscription()
                                self.app_Install_Launch()

                            }
                            else {
                                CustomProgressView.hideActivityIndicator()

                                self.getToken()

                              
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
    
    func cancelAlertAction(){
        WarningDisplayViewController().customActionAlert(viewController :self,title: "\(fb_email ?? "jgy") is already registered with KICCTV. Please Login.", message: "", actionTitles: ["OK"], actions:[{action1 in self.showAlert()},nil])
    }
    func cancelAlertActionApple(){
           WarningDisplayViewController().customActionAlert(viewController :self,title: "\(apple_email ?? "jgy") is already registered with KICCTV. Please Login.", message: "", actionTitles: ["OK"], actions:[{action1 in self.showAlert()},nil])
       }
    func showAlertForLinkingAccountApple(){
           WarningDisplayViewController().customActionAlert(viewController :self,title: "Do you want to link your Apple Account?", message: "", actionTitles: ["No","Yes"], actions:[{action1 in self.cancelAlertActionApple()},{action2 in
                                  self.linkSocialAccountApiCallApple()
                              },nil])
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
                    self.userDetails = responseDictionary["Channels"] as! [VideoModel]
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                            UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            if self.guestUserLogedIn == true {
                                CustomProgressView.hideActivityIndicator()
                                Application.shared.guestRegister = true
                                self.getUserSubscription()
                                self.app_Install_Launch()

                            }
                            else {
                                CustomProgressView.hideActivityIndicator()

                                self.getToken()
                               
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
                    self.userDetails = responseDictionary["Channels"] as! [VideoModel]
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                            UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            if self.guestUserLogedIn == true {
                                CustomProgressView.hideActivityIndicator()
                                Application.shared.guestRegister = true
                                self.getUserSubscription()
                                self.app_Install_Launch()

                            }
                            else {
                                CustomProgressView.hideActivityIndicator()

                                self.getToken()
                            
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
        // return  to videoPlaying VC after intermediate login from guest user
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            
            if isFromSideMenu{
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate!.loadTabbar()
                //        self.navigationController?.popToRootViewController(animated: false)
            }
            else if isfromDeails{
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate!.loadTabbar()
            }
            else if isFromAccountScreen{
                
                self.dismiss(animated: true, completion: nil)
//                self.AccountDelegate.loadAfterIntermediateLogin()
            }
            else{
                self.dismiss(animated: true, completion: nil)
                self.backDelegate!.loadAfterIntermediateLogin()
            }
        }
        // todo ......   from subscription page login (no neeed now)
        func dismiss() {
            UIView.animate(withDuration: 0.15, animations: {
                self.view.backgroundColor=UIColor.clear
            }, completion:{ _ in
                if self.isFromSubscriptionPage {
                    
       
        self.dismiss(animated: true, completion: nil)
       
               
      } else {
        self.dismiss(animated: true, completion: nil)
      }
    })
  }
     var iconClick: Bool = true
        var iconClickS: Bool = true
        
           
    @IBAction func showPassword(_ sender: Any) {
        passwordText.isSelected = !showPassword.isSelected
        
        
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
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
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
      serachController.fromHome = false
      self.navigationController?.pushViewController(serachController, animated: false)
      print("Network not reachable")
    }
  }
  @IBAction func signInAction(_ sender: Any) {
    self.signin()
  }
    func signin(){
        loginType = "gmail login"
        
        let trimmedString = emailText!.text!.trimmingCharacters(in: .whitespaces)
        
        if (isValidEmail(testStr:trimmedString) == 1) {
            WarningDisplayViewController().customAlert(viewController:self, messages: "Enter Email")
        } else if(isValidEmail(testStr:trimmedString) == 3) {
            WarningDisplayViewController().customAlert(viewController:self, messages: "Invalid Email")
        }else if (passwordText.text?.isEmpty)!{
            WarningDisplayViewController().customAlert(viewController:self, messages: "Enter Password")
        }
            
        else if (passwordText.text!.count < 6) {
            WarningDisplayViewController().customAlert(viewController:self, messages: "Password should contain minimum of 6 characters")
        }
        else{
            if  reachability.connection != .none {
                
                Login()
            } else {
                AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
            }
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
    @objc func tapFunction(sender:UITapGestureRecognizer) {
            print("tap working")
        if isFromSubscriptionPage {
          self.dismiss(animated: false, completion: {
            let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
            watchListController.isFromSubscriptionPage = true
            UIApplication.topViewController()?.present(watchListController, animated: true, completion: nil)
          })
        } else if isFromSideMenu{
            let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
            watchListController.isFromLogin = true
            self.navigationController?.pushViewController(watchListController, animated: false)
        }
        else if isfromDeails {
          let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
            watchListController.isFromVideoDeails = true
          self.navigationController?.pushViewController(watchListController, animated: false)
        }
        else{
            
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        watchListController.isFromSubscriptionPage = false
          watchListController.isFromVideoDeails = true
        self.navigationController?.pushViewController(watchListController, animated: false)
        }
        }

  @IBAction func signUpAction(_ sender: Any) {
    if isFromSubscriptionPage {
      self.dismiss(animated: false, completion: {
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        watchListController.isFromSubscriptionPage = true
        UIApplication.topViewController()?.present(watchListController, animated: true, completion: nil)
      })
    } else if isFromSideMenu{
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        watchListController.isFromLogin = true
        self.navigationController?.pushViewController(watchListController, animated: false)
    }
    else if isfromDeails {
      let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        watchListController.isFromVideoDeails = true
      self.navigationController?.pushViewController(watchListController, animated: false)
    }
    else if isFromAccountScreen {
//      let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
//        watchListController.isFromAccountScreen = true
//      self.present(watchListController, animated: true, completion: nil)
        self.dismiss(animated: false, completion: {
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        watchListController.isFromAccountScreen = true
        UIApplication.topViewController()?.present(watchListController, animated: true, completion: nil)
        })
    }
    
    else{
    let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
    watchListController.isFromSubscriptionPage = false
      watchListController.isFromVideoDeails = true
    self.navigationController?.pushViewController(watchListController, animated: false)
    }
  }
   func goToRegisterPage(){
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
    watchListController.isFromFbLogin = true
    watchListController.fbName = self.fb_name
    watchListController.fbEmail = self.fb_email
    watchListController.fbId = self.facebook_id
    
        self.navigationController?.pushViewController(watchListController, animated: false)
    }
    func goToRegisterPageFromApele(){
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
    watchListController.isFromAppleLogin = true
    watchListController.appleName = self.apple_name
    watchListController.appleEmail = self.apple_email
        watchListController.appleId = self.apple_id
    
        self.navigationController?.pushViewController(watchListController, animated: false)
    }
  @IBAction func forgotPasswordAction(_ sender: Any) {
    if guestUserLogedIn {
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "forgotPassword") as! ForgotPasswordViewController
        watchListController.isFromSubscriptionPage = true
        self.present(watchListController, animated: true, completion: nil)

    }
    else if isFromAccountScreen{
        
        let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "forgotPassword") as! ForgotPasswordViewController
        watchListController.isFromSubscriptionPage = true
        self.present(watchListController, animated: true, completion: nil)
    }
        
    else {
      let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "forgotPassword") as! ForgotPasswordViewController
      watchListController.isFromSubscriptionPage = false
      self.navigationController?.pushViewController(watchListController, animated: false)
    }
  }

  @IBAction func skipLoginAction(_ sender: Any) {
    if  reachability.connection != .none {
      skipLogin()
    } else {
      AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
    }
  }
  func getDateAfterTenDays() -> String {
    let dateAftrTenDays =  (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let date = formatter.string(from: dateAftrTenDays)
    return date
  }
    // MARK: API Calls
       func getAllLiveVideos() {
         CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
         ApiCommonClass.getAllChannels { (responseDictionary: Dictionary) in
           if responseDictionary["error"] != nil {
             DispatchQueue.main.async {
               WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
               CustomProgressView.hideActivityIndicator()
             }
           } else {
             self.liveVideos = responseDictionary["data"] as! [VideoModel]
               self.channelVideos = responseDictionary["data"] as! [VideoModel]
             if self.liveVideos.count == 0 {
               DispatchQueue.main.async {
                 WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                 CustomProgressView.hideActivityIndicator()
               }
             } else {
               DispatchQueue.main.async {
//                   self.channelVideo = self.channelVideos[0]
                 CustomProgressView.hideActivityIndicator()
               }
             }
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

  @IBAction func LoginAction(_ sender: Any) {

  }

  func Register(email :String?,facebook_id:String?) {
    CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    let UDID = UIDevice.current.identifierForVendor?.uuidString
    var parameterDict: [String: String?] = [ : ]
    guard let email = email, let facebook_id = facebook_id,let udid = UDID else {
      return
    }
    parameterDict["user_email"] = email
    parameterDict["password"] = ""
    parameterDict["first_name"] = ""
    parameterDict["last_name"] = ""
    parameterDict["phone"] = ""
    parameterDict["device_id"] = udid
    parameterDict["device_type"] = "ios-phone"
    parameterDict["login_type"] = "facebook-login"
    parameterDict["facebook_id"] = facebook_id
    print(parameterDict)
    ApiCommonClass.Register (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        DispatchQueue.main.async {
          UserDefaults.standard.set("true", forKey: "login_status")
          CustomProgressView.hideActivityIndicator()
          let delegate = UIApplication.shared.delegate as? AppDelegate
          delegate!.loadTabbar()
          //                    let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "demofirst") as! HomeViewController
          //                    //    //self.present(videoPlayerController, animated: true, completion: nil)
          //                    self.navigationController?.pushViewController(videoPlayerController, animated: false)

        }

      }
    }
  }
    weak var AccountDelegate: AccountBackNavigationDelegate!

    func Login() {
        userDetails.removeAll()
        

        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        var parameterDict: [String: String?] = [ : ]
        guard let email = emailText.text, let password = passwordText.text else {
            return
        }
        if emailText.text != nil{
            let trimmedString = emailText!.text!.trimmingCharacters(in: .whitespaces)
            parameterDict["user_email"] = trimmedString.lowercased()

        }
        if !password.isEmpty{
            let trimmedString = password.trimmingCharacters(in: .whitespaces)
            parameterDict["password"] = trimmedString
        }
        
        
        parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
        if UserDefaults.standard.string(forKey:"countryCode") != nil{
             parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        }
        else{
            parameterDict["country_code"] = " "
        }
//         parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
             parameterDict["device_id"] = device_id
           }
        if UserDefaults.standard.string(forKey:"IPAddress") != nil{
          if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
               parameterDict["ipaddress"] = ipAddress
           }
        }
        ApiCommonClass.login(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            CustomProgressView.hideActivityIndicator()
            if let val = responseDictionary["error"] {
                DispatchQueue.main.async {
                    if responseDictionary["user_id"] == nil{
                        WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
                        CustomProgressView.hideActivityIndicator()
                    }
                    else{
                        
                        
                        CustomProgressView.hideActivityIndicator()
                        WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
//                       let vc = OTPverificationViewController()
//                       UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
//                       UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                       
//                       vc.modalPresentationStyle = .overCurrentContext
//                       vc.userid = responseDictionary["user_id"]! as! String
//                       self.present(vc, animated: false, completion: nil)
                          UserDefaults.standard.set(email.lowercased(), forKey: "user_email")
                        if self.isFromAccountScreen{
                            self.dismiss(animated: false, completion: {
                                let vc = OTPverificationViewController()
                                vc.fromLogin = true
                                vc.fromRegister = true
//                                vc.logindelegates = self
                                vc.userid = responseDictionary["user_id"]! as! String
                              UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                            })
                        }
                      
                        else{
                          
                            OTPverificationViewController.showOTPviewController(viewController: self,isFromRegister : false, userId: responseDictionary["user_id"]! as! String)
                            print(responseDictionary["user_id"])
                        }
                      
                    }
                    
                }
            } else {
                self.userDetails = responseDictionary["Channels"] as! [VideoModel]
                DispatchQueue.main.async {
                    UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                    UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                    UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                    UserDefaults.standard.set("true", forKey: "login_status")
                    UserDefaults.standard.set("false", forKey: "skiplogin_status")
                    
                    
                    if self.guestUserLogedIn == true {
                        CustomProgressView.hideActivityIndicator()
                        Application.shared.guestRegister = true
                        self.getUserSubscription()
                        self.app_Install_Launch()

                    }
                    else {
                        self.getToken()
              
                    }
                    
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
            } else {
                DispatchQueue.main.async {
                    self.app_Install_Launch()
                    self.getUserSubscriptions()
            }
        }
    }
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
                if self.isFromAccountScreen{
                    print("inside logoutall from account screen")
                   
                   
                }
                else{
                print("inside logoutall")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    self.navigationController?.pushViewController(nextViewController, animated: false)
            }

                
            } else {
                WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
            }
        }

    }
    func getUserSubscriptions() {
        ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
          if responseDictionary["forcibleLogout"] as? Bool == true {
            DispatchQueue.main.async {
                          WarningDisplayViewController().customActionAlert(viewController :self,title: "You have exceeded allowed device limit.Please log off from all your devices first and login again. \n\n\n LOGOUT ALL lets you logout from all currently active devices.", message: "", actionTitles: ["OK","LOGOUT ALL"], actions:[{action1 in
                            },{action2 in
                              self.logOUtAll()
                            }, nil])
            }
          }
          else if responseDictionary["session_expired"] as? Bool == true {
              DispatchQueue.main.async {
                            WarningDisplayViewController().customActionAlert(viewController :self,title: "Your session expired. Please Login again to access.", message: "", actionTitles: ["OK","LOGOUT"], actions:[{action1 in
                              },{action2 in
                                self.logOutdata()
                              }, nil])
              }
            }
          else if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                }
            } else {
                if self.isFromAccountScreen{
                    print("hello ytgsuqyr")
                    self.dismiss(animated: false, completion: {
                        let delegate = UIApplication.shared.delegate as? AppDelegate
                        delegate!.loadTabbar()
                    })
                   
                }
                else{
                print("loadTabbar")
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.loadTabbar()
            }

                
            }
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
                   UserDefaults.standard.removeObject(forKey: "cart_id")

                    Application.shared.userSubscriptionsArray.removeAll()
                    if self.isFromAccountScreen{
                        print("inside logoutall from account screen")
                       
                       
                    }
                    else{
                    print("inside logoutall")
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                        self.navigationController?.pushViewController(nextViewController, animated: false)
                }
                  
                } else {
                    WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
                }
        }
        
    }
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
  static func getGustUserId(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let JSONData = try?  JSONSerialization.data(
      withJSONObject: parameterDictionary,
      options: []
    )

    ApiCallManager.apiCallREST(mainUrl: GetGustUserLogin, httpMethod: "POST", headers: ["Content-Type":"application/json"], postData: JSONData) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        print("responsearray:", channelResponseArray)
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
    
  func textFieldDidEndEditing(_ textField: UITextField) {
//    self.signin()
  }
}
//extension LoginViewController: LoginMenuDelegate {
//
//    func loadHome(){
////        navigationController?.popViewController(animated: false)
//        Application.shared.guestRegister = false
////        self.gotoHome()
//      let subscriptionController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
//      subscriptionController.isFromVideoPlayingPage = true
//      self.navigationController?.pushViewController(subscriptionController, animated: false)
//    }
//}
//protocol LoginMenuDelegate: class {
//    func loadHome()
//}
