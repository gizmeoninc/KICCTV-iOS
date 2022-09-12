//
//  PhoneVerifiedModel.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 20/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//


import Foundation
import Mapper

struct PhoneVerifiedModel: Mappable {
    
    var phone :String?
    var phone_verified_flag  :Int?
    
    init(map: Mapper) throws {
        
        phone = map.optionalFrom("phone")
        phone_verified_flag = map.optionalFrom("phone_verified_flag")
    }
}
