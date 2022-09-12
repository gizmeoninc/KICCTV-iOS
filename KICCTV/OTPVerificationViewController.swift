//
//  OTPverificationViewController.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 17/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Firebase
import KWVerificationCodeView
import OTPTextField
import Reachability

protocol RegisterMenuDelegate: class {
    func didSelectRegister()
    func didSelectRegisterSkip()
}
protocol GuestRegisterDelegate: class {
    func didSelectGuestRegister()
    func didSelectSkipVerification()
}
class OTPverificationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var enterOTPLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var resendlabel: UILabel!
    @IBOutlet weak var reSendButton: UIButton!
    @IBOutlet weak var otpTextField: OTPTextField!
    @IBOutlet weak var validationlabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mobileNumberLabel: UILabel!


    weak var registerdelegates : RegisterMenuDelegate?
    weak var logindelegates : LoginMenuDelegate?

    weak var guestRegisterDelegates : GuestRegisterDelegate?
    var fromRegister = Bool()
    var reachability = Reachability()!
    var countTimer:Timer!
    var counter = 60
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.mobileNumberLabel.text =  ""
        self.enterOTPLabel.textColor = ThemeManager.currentTheme().TabbarColor
       if UserDefaults.standard.string(forKey: "user_email") != nil
        {
            self.enterOTPLabel.text = "Enter the 6-digit code sent to \(UserDefaults.standard.string(forKey: "user_email") ?? "hjhj")"

        }
        self.okButton.backgroundColor = .lightGray
        self.okButton.layer.cornerRadius = 5
        self.okButton.clipsToBounds = true
        skipButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
        self.mainView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.mainView.layer.cornerRadius = 5
        self.mainView.clipsToBounds = true
        self.reSendButton.isHidden = true
        self.resendlabel.isHidden = true
        self.countDownLabel.isHidden = true
        self.reSendButton.isHidden = true
        self.validationlabel.isHidden = true
        self.okButton.isEnabled = false
       // verificationCodeView.delegate = self
       self.reSendButton.setTitleColor(ThemeManager.currentTheme().UIImageColor, for: .normal)
        // Do any additional setup after loading the view.
        otpTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                             target: self,
                                             selector: #selector(self.changeTitle),
                                             userInfo: nil,
                                             repeats: true)
                 WarningDisplayViewController().customAlert(viewController:self, messages: "Please check your email for verification code.if not found in your Inbox,Please check the SPAM folder")
        if fromLogin{
            print("fromLogin")
            self.isFromAccountScreen = true
            self.fromRegister = true

//            self.logindelegates = self as? LoginMenuDelegate
            
        }

      //self.otpTextField.delegate = self
    }
   
    func dismiss() {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func didCallRegisterApi() {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: {
                if Application.shared.isFromRegister {
                  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                  let subscriptionController = storyBoard.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
                  self.navigationController?.pushViewController(subscriptionController, animated: false)
//                    self.registerdelegates?.didSelectRegister()

                } else {
                    self.guestRegisterDelegates?.didSelectGuestRegister()
//                        let subscriptionController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
//                        subscriptionController.isFromVideoPlayingPage = true
//                        self.navigationController?.pushViewController(subscriptionController, animated: false)
                }
            })
        })
