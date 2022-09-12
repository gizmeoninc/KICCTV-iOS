//
//  ThemeManager.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 19/02/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  func colorFromHexString (_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    if ((cString.count) != 6) {
      return UIColor.gray
    }

    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)

    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}
enum Theme: Int {

  case theme1, theme2

  var mainColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }

  //Customizing the Navigation Bar
  var barStyle: UIBarStyle {
    switch self {
    case .theme1:
      return .default
    case .theme2:
      return .black
    }
  }

  var navigationBackgroundImage: UIImage? {
    return self == .theme1 ? UIImage(named: "navBackground") : nil
  }

  var tabBarBackgroundImage: UIImage? {
    return self == .theme1 ? UIImage(named: "tabBarBackground") : nil
  }

  var backgroundColor: UIColor {
    return UIColor().colorFromHexString("#000000")
  }

  var secondaryColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }

  var titleTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }
  var subtitleTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }
  var textColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("000000")
    case .theme2:
      return UIColor().colorFromHexString("ffffff")
    }
  }
  var sideMenuTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor.darkGray
    case .theme2:
      return UIColor.lightGray
    }
  }

  var textfeildColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("000000")
    case .theme2:
      return UIColor().colorFromHexString("808080")
    }
  }
  var CgColor: CGColor {
    switch self {
    case .theme1:
      return  UIColor.white.cgColor
    case .theme2:
      return  UIColor.black.cgColor
    }
  }
  var PrivacyPolicyURL: String {
    return "https://dev.projectfortysix.com/privacypolicy"
  }
  var TermsAndConditionURL: String {
    return "https://dev.projectfortysix.com/termsandconditions"
  }
  //screen change
  var Splashscreenimage: String {
    return "splashscreenimage"
  }
  var RightImage: String {
    return "rightArrow"
  }
  var emailAddress: String {
    return "info@projectfortysix.com"
  }
  var logoutImage: String {
    return "TVExcelLogout"
  }
  var logoImage: String {
    return "ApplLogo"
  }
    var screenIcons: String {
      return "logoIcon"
    }
  var navigationControllerLogo: String {
    return "logoIcon"
  }
  var backImage: String {
    return "TVExcelBack"
  }
  var UIImageColor: UIColor {
    return UIColor().colorFromHexString("#FFFFFF")
  }
    var HeadTextColor: UIColor {
      return UIColor().colorFromHexString("#B9B8B6")
    }
    var TabbarColor: UIColor {
      return UIColor().colorFromHexString("#74B4DF")
    }
    var ThemeColor: UIColor {
      return UIColor().colorFromHexString("#74B4DF")
    }
  var appName: String {
    return "KICCTV"
  }
 var app_publisher_bundle_id: String {
     let bundleID = "com.ios.projectfortysix"
     return bundleID
  }
  var app_key: String {
   return "KICCTV"
  }
  var grayImageColor: UIColor {
    return UIColor().colorFromHexString("1F1F1F")
  }
    var newBackgrondColor: UIColor {
       return UIColor().colorFromHexString("#141414")
     }
  var subscriptionLabelColor: UIColor {
    return UIColor().colorFromHexString("#F7D703")
  }
  var subscriptionLabelCornerRadius: UIRectCorner{
    return UIRectCorner.allCorners
  }
}
// Enum declaration
let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
class ThemeManager {

  // ThemeManager
  static func currentTheme() -> Theme {
    if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
      return Theme(rawValue: storedTheme)!
    } else {
      return .theme2
    }
  }

//  static func applyTheme(theme: Theme) {
//    UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
//    UserDefaults.standard.synchronize()
//    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
//    UINavigationBar.appearance().tintColor = ThemeManager.currentTheme().UIImageColor
//    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//    //   // Sets shadow (line below the bar) to a blank image
//    UINavigationBar.appearance().shadowImage = UIImage()
//    //   // Sets the translucent background color
//    UINavigationBar.appearance().backgroundColor = theme.backgroundColor
//    UINavigationBar.appearance().isTranslucent = true
//    UINavigationBar.appearance().barStyle = theme.barStyle
//    //    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//    //    if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//    //        statusBar.backgroundColor = theme.backgroundColor
//    //    }
//    UITabBar.appearance().barStyle = theme.barStyle
//    UITabBar.appearance().backgroundColor = theme.backgroundColor
//  }
//  
//}
static func applyTheme(theme: Theme) {
    UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
          UserDefaults.standard.synchronize()
          UINavigationBar.appearance().barStyle = theme.barStyle
          UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
          UINavigationBar.appearance().backgroundColor = theme.backgroundColor
          UINavigationBar.appearance().tintColor = ThemeManager.currentTheme().UIImageColor
          UITabBar.appearance().barStyle = theme.barStyle
          UITabBar.appearance().backgroundColor = theme.backgroundColor
     UINavigationBar.appearance().isTranslucent = true
 
   }}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
