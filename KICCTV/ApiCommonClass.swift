//
//  ApiCommonClass.swift
//  AlimonySwift
//
//  Created by Firoze Moosakutty on 09/02/18.
//  Copyright © 2018 Firoze Moosakutty. All rights reserved.
//

import Foundation
import Alamofire

public class ApiCommonClass {

  static func getLocatioAndIp(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["user_id"] = "user_id"
    let getChannelsApi = ApiRESTUrlString().getLocatiionAndIp(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
    static func GetAutoPlayAPI(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        print("getVideoAutoPlay apicommomclass")
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getTokenApi = ApiRESTUrlString().GetAutoPlayAPI(parameterDictionary: parameterDictionary) {
            Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:  ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [VideoModel]()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            if responseDict["data"] as? Dictionary<String, Any> != nil{
                                let dataArray = responseDict["data"] as! Dictionary<String, Any>
                              
                                    let JSON: NSDictionary = dataArray as NSDictionary
                                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                    channelResponseArray.append(videoModel)
                                
                                channelResponse["data"] = channelResponseArray as AnyObject
                            }
                            else{
                                channelResponse["error"] = responseDict["message"]
                            }
                            
                        } else {
                            channelResponse["error"] = responseDict["message"]
                        }
                        callback(channelResponse)
                        break
                    case .failure(let error):
                        channelResponse["error"] = error as AnyObject
                        callback(channelResponse)
                        break
                    }
                }
        }
    }

  static func UserDeletion( parameterDictionary: Dictionary<String, String>!,completion: @escaping(_ result: Bool)->()) {
      if let accesToken = UserDefaults.standard.string(forKey:"access_token") {
          let user_id = UserDefaults.standard.string(forKey:"user_id")!
          let country_code = UserDefaults.standard.string(forKey:"countryCode")!
          let pubid = UserDefaults.standard.string(forKey:"pubid")!
          let device_type = "ios-phone"
          let dev_id = UserDefaults.standard.string(forKey:"UDID")!
          let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
          let channelid = UserDefaults.standard.string(forKey:"channelid")!
          let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
          let userAgent = UserDefaults.standard.string(forKey:"userAgent")
          let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
          if let getUrl = ApiRESTUrlString().getUserDeleteApi(parameterDictionary: nil){
              var mutableURLRequest = URLRequest(url: URL(string: getUrl)!)
              mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
              mutableURLRequest.httpMethod = "POST"
              mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
              mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
              Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
                  switch(response.result) {
                  case .success(let value):
                      let responseDict = value as! [String: AnyObject]
                      guard let status = responseDict["success"] as? NSNumber  else {
                          return
                      }
                      if status == 1 {
                          completion(true)
                      } else {
                          completion(false)
                      }
                      break
                  case .failure:
                      completion(false)
                      break
                  }
              }
          }
      }
  }


  //    static func getToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
  //        var parameterDict: [String: String?] = [ : ]
  //        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
  //        if UserDefaults.standard.string(forKey:"fcmToken") != nil {
  //            parameterDict["fcmToken"] = UserDefaults.standard.string(forKey:"fcmToken")
  //        } else {
  //            parameterDict["fcmToken"] = ""
  //        }
  //        parameterDict["device_type"] = "ios-phone"
  //        parameterDict["app_bundle_id"] = ThemeManager.currentTheme().app_publisher_bundle_id
  //        parameterDict["app_key"] = ThemeManager.currentTheme().app_key
  //        let getChannelsApi = ApiRESTUrlString().getToken(parameterDictionary: parameterDict as? Dictionary<String, String>)
  //        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
  //            var channelResponse = Dictionary<String, AnyObject>()
  //
  //            if  responseDictionary["message"] as? String  == "authentication done " {
  //               if  responseDictionary["pubid"] as? String != "" {
  //                let pubid = responseDictionary["pubid"] as! Int
  //
  //                }
  ////                let mopub_rect_banner_id = responseDictionary["mopub_rect_banner_id"] as! String
  ////                UserDefaults.standard.set(mopub_rect_banner_id, forKey: "mopub_rect_banner_id")
  //
  //                 //channelResponse["Channels"] = channelResponseArray as AnyObject
  //                 channelResponse["Channels"] = responseDictionary ["token"]
  //            } else {
  //                channelResponse["error"]=responseDictionary["message"]
  //            }
  //            callback(channelResponse)
  //        }
  //    }
    static func ActivateTv(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
  //    let JSONData = try?  JSONSerialization.data(
  //        withJSONObject: parameterDictionary as Any,
  //      options: []
  //    )
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)


      ApiCallManager.apiCallREST(mainUrl: ActivateTvApi, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponse = Dictionary<String, AnyObject>()
        guard let status = responseDictionary["success"] as? NSNumber  else {
            channelResponse["error"] = responseDictionary["message"]
            callback(channelResponse)

            return
        }
        if status == 1 {
            if let dataArray = responseDictionary["code"] as? NSNumber{
                channelResponse["code"] = dataArray
            }
            if let message = responseDictionary["message"] as? String{
                channelResponse["message"] = message as AnyObject
            }

          
        } else {
          channelResponse["error"] = responseDictionary["message"]
        }
        callback(channelResponse)
      }
    }
  
  static func getToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
