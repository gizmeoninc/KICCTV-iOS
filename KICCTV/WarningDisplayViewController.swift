//
//  WarningDisplayViewController.swift
//  OfferCloud_Swift
//
//  Created by Gizmeon on 14/01/18.
//  Copyright © 2018 Rukmini KR. All rights reserved.
//

import UIKit

class WarningDisplayViewController: UIViewController {
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var warningViewHeight: NSLayoutConstraint!
    @IBOutlet weak var warningTextLabel: UILabel?
    
    var noResultView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white.withAlphaComponent(0.6)
        view.tintColor = UIColor.blue
        warningTextLabel?.lineBreakMode = .byWordWrapping
        warningTextLabel!.numberOfLines = 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func okAction(_ sender: Any) {
        dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public class func showFromViewController(viewController : UIViewController , message : String, messageType : String , delegate : (Any)) {
        let vc = WarningDisplayViewController()
        vc.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
            vc.warningTextLabel?.text = message
            vc.okButton .setTitle("OK", for: .normal)
            vc.calculateWarningviewHeight()
        }
        viewController.present(vc, animated: false, completion: nil)
    }
    
    func calculateWarningviewHeight() {
        
        let textHeight = warningTextLabel?.text?.height(withConstrainedWidth: UIScreen .main .bounds.size.width-66, font: (warningTextLabel?.font)!)
        warningViewHeight.constant = 100.0 + textHeight!
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func customAlert(viewController : UIViewController ,messages :String) {
        
        let alert = UIAlertController(title: messages, message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor().colorFromHexString("207CFF")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func customActionAlert(viewController : UIViewController,title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor().colorFromHexString("207CFF")
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func noResultview(view : UIView,title: String?) {
        noResultView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        noResultView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        view.addSubview(noResultView)
        let imageName = "icons8-retro-tv"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = noResultView.center
        noResultView.addSubview(imageView)
        let label = UILabel()
        label.frame = CGRect(x: 8, y: (view.center.y + 25), width: view.frame.width - 16, height: 75)
        noResultView.addSubview(label)
        label.textAlignment = .center
        label.text = title
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
    }
}
