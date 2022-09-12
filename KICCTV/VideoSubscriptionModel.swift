//
//  VideoSubscriptionModel.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 18/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct VideoSubscriptionModel: Mappable {
    
    var subscription_name :String?
    var subscription_type_name :String?
    var subscription_type_id :Int?
    var video_id  :Int?
    var pub_id  :Int?
    var id  :Int?
    var subscription_id  :Int?
    var logo :String?
    var description : String?
    var symbol : String?
    var price : Float?
    var ios_keyword : String?
    
    init(map: Mapper) throws {
        
        id = map.optionalFrom("id")
        subscription_id = map.optionalFrom("subscription_id")
        pub_id = map.optionalFrom("pub_id")
        video_id = map.optionalFrom("video_id")
        subscription_name = map.optionalFrom("subscription_name")
        subscription_type_name = map.optionalFrom("subscription_type_name")
        subscription_type_id = map.optionalFrom("subscription_type_id")
        logo = map.optionalFrom("logo")
        description = map.optionalFrom("description")
        symbol = map.optionalFrom("symbol")
        price = map.optionalFrom("price")
        ios_keyword = map.optionalFrom("ios_keyword")
    }
}



