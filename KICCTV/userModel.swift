////
//  userModel.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 07/02/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct userModel: Mappable {

  let user_email : String?
  let first_name : String?
  let user_image : String?
  let user_id : Int?
  let phone : String?

  // Implement this initializer
  init(map: Mapper) throws {
    user_email = map.optionalFrom("user_email")
    first_name = map.optionalFrom("first_name")
    user_image = map.optionalFrom("user_image")
    user_id = map.optionalFrom("user_id")
    phone = map.optionalFrom("phone")
  }
}
