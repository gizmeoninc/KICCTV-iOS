//
//  CustomFlowLayout.swift
//  AUSFLIX
//
//  Created by GIZMEON on 08/11/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

class CustomFlowLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let answer = super.layoutAttributesForElements(in: rect)
        for i in 1..<(answer?.count ?? 0) {
            let currentLayoutAttributes: UICollectionViewLayoutAttributes = (answer?[i])!
            let prevLayoutAttributes: UICollectionViewLayoutAttributes = (answer?[i - 1])!
            let maximumSpacing = CGFloat(15)
            let origin = prevLayoutAttributes.frame.maxX
            
            if CGFloat(origin + maximumSpacing) + currentLayoutAttributes.frame.size.width < collectionViewContentSize.width {
                var frame: CGRect = currentLayoutAttributes.frame
                frame.origin.x = CGFloat(origin + maximumSpacing)
                currentLayoutAttributes.frame = frame
            }
        }
        return answer
    }
}
