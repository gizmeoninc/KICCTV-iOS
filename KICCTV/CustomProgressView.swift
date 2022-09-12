//
//  CustomProgressView.swift
//  SwiftTest
//
//  Created by Firoze Moosakutty on 16/02/18.
//  Copyright © 2018 Firoze Moosakutty. All rights reserved.
//
import UIKit

public class CustomProgressView: NSObject {
    
    static let maxLabelWidth = (UIScreen.main.bounds.size.width/2)-20
    static var keyboardHeightValue = CGFloat()
    static var container: UIView = UIView()
    static var loadingView: UIVisualEffectView = UIVisualEffectView()
    static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    static var animatingDuration = Bool()
    static let window = UIApplication.shared.keyWindow!
    static var userInteractionBoolValue = Bool()
    static var messageBoolValue = Bool()
    static var messageString = String()
    static var messageLabel = UILabel()
   
    private static func setFrame() {
        keyboardHeightValue = keyboardHeight()
        loadingView.transform = CGAffineTransform(scaleX: 1, y: 1)
        if messageBoolValue {
            //get frame of message label
            let attributesDictionary = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.systemFont(ofSize: 17)]
            let messageStringFrame = NSString(format: "%@", messageString).boundingRect(with: CGSize(width:maxLabelWidth,height:300), options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributesDictionary), context: nil)
            
            messageLabel.lineBreakMode = .byWordWrapping
            messageLabel.numberOfLines = 0
            messageLabel.text = messageString
            
            let messageLabelFrame = CGRect(x: 20, y: 70, width: max(80,messageStringFrame.size.width), height:round(messageStringFrame.size.height))
            messageLabel.frame = messageLabelFrame
            
            // set frame for loadingView
            loadingView.frame = CGRect(x: 0, y: 0, width: max(80,messageStringFrame.size.width+40), height: 90+round(messageStringFrame.size.height))
            loadingView.effect = UIBlurEffect.init(style: .light)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            // set frame for activityIndicator
            
            activityIndicator.frame =  CGRect(x: (loadingView.frame.size.width/2)-20, y: 20, width: 40, height: 40)
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            activityIndicator.color =  ThemeManager.currentTheme().ThemeColor
            
        } else {
            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.effect = UIBlurEffect.init(style: .light)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            activityIndicator.frame =  CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            activityIndicator.color =  ThemeManager.currentTheme().ThemeColor
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        }
        
        if keyboardHeightValue == 0
        {
            loadingView.center = window.center

        }
        else
        {
            loadingView.center.x = UIScreen.main.bounds.size.width/2
            loadingView.center.y = UIScreen.main.bounds.size.height/2 - keyboardHeightValue/2
            
        }
    }
    
    private static func setFrames() {
        keyboardHeightValue = keyboardHeight()
        loadingView.transform = CGAffineTransform(scaleX: 1, y: 1)
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
       //     loadingView.effect = UIBlurEffect.init(style: .light)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            activityIndicator.frame =  CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            activityIndicator.color =  ThemeManager.currentTheme().ThemeColor
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
            loadingView.center = window.center
    }
    
    private static func setUserInteractionDisabled() {
        if !userInteractionBoolValue {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    static func showActivityIndicator(userInteractionEnabled:Bool) {
        messageBoolValue = false
        userInteractionBoolValue = userInteractionEnabled
        setFrames()
        loadingView.contentView.addSubview(activityIndicator)
        setUserInteractionDisabled()
        window.addSubview(loadingView)
        activityIndicator.startAnimating()
        startShowingProgressView()
    }
    
    static func showActivity(userInteractionEnabled:Bool, view : UIView){
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        
        view.addSubview(myActivityIndicator)
    }
    
    static func showActivityIndicator(message:String!, userInteractionEnabled:Bool) {

        messageBoolValue = true
        messageString = message
        userInteractionBoolValue = userInteractionEnabled
        setFrame()
        loadingView.contentView.addSubview(activityIndicator)
        loadingView.addSubview(messageLabel)
        setUserInteractionDisabled()
        window.addSubview(loadingView)
        activityIndicator.startAnimating()
      //  startShowingProgressView()
    }
    
    static func hideActivityIndicator() {
        if Thread.isMainThread {
            activityIndicator.stopAnimating()
            dismissingProgressView()
        } else {
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                dismissingProgressView()
            }
        }
    }
    
    private static func UIColorFromHex(rgbValue:UInt32, alpha:Double)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    private static func startShowingProgressView() {
        loadingView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        animatingDuration = true
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [UIView.AnimationOptions.curveEaseIn,UIView.AnimationOptions.allowUserInteraction], animations: {
            loadingView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (finished: Bool) in
            animatingDuration = false
        })
    }
    
    private static func dismissingProgressView() {
        animatingDuration = true
        UIView.animate(withDuration: 0.2, delay: 0, options: [UIView.AnimationOptions.curveEaseIn,UIView.AnimationOptions.allowUserInteraction], animations: {
            loadingView.transform = CGAffineTransform(scaleX:0.2, y:0.2)
            
        }, completion: { (finished: Bool) in
            animatingDuration = false
            loadingView.removeFromSuperview()
            if !userInteractionBoolValue {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        })
    }
    
    private static func keyboardHeight() -> CGFloat {
        for testWindow in  UIApplication.shared.windows {
            if String(describing: testWindow) != String(describing: UIWindow()) {
                for possibleKeyboard in testWindow.subviews {
                    if possibleKeyboard.description.hasPrefix("<UIPeripheralHostView") {
                        return possibleKeyboard.bounds.size.height
                    }
                    else if possibleKeyboard.description.hasPrefix("<UIInputSetContainerView") {
                        for hostKeyboard in possibleKeyboard.subviews {
                            if hostKeyboard.description.hasPrefix("<UIInputSetHost") {
                                return hostKeyboard.frame.size.height
                            }
                        }
                    }
                }
            }
        }
        return 0
    }
   static func showActivityIndicatory(UiView: UICollectionView) {
        activityIndicator.frame = UiView.bounds
        activityIndicator.center = UiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style =
            UIActivityIndicatorView.Style.whiteLarge
        UiView.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        UiView.isUserInteractionEnabled = false
    }
    static func hideActivityIndicatorforView(UiView: UICollectionView){
        activityIndicator.startAnimating()
        UiView.isUserInteractionEnabled = true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
