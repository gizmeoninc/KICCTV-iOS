//
//  UserSession.swift
//  MyVideoApp
//
//  Created by GIZMEON on 10/04/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//
import Foundation
import UIKit
import JNKeychain

public class UserSession {
    
    /**
     Returns device OSVersion string
     */
    static func deviceOSVersion () -> String {
        let systemVersion = UIDevice.current.systemVersion
        return systemVersion
    }
    
    /**
     Method returns the device id
     */
    static func deviceID () -> String {
        let deviceID = self.getDeviceIdentifierFromKeychain()
        return deviceID
    }
    
    /**
     Method returns the device model
     */
    static func modelName () -> String {
        let modelName = UIDevice.current.modelName
        return modelName
    }
    
    /**
     Platform method returns the platform, which is iOS in this case
     */
    static func platform () -> String {
        let platform = "1" //For iOS : 1 , Android :0
        return platform
    }
    
    /**
     Method returns Device Token -FCM Token
     */
    static func deviceToken() -> String? {
        return UserDefaults.standard.string(forKey: "device_token")
    }
    /**
     Return user session for Registration & Getupdate user
     */
    
//    static func returnUserSessionDictionary(user: UserV2) -> [String: Any] {
//        var parameterDict = [String: Any]()
//        parameterDict ["user_device_id"] = UserSession.deviceID()
//        parameterDict ["platform"] = UserSession.platform()
//        parameterDict ["model"] = UserSession.modelName()
//        parameterDict ["os_version"] = UserSession.deviceOSVersion()
//        parameterDict ["user_id"] = user.id
//
//        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
//            parameterDict["version"] = appVersion
//        }
//        parameterDict ["device_token"] = UserSession.deviceToken()
//        return parameterDict
//    }
    
    /**
     Return Push notification status
     */
//    static  func checkForPushNotification(completion:@escaping (Int) -> Void) {
//        if #available(iOS 10.0, *) {
//            let current = NotificationCenter.current()
//            current.getNotificationSettings(completionHandler: { (settings) in
//                if settings.authorizationStatus == .notDetermined {
//                    // Notification permission has not been asked yet, go for it!
//                    //UserDefaults.standard.set(1 , forKey: "push_enabled")
//                    completion(0)
//                }
//
//                if settings.authorizationStatus == .denied {
//                    // Notification permission was previously denied, go to settings & privacy to re-enable
//                    //  UserDefaults.standard.set(0 , forKey: "push_enabled")
//                    completion(0)
//
//                }
//
//                if settings.authorizationStatus == .authorized {
//                    // Notification permission was already granted
//                    //  UserDefaults.standard.set(1 , forKey: "push_enabled")
//                    completion(1)
//                }
//            })
//
//        } else {
//            // Fallback on earlier versions
//        }
//
//    }
    
}
// MARK: - Unique Device ID - KeyChain
extension UserSession {
    static let sharedInstance = UserSession()
    
    static func getDeviceIdentifierFromKeychain() -> String {
        
        // try to get value from keychain
        var deviceUUID = self.keychain_valueForKey("keychainDeviceUUID") as? String
        if deviceUUID == nil {
            deviceUUID = UIDevice.current.identifierForVendor!.uuidString
            // save new value in keychain
            self.keychain_setObject(deviceUUID! as AnyObject, forKey: "keychainDeviceUUID")
        }
        return deviceUUID!
    }
    // MARK: - Keychain
    
    static func keychain_setObject(_ object: AnyObject, forKey: String) {
        let result = JNKeychain.saveValue(object, forKey: forKey)
        if !result {
            print("keychain saving: smth went wrong")
        }
    }
    
    static func keychain_deleteObjectForKey(_ key: String) -> Bool {
        let result = JNKeychain.deleteValue(forKey: key)
        return result
    }
    
    static func keychain_valueForKey(_ key: String) -> AnyObject? {
        let value = JNKeychain.loadValue(forKey: key)
        return value as AnyObject?
    }
}

// MARK: - Fetch Device Model

public extension UIDevice {
    
    /**
     Device string variable
     */
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
