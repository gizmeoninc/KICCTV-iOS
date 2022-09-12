//
//  PopupViewController.swift
//  Mongol
//
//  Created by GIZMEON on 22/03/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
protocol AccountBackNavigationDelegate:class {
    func loadAfterIntermediateLogin()
}
class PopupViewController: UIViewController,AccountBackNavigationDelegate {
    @IBOutlet weak var ClosButton: UIButton!{
        didSet{
            self.ClosButton.tintColor = .white

        }
    }
    @IBOutlet weak var ImageView: UIImageView!{
        didSet{
//            ImageView.image = #imageLiteral(resourceName: "40_400 (2)")
//            ImageView.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var Header: UILabel!{
        didSet{
            self.Header.text =  "Free TV \nUnlimited Movies \nFree Registration"
        }
    }
    @IBOutlet weak var DescriptionLabel: UILabel!{
        didSet{
//            self.DescriptionLabel.text = "Add TV shows and Movies to My List to watch later.Get unlimited access to your Favourite Shows and Movies all your devices."
        }
    }
    @IBOutlet weak var SignupButton: UIButton!{
        didSet{
            SignupButton.layer.cornerRadius = 8
            SignupButton.backgroundColor = ThemeManager.currentTheme().ThemeColor
            
        }
    }
    @IBOutlet weak var SignInLabel: UILabel!{
        didSet{
            SignInLabel.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var PrivacyLabel: UILabel!
    
    @IBOutlet weak var termsOfUseLabel: UILabel!
    @IBOutlet weak var seperatorLabel: UILabel!
    var myString:NSString = "Have an account? Sign In"
    var myMutableString = NSMutableAttributedString()
    override func viewDidLoad() {
        super.viewDidLoad()
      

        self.view.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
        self.view.layer.cornerRadius = 8
        self.view.layer.masksToBounds = true
        let attributedString = NSMutableAttributedString(string: "Free TV \nUnlimited Movies  \nFree Registration")
        let attributedString1 = NSMutableAttributedString(string: "Add TV shows and Movies to My List to watch later.Get unlimited access to your Favourite Shows and Movies all your devices.")
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 16 // Whatever line spacing you want in points

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        // *** Set Attributed String to your label ***
        Header.attributedText = attributedString
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle1 = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle1.lineSpacing = 6 // Whatever line spacing you want in points

        // *** Apply attribute to string ***
        attributedString1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle1, range:NSMakeRange(0, attributedString.length))
        DescriptionLabel.attributedText = attributedString1
        let tap = UITapGestureRecognizer(target: self, action: #selector(signInTap(sender:)))
        SignInLabel.addGestureRecognizer(tap)
        SignInLabel.isUserInteractionEnabled = true
       
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-SemiBold", size: 17.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().TabbarColor, range: NSRange(location:16,length:8))
           // set label Attribute
        self.SignInLabel.attributedText = myMutableString
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.goToTermsAndConditions(_:)))
        self.termsOfUseLabel.addGestureRecognizer(tap1)
        self.termsOfUseLabel.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.goToPrivacyPolicy(_:)))
        self.PrivacyLabel.addGestureRecognizer(tap2)
        self.PrivacyLabel.isUserInteractionEnabled = true
    }
    @objc func backAction(_ sender: Any){
          self.navigationController?.popViewController(animated: true)
    }
    func loadAfterIntermediateLogin(){
        print("hjgcjahvhvc")
//        self.dismiss(animated: true, completion: nil)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate!.loadTabbar()
    }
    @objc func signInTap(sender:UITapGestureRecognizer) {
          print("tap working")
//        self.dismiss(animated: true, completion: nil)
//        let delegate = UIApplication.shared.delegate as? AppDelegate
        self.dismiss(animated: false, completion: {
            let loginController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController // move to login page from guest user                                                                                                                       login
            loginController.isFromAccountScreen = true
//            loginController.AccountDelegate = self
            loginController.modalPresentationStyle = .fullScreen

          UIApplication.topViewController()?.present(loginController, animated: true, completion: nil)
        })
//        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController // move to login page from guest user                                                                                                                       login
////        loginController.isFromAccountScreen = true
//        loginController.AccountDelegate = self
//        self.present(loginController, animated: true, completion: nil)
      }
    
    @IBAction func signUpAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
          let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController

          watchListController.isFromAccountScreen = true
          watchListController.modalPresentationStyle = .fullScreen

          UIApplication.topViewController()?.present(watchListController, animated: true, completion: nil)
        })
    }
    
    
    @IBAction func CloseButtonOnclick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    public class func showFromContactUs(viewController : UITabBarController) {
        let vc = PopupViewController()
        print("hgufjkdt")
        vc.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
        }
        viewController.present(vc, animated: false, completion: nil)
    }
    @objc func goToTermsAndConditions(_ recognizer: UITapGestureRecognizer) {
        print("go to terms")
   
        self.dismiss(animated: false, completion: {
           
            
            let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
            watchListController.webUrl = ThemeManager.currentTheme().TermsAndConditionURL
            watchListController.titles = "Terms of Use"
            UIApplication.topViewController()?.navigationController?.pushViewController(watchListController, animated: true)
        })

    }
    @objc func goToPrivacyPolicy(_ recognizer: UITapGestureRecognizer) {
        print("priacy policy")
        self.dismiss(animated: false, completion: {
           
            
            let watchListController = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
            watchListController.webUrl = ThemeManager.currentTheme().PrivacyPolicyURL
            watchListController.titles = "Privacy Policy"
            UIApplication.topViewController()?.navigationController?.pushViewController(watchListController, animated: true)
        })
        

    }
    
    
}




