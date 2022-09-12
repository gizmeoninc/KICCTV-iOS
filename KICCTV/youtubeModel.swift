//
//  youtubeModel.swift
//  PoppoTv
//
//  Created by Firoze Moosakutty on 13/05/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct youtubeModel: Mappable {
    let key :String?
    let name :String?
    let description :String?
    let channel_name : String?
    let thumbnail : String?
    // Implement this initializer
    
    init(map: Mapper) throws {
        name = map.optionalFrom("name")
        key = map.optionalFrom("key")
        description = map.optionalFrom("description")
        channel_name = map.optionalFrom("channel_name")
        thumbnail = map.optionalFrom("thumbnail")
        
    }
}
