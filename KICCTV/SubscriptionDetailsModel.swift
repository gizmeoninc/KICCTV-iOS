//
//  SubscriptionDetailsModel.swift
//  KICCTV
//
//  Created by Firoze Moosakutty on 21/07/22.
//  Copyright © 2022 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct SubscriptionDetailsModel : Mappable {
  var price : Float?
  var subscription_name : String?
  var subscription_type : Int?

  init(map: Mapper) throws {
    price = map.optionalFrom("price")
    subscription_name = map.optionalFrom("subscription_name")
    subscription_type = map.optionalFrom("subscription_type")
  }
}
