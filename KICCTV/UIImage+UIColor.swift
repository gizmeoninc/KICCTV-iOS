//
//  UIImage+UIColor.swift
//  AUSFLIX
//
//  Created by Firoze Moosakutty on 31/01/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
static func fromColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
}
}
