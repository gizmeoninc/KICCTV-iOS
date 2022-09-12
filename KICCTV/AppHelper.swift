//
//  AppHelper.swift
//  AlimonySwift
//
//  Created by Firoze Moosakutty on 08/02/18.
//  Copyright © 2018 Firoze Moosakutty. All rights reserved.
//

import UIKit

public class AppHelper
{
    // MARK: email validation
    
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // MARK: show default alert with action
    static func showAppErrorWithOKAction(vc: UIViewController, title:String, message:String, handler: ((UIAlertAction) -> Void)?) -> Void
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        vc.present(alertView, animated: true, completion: nil)


    }
    // MARK: show default alert
    static func showAlertMessage(vc: UIViewController, title:String, message:String) -> Void
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if !(UIApplication.topViewController() is UIAlertController){
            vc.present(alert, animated: true, completion: nil)

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.dismiss(alert:alert)
        })
    }
    static func dismiss(alert:UIAlertController)
    {
        alert.dismiss(animated: true, completion: nil)
    }
    
    // MARK: get age
    static func getAgeFromCurrentDate(date:String) -> String!
    {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy/MM/dd"
        let time = todaysDate.timeIntervalSince(dateFormatter.date(from: date)!)
        let allDays = (((time/60)/60)/24)
        let days = allDays.remainder(dividingBy: 365)
        let years = (allDays-days)/365
        return String(format:"%f", years)
        
    }
    
    // MARK: convert date format to another
    static func convertDateFormat(dateString:String, dateFormat:String, newDateFormat:String) -> String!
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateFromString = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = newDateFormat
        let dateString = dateFormatter.string(from: dateFromString!)
        return dateString
    }
    
    // MARK: change image size
    static func imageScaledToSize(image:UIImage, newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
