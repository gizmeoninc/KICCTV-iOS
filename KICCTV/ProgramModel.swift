//
//  ProgramModel.swift
//  PoppoTv
//
//  Created by GIZMEON on 28/05/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct ProgramModel: Mappable {
    let program_name :String?
    let channel_id :String?
    let image :String?
    let status_flag : String?
    let date : String?
    let start_time : String?
    let end_time : String?
    // Implement this initializer
    
    init(map: Mapper) throws {
        program_name = map.optionalFrom("program_name")
        channel_id = map.optionalFrom("channel_id")
        image = map.optionalFrom("image")
        status_flag = map.optionalFrom("status_flag")
        date = map.optionalFrom("date")
        start_time = map.optionalFrom("start_time")
        end_time = map.optionalFrom("end_time")
        
    }
}
