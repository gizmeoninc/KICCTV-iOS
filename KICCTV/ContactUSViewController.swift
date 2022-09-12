//
//  ContactUSViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 14/03/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import MessageUI
class ContactUSViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
  @IBOutlet weak var AccountDeletionLabel: UILabel!
  @IBOutlet weak var contactusLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var versionLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var emailButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var mainviewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainviewWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.versionLabel.text = "Thank you for using our app."
//        self.mainView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor

      self.mainView.backgroundColor = .black

//        self.logoImageView.image = UIImage(named: ThemeManager.currentTheme().logoImage)
//        self.logoImageView.image = AppHelper.imageScaledToSize(image: UIImage(named: ThemeManager.currentTheme().navigationControllerLogo)!, newSize: CGSize(width: 110, height: 30))
//        self.cancelButton.setTitleColor(ThemeManager.currentTheme().UIImageColor, for: .normal)
//        self.emailButton.setTitleColor(ThemeManager.currentTheme().TabbarColor, for: .normal)

      self.navigationItem.title = "Contact Us"

      self.AccountDeletionLabel.textAlignment = .center

      self.AccountDeletionLabel.isUserInteractionEnabled = true

      let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))

      AccountDeletionLabel.addGestureRecognizer(guestureRecognizer)

        self.emailButton.setTitle(ThemeManager.currentTheme().emailAddress, for: .normal)
        emailButton.titleLabel?.numberOfLines = 1
        self.mainView.layer.cornerRadius = 5
        self.mainView.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.mainviewWidth.constant = 400
                       self.mainviewHeight.constant = 400
            self.versionLabel.font = UIFont.boldSystemFont(ofSize: 25)
            self.contactUsLabel.font = UIFont.boldSystemFont(ofSize: 25)
            self.emailButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 25)
//            self.cancelButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 25)
            self.contactusLabelHeight.constant = 80
            self.versionLabelHeight.constant = 60
            self.emailButtonHeight.constant = 60
//            self.cancelButtonHeight.constant = 60


            
             } else {
               
           self.mainviewWidth.constant = 230
                     self.mainviewHeight.constant = 261
             }
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public class func showFromContactUs(viewController : UITabBarController) {
        let vc = ContactUSViewController()
        vc.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
        }
        viewController.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func emailAction(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }

  @objc func labelClicked(_ sender: Any) {
        print("UILabel clicked")
    DispatchQueue.main.async {
      WarningDisplayViewController().customActionAlert(viewController :self,title: "Are you sure you want to delete your account?", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
        },{action2 in
          self.DeleteAccount()
        }, nil])
    }
  }

  func DeleteAccount() {
    print("delete account")
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

    ApiCommonClass.UserDeletion(parameterDictionary: parameterDict as? Dictionary<String, String>){ (result) -> () in
              print(result)
              if result {
                  UserDefaults.standard.removeObject(forKey: "user_id")
                  UserDefaults.standard.removeObject(forKey: "login_status")
                  UserDefaults.standard.removeObject(forKey: "first_name")
                  UserDefaults.standard.removeObject(forKey: "skiplogin_status")
                  UserDefaults.standard.removeObject(forKey: "access_token")
                  Application.shared.userSubscriptionsArray.removeAll()
                
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate!.loadTabbar()
//                  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                  let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//                  self.navigationController?.pushViewController(nextViewController, animated: false)
              } else {
                  WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
              }
      }

  }

//    @IBAction func cancelAction(_ sender: Any) {
//        dismiss()
//    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([ThemeManager.currentTheme().emailAddress])
        mailComposerVC.navigationBar.tintColor = ThemeManager.currentTheme().TabbarColor
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        WarningDisplayViewController().customAlert(viewController:self, messages: "Could Not Send Email ")
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    func dismiss()
    {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: false, completion: nil)
        })    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
