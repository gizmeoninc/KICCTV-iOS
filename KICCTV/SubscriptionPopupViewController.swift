//
//  SubscriptionPopupViewController.swift
//  KICCTV
//
//  Created by Firoze Moosakutty on 24/08/22.
//  Copyright © 2022 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionPopupViewController: UIViewController{

  @IBOutlet weak var loginButton: UIButton!{
    didSet{
        self.loginButton.backgroundColor = ThemeManager.currentTheme().ThemeColor

        self.loginButton.layer.cornerRadius = 8.0
        self.loginButton.layer.masksToBounds = true
    }
  }

  @IBOutlet weak var subscribeButton: UIButton!{
    didSet{
        self.subscribeButton.backgroundColor = ThemeManager.currentTheme().ThemeColor

        self.subscribeButton.layer.cornerRadius = 8.0
        self.subscribeButton.layer.masksToBounds = true
    }
  }

  @IBOutlet weak var orLabel: UILabel!
  @IBAction func loginButtonAction(_ sender: Any) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
    self.navigationController?.pushViewController(nextViewController, animated: false)

  }

  @IBAction func subscribeButtonAction(_ sender: Any)
  {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
    self.navigationController?.pushViewController(nextViewController, animated: false)
  }
  
  //  var noResultView = UIView()
  override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
      view.tintColor = UIColor.blue
//      warningTextLabel?.lineBreakMode = .byWordWrapping
//      warningTextLabel!.numberOfLines = 2
      // Do any additional setup after loading the view.
  }
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  public class func showFromSubscriptionPopup(viewController : UITabBarController) {
      let vc = SubscriptionPopupViewController()
      vc.modalPresentationStyle = .overCurrentContext
      DispatchQueue.main.async {
      }
      viewController.present(vc, animated: false, completion: nil)
  }
  
//  func customActionAlert(viewController : UIViewController,title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
//      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//      alert.view.tintColor = UIColor().colorFromHexString("207CFF")
//      for (index, title) in actionTitles.enumerated() {
//          let action = UIAlertAction(title: title, style: .default, handler: actions[index])
//          alert.addAction(action)
//      }
//      viewController.present(alert, animated: true, completion: nil)
//  }
//  func noResultview(view : UIView,title: String?) {
//      noResultView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
//      noResultView.backgroundColor = ThemeManager.currentTheme().backgroundColor
//      view.addSubview(noResultView)
//      let imageName = "icons8-retro-tv"
//      let image = UIImage(named: imageName)
//      let imageView = UIImageView(image: image!)
//      imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//      imageView.center = noResultView.center
//      noResultView.addSubview(imageView)
//      let label = UILabel()
//      label.frame = CGRect(x: 8, y: (view.center.y + 25), width: view.frame.width - 16, height: 75)
//      noResultView.addSubview(label)
//      label.textAlignment = .center
//      label.text = title
//      label.textColor = UIColor.darkGray
//      label.font = UIFont.boldSystemFont(ofSize: 20.0)
//  }

}
