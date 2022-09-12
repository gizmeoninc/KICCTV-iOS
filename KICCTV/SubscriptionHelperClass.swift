//
//  SubscriptionHelperClass.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 13/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
public class SubscriptionHelperClass {
    func getUserSubscriptions(){
        ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                }
            } else {
                if let videos = responseDictionary["data"] as? [SubscriptionModel] {
                    if videos.count == 0 {
                        Application.shared.userSubscriptionStatus = false
                        
                    }
                    else{
                        Application.shared.userSubscriptionStatus = true
                    }
                    Application.shared.userSubscriptionsArray = videos
                    
                }
            }
        }
    }
}
