//
//  AboutusViewController.swift
//  Mongol
//
//  Created by GIZMEON on 29/03/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class AboutusViewController: UIViewController {
    
    @IBOutlet weak var AboutusLabel: UILabel!
    @IBOutlet weak var PrivacyLabel: UIButton!
    @IBOutlet weak var TermsofuseLabel: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        PrivacyLabel.imageEdgeInsets = UIEdgeInsets(top: 0, left:view.frame.width - 60, bottom: 0, right:0)
        PrivacyLabel.tintColor = .white
        TermsofuseLabel.imageEdgeInsets = UIEdgeInsets(top: 0, left:view.frame.width - 60, bottom: 0, right:0)
        TermsofuseLabel.tintColor = .white
//        AboutusLabel.text = "Sinumas TV is a live streaming app that lets you view and enjoy your favourite TV shows and movies.There are 10000+ videos on demand contents including shows,short films,movies available in Sinumas TV.This is a large streaming platform with drama and movie content in various genres.Sinumas TV features some of the best shows and movies."
        let attributedString = NSMutableAttributedString(string: "KICCTV reaches no less than 140 million homes across Europe, Africa and parts of the Middle East on three leading satellite platforms. In the UK and Ireland, KICCTV is available through Sky, the premier subscription television platform, offering a vast range of services to over 10.5 million active subscribers in the UK alone.")

//      let attributedString = NSMutableAttributedString(string: "KICCTV, The Ultimate Gaming Network, is the first 24/7 streaming and on-demand TV network dedicated to covering land-based and online casino gaming content!")

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        // *** Set Attributed String to your label ***
        AboutusLabel.attributedText = attributedString
        setupNavigationbar()
    }
    

func setupNavigationbar(){
    self.navigationItem.title = "About Us"

    let newBackButton = UIButton(type: .custom)
    newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
    newBackButton.contentMode = .scaleAspectFit
    newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
    newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
    newBackButton.addTarget(self, action: #selector(AboutusViewController.backAction), for: .touchUpInside)
    let item2 = UIBarButtonItem(customView: newBackButton)
    self.navigationItem.leftBarButtonItem = item2
}
    @objc func backAction(_ sender: Any) {
      navigationController?.popViewController(animated: true)
    }
    @IBAction func loadPrivacyPolicy(_ sender: Any) {
        print("loadPrivacyPolicy")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let watchListController = storyBoard.instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
        watchListController.webUrl = ThemeManager.currentTheme().PrivacyPolicyURL
        watchListController.titles = "Privacy Policy"
        self.navigationController?.pushViewController(watchListController, animated: false)
    }
    @IBAction func loadTermsandCondition(_ sender: Any) {
        print("loadTermsandCondition")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let watchListController = storyBoard.instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
        watchListController.webUrl = ThemeManager.currentTheme().TermsAndConditionURL
        watchListController.titles = "Terms of Use"
        self.navigationController?.pushViewController(watchListController, animated: false)
    }
}
