//
//  LeftMenuViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 23/02/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LeftMenuViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    //if the user is already logged in
    if AccessToken.current != nil {
      getFBUserData()
    }
    // Do any additional setup after loading the view.
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  //function is fetching the user data
  func getFBUserData() {
    if(AccessToken.current) != nil {
      let params = ["fields": "<some_fields>"]
      let graphRequest = GraphRequest(graphPath: "<graph_path>", parameters: params)
      graphRequest.start { (_ urlResponse, _ requestResult) in
        switch requestResult {
        case .success(let graphResponse):
          if let responseDictionary = graphResponse.dictionaryValue {
            // Do something with your responseDictionary
            print(responseDictionary)
          }
        case .failed:
          print("error")
        }
      }
    }
  }
  //when login button clicked
  @objc func loginButtonClicked() {
    let loginManager = LoginManager()
    loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (loginResult) in
      switch loginResult {
      case .failed(let error):
        print(error)
      case .cancelled:
        print("User cancelled login.")
      //  case .success(let grantedPermissions, let declinedPermissions, let accessToken):
      case .success(let grantedPermissions, let declinedPermissions, let accessToken):
        print(grantedPermissions)
        print(declinedPermissions)
        print(accessToken)
        self.getFBUserData()
      }
    }
  }
}
