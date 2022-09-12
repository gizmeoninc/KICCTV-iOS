//
//  GradientView.swift
//  Justwatchme.tv
//
//  Created by GIZMEON on 17/08/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class CustomGradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
   
    func updateView() {
     let layer = self.layer as! CAGradientLayer
     layer.colors = [firstColor, secondColor].map{$0.cgColor}
//        layer.startPoint = CGPoint(x: 0, y: 0.5)
//        layer.endPoint = CGPoint (x: 1, y: 0.5)
//     if (self.isHorizontal) {
//        layer.startPoint = CGPoint(x: 0, y: 0.5)
//        layer.endPoint = CGPoint (x: 1, y: 0.5)
//     } else {
//        layer.startPoint = CGPoint(x: 0.5, y: 0)
//        layer.endPoint = CGPoint (x: 0.5, y: 1)
//     }
    }
}
