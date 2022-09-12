//
//  TVActivationViewContoller.swift
//  Discover
//
//  Created by GIZMEON on 20/01/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class ActivationVC: UIViewController {
    @IBOutlet weak var mainView: UIView!
    
//    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
//
//    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
//
    
    @IBOutlet weak var subHeader1: UILabel!
    @IBOutlet weak var subHeader3: UILabel!
    
    @IBOutlet weak var subHeader2: UILabel!
    
    
    var ActivationCode = Int()
    @IBOutlet weak var generateCodeButton: UIButton!
    @IBOutlet weak var EnterCodeLabel: UILabel!
    
    @IBOutlet weak var TitleHeader: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!{
        didSet{
//            TimerLabel.isHidden = true
        }
    }
    var countTimer:Timer!
    var counter = 300
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.mainView.backgroundColor = .clear
     
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        generateCodeButton.backgroundColor = ThemeManager.currentTheme().TabbarColor
        generateCodeButton.setTitle("Generate Code", for: .normal)
        generateCodeButton.isHidden = false
        generateCodeButton.layer.cornerRadius = 8
        generateCodeButton.titleLabel?.textColor = .black
        generateCodeButton.titleLabel?.textAlignment = .center
        EnterCodeLabel.isHidden = false
        EnterCodeLabel.text = "Activation code"
        EnterCodeLabel.backgroundColor = .clear
//        EnterCodeLabel.layer.borderColor = UIColor.white.cgColor
//        EnterCodeLabel.layer.borderWidth = 2.0
        EnterCodeLabel.textAlignment = .center
        EnterCodeLabel.textColor = ThemeManager.currentTheme().TabbarColor
        TimerLabel.textAlignment = .center
        
        self.navigationItem.title = "Sign in with TV"
        

    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss()
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
       TimerLabel.text = "Code expires in \(x)"
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
    @IBAction func generateCode(_ sender: Any) {
        

        self.showAlert()
            
    }
    
    
  func showAlert(){
    WarningDisplayViewController().customActionAlert(viewController :self,title: "Do you want to generate TV Activation Code?", message: "", actionTitles: ["No","Yes"], actions:[{action1 in self.cancelAlertAction()},{action2 in
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
    
    public class func showFromActivation(viewController : UITabBarController) {
        print("show")
        let vc = ActivationVC()
        vc.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
        }
        viewController.present(vc, animated: false, completion: nil)
    }
    func dismiss()
    {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: false, completion: nil)
        })    }
}
