//
//  NotificationAPI.swift
//  AUSFLIX
//
//  Created by Firoze Moosakutty on 24/02/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class NotificationApi {
  static func moveToController() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let showingVC = UIApplication.topViewController()
    let viewController = storyboard.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
    viewController.fromDeepLink = true
    viewController.show_Id = Application.shared.deepLink_ShowID
    showingVC?.navigationController?.pushViewController(viewController, animated: false)
  }
    static func movToVideoPlaying() {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let showingVC = UIApplication.topViewController()
      let viewController = storyboard.instantiateViewController(withIdentifier: "videoPlay") as! VideoPlayingViewController
    viewController.videoNotificationId = Int(Application.shared.deepLink_ShowID)!
        viewController.premium_flag = 0
        viewController.fromNotification = true
    showingVC?.navigationController?.pushViewController(viewController, animated: false)
        
    }
  static func scheme(url: URL){
    if let scheme = url.scheme,
      scheme.localizedCaseInsensitiveCompare("com.adventuresportstv") == .orderedSame,
      let _ = url.host {
      var parameters: [String: String] = [:]
      URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
        parameters[$0.name] = $0.value
      }
      if let showId = parameters["showId"] {
        if  UserDefaults.standard.string(forKey:"user_id") != nil {
          Application.shared.deepLink_ShowID = showId
          Application.shared.isFromDeepLink = true
        }
      }
    }
  }
    static func app_backGround_Event(){
      var parameterDict: [String: String?] = [ : ]
      
      if UserDefaults.standard.string(forKey:"user_id") != nil {
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
          parameterDict["device_id"] = device_id
        }
        parameterDict["event_type"] = "POP06"
          
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
          parameterDict["app_id"] = app_id
        }
          if let channelid = UserDefaults.standard.string(forKey:"channelid") {
              parameterDict["channel_id"] = channelid
          }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
            }
          }
        }
      }
    }
    static func app_terminate_Event(){
        var parameterDict: [String: String?] = [ : ]
       if UserDefaults.standard.string(forKey:"user_id") != nil {
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
          parameterDict["device_id"] = device_id
        }
          if let app_id = UserDefaults.standard.string(forKey: "application_id") {
            parameterDict["app_id"] = app_id
          }
        parameterDict["event_type"] = "POP07"
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
          parameterDict["app_id"] = app_id
        }
          if let channelid = UserDefaults.standard.string(forKey:"channelid") {
              parameterDict["channel_id"] = channelid
          }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
            }
          }
        }
      }
    }
  static func registerForLocalNotification(notificationId: String, title: String, body: String, onDate:Date,type: String,eventKey: Int,premiumFlag:Int) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = "\(body)."
    content.categoryIdentifier = "alarm"
    content.sound = UNNotificationSound.default
    content.userInfo = ["type": type,"eventKey": eventKey,"showID":notificationId,"premiumFlag":premiumFlag]
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
      let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: onDate)
    print("dateComponents",dateComponents)
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
      let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
      center.add(request, withCompletionHandler: { error in
        if let error = error {
          print(error.localizedDescription)
        } else {
          print("notification set up successfully")
        }
      })
  }
  static func moveToChannelController(channelID: Int,premium_Flag: Int){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let showingVC = UIApplication.topViewController()
    let videoPlayerController = storyboard.instantiateViewController(withIdentifier: "channelvideo") as! ChannelVideoViewController
    videoPlayerController.fromNotification = true
    videoPlayerController.channelId = channelID
    videoPlayerController.premium_flag = premium_Flag
    showingVC?.navigationController?.pushViewController(videoPlayerController, animated: false)
  }
}

