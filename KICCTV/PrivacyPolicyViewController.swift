//
//  PrivacyPolicyViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 18/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import WebKit
import Reachability
class PrivacyPolicyViewController: UIViewController , WKNavigationDelegate, WKUIDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var webUrl = ""
    var titles = ""
    
    var reachability = Reachability()!
    var webView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationbar()
        if reachability.connection != .none {
            let url = NSURL(string: webUrl)
            let request = NSURLRequest(url: url! as URL)
            webView = WKWebView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - 60))
            webView.navigationDelegate = self
            webView.load(request as URLRequest)
            self.view.addSubview(webView)
            self.view.sendSubviewToBack(webView)
            webView.uiDelegate = self
        }
        self.webView.backgroundColor =  ThemeManager.currentTheme().backgroundColor
        self.webView.isOpaque = false
        self.view.backgroundColor =  ThemeManager.currentTheme().backgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
      if let delegate = UIApplication.shared.delegate as? AppDelegate {
        delegate.restrictRotation = .portrait
      }
    }
    func setupNavigationbar(){
        self.navigationItem.title = titles

        let newBackButton = UIButton(type: .custom)
        newBackButton.setImage(UIImage(named: ThemeManager.currentTheme().backImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
        newBackButton.contentMode = .scaleAspectFit
        newBackButton.frame = CGRect(x: 0, y: 0, width: 5, height: 10)
        newBackButton.tintColor = ThemeManager.currentTheme().UIImageColor
        newBackButton.addTarget(self, action: #selector(AboutusViewController.backAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: newBackButton)
        self.navigationItem.leftBarButtonItem = item2
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        CustomProgressView.hideActivityIndicator()
    }
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.navigationBar.isHidden = false
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
            self.navigationController?.pushViewController(serachController, animated: false)
        }
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        let elementID = "mobile-bars-icon-pro"
        let removeElementIdScript = "document.getElementById('\(elementID)').style.display = \"none\";"
        webView.evaluateJavaScript(removeElementIdScript) { (response, error) in
        }
        CustomProgressView.hideActivityIndicator()
    }
}

