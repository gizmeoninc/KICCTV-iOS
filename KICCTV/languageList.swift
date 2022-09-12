//
//  languageList.swift
//  AUSFLIX
//
//  Created by Firoze Moosakutty on 12/11/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct languageList: Mappable {

      let audio_language_id :Int?
      let language_name :String?
      let language_icon :String?
      var status :String?
      let audio_language_name : String?
      var selected :Bool?

    init(map: Mapper) throws {
        audio_language_id = map.optionalFrom("audio_language_id")
        language_name = map.optionalFrom("language_name")
        language_icon = map.optionalFrom("language_icon")
        status = map.optionalFrom("status")
        audio_language_name = map.optionalFrom("audio_language_name")
        selected = map.optionalFrom("selected")
  }
}
