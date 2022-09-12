//
//  NonetworkDisplayViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 04/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Reachability

  protocol InternetConnectivityDelegate:class {
    func gotoOnline()
  }
class NoNetworkDisplayViewController: UIViewController {
    
    var reachability = Reachability()!
    var delegate : InternetConnectivityDelegate!
    var fromHome = Bool()
    var fromSplash = Bool()
    var fromchannelTab = Bool()
    var frompopularTab = Bool()
    var fromLiveTab = Bool()
    
  @IBOutlet weak var retryButton: UIButton!{
    didSet{
      self.retryButton.setTitleColor(ThemeManager.currentTheme().UIImageColor, for: .normal)
    }
  }
  override func viewDidLoad() {
        super.viewDidLoad()
        CustomProgressView.hideActivityIndicator()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    // MARK: Newtork connection checking
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else {
            return
        }
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            CustomProgressView.hideActivityIndicator()
            if fromHome == true {
                delegate.gotoOnline()
                navigationController?.popViewController(animated: true)
            } else if fromSplash {
                delegate.gotoOnline()
                navigationController?.popViewController(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        case .cellular:
            print("Reachable via Cellular")
            CustomProgressView.hideActivityIndicator()
            if fromHome == true {
                delegate.gotoOnline()
                navigationController?.popViewController(animated: true)
            } else if fromSplash {
                delegate.gotoOnline()
                navigationController?.popViewController(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        case .none:
            print("Network not reachable")
        }
    }
    func startTimer()  {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(NoNetworkDisplayViewController.stopActivityIndicator), userInfo: nil, repeats: true);
    }
    
    @objc func stopActivityIndicator() {
        CustomProgressView.hideActivityIndicator()
    }
    
    @IBAction func retryAction(_ sender: Any) {
        CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
        startTimer()
        
    }
}
