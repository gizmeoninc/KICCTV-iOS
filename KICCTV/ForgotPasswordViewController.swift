//
//  ForgotPasswordViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 09/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Reachability

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate  {


  @IBOutlet weak var contentView: UIView!{
    didSet {
      self.contentView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
    }
  }
  @IBOutlet weak var logoImage: UIImageView!{
    didSet {
       self.logoImage.image = UIImage(named: ThemeManager.currentTheme().logoImage)
    }
  }
  @IBOutlet weak var submitOutlet: UIButton! {
    didSet{
       self.submitOutlet.backgroundColor = ThemeManager.currentTheme().TabbarColor
//        self.submitOutlet.backgroundColor =  UIColor(white: 1, alpha: 0.3)

       self.submitOutlet.layer.cornerRadius = 20.0
    }
  }
  @IBOutlet weak var emailText: UITextField! {
    didSet{
      self.emailText.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
      self.emailText.textColor = ThemeManager.currentTheme().textfeildColor
      self.emailText.tintColor = ThemeManager.currentTheme().UIImageColor
//      emailText.setBottomBorder()
      self.emailText.delegate = self
    }
  }

    var reachability = Reachability()!
     var isFromSubscriptionPage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0.0, y: emailText.frame.height - 1, width: view.frame.width - 50, height: 1.0)
        bottomLine1.backgroundColor = UIColor.white.cgColor
        emailText.borderStyle = UITextField.BorderStyle.none
        emailText.layer.addSublayer(bottomLine1)
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //declare this inside of viewWillAppear
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.restrictRotation = .portrait
    }
  }

    @IBAction func submitAction(_ sender: Any) {
       submitAction()
    }

    @IBAction func backToLoginAction(_ sender: Any) {
    }
    func submitAction() {
    if (RegisterViewController().isValidEmail(testStr:emailText!.text! ) == 1) {
    WarningDisplayViewController().customAlert(viewController:self, messages: "Enter Email")
    print("enter Email")


    }else if(RegisterViewController().isValidEmail(testStr:emailText!.text! ) == 3){
    print("Invalid Email")
    WarningDisplayViewController().customAlert(viewController:self, messages: "Invalid Email")

    }else{
    if  reachability.connection != .none {
    forgotPassword()
    }
    }
}
    func forgotPassword() {
        CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
        var parameterDict: [String: String?] = [ : ]
        guard let email = emailText.text else {
            return
        }
        parameterDict["user_email"] = email.lowercased()
        parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
        print(parameterDict)
        ApiCommonClass.ForgotPassword (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    CustomProgressView.hideActivityIndicator()

                    WarningDisplayViewController().customAlert(viewController:self, messages: "This email id is not registered with KICCTV.")
                }
            } else {

                DispatchQueue.main.async {
                    let message = responseDictionary["Channels"] as! String
                    print(message)
                    if message != "Invalid user" {
                      WarningDisplayViewController().customAlert(viewController:self, messages: "Please check your mail")
                    CustomProgressView.hideActivityIndicator()
                    }else {
                        WarningDisplayViewController().customAlert(viewController:self, messages: message)
                        CustomProgressView.hideActivityIndicator()
                    }
                }
            }
        }
    }
  @IBAction func loginHomePAge(_ sender: Any) {
    if isFromSubscriptionPage {
       self.dismiss(animated: true, completion: nil)
    } else{
       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
       self.navigationController?.pushViewController(nextViewController, animated: false)
    }
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
        submitAction()
    }
}
