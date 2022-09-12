//
//  HomeTabBarViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 14/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//
import UIKit

class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate {


  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:self, action:nil)
    self.delegate = self
  
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // UITabBarControllerDelegate method
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
   
    // If your view controller is emedded in a UINavigationController you will need to check if it's a UINavigationController and check that the root view controller is your desired controller (or subclass the navigation controller)
 
       
//        if tabBarController.selectedIndex == 3{
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let pvc = storyboard.instantiateViewController(withIdentifier: "PopupVc") as! PopupViewController
//            pvc.modalPresentationStyle = UIModalPresentationStyle.custom
//            pvc.transitioningDelegate = self
//            self.present(pvc, animated: true, completion: nil)
//            self.view.backgroundColor = .clear
//
//        }
//        else{
            let navController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController
            navController?.popToRootViewController(animated: false)
//        }
               
             
      
     
    
  }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        var tabFour = UIViewController()
        if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false", let vc = viewController as? UINavigationController,vc.viewControllers.filter({$0 is TransparentVc}).count > 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabOne =  storyboard.instantiateViewController(withIdentifier: "demofirst") as! HomeViewController
            //let tabOne = HomeViewController()
            let tabOneBarItem = UITabBarItem(title: "Home", image: UIImage(named: "TabBarOneHome"), selectedImage: UIImage(named: "TabBarOneHome"))
            tabOne.tabBarItem = tabOneBarItem
            let nav1 = UINavigationController(rootViewController: tabOne)
            let tabTwo = storyboard.instantiateViewController(withIdentifier: "Search") as! HomeSearchViewController
            let tabBarItem2 = UITabBarItem(title: "Explore", image: UIImage(named: "TVExcelSearchImage"), selectedImage: UIImage(named: "TVExcelSearchImage"))
            tabTwo.type = "video"
    //        tabTwo.fromNewReleaseTab = true
            tabTwo.tabBarItem = tabBarItem2
            let nav2 = UINavigationController(rootViewController: tabTwo)
            tabFour = storyboard.instantiateViewController(withIdentifier: "MyAccountVc") as! MyAccountVC
            let tabBarItem4 = UITabBarItem(title: "Account", image: UIImage(named: "ic_account"), selectedImage: UIImage(named: "ic_account"))
             tabFour.tabBarItem = tabBarItem4
            let nav4 = UINavigationController(rootViewController: tabFour)
            var window: UIWindow?
//            self.viewControllers?.remove(at: 2)
            tabBarController.setViewControllers([nav1,nav2,nav4], animated: false)
            tabBarController.selectedIndex = 2
                   window?.rootViewController = self
                    return false

        }
        else{
                 if let vc = viewController as? UINavigationController,vc.viewControllers.filter({$0 is TransparentVc}).count > 0 {
                         let storyboard = UIStoryboard(name: "Main", bundle: nil)
                         let newVC = storyboard.instantiateViewController(withIdentifier: "PopupVc") as! PopupViewController
                         newVC.modalPresentationStyle = UIModalPresentationStyle.custom
                         newVC.transitioningDelegate = self
                         tabBarController.present(newVC, animated: true)
                                        return false
                 }
        }
        return true
    }
    var view1 : UIView {
        let view1 = UIView()
        view1.backgroundColor = .white
        view1.frame = CGRect(x: 0, y: 200, width: 300, height: 300)
        return view1
        
    }
}
extension UITabBar {
  // Workaround for iOS 11's new UITabBar behavior where on iPad, the UITabBar inside
  // the Master view controller shows the UITabBarItem icon next to the text
  override open var traitCollection: UITraitCollection {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return UITraitCollection(horizontalSizeClass: .compact)
    }
    return super.traitCollection
  }
}
extension HomeTabBarViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
class HalfSizePresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            print("actual height",theView.bounds.height)
            print("actual heigh subractedt", theView.bounds.height - theView.bounds.height/3)

            return CGRect(x: 0, y:  theView.bounds.height/3, width: theView.bounds.width, height:theView.bounds.height -  theView.bounds.height/3)
            
        }
    }
}
