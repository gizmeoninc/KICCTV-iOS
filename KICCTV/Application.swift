//
//  Application.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 18/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
public class Application {
  
  static var shared = Application()
  var userSubscriptionsArray = [SubscriptionModel]()
  var userSubscriptionStatus = Bool()
  var userSubscriptionVideoStatus = Bool()
  var isFromRegister = Bool()
  var pubId = String()
  var guestRegister = false
  var CastSessionStart = false
  var videoDescription = ""
  var selectedVideoModel: VideoModel!
  var langugeIdList = "145" //Default Value Sinhalese
  var isFromDeepLink = false
  var isFromChannelNotification = false
  var deepLink_ShowID = ""
  var existingSession = false
  var isVideoPlaying = false

  var APP_LAUNCH = true
  var nowPlayingValue = false
  var nowPlayingIndex = Int()
  var notificationchannelId = Int()
  var notificationpremiumFlag = Int()
  var userLanguages = [languageList]()
  
  static func showAlert(onViewController: UIViewController, title: String, message: String, actionTitle: String, cancelButton: Bool, handler: ((UIAlertAction) -> Void)?) -> Void{
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handler))
    if cancelButton{
      alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    }
    onViewController.present(alert, animated: true, completion: nil)
  }
  
}