//      let subscriptionController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
//      subscriptionController.isFromVideoPlayingPage = true
//      self.navigationController?.pushViewController(subscriptionController, animated: false)
    }
    func didCallLoginApi() {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: {
                print("hello")
                self.logindelegates?.loadHome()
            })
        })
    }
    func didClickSkipRegisterd(){
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: {
                if Application.shared.isFromRegister {
                    self.registerdelegates?.didSelectRegisterSkip()
                } else {
                    self.guestRegisterDelegates?.didSelectSkipVerification()
                }
            })
        })
    }
   @objc func changeTitle() {
    if counter != 0 {
      self.resendlabel.isHidden = false
      self.countDownLabel.isHidden = false
      self.reSendButton.isHidden = true
      countDownLabel.text = String(counter)
      counter -= 1
    } else {
      countTimer.invalidate()
      countDownLabel.text = "60"
      self.resendlabel.isHidden = true
      self.countDownLabel.isHidden = true
      self.reSendButton.isHidden = false
    }
  }
    var userid = String()

    public class func showOTPviewController(viewController : UIViewController,isFromRegister : Bool,userId:String?) {
//         WarningDisplayViewController().customAlert(viewController:self, messages: "Otp send to email please check spam")
        CustomProgressView.hideActivityIndicator()
        let userid = userId
        Application.shared.isFromRegister = isFromRegister
        let vc = OTPverificationViewController()
        if isFromRegister {
          vc.registerdelegates = viewController as? RegisterMenuDelegate
        } else {
            vc.isFromAccountScreen = true
            vc.fromRegister = true

            vc.logindelegates = viewController as? LoginMenuDelegate

//          vc.guestRegisterDelegates = viewController as? GuestRegisterDelegate
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.userid = userid!
        viewController.present(vc, animated: true, completion: nil)
    }

    @IBAction func resendAction(_ sender: Any) {
      self.validationlabel.isHidden = true
      self.okButton.isEnabled = true
      self.okButton.backgroundColor = .lightGray
      if  reachability.connection != .none {
        let UDID = UIDevice.current.identifierForVendor?.uuidString
        let udid = UDID
        var parameterDict: [String: String?] = [ : ]
//        parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
//        parameterDict["user_id"] = self.userid
//        parameterDict["device_id"] = udid
//        if UserDefaults.standard.string(forKey:"IPAddress") != nil {
//          let IPAddress = UserDefaults.standard.string(forKey:"IPAddress")!
//            parameterDict["ipaddress"] = IPAddress
//        }
//        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = self.userid
         let country_code = UserDefaults.standard.string(forKey:"countryCode")!
         let pubid = UserDefaults.standard.string(forKey:"pubid")!
         let device_type = "ios-phone"
         let dev_id = UserDefaults.standard.string(forKey:"UDID")!
         let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
         let channelid = UserDefaults.standard.string(forKey:"channelid")!
         let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
              print("parameterDictionary",parameterDict)
                
//        let accesToken = UserDefaults.standard.string(forKey:"access_token")!

        let otpVerification = ApiRESTUrlString().resendOtp(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: otpVerification!, httpMethod: "GET", headers: ["access-token": " ","uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
//                 if let getTokenApi = ApiRESTUrlString().getFreeShows(parameterDictionary: parameterDict as? Dictionary<String, String>) {
                guard let status = responseDictionary["success"] as? Bool  else {
                  return
                }
                if status == true{
                    print("otp send to email")
                }
                DispatchQueue.main.async {
                    CustomProgressView.hideActivityIndicator()
                     self.otpTextField.text?.removeAll()
                    self.counter = 60
                              self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                                                     target: self,
                                                                     selector: #selector(self.changeTitle),
                                                                     userInfo: nil,
                                                                     repeats: true)
                           
                              self.reSendButton.isHidden = true
                              self.resendlabel.isHidden = false
                              self.countDownLabel.isHidden = false
                }
                
                
                  
              }
            
          
        
//        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber")
//        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
//          if let error = error {
//            CustomProgressView.hideActivityIndicator()
//            Application.showAlert(onViewController: self, title: "There was an error \n sending the SMS code", message: error.localizedDescription, actionTitle: "OK", cancelButton: false, handler: nil)
//            return
//          }
//          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//          CustomProgressView.hideActivityIndicator()
//          self.counter = 15
//          self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
//                                                 target: self,
//                                                 selector: #selector(self.changeTitle),
//                                                 userInfo: nil,
//                                                 repeats: true)
//          self.reSendButton.isHidden = true
//          self.resendlabel.isHidden = false
//          self.countDownLabel.isHidden = false
//        }
      } else {
        AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
      }

    }
    var userDetails = [userModel]()
var accesstoken = String()
    @IBAction func okButtonAction(_ sender: Any) {
      otpTextField.resignFirstResponder()
       if otpTextField.text?.count == 6 {
//            CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
            let verificationCode = otpTextField.text
        var parameterDict: [String: String?] = [ : ]
//         parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
//        parameterDict["user_id"] = self.userid
        parameterDict["otp"] = verificationCode
               let user_id = self.userid
               let country_code = UserDefaults.standard.string(forKey:"countryCode")!
               let pubid = UserDefaults.standard.string(forKey:"pubid")!
               let device_type = "ios-phone"
               let dev_id = UserDefaults.standard.string(forKey:"UDID")!
               let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
               let channelid = UserDefaults.standard.string(forKey:"channelid")!
               let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
//        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
         if UserDefaults.standard.string(forKey:"access_token") == nil {
            self.accesstoken = " "
            
                 }
         else{
            self.accesstoken = UserDefaults.standard.string(forKey:"access_token")!
        }
        let otpVerification = ApiRESTUrlString().verifyOtp(parameterDictionary: parameterDict as? Dictionary<String, String>)
        
        ApiCallManager.apiCallREST(mainUrl: otpVerification!, httpMethod: "GET", headers: ["access-token": self.accesstoken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: parameterDict as? Data) { (responseDictionary: Dictionary) in
                var channelResponseArray = [userModel]()
                var channelResponse = Dictionary<String, AnyObject>()
                guard let status: Int = responseDictionary["success"] as? Int else { return }
                if status == 0{
                            print("incorrect otp")
                    DispatchQueue.main.async {
                        CustomProgressView.hideActivityIndicator()
                        WarningDisplayViewController().customAlert(viewController:self, messages: "Incorrect OTP")
                        self.otpTextField.text?.removeAll()
                    }
                    
                }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: userModel = userModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                  
                    
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
                self.userDetails = channelResponse["Channels"] as! [userModel]
                if self.userDetails.count != 0 {
                    print(self.userDetails[0])
                    DispatchQueue.main.async {
                        UserDefaults.standard.string(forKey: "first_name")
                        UserDefaults.standard.set(self.userDetails[0].phone, forKey: "user_contact_number")
                        UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                        UserDefaults.standard.set("true", forKey: "login_status")
                        UserDefaults.standard.set("false", forKey: "skiplogin_status")
                        UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                        UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                       self.gotoHome()
                    }
                    
                }
                
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            
        }

     
        
       } else {
        self.validationlabel.isHidden = false
        self.otpTextField.layer.shadowColor = ThemeManager.currentTheme().UIImageColor.cgColor
      }
    }
    func gotoHomeAferVerification(){
        UIView.animate(withDuration: 0.15, animations: {
                  self.view.backgroundColor=UIColor.clear
              }, completion:{ _ in
                  self.dismiss(animated: true, completion: {
//                    navigationController?.popViewController(animated: false)
                           Application.shared.guestRegister = false
                           self.gotoHome1()
                  })
              })
       
    }
      func gotoHome1(){
//            self.dismiss(animated: true, completion: nil)
    //        getUserSubscription()
            let delegate = UIApplication.shared.delegate as? AppDelegate
                                            delegate!.loadTabbar()
        }
    var fromLogin = false
    var isFromAccountScreen = false
    func gotoHome(){
        if UserDefaults.standard.string(forKey:"access_token") == nil {
          self.getTokenForAuthentication()
        }
        else{
            self.app_Install_Launch()

        }
        if fromRegister{
            UserDefaults.standard.set("1", forKey: "verifiedNumber")
            CustomProgressView.hideActivityIndicator()
            if isFromAccountScreen {
//                if fromLogin{
//                    loadHome()
                  let subscriptionController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
                  subscriptionController.isFromVideoPlayingPage = true
                  self.navigationController?.pushViewController(subscriptionController, animated: false)
//                }
//                else{
//                    didCallLoginApi()
//                }
            }
            else{
            self.didCallRegisterApi()
            }
        }
        else{
            UserDefaults.standard.set("1", forKey: "verifiedNumber")
                       CustomProgressView.hideActivityIndicator()
            if (UserDefaults.standard.string(forKey: "skiplogin_status") != nil) == true{
                self.didCallRegisterApi()

            }
            else{
              let subscriptionController = self.storyboard?.instantiateViewController(withIdentifier: "subscriptionView") as! SubscriptionViewController
              subscriptionController.isFromVideoPlayingPage = true
              self.navigationController?.pushViewController(subscriptionController, animated: false)
//                gotoHomeAferVerification()

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
    func loadHome(){
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: {
                print("hello")
                self.logindelegates?.loadHome()
            })
        })
    }
    @IBAction func skipButtonAction(_ sender: Any) {
        UserDefaults.standard.set("0", forKey: "verifiedNumber")
        self.didClickSkipRegisterd()
    }
   @IBAction func closeButtonAction(_ sender: Any) {
     self.dismiss()
  }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
       self.validationlabel.isHidden = true
      if textField.text?.count == 6 {
        self.okButton.isEnabled = true
        self.okButton.backgroundColor = ThemeManager.currentTheme().TabbarColor
      } else {
        self.okButton.isEnabled = true
        self.okButton.backgroundColor = .lightGray
      }
    }
}