//    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
//    print("user id",UserDefaults.standard.string(forKey: "user_id")!)

    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    var parameterDict: [String: String?] = [ : ]
   

    if UserDefaults.standard.string(forKey:"fcmToken") != nil {
      parameterDict["fcmToken"] = UserDefaults.standard.string(forKey:"fcmToken")
    } else {
      parameterDict["fcmToken"] = ""
    }
    
    parameterDict["app_bundle_id"] = ThemeManager.currentTheme().app_publisher_bundle_id
    parameterDict["app_key"] = ThemeManager.currentTheme().app_key
    if let getTokenApi = ApiRESTUrlString().getToken(parameterDictionary: parameterDict as? Dictionary<String, String>) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      mutableURLRequest.timeoutInterval = 30.0
        mutableURLRequest.allHTTPHeaderFields = ["uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDictionary = value as! [String: AnyObject]
          if  responseDictionary["message"] as? String  == "authentication done " {
            if responseDictionary["pubid"] as? String != "" {
              if let pubid = responseDictionary["pubid"] as? Int {
                UserDefaults.standard.set(pubid, forKey: "pubid")
                print("authen pubid",pubid)
              }
            }
            if let accessToken = responseDictionary ["token"] as? String {
              UserDefaults.standard.set(accessToken, forKey: "access_token")
                print("authen accessToken",accessToken)
            }
            if let app_id = responseDictionary["app_id"] as? String {
              UserDefaults.standard.set(app_id, forKey: "app_id")
               
            }
            if let application_id = responseDictionary["application_id"] as? Int {
              UserDefaults.standard.set(application_id, forKey: "application_id")
            }

            if let banner_id = responseDictionary["banner_id"] as? String{
              UserDefaults.standard.set(banner_id, forKey: "banner_id")
            }

            if let rewarded_id = responseDictionary["rewarded_id"] as? String {
              UserDefaults.standard.set(rewarded_id, forKey: "rewarded_id")
            }

            if let interstitial_id = responseDictionary["interstitial_id"] as? String{
              UserDefaults.standard.set(interstitial_id, forKey: "interstitial_id")
            }
            if let interstitial_status = responseDictionary["interstitial_status"] as? String{
              UserDefaults.standard.set(interstitial_status, forKey: "interstitial_status")
            }

            if let mobpub_interstitial_status = responseDictionary["mobpub_interstitial_status"] as? String {
              UserDefaults.standard.set(mobpub_interstitial_status, forKey: "mobpub_interstitial_status")
            }

            if let mobpub_interstitial_id = responseDictionary["mobpub_interstitial_id"] as? String {
              UserDefaults.standard.set(mobpub_interstitial_id, forKey: "mobpub_interstitial_id")
            }

            if let mobpub_banner_id = responseDictionary["mobpub_banner_id"] as? String {
              UserDefaults.standard.set(mobpub_banner_id, forKey: "mobpub_banner_id")
            }
            channelResponse =  [:]
          } else {
            channelResponse["error"] = responseDictionary["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          print("error in get token",error)
          callback(channelResponse)
          break

        }
      }
    }
  }
  static func getHome(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {

    var parameterDict: [String: String?] = [ : ]
    parameterDict["user_id"] = "user_id"
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    let getChannelsApi = ApiRESTUrlString().getHome(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }


  static func getShowVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {

    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getChannelsApi = ApiRESTUrlString().getShowVideos(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }



  static func setLanguagePriority(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {

    let JSONData = try?  JSONSerialization.data(
      withJSONObject: parameterDictionary,
      options: []
    )
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!

    ApiCallManager.apiCallREST(mainUrl: SetLanguagePriority, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken], postData: JSONData) { (responseDictionary: Dictionary) in
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        channelResponse["Channels"]=responseDictionary["message"]
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func Login(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let loginApi = ApiRESTUrlString().Login(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: loginApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }

      callback(channelResponse)
    }
  }
    static func logOutAction( parameterDictionary: Dictionary<String, String>!,completion: @escaping(_ result: Bool)->()) {
        if let accesToken = UserDefaults.standard.string(forKey:"access_token") {
            let user_id = UserDefaults.standard.string(forKey:"user_id")!
            let country_code = UserDefaults.standard.string(forKey:"countryCode")!
            let pubid = UserDefaults.standard.string(forKey:"pubid")!
            let device_type = "ios-phone"
            let dev_id = UserDefaults.standard.string(forKey:"UDID")!
            let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
            let channelid = UserDefaults.standard.string(forKey:"channelid")!
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
            let userAgent = UserDefaults.standard.string(forKey:"userAgent")
            let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            if let getUrl = ApiRESTUrlString().getlogOUtUrl(parameterDictionary: nil) {
                var mutableURLRequest = URLRequest(url: URL(string: getUrl)!)
                mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
                mutableURLRequest.httpMethod = "GET"
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
                Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            completion(true)
                        } else {
                            completion(false)
                        }
                        break
                    case .failure:
                        completion(false)
                        break
                    }
                }
            }
        }
    }
//    static func login( parameterDictionary: Dictionary<String, String>!,completion: @escaping(_ result: Bool)->()) {
        static func login(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
           let country_code = UserDefaults.standard.string(forKey:"countryCode")!
           let pubid = UserDefaults.standard.string(forKey:"pubid")!
           let device_type = "ios-phone"
           let dev_id = UserDefaults.standard.string(forKey:"UDID")!
           let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
           let channelid = UserDefaults.standard.string(forKey:"channelid")!
           let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
            let userAgent = UserDefaults.standard.string(forKey:"userAgent")
            let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            var responseMessage = String()

               if let getUrl = ApiRESTUrlString().LoginNew(parameterDictionary: parameterDictionary) {
                   var mutableURLRequest = URLRequest(url: URL(string: getUrl)!)
                   mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
                   mutableURLRequest.httpMethod = "GET"
                   mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.allHTTPHeaderFields = ["country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
                   Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
                       switch(response.result) {
                      
                       case .success(let value):
                        var channelResponseArray = [VideoModel]()
                        var channelResponse = Dictionary<String, AnyObject>()
                           let responseDict = value as! [String: AnyObject]
                           guard let status = responseDict["success"] as? NSNumber  else {
                               return
                           }
                        guard let statuscode = response.response?.statusCode else {
                            return
                        }
                        if statuscode == 200{
                            // Create a user!
                            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                            for videoItem in dataArray {
                                let JSON: NSDictionary = videoItem as NSDictionary
                                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                channelResponseArray.append(videoModel)
                            }
                            channelResponse["Channels"]=channelResponseArray as AnyObject
                        }
                        else if  statuscode == 201 {
                            CustomProgressView.hideActivityIndicator()
                            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                            for videoItem in dataArray {
                                let JSON: NSDictionary = videoItem as NSDictionary
                                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                let userid = videoModel.user_id!
                                let userId = String(userid)
                                channelResponseArray.append(videoModel)
                                responseMessage = "Please verify your email"
                                channelResponse["user_id"] = userId as AnyObject
                                channelResponse["error"] = responseMessage as AnyObject
                                
                                
                            }
                           
                            
                            
                        }
                        else if statuscode == 202 {
                            responseMessage = "Invalid Credentials"
                            channelResponse["error"] = responseMessage as AnyObject
                        } else if statuscode == 203 {
                            responseMessage = "You have exceeded no of users. Please logout from existing device to access."
                            channelResponse["error"] = responseMessage as AnyObject
                        } else {
                            responseMessage = "Internal Server Error"
                            channelResponse["error"] = responseMessage as AnyObject
                        }
                        
                        callback(channelResponse)
                           break
                       case .failure:
//                           completion(false)
                           break
                       }
                   }
               }
         
       }
    
    static func LoginNew(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var responseMessage = String()
        let loginNewApi = ApiRESTUrlString().LoginNew(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: loginNewApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber else {
                return
            }
            
            guard let statuscode = responseDictionary["status"] as? Int else {
                return
            }
            if statuscode == 100{
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            }
            else if  statuscode == 101 {
                CustomProgressView.hideActivityIndicator()
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    let userid = videoModel.user_id!
                    let userId = String(userid)
                    channelResponseArray.append(videoModel)
                    responseMessage = "Please verify your email"
                    channelResponse["user_id"] = userId as AnyObject
                    channelResponse["error"] = responseMessage as AnyObject
                    
                    
                }
                //                channelResponse["Channels"]=channelResponseArray as AnyObject
                
                
            }
            else if statuscode == 102 {
                responseMessage = "Invalid Credentials"
                channelResponse["error"] = responseMessage as AnyObject
            } else if statuscode == 103 {
                responseMessage = "You have exceeded no of users. Please logout from existing device to access."
                channelResponse["error"] = responseMessage as AnyObject
            } else {
                responseMessage = "Internal Server Error"
                channelResponse["error"] = responseMessage as AnyObject
            }
            
            callback(channelResponse)
        }
    }
   
   
    static func logOutAllAction( parameterDictionary: Dictionary<String, String>!,completion: @escaping(_ result: Bool)->()) {
        if let accesToken = UserDefaults.standard.string(forKey:"access_token") {
            let user_id = UserDefaults.standard.string(forKey:"user_id")!
            let country_code = UserDefaults.standard.string(forKey:"countryCode")!
            let pubid = UserDefaults.standard.string(forKey:"pubid")!
            let device_type = "ios-phone"
            let dev_id = UserDefaults.standard.string(forKey:"UDID")!
            let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
            let channelid = UserDefaults.standard.string(forKey:"channelid")!
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
            let userAgent = UserDefaults.standard.string(forKey:"userAgent")
            let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            if let getUrl = ApiRESTUrlString().getlogOUtAllUrl(parameterDictionary: nil) {
                var mutableURLRequest = URLRequest(url: URL(string: getUrl)!)
                mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
                mutableURLRequest.httpMethod = "GET"
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
                Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            completion(true)
                        } else {
                            completion(false)
                        }
                        break
                    case .failure:
                        completion(false)
                        break
                    }
                }
            }
        }
    }
  static func ForgotPassword(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let loginApi = ApiRESTUrlString().ForgotPassword(parameterDictionary: parameterDictionary)
    
    ApiCallManager.apiCallREST(mainUrl: loginApi!, httpMethod: "GET", headers: ["country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["message"]
        channelResponse["Channels"]=dataArray
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }

      callback(channelResponse)
    }
  }
  static func FBLogin(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    // var parameterDict: [String: String?] = [ : ]
    // parameterDict["user_id"] = "user_id"
    let loginApi = ApiRESTUrlString().getFBLogin(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: loginApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }

      callback(channelResponse)
    }
  }

  static func getPopularChannels(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    let getChannelsApi = ApiRESTUrlString().getPopularChannels(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func getChannels(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["user_id"] = "user_id"
    let getChannelsApi = ApiRESTUrlString().getChannels(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func getHomePopularVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    var parameterDict: [String: String?] = [ : ]
    parameterDict["key"] = "1"
    parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    let getChannelsApi = ApiRESTUrlString().getHomePopularVideos(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func getvideoList(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getSearchResultsApi = ApiRESTUrlString().getvideoList(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status: Int = responseDictionary["success"] as? Int else { return }
      if status == 1 {// Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func getSimilarVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    //var parameterDict: [String : String?] = [:]
    //parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String

    let getSearchResultsApi = ApiRESTUrlString().getSimilarVideos(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers:  ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status: Int = responseDictionary["success"] as? Int else { return }
      if status == 1 {// Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }


  static func getVideoByID(callback:@escaping (Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String: String?] = [:]
    parameterDict["video_id"] = "1"
    parameterDict["video_title"] = "asd"
    parameterDict["video_description"] = "song"
    parameterDict["token"] = "videoplayback.mp4"
    let getStudioApi = ApiRESTUrlString().getChannels(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getStudioApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
    }
  }

  static func getHomeSearchResults(searchText: String!,searchType: String,category: String!,liveflag: String, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {

    var parameterDict: [String : String?] = [ : ]
    parameterDict["key"] = searchText
    parameterDict["type"] = searchType
    parameterDict["category"] = category
    parameterDict["liveflag"] = liveflag
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String


//    parameterDict["language"] = Application.shared.langugeIdList
    let getSearchResultsApi = ApiRESTUrlString().getHomeSearchResults(parameterDictionary: (parameterDict as! Dictionary<String, String>))
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"uid":user_id], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber else { return }
      if status == 1 {// Create a user!
        if searchType == "channel"{
          let dataArray = responseDictionary["channel_data"] as! [Dictionary<String, Any>]
          for videoItem in dataArray {
            let JSON: NSDictionary = videoItem as NSDictionary
            let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
            channelResponseArray.append(videoModel)
          }
        }else{

          let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
          for videoItem in dataArray {
            let JSON: NSDictionary = videoItem as NSDictionary
            let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
            channelResponseArray.append(videoModel)
          }
        }


        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func getSearchSuggestion(searchText: String!,searchType: String,category: String!,liveflag: String, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String : String?] = [ : ]
    parameterDict["key"] = searchText
    parameterDict["type"] = searchType
    parameterDict["category"] = category
    parameterDict["liveflag"] = liveflag
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let getSearchResultsApi = ApiRESTUrlString().getSearchSuggestion(parameterDictionary: (parameterDict as! Dictionary<String, String>))
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"uid":user_id], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [String]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber else { return }
      if status == 1 {// Create a user!
          let dataArray = responseDictionary["data"] as! [String]
           // This is a 'User?'
            channelResponseArray = dataArray
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }



  static func getSearchlist(callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    var parameterDict: [String: String?] = [: ]
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    let getSearchResultsApi = ApiRESTUrlString().getSearchlist(parameterDictionary: (parameterDict as! Dictionary<String, String>))
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber else { return }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func getMoreVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    //        let parameterDict: [String : String?] = [:]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getSearchResultsApi = ApiRESTUrlString().getMoreVideos(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status: Int = responseDictionary["success"] as? Int else { return }
      if status == 1 {// Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func getLikedDislikedVideo(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    //        let parameterDict: [String : String?] = [:]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getSearchResultsApi = ApiRESTUrlString().likeDislikeVideo(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status: Int = responseDictionary["success"] as? Int else { return }
      if status == 1 {// Create a user!
        channelResponse["Channels"]=responseDictionary["message"]
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
   

    static func getWatchList (parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String : String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let getWatchList = ApiRESTUrlString().getWatchlist(parameterDictionary: (parameterDict as! Dictionary<String, String>))
    ApiCallManager.apiCallREST(mainUrl: getWatchList!, httpMethod: "GET", headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber else { return }
      if status == 1 {// Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func getPayperviewVideos(callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    var parameterDict: [String : String?] = [ : ]
    parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    let getWatchList = ApiRESTUrlString().getPayperview(parameterDictionary: (parameterDict as! Dictionary<String, String>))
    ApiCallManager.apiCallREST(mainUrl: getWatchList!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber else { return }
      if status == 1 {// Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func generateToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    let getLanguagesApi = ApiRESTUrlString().generateToken(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getLanguagesApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"]

        channelResponse["Channels"]=dataArray
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func updateWatchList(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    //let _: [String : String?] = [:]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getSearchResultsApi = ApiRESTUrlString().updateWatchList(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status: Int = responseDictionary["success"] as? Int else { return }
      if status == 1 {// Create a user!

        channelResponse["Channels"]=responseDictionary["message"]
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func getShows(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {

    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    let getChannelsApi = ApiRESTUrlString().getShows(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func getAllLiveVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {

    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    let getChannelsApi = ApiRESTUrlString().getAllLiveVideos(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func getGustUserId(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let JSONData = try?  JSONSerialization.data(
      withJSONObject: parameterDictionary,
      options: []
    )
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    ApiCallManager.apiCallREST(mainUrl: GetGustUserLogin, httpMethod: "POST", headers: ["Content-Type":"application/json","country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: JSONData) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      if let status: Int = responseDictionary["success"] as? Int, status == 1 {
        let dataArray = responseDictionary["user_id"] as! NSNumber
//        for videoItem in dataArray {
//          let JSON: NSDictionary = videoItem as NSDictionary
//          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
//          channelResponseArray.append(videoModel)
//        }
        channelResponse["Channels"] = dataArray as AnyObject

      } else {
        channelResponse["error"] = "An error occurred, please try again later" as AnyObject
      }
      callback(channelResponse)
    }
  }

  static func getGustUserStaus(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let JSONData = try?  JSONSerialization.data(
      withJSONObject: parameterDictionary,
      options: []
    )

    ApiCallManager.apiCallREST(mainUrl: LoginRemoval, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken], postData: JSONData) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        if responseDictionary["data"] != nil {
          let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
          for videoItem in dataArray {
            let JSON: NSDictionary = videoItem as NSDictionary
            let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
            channelResponseArray.append(videoModel)
          }

          channelResponse["Channels"]=channelResponseArray as AnyObject
        } else {
          channelResponse["error"] = "Error" as AnyObject
        }
      } else {
        channelResponse["error"] = responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func generateLiveToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    let parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getLanguagesApi = ApiRESTUrlString().generateLiveToken(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getLanguagesApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"]

        channelResponse["Channels"]=dataArray
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func getYTVOD(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))

    let getChannelsApi = ApiRESTUrlString().getYTVOD(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [youtubeModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        // Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: youtubeModel = youtubeModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func getScheduleByDate(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getSearchResultsApi = ApiRESTUrlString().getScheduleByDate(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [ProgramModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status: Int = responseDictionary["success"] as? Int else { return }
      if status == 1 {// Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: ProgramModel = ProgramModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

    static func getvideoSubscriptions(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let getSearchResultsApi = ApiRESTUrlString().getvideoSubscriptions(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoSubscriptionModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoSubscriptionModel = VideoSubscriptionModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }

    static func verifyOtp(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let otpVerification = ApiRESTUrlString().verifyOtp(parameterDictionary: parameterDictionary)
      ApiCallManager.apiCallREST(mainUrl: otpVerification!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponseArray = [userModel]()
        var channelResponse = Dictionary<String, AnyObject>()
        guard let status: Int = responseDictionary["success"] as? Int else { return }
        if status == 0{
            print("incorrect otp")
        }
        if status == 1 {// Create a user!
          let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
          for videoItem in dataArray {
            let JSON: NSDictionary = videoItem as NSDictionary
            let videoModel: userModel = userModel.from(JSON)! // This is a 'User?'
            channelResponseArray.append(videoModel)
          }

          channelResponse["Channels"]=channelResponseArray as AnyObject
        } else {
          channelResponse["error"]=responseDictionary["message"]
        }
        callback(channelResponse)
      }
    }
    static func getchannelSubscriptions(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
      let device_type = "ios-phone"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
      let getSearchResultsApi = ApiRESTUrlString().getchannelSubscriptions(parameterDictionary: parameterDictionary)
      ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponseArray = [ChannelSubscriptionModel]()
        var channelResponse = Dictionary<String, AnyObject>()
        guard let status: Int = responseDictionary["success"] as? Int else { return }
        if status == 1 {// Create a user!
          let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
          for videoItem in dataArray {
            let JSON: NSDictionary = videoItem as NSDictionary
            let videoModel: ChannelSubscriptionModel = ChannelSubscriptionModel.from(JSON)! // This is a 'User?'
            channelResponseArray.append(videoModel)
          }

          channelResponse["Channels"]=channelResponseArray as AnyObject
        } else {
          channelResponse["error"]=responseDictionary["message"]
        }
        callback(channelResponse)
      }
    }
  static func checkPhoneVerification(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getChannelsApi = ApiRESTUrlString().checkPhoneVerification(parameterDictionary: parameterDict as? Dictionary<String, String>)
    ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [PhoneVerifiedModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status: Int = responseDictionary["success"] as? Int else { return }
      if status == 1 {// Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: PhoneVerifiedModel = PhoneVerifiedModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }
        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func verifyPhoneNumber(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let getSearchResultsApi = ApiRESTUrlString().verifyPhoneNumber(parameterDictionary: parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status: Int = responseDictionary["success"] as? Int else { return }
      if status == 1 {// Create a user!
        channelResponse["Channels"] = responseDictionary["success"]
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
    static func subscriptionTransaction(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let JSONData = try?  JSONSerialization.data(
            withJSONObject: parameterDictionary,
            options: []
        )
        
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        ApiCallManager.apiCallREST(mainUrl: SubscriptionTransaction, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: JSONData) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                channelResponse["Channels"] = responseDictionary["success"]
                
            } else {
                channelResponse["error"] = responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getIpandlocation(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
         var dataResponse = Dictionary<String, AnyObject>()
         let getTokenApi = "https://giz.poppo.tv/service/ipinfo"
         Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
           .responseJSON{ (response) in
             switch(response.result) {
             case .success(let value):
               let responseDictionary = value as! [String: AnyObject]
                   let countryCode = responseDictionary["countryCode"] as! String
                   UserDefaults.standard.set(countryCode, forKey: "countryCode")
                let country = responseDictionary["country"] as! String
                UserDefaults.standard.set(country, forKey: "country")
                   UserDefaults.standard.set(countryCode, forKey: "c_code")
                   if UserDefaults.standard.string(forKey: "countryCode") == nil {
                     UserDefaults.standard.set("US", forKey: "countryCode")
                     UserDefaults.standard.set("US", forKey: "c_code")
                   }
                   let lat = responseDictionary["lat"]
                   UserDefaults.standard.set(lat, forKey: "latitude")
                   let lon = responseDictionary ["lon"]
                   UserDefaults.standard.set(lon, forKey: "longitude")
                   let IPAddress = responseDictionary["query"] as! String
                   UserDefaults.standard.set(IPAddress, forKey: "IPAddress")
               if UserDefaults.standard.string(forKey: "IPAddress") == nil {
                   UserDefaults.standard.set(" ", forKey: "IPAddress")
               }
                   let city = responseDictionary ["city"] as! String
                   UserDefaults.standard.set(city, forKey: "city")
                   let region = responseDictionary["region"] as! String
                   UserDefaults.standard.set(region, forKey: "region")
                   UserDefaults.standard.set("2", forKey: "Geo_Type")
                   dataResponse =  [:]
                   callback(dataResponse)
               break
             case .failure(let error):
               print(error)
               dataResponse["error"] = error as AnyObject
               callback(dataResponse)
               break
             }
         }
     }
  static func getuserLanguages(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    if let getTokenApi = ApiRESTUrlString().getUserLanguages(parameterDictionary: parameterDict as? Dictionary<String, String>) {
      Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken])
        .responseJSON{ (response) in
          switch(response.result) {
          case .success(let value):
            let responseDict = value as! [String: AnyObject]
            var channelResponseArray = [languageList]()
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
              for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: languageList = languageList.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
              }
              channelResponse["data"] = channelResponseArray as AnyObject
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
      }
    }
  }
  static func getLanguages(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    if let getTokenApi = ApiRESTUrlString().getLanguages(parameterDictionary: parameterDict as? Dictionary<String, String>) {
      Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken])
        .responseJSON{ (response) in
          switch(response.result) {
          case .success(let value):
            let responseDict = value as! [String: AnyObject]
            var channelResponseArray = [languageList]()
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
              for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: languageList = languageList.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
              }
              channelResponse["data"] = channelResponseArray as AnyObject
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
      }
    }
  }

    static func getUserSubscriptions(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        
        if let getTokenApi = ApiRESTUrlString().getUserSubscriptions(parameterDictionary: nil) {
            Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [SubscriptionModel]()
                        if let isForcibleLogout = responseDict["forcibleLogout"] as? NSNumber, isForcibleLogout == 1 {
                            channelResponse["forcibleLogout"] = responseDict["forcibleLogout"]
                            callback(channelResponse)
                        }
                        else if  let isSessionExpired = responseDict["session_expired"] as? NSNumber, isSessionExpired == 1 {
                            channelResponse["session_expired"] = responseDict["session_expired"]
                            callback(channelResponse)
                        }else {
                            guard let status = responseDict["success"] as? NSNumber  else {
                                return
                            }
                            
                            if status == 1 {
                                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                                for videoItem in dataArray {
                                    let JSON: NSDictionary = videoItem as NSDictionary
                                    let videoModel: SubscriptionModel = SubscriptionModel.from(JSON)! // This is a 'User?'
                                    channelResponseArray.append(videoModel)
                                }
                                channelResponse["data"] = channelResponseArray as AnyObject
                            } else {
                                channelResponse["error"] = responseDict["message"]
                            }
                            callback(channelResponse)
                        }
                            break
                            case .failure(let error):
                            channelResponse["error"] = error as AnyObject
                            callback(channelResponse)
                            break
                        }
                    }
                }
        }
//  static func getFeaturedVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
//    var channelResponse = Dictionary<String, AnyObject>()
//    var parameterDict: [String: String?] = [ : ]
//    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
//    parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
//    parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
//    parameterDict["device_type"] = "ios-phone"
//    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
//    parameterDict["language"] = Application.shared.langugeIdList
//    if UserDefaults.standard.string(forKey:"channel_id") == nil{
//        parameterDict["channel_id"] = "354"
//    }
//    else{
//        parameterDict["channel_id"] = UserDefaults.standard.string(forKey:"channel_id")
//    }
//    if let getTokenApi = ApiRESTUrlString().getFeaturedVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) {
//      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
//      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
//      mutableURLRequest.httpMethod = "GET"
//      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//      mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken]
//      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
//        switch(response.result) {
//        case .success(let value):
//          let responseDict = value as! [String: AnyObject]
//          var channelResponseArray = [LiveGuideModel]()
//
//
//            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
//            for videoItem in dataArray {
//              let JSON: NSDictionary = videoItem as NSDictionary
//              let videoModel: LiveGuideModel = LiveGuideModel.from(JSON)! // This is a 'User?'
//              channelResponseArray.append(videoModel)
//            }
//            channelResponse["data"] = channelResponseArray as AnyObject
//
//          callback(channelResponse)
//          break
//        case .failure(let error):
//          channelResponse["error"] = error as AnyObject
//          callback(channelResponse)
//          break
//        }
//      }
//    }
//  }
    static func getLiveGuide(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        
        print("accesToken",accesToken)
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if UserDefaults.standard.string(forKey:"channelid") == nil{
            parameterDict["channel_id"] = "354"
        }
        else{
            parameterDict["channel_id"] = UserDefaults.standard.string(forKey:"channelid")
        }
        if let getTokenApi = ApiRESTUrlString().getLiveGuide(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
            mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            mutableURLRequest.httpMethod = "GET"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
            Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
                switch(response.result) {
                case .success(let value):
                    let responseDict = value as! [String: AnyObject]
                    var channelResponseArray = [LiveGuideModel]()
                    guard let status = responseDict["success"] as? NSNumber  else {
                        return
                    }
                    if status == 1 {
                        let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                        for videoItem in dataArray {
                            let JSON: NSDictionary = videoItem as NSDictionary
                            let videoModel: LiveGuideModel = LiveGuideModel.from(JSON)! // This is a 'User?'
                            channelResponseArray.append(videoModel)
                        }
                        channelResponse["data"] = channelResponseArray as AnyObject
                    } else {
                        channelResponse["error"] = responseDict["message"]
                    }
                    callback(channelResponse)
                    break
                case .failure(let error):
                    channelResponse["error"] = error as AnyObject
                    callback(channelResponse)
                    break
                }
            }
        }
    }
    
    static func getFeaturedVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getFeaturedVideos(parameterDictionary:parameterDictionary) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
        Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [VideoModel]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
    static func getFeaturedVideos1(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        
        
        print("accesToken",accesToken)
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

        if let getTokenApi = ApiRESTUrlString().getFeaturedVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
            mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            mutableURLRequest.httpMethod = "GET"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
            Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
                switch(response.result) {
                case .success(let value):
                    let responseDict = value as! [String: AnyObject]
                    var channelResponseArray = [VideoModel]()
                    guard let status = responseDict["success"] as? NSNumber  else {
                        return
                    }
                    if status == 1 {
                        let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                        for videoItem in dataArray {
                            let JSON: NSDictionary = videoItem as NSDictionary
                            let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                            channelResponseArray.append(videoModel)
                        }
                        channelResponse["data"] = channelResponseArray as AnyObject
                    } else {
                        channelResponse["error"] = responseDict["message"]
                    }
                    callback(channelResponse)
                    break
                case .failure(let error):
                    channelResponse["error"] = error as AnyObject
                    callback(channelResponse)
                    break
                }
            }
        }
    }
    static func getFreeShows(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    var parameterDict: [String: String?] = [ : ]
    
    if let getTokenApi = ApiRESTUrlString().getFreeShows(parameterDictionary: parameterDictionary as? Dictionary<String, String>) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
        Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [VideoModel]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
    static func getHomeNewArrivals(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getHomeNewArrivals(parameterDictionary:parameterDictionary) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
        Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [VideoModel]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
    static func getFilmOfTheDayVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getFilmOfTheDayVideos(parameterDictionary:parameterDictionary) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
        Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [VideoModel]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
    static func RegisterWithFB(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
       let country_code = UserDefaults.standard.string(forKey:"countryCode")!
       let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "ios-phone"
       let dev_id = UserDefaults.standard.string(forKey:"UDID")!
       let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
       let channelid = UserDefaults.standard.string(forKey:"channelid")!
       let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var responseMessage = String()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(parameterDictionary)
           if let getUrl = ApiRESTUrlString().registerWithFB() {
               var mutableURLRequest = URLRequest(url: URL(string: getUrl)!)
               mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
               mutableURLRequest.httpMethod = "POST"
            mutableURLRequest.httpBody = data
//               mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.allHTTPHeaderFields = ["Content-Type":"application/json","country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
               Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
                   switch(response.result) {
                  
                   case .success(let value):
                    var channelResponseArray = [VideoModel]()
                    var channelResponse = Dictionary<String, AnyObject>()
                      
                    guard let statuscode = response.response?.statusCode else {
                        return
                    }
                    if statuscode == 200{
                        let responseDict = value as! [String: AnyObject]
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        // Create a user!
                        let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                        for videoItem in dataArray {
                            let JSON: NSDictionary = videoItem as NSDictionary
                            let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                            channelResponseArray.append(videoModel)
                        }
                        channelResponse["statuscode"] = 200 as AnyObject

                        channelResponse["Channels"]=channelResponseArray as AnyObject
                    }
                    else if  statuscode == 204 {
                        channelResponse["statuscode"] = 204 as AnyObject
                    }
                    else if  statuscode == 201 {
                        let responseDict = value as! [String: AnyObject]

                        CustomProgressView.hideActivityIndicator()
                        let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                        for videoItem in dataArray {
                            let JSON: NSDictionary = videoItem as NSDictionary
                            let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                            let userid = videoModel.user_id!
                            let userId = String(userid)
                            channelResponseArray.append(videoModel)
                            responseMessage = "Please verify your email"
                            channelResponse["user_id"] = userId as AnyObject
                            channelResponse["error"] = responseMessage as AnyObject
                            
                            
                        }
                       
                        
                        
                    }
                    else if statuscode == 202 {
                        responseMessage = "Invalid Credentials"
                        channelResponse["error"] = responseMessage as AnyObject
                    } else if statuscode == 203 {
                        responseMessage = "You have exceeded no of users. Please logout from existing device to access."
                        channelResponse["error"] = responseMessage as AnyObject
                    } else {
                        responseMessage = "Internal Server Error"
                        channelResponse["error"] = responseMessage as AnyObject
                    }
                    
                    callback(channelResponse)
                       break
                   case .failure:
                    var channelResponse = Dictionary<String, AnyObject>()

                    responseMessage = "Internal Server Error"
                    channelResponse["message"] = responseMessage as AnyObject
                    channelResponse["error"] = responseMessage as AnyObject

                    callback(channelResponse)
                    break
                   }
               }
           }
     
   }
    static func linkSocialMediaAccount(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
       let country_code = UserDefaults.standard.string(forKey:"countryCode")!
       let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "ios-phone"
       let dev_id = UserDefaults.standard.string(forKey:"UDID")!
       let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
       let channelid = UserDefaults.standard.string(forKey:"channelid")!
       let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var responseMessage = String()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(parameterDictionary)
           if let getUrl = ApiRESTUrlString().linkSocialMediaAccount() {
               var mutableURLRequest = URLRequest(url: URL(string: getUrl)!)
               mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
               mutableURLRequest.httpMethod = "POST"
            mutableURLRequest.httpBody = data

//               mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.allHTTPHeaderFields = ["Content-Type":"application/json","country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
               Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
                   switch(response.result) {
                  
                   case .success(let value):
                    var channelResponseArray = [VideoModel]()
                    var channelResponse = Dictionary<String, AnyObject>()
                       let responseDict = value as! [String: AnyObject]
                       guard let status = responseDict["success"] as? NSNumber  else {
                           return
                       }
                    guard let statuscode = response.response?.statusCode else {
                        return
                    }
                    if statuscode == 200{
                        // Create a user!
                        let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                        for videoItem in dataArray {
                            let JSON: NSDictionary = videoItem as NSDictionary
                            let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                            channelResponseArray.append(videoModel)
                        }
                        channelResponse["statuscode"] = 200 as AnyObject

                        channelResponse["Channels"]=channelResponseArray as AnyObject
                    }
                    else {
                        responseMessage = "Internal Server Error"
                        channelResponse["message"] = responseMessage as AnyObject
                    }
                    
                    callback(channelResponse)
                       break
                   case .failure:
                    var channelResponse = Dictionary<String, AnyObject>()

                    responseMessage = "Internal Server Error"
                    channelResponse["error"] = responseMessage as AnyObject
                    callback(channelResponse)

//                           completion(false)
                       break
                   }
               }
           }
     
   }
    
  static func getCategories(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getCategories(parameterDictionary: parameterDict as? Dictionary<String, String>) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [VideoModel]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["categories"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["categories"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
   
    static func getvideoByCategoryid(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
      let device_type = "ios-phone"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
      let userAgent = UserDefaults.standard.string(forKey:"userAgent")
      let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      if let getTokenApi = ApiRESTUrlString().getvideoByCategory(parameterDictionary: parameterDictionary) {
        var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
        mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableURLRequest.httpMethod = "GET"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
          mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
        Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
          switch(response.result) {
          case .success(let value):
            let responseDict = value as! [String: AnyObject]
            var channelResponseArray = [VideoModel]()
            if responseDict["data"] != nil {
                let dataArray = responseDict["data"] as! NSDictionary
                if let categories = dataArray["shows"] as? [Dictionary<String, Any>] {
                    for videoItem in categories {
                      let JSON: NSDictionary = videoItem as NSDictionary
                      let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                      channelResponseArray.append(videoModel)
                    }
                    channelResponse["data"] = channelResponseArray as AnyObject
                    if let baneer = dataArray["banner"] as? String{
                        channelResponse["banner"] = baneer as AnyObject
                    }
                    if let synopsis = dataArray["synopsis"] as? String{
                        channelResponse["synopsis"] = synopsis as AnyObject
                    }
                    if let category_name = dataArray["category_name"] as? String{
                        channelResponse["category_name"] = category_name as AnyObject
                    }
               
                }
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
        }
      }
    }
    static func getPartnerList(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
       var channelResponse = Dictionary<String, AnyObject>()
       var parameterDict: [String: String?] = [ : ]
       let accesToken = UserDefaults.standard.string(forKey:"access_token")!
       parameterDict["user_id"] = ""
       parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
       parameterDict["device_type"] = "ios-phone"
       parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
       parameterDict["language"] = Application.shared.langugeIdList
       if let getTokenApi = ApiRESTUrlString().getPartnerList(parameterDictionary: parameterDict as? Dictionary<String, String>) {
         var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
         mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
         mutableURLRequest.httpMethod = "GET"
         mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
         mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken]
         Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
           switch(response.result) {
           case .success(let value):
             let responseDict = value as! [String: AnyObject]
             var channelResponseArray = [VideoModel]()
//             guard let status = responseDict["success"] as? NSNumber  else {
//               return
//             }
            
               let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
             if !dataArray.isEmpty {
               for videoItem in dataArray {
                 let JSON: NSDictionary = videoItem as NSDictionary
                 let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                 channelResponseArray.append(videoModel)
               }
               channelResponse["data"] = channelResponseArray as AnyObject
             } else {
               channelResponse["error"] = responseDict["message"]
             }
             callback(channelResponse)
             break
           case .failure(let error):
             channelResponse["error"] = error as AnyObject
             callback(channelResponse)
             break
           }
         }
       }
     }
    static func getContinueWatchingVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getTokenApi = ApiRESTUrlString().getContinueWatchingVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) {
          var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
          mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
          mutableURLRequest.httpMethod = "GET"
          mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
            Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
            switch(response.result) {
            case .success(let value):
              let responseDict = value as! [String: AnyObject]
              var channelResponseArray = [VideoModel]()
              guard let status = responseDict["success"] as? NSNumber  else {
                return
              }
              if status == 1 {
                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                  let JSON: NSDictionary = videoItem as NSDictionary
                  let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                  channelResponseArray.append(videoModel)
                }
                channelResponse["data"] = channelResponseArray as AnyObject
              } else {
                channelResponse["error"] = responseDict["message"]
              }
              callback(channelResponse)
              break
            case .failure(let error):
              channelResponse["error"] = error as AnyObject
              callback(channelResponse)
              break
            }
          }
        }
    }
    static func getDianamicHomeVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
 
    var channelResponse = Dictionary<String, AnyObject>()
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getDianamicHomeVideos(parameterDictionary: parameterDictionary) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [showByCategoryModel]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: showByCategoryModel = showByCategoryModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
    static func getAllChannels(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      var parameterDict: [String: String?] = [ : ]
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
      let device_type = "ios-phone"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
      let userAgent = UserDefaults.standard.string(forKey:"userAgent")
      let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      parameterDict["user_id"] = ""
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["language"] = Application.shared.langugeIdList
      if let getTokenApi = ApiRESTUrlString().getAllChannels(parameterDictionary: parameterDict as? Dictionary<String, String>) {
        var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
        mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableURLRequest.httpMethod = "GET"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
        Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
          switch(response.result) {
          case .success(let value):
            let responseDict = value as! [String: AnyObject]
            var channelResponseArray = [VideoModel]()
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
              for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
              }
              channelResponse["data"] = channelResponseArray as AnyObject
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
        }
      }
    }
  static func getProducerBasedShows(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    if let getTokenApi = ApiRESTUrlString().getProducerBasedShows(parameterDictionary: parameterDictionary) {
        var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version]
      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [VideoModel]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }

  static func getShowData(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getShowData(parameterDictionary: parameterDictionary) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [ShowDetailsModel]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! Dictionary<String, Any>
//            for videoItem in dataArray {
            let JSON: NSDictionary = dataArray as NSDictionary
              let videoModel: ShowDetailsModel = ShowDetailsModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
//            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
  static func getvideoByCategory(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getvideoByCategory(parameterDictionary: parameterDictionary) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [VideoModel]()
//          guard let status = responseDict["success"] as? NSNumber  else {
//            return
//          }
//          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
          if !dataArray.isEmpty{
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
      static func getPartnerByPartnerid(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        if let getTokenApi = ApiRESTUrlString().GetPartnerByCategory(parameterDictionary: parameterDictionary) {
          var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
          mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
          mutableURLRequest.httpMethod = "GET"
          mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
          mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken]
          Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
            
            switch(response.result) {
            case .success(let value):

              let responseDict = value as! [String: AnyObject]
              if responseDict["err"] != nil{
                channelResponse["error"] = "no value" as AnyObject
              }
              else{
              let dataArray = responseDict["data"] as! NSDictionary

              var channelResponseArray = [VideoModel]()
             
              let categories = dataArray["shows"] as! [Dictionary<String, Any>]
            
              
              if !categories.isEmpty {
//                        let dataArray1 = param["videos"] as! [Dictionary<String, Any>]
                        for videoItem in categories {
                          let JSON: NSDictionary = videoItem as NSDictionary
                          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                          channelResponseArray.append(videoModel)
                        }
                
                        channelResponse["data"] = channelResponseArray as AnyObject
                     if dataArray["partner_image"] != nil{
                                    channelResponse["partner_image"] = dataArray["partner_image"] as AnyObject
                                    }
                                    if dataArray["partner_description"] != nil{
                                    channelResponse["partner_description"] = dataArray["partner_description"] as AnyObject
                                    }
                                    if dataArray["partner_name"] != nil{
                                    channelResponse["partner_name"] = dataArray["partner_name"] as AnyObject
                                    }
                      } else {
//                channelResponse["error"] = "no value" as AnyObject
                if dataArray["partner_image"] != nil{
                channelResponse["partner_image"] = dataArray["partner_image"] as AnyObject
                }
                if dataArray["partner_description"] != nil{
                channelResponse["partner_description"] = dataArray["partner_description"] as AnyObject
                }
                if dataArray["partner_name"] != nil{
                channelResponse["partner_name"] = dataArray["partner_name"] as AnyObject
                }

                      }
              }
              
              callback(channelResponse)
              break
            case .failure(let error):
              channelResponse["error"] = error as AnyObject
              callback(channelResponse)
              break
            }
          }
        }
      }
    static func getPubId(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    var parameterDictionary: [String: String] = [ : ]
    parameterDictionary["app_publisher_bundle_id"] = ThemeManager.currentTheme().app_publisher_bundle_id
    parameterDictionary["app_key"] = ThemeManager.currentTheme().app_key
    let getPubUrl = ApiRESTUrlString().getPubID(parameterDictionary: parameterDictionary)
  Alamofire.request(getPubUrl!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:  ["Content-Type":"application/json"])
      .responseJSON{ (response) in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: Any]
          guard let publisherId = responseDict["pubid"] as? Int else {
            return
          }
            guard let channelid = responseDict["channelid"] as? Int else {
                return
              }
            print("channelid",channelid)
            print("publisherId",publisherId)
            
           
          guard let registration_mandatory_flag = responseDict["registration_mandatory_flag"] as? Bool else {
            return
          }
          guard let subscription_mandatory_flag = responseDict["subscription_mandatory_flag"] as? Int else {
            return
          }
           
          UserDefaults.standard.set(publisherId, forKey: "pubid")
            UserDefaults.standard.set(channelid, forKey: "channelid")
          UserDefaults.standard.set(registration_mandatory_flag, forKey: "registration_mandatory_flag")
          UserDefaults.standard.set(subscription_mandatory_flag, forKey: "subscription_mandatory_flag")

          print(publisherId)
          print("subscription_mandatory_flag",subscription_mandatory_flag)
            channelResponse["pubid"] =  responseDict["pubid"] as AnyObject
            callback(channelResponse)
          break
        case .failure(let error):
          print(error)
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
          break
        }
    }
  }
    static func GetSelectedVideo(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getTokenApi = ApiRESTUrlString().getSelectedVideo(parameterDictionary: parameterDictionary) {
            Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:  ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [VideoModel]()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            let dataArray = responseDict["data"] as! Dictionary<String, Any>
                          
                                let JSON: NSDictionary = dataArray as NSDictionary
                                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                channelResponseArray.append(videoModel)
                            
                            channelResponse["data"] = channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"] = responseDict["message"]
                        }
                        callback(channelResponse)
                        break
                    case .failure(let error):
                        channelResponse["error"] = error as AnyObject
                        callback(channelResponse)
                        break
                    }
                }
        }
    }
    static func GetLinearEvents(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getTokenApi = ApiRESTUrlString().getLinearEvent(parameterDictionary: parameterDictionary) {
            Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:  ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [VideoModel]()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            let dataArray = responseDict["data"] as! Dictionary<String, Any>
                                let JSON: NSDictionary = dataArray as NSDictionary
                                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                channelResponseArray.append(videoModel)
                                channelResponse["data"] = channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"] = responseDict["message"]
                        }
                        callback(channelResponse)
                        break
                    case .failure(let error):
                        channelResponse["error"] = error as AnyObject
                        callback(channelResponse)
                        break
                    }
                }
        }
    }
    static func GetNewsDetails(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getTokenApi = ApiRESTUrlString().getNewsDetails(parameterDictionary: parameterDictionary) {
            Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:  ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [VideoModel]()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            let dataArray = responseDict["data"] as! Dictionary<String, Any>
                                let JSON: NSDictionary = dataArray as NSDictionary
                                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                channelResponseArray.append(videoModel)
                                channelResponse["data"] = channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"] = responseDict["message"]
                        }
                        callback(channelResponse)
                        break
                    case .failure(let error):
                        channelResponse["error"] = error as AnyObject
                        callback(channelResponse)
                        break
                    }
                }
        }
    }

    static func Channelhome(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
      let device_type = "ios-phone"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
      let userAgent = UserDefaults.standard.string(forKey:"userAgent")
      let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      if let getTokenApi = ApiRESTUrlString().getChannelhome(parameterDictionary: parameterDictionary) {
        Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
          .responseJSON{ (response) in
            switch(response.result) {
            case .success(let value):
              let responseDict = value as! [String: AnyObject]
              var channelResponseArray = [VideoModel]()
              guard let status = responseDict["success"] as? NSNumber  else {
                return
              }
              if status == 1 {
                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                  let JSON: NSDictionary = videoItem as NSDictionary
                  let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                  channelResponseArray.append(videoModel)
                }
                channelResponse["data"] = channelResponseArray as AnyObject
              } else {
                channelResponse["error"] = responseDict["message"]
              }
              callback(channelResponse)
              break
            case .failure(let error):
              channelResponse["error"] = error as AnyObject
              callback(channelResponse)
              break
            }
        }
      }
    }
  static func Register(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
//    let JSONData = try?  JSONSerialization.data(
//        withJSONObject: parameterDictionary as Any,
//      options: []
//    )
    print("parameterDictionary",parameterDictionary)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try! encoder.encode(parameterDictionary)
    ApiCallManager.apiCallREST(mainUrl: RegisterApi, httpMethod: "POST", headers: ["Content-Type":"application/json"], postData: data) { (responseDictionary: Dictionary) in
      var channelResponseArray = [userModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber  else {
        return
      }
      if status == 1 {
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: userModel = userModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }

  static func GETLanguagesLIST() {
    var parameterDict: [String: String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    parameterDict["device_type"] = "ios-phone"
    parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
    if let getTokenApi = ApiRESTUrlString().getLanguages(parameterDictionary: parameterDict as? Dictionary<String, String>) {
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken]
      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          let responseDict = value as! [String: AnyObject]
          var channelResponseArray = [languageList]()
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: languageList = languageList.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            Application.shared.userLanguages = channelResponseArray
          }
          break
        case .failure(let error):
          print(error)
          break
        }
      }
    }
  }
  static func WatchlistShows(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

    if let getTokenApi = ApiRESTUrlString().getWatchlistShows(parameterDictionary: parameterDictionary) {
        Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
        .responseJSON{ (response) in
          switch(response.result) {
          case .success(let value):
            let responseDict = value as! [String: AnyObject]
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              channelResponse["data"] = responseDict["message"]
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
      }
    }
  }
  static func LikeShow(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getLikedShows(parameterDictionary: parameterDictionary) {
        Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
        .responseJSON{ (response) in
          switch(response.result) {
          case .success(let value):
            let responseDict = value as! [String: AnyObject]
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              channelResponse["data"] = responseDict["message"]
                print("channel response = \(channelResponse["data"])")
            } else {
              channelResponse["error"] = responseDict["message"]
                print("channel response = \(channelResponse["error"])")

            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
      }
    }
  }
    static func disLikeShow(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
       var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getTokenApi = ApiRESTUrlString().getdisLikedShows(parameterDictionary: parameterDictionary) {
            Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
           .responseJSON{ (response) in
             switch(response.result) {
             case .success(let value):
               let responseDict = value as! [String: AnyObject]
               guard let status = responseDict["success"] as? NSNumber  else {
                 return
               }
               if status == 1 {
                 channelResponse["data"] = responseDict["message"]
                   print("channel response = \(channelResponse["data"])")
               } else {
                 channelResponse["error"] = responseDict["message"]
                   print("channel response = \(channelResponse["error"])")

               }
               callback(channelResponse)
               break
             case .failure(let error):
               channelResponse["error"] = error as AnyObject
               callback(channelResponse)
               break
             }
         }
       }
     }
  static func getLikeList(callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var parameterDict: [String : String?] = [ : ]
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
    let user_id = UserDefaults.standard.string(forKey:"user_id")!
    let country_code = UserDefaults.standard.string(forKey:"countryCode")!
    let pubid = UserDefaults.standard.string(forKey:"pubid")!
    let device_type = "ios-phone"
    let dev_id = UserDefaults.standard.string(forKey:"UDID")!
    let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
    let channelid = UserDefaults.standard.string(forKey:"channelid")!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    let getWatchList = ApiRESTUrlString().getLikeList(parameterDictionary: (parameterDict as! Dictionary<String, String>))
    ApiCallManager.apiCallREST(mainUrl: getWatchList!, httpMethod: "GET", headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: nil) { (responseDictionary: Dictionary) in
      var channelResponseArray = [VideoModel]()
      var channelResponse = Dictionary<String, AnyObject>()
      guard let status = responseDictionary["success"] as? NSNumber else { return }
      if status == 1 {// Create a user!
        let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
        for videoItem in dataArray {
          let JSON: NSDictionary = videoItem as NSDictionary
          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
          channelResponseArray.append(videoModel)
        }

        channelResponse["Channels"]=channelResponseArray as AnyObject
      } else {
        channelResponse["error"]=responseDictionary["message"]
      }
      callback(channelResponse)
    }
  }
  static func getLikeFlag(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
           let user_id = UserDefaults.standard.string(forKey:"user_id")!
            let country_code = UserDefaults.standard.string(forKey:"countryCode")!
            let pubid = UserDefaults.standard.string(forKey:"pubid")!
            let device_type = "ios-phone"
            let dev_id = UserDefaults.standard.string(forKey:"UDID")!
            let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
            let channelid = UserDefaults.standard.string(forKey:"channelid")!
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getLikeFlag(parameterDictionary: parameterDictionary) {
        Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
        .responseJSON{ (response) in
          switch(response.result) {
          case .success(let value):
            var channelResponseArray = [LikeWatchListModel]()
            let responseDict = value as! [String: AnyObject]
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
              for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: LikeWatchListModel = LikeWatchListModel.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
              }
              channelResponse["data"] = channelResponseArray as AnyObject
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            break
          }
      }
    }
  }
  static func getWatchFlag(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    let accesToken = UserDefaults.standard.string(forKey:"access_token")!
           let user_id = UserDefaults.standard.string(forKey:"user_id")!
            let country_code = UserDefaults.standard.string(forKey:"countryCode")!
            let pubid = UserDefaults.standard.string(forKey:"pubid")!
            let device_type = "ios-phone"
            let dev_id = UserDefaults.standard.string(forKey:"UDID")!
            let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
            let channelid = UserDefaults.standard.string(forKey:"channelid")!
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
    let userAgent = UserDefaults.standard.string(forKey:"userAgent")
    let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    if let getTokenApi = ApiRESTUrlString().getWatchFlag(parameterDictionary: parameterDictionary) {
        Alamofire.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
        .responseJSON{ (response) in
          switch(response.result) {
          case .success(let value):
            var channelResponseArray = [LikeWatchListModel]()
            let responseDict = value as! [String: AnyObject]
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
              for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: LikeWatchListModel = LikeWatchListModel.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
              }
              channelResponse["data"] = channelResponseArray as AnyObject
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
      }
    }
  }

  static func analayticsAPI(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    Alamofire.request(APP_LAUNCH, method: .post, parameters: parameterDictionary, encoding: URLEncoding.default, headers:  nil)
      .responseString{ (response) in
        switch(response.result) {
        case .success(let value):
          print("Sucess Device API")
          print(value)
          break
        case .failure(let error):
          print("Error Device API")
          if let value =  parameterDictionary["event_type"] {
            print(value)
          }
          print(error)
          break
        }
    }
  }
  static func analayticsEventAPI(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    
    Alamofire.request(eventAPI, method: .post, parameters: parameterDictionary, encoding: URLEncoding.default, headers:  nil)
      .responseString{ (response) in
        switch(response.result) {
        case .success(let value):
          print("Sucess Event API")
          print(value)
          break
        case .failure(let error):
          print("Error Event API")
          print(error)
          break
        }
    }
  }

  static func parseSrtFile(urlString: String, callback: @escaping(Dictionary<String, String?>) -> Void) {
    var apiResponse = Dictionary<String, String>()
    Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers:  nil)
      .responseString{ response in
        switch(response.result) {
        case .success(let value):
          apiResponse["data"] = value
          callback(apiResponse)
          break
        case .failure(let error):
          print(error)
          callback(apiResponse)
          break
        }
    }
  }

  static func sheduleAPI(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
    var channelResponse = Dictionary<String, AnyObject>()
    if let  accesToken = UserDefaults.standard.string(forKey:"access_token"),let getTokenApi = ApiRESTUrlString().getSchedule(parameterDictionary: parameterDictionary) {
      //let value = "https://poppo.tv/platform/bk/api/GetSchedule?pubid=50012&channelid=275&date=2020-01-21"
      var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
      mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
      mutableURLRequest.httpMethod = "GET"
      mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken]
      Alamofire.request(mutableURLRequest).validate().responseJSON{ response in
        switch(response.result) {
        case .success(let value):
          var channelResponseArray = [scheduleModel]()
          let responseDict = value as! [String: AnyObject]
          guard let status = responseDict["success"] as? NSNumber  else {
            return
          }
          if status == 1 {
            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: scheduleModel = scheduleModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
            channelResponse["data"] = channelResponseArray as AnyObject
          } else {
            channelResponse["error"] = responseDict["message"]
          }
          callback(channelResponse)
          break
        case .failure(let error):
          print(error)
          channelResponse["error"] = error as AnyObject
          callback(channelResponse)
          break
        }
      }
    }
  }
  static func parseSubRip(_ payload: String) -> NSDictionary? {

     do {

       // Prepare payload
       var payload = payload.replacingOccurrences(of: "\n\r\n", with: "\n\n")
       payload = payload.replacingOccurrences(of: "\n\n\n", with: "\n\n")
       payload = payload.replacingOccurrences(of: "\r\n", with: "\n")

       // Parsed dict
       let parsed = NSMutableDictionary()

       // Get groups
       let regexStr = "(\\d+)\\n([\\d:,.]+)\\s+-{2}\\>\\s+([\\d:,.]+)\\n([\\s\\S]*?(?=\\n{2,}|$))"
       let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
       let matches = regex.matches(in: payload, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, payload.count))
       for m in matches {

         let group = (payload as NSString).substring(with: m.range)

         // Get index
         var regex = try NSRegularExpression(pattern: "^[0-9]+", options: .caseInsensitive)
         var match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
         guard let i = match.first else {
           continue
         }
         let index = (group as NSString).substring(with: i.range)

         // Get "from" & "to" time
         regex = try NSRegularExpression(pattern: "\\d{1,2}:\\d{1,2}:\\d{1,2}[,.]\\d{1,3}", options: .caseInsensitive)
         match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
         guard match.count == 2 else {
           continue
         }
         guard let from = match.first, let to = match.last else {
           continue
         }

         var h: TimeInterval = 0.0, m: TimeInterval = 0.0, s: TimeInterval = 0.0, c: TimeInterval = 0.0

         let fromStr = (group as NSString).substring(with: from.range)
         var scanner = Scanner(string: fromStr)
         scanner.scanDouble(&h)
         scanner.scanString(":", into: nil)
         scanner.scanDouble(&m)
         scanner.scanString(":", into: nil)
         scanner.scanDouble(&s)
         scanner.scanString(",", into: nil)
         scanner.scanDouble(&c)
         let fromTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)

         let toStr = (group as NSString).substring(with: to.range)
         scanner = Scanner(string: toStr)
         scanner.scanDouble(&h)
         scanner.scanString(":", into: nil)
         scanner.scanDouble(&m)
         scanner.scanString(":", into: nil)
         scanner.scanDouble(&s)
         scanner.scanString(",", into: nil)
         scanner.scanDouble(&c)
         let toTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)

         // Get text & check if empty
         let range = NSMakeRange(0, to.range.location + to.range.length + 1)
         guard (group as NSString).length - range.length > 0 else {
           continue
         }
         let text = (group as NSString).replacingCharacters(in: range, with: "")

         // Create final object
         let final = NSMutableDictionary()
         final["from"] = fromTime
         final["to"] = toTime
         final["text"] = text
         parsed[index] = final

       }

       return parsed

     } catch {

       return nil

     }

   }

   static func searchSubtitles(_ payload: NSDictionary?, _ time: TimeInterval) -> String? {
     let predicate = NSPredicate(format: "(%f >= %K) AND (%f <= %K)", time, "from", time, "to")
     guard let values = payload?.allValues, let result = (values as NSArray).filtered(using: predicate).first as? NSDictionary else {
       return nil
     }
     guard let text = result.value(forKey: "text") as? String else {
       return nil
     }
     return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
   }
}
