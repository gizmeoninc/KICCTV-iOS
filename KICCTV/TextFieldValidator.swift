//
//  TextFieldValidator.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 20/03/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

//static

let iconImageName = "error.png"
let colorPopUpBg = UIColor(red: 0.702, green: 0.000, blue: 0.000, alpha: 1.000)
let colorFont = UIColor.white
let fontSize = 15
let fontName = "Helvetica-Bold"
let paddingInErrorPopUp = 5
let msgValidateLength = "This field cannot be blank"

// properties

let isMandatory = Bool()
let presentInView = UIView()
let popUpColor = UIColor()
let validateOnCharacterChanged = Bool()
let validateOnResign = Bool()
extension CGColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let ciColor = CIColor(cgColor: self)
        return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
    }
}

class TextFieldValidator: UITextField, UITextFieldDelegate {
}

class IQPopUp: UIView {
    let showOnRect = CGRect()
    let popWidth = Int()
    let fieldFrame = CGRect()
    let strMsg = NSString()
    let popUpColor = UIColor()
    override func draw(_ rect: CGRect) {
        //let color = CGColorGetComponents(popUpColor.cgColor)
       // UIGraphicsBeginImageContext(CGSize(width: 30, height: 20))
       // let ctx =  UIGraphicsGetCurrentContext()
       // print(color)
        //ctx?.setFillColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    }
}
