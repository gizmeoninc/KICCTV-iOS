//
//  String.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 28/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func numberOfSeconds() -> Int {
        var components: Array = self.components(separatedBy: ":")
        var hours = Int()
        var minutes = Int()
        var seconds = Int()
        if components.count == 3 {
            hours = Int(components[0]) ?? 0
            minutes = Int(components[1]) ?? 0
            seconds = Int(components[2]) ?? 0
        } else if components.count == 2 {
            hours = 0
            minutes = Int(components[0]) ?? 0
            seconds = Int(components[1]) ?? 0
        } else{
            hours = 0
            minutes = 0
            seconds = 0
        }
        return (hours * 3600) + (minutes * 60) + seconds
    }
}
