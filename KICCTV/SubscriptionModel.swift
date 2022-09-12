//
//  SubscriptionModel.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 12/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct SubscriptionModel: Mappable {
    
    var sub_id :Int?
    var valid_from :String?
    var valid_to :String?
    var subscription_name :String?
    var subscription_type_name :String?
    var subscription_type_id :Int?
    var mode_of_payment : String?
    var price : Float?
    var symbol : String?
    
    init(map: Mapper) throws {
        
        sub_id = map.optionalFrom("sub_id")
        valid_from = map.optionalFrom("valid_from")
        valid_to = map.optionalFrom("valid_to")
        subscription_name = map.optionalFrom("subscription_name")
        subscription_type_name = map.optionalFrom("subscription_type_name")
        subscription_type_id = map.optionalFrom("subscription_type_id")
        mode_of_payment = map.optionalFrom("mode_of_payment")
        price = map.optionalFrom("price")
        symbol = map.optionalFrom("symbol")
    }
}



