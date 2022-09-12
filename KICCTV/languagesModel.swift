//
//  languagesModel.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 18/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct languagesModel : Mappable {
  var languagename : String?
  var languageid : Int?

  init(map: Mapper) throws {
    languagename = map.optionalFrom("audio_language_name")
    languageid = map.optionalFrom("language_id")
  }
}
