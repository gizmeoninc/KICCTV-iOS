//
//  TVActivationVC.swift
//  Discover
//
//  Created by GIZMEON on 01/02/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class TVActivationVC: UIViewController {
    
    @IBOutlet weak var TitleHeader: UILabel!
    
    @IBOutlet weak var subHeader1: UILabel!
    @IBOutlet weak var subHeader2: UILabel!
    @IBOutlet weak var subHeader3: UILabel!
    
    @IBOutlet weak var EnterCodeLabel: UILabel!
    
    @IBOutlet weak var generateCodeButton: UIButton!
    
    
    @IBOutlet weak var TimerLabel: UILabel!
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    var ActivationCode = Int()
    var countTimer:Timer!
    var counter = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.mainView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
        self.mainView.layer.cornerRadius = 5
        self.mainView.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        subHeader1.text = "1.Open the Discover Wisconsin app installed on your TV."
        generateCodeButton.backgroundColor = ThemeManager.currentTheme().TabbarColor
        generateCodeButton.setTitle("Generate code", for: .normal)
        generateCodeButton.isHidden = false
        generateCodeButton.layer.cornerRadius = 8
        generateCodeButton.titleLabel?.textColor = .black
        generateCodeButton.titleLabel?.textAlignment = .center
        EnterCodeLabel.isHidden = false
        EnterCodeLabel.text = ""
        EnterCodeLabel.backgroundColor = .clear
//        EnterCodeLabel.layer.borderColor = UIColor.white.cgColor
//        EnterCodeLabel.layer.borderWidth = 2.0
        EnterCodeLabel.textAlignment = .center
        EnterCodeLabel.textColor = ThemeManager.currentTheme().TabbarColor
        TimerLabel.textAlignment = .center
        
        
          if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
              self.mainViewWidth.constant = 400
              self.mainViewHeight.constant = 400
            self.TitleHeader.font = UIFont.boldSystemFont(ofSize: 30)
            self.subHeader2.font =  UIFont.systemFont(ofSize: 24, weight: .regular)

            self.TimerLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)

             
          }
          else{
              self.mainViewWidth.constant = view.frame.width - 100
              self.mainViewHeight.constant = 261
          }
        
    }
    
    
    
    @IBAction func generateVerificationCode(_ sender: Any) {
        self.showAlert()
    }
    
    
    func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    @objc func changeTitle() {
     if counter != 0 {
        self.generateCodeButton.isEnabled = false
        self.generateCodeButton.backgroundColor = .lightGray
//        self.TitleHeader.text = "You can enter this 5 digit code on BoondockNation Tv apps and activate."

//       self.resendlabel.isHidden = false
       self.TimerLabel.isHidden = false
//       self.reSendButton.isHidden = true
        let x = timeString(time: TimeInterval(counter))
       TimerLabel.text = "Code will expire in \(x)"
       counter -= 1
     } else {
       countTimer.invalidate()
        self.generateCodeButton.isEnabled = true
        self.generateCodeButton.backgroundColor = ThemeManager.currentTheme().TabbarColor
        self.EnterCodeLabel.text = "Code expired"
//        self.TitleHeader.text = "Please click below to generate BoondockNation Tv apps activation code."

//       self.resendlabel.isHidden = true
       self.TimerLabel.isHidden = true
        self.counter = 300
//       self.reSendButton.isHidden = false
     }
   }
    func showAlert(){
      WarningDisplayViewController().customActionAlert(viewController :self,title: "Do you want to generate TV Activation code?", message: "", actionTitles: ["No","Yes"], actions:[{action1 in self.cancelAlertAction()},{action2 in
                             self.generateCodeApi()
                         },nil])
      }
    func cancelAlertAction(){
        
    }
    func generateCodeApi(){
        ApiCommonClass.ActivateTv(parameterDictionary: nil) { (responseDictionary: Dictionary) in
            print("response",responseDictionary)
            if let val = responseDictionary["error"] {
                DispatchQueue.main.async {
                    WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
                    CustomProgressView.hideActivityIndicator()
                    
                }
                
            }
            else{
                DispatchQueue.main.async { [self] in
                    if let code = responseDictionary["code"]{
                        self.ActivationCode = code as! Int
                        self.EnterCodeLabel.isHidden = false
                        self.EnterCodeLabel.text = String(ActivationCode)
                        
                        
                    }
                    if let message = responseDictionary["message"]{
                        print("message",message)
                    }
                    self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                                         target: self,
                                                         selector: #selector(self.changeTitle),
                                                         userInfo: nil,
                                                         repeats: true)
                }
                
            }
        }
    }
    public class func showActivationPopup(viewController : UITabBarController) {
        print("show")
        let vc = TVActivationVC()
        vc.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
        }
        viewController.present(vc, animated: false, completion: nil)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    func dismiss()
    {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: false, completion: nil)
        })    }
}
