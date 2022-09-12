//
//  LiveGuideModel.swift
//  FantasticFilms
//
//  Created by GIZMEON on 05/10/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct LiveGuideModel:Mappable {
    let starttime : String?
    let endtime : String?
    let video_title : String?
    let video_description : String?
    let thumbnail: String?
    let logo: String?
    let partner_name : String?
    
    init(map: Mapper) throws {
        starttime = map.optionalFrom("starttime")
        endtime = map.optionalFrom("endtime")
        video_title = map.optionalFrom("video_title")
        video_description = map.optionalFrom("video_description")
        thumbnail = map.optionalFrom("thumbnail")
        logo = map.optionalFrom("logo")
        partner_name = map.optionalFrom("partner_name")
        
//       ad_link = map.optionalFrom("ad_link")
    }
}
