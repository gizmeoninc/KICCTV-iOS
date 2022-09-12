//
//  UITapGestureRecognizer.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 28/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
//extension UITapGestureRecognizer {
//
//  func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
//    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
//    let layoutManager = NSLayoutManager()
//    let textContainer = NSTextContainer(size: CGSize.zero)
//    let textStorage = NSTextStorage(attributedString: label.attributedText!)
//
//    // Configure layoutManager and textStorage
//    layoutManager.addTextContainer(textContainer)
//    textStorage.addLayoutManager(layoutManager)
//
//    // Configure textContainer
//    textContainer.lineFragmentPadding = 0.0
//    textContainer.lineBreakMode = label.lineBreakMode
//    textContainer.maximumNumberOfLines = label.numberOfLines
//    let labelSize = label.bounds.size
//    textContainer.size = labelSize
//
//    // Find the tapped character location and compare it to the specified range
//    let locationOfTouchInLabel = self.location(in: label)
//    let textBoundingBox = layoutManager.usedRect(for: textContainer)
//    let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
//                                      y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
//    let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
//                                                 y: locationOfTouchInLabel.y - textContainerOffset.y);
//    let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//
//    return NSLocationInRange(indexOfCharacter, targetRange)
//  }

//}
