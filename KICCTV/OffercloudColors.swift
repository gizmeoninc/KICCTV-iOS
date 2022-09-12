//
//  OffercloudColors.swift
//  OfferCloud_Swift
//
//  Created by Rukmini KR on 22/10/17.
//  Copyright © 2017 Rukmini KR. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    func textmaincolor() -> UIColor {
        
        return ColorChanger().color(from: "aa0e8b")
        
    }
    func commonBackgroundColor() -> UIColor {
        
        return ColorChanger().color(from: "C7CEDA")
        
    }
    func commonTextColor() -> UIColor {
        
        return ColorChanger().color(from: "0d46a1")
        
    }
    func searchBarTextColor() -> UIColor {
        
        return ColorChanger().color(from: "2096F3")
        
    }
    func sliderGreenColor() -> UIColor {
        
        return ColorChanger().color(from: "B1FF00")
        
    }
}
