//
//  Collection.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 28/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}
