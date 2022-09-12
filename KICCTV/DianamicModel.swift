//
//  DianamicModel.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 15/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct DianamicModel: Mappable {
    var id :Int?
    var title :String?
    var data :[VideoModel]?
    
    init(map: Mapper) throws {
        id = map.optionalFrom("id")
        title = map.optionalFrom("title")
        data = map.optionalFrom("data")
    }
}

struct PartnerModel: Mappable {
    var partner_id :Int?
    var partner_name :String?
    var shows :[VideoModel]?
    
    init(map: Mapper) throws {
        partner_id = map.optionalFrom("partner_id")
        partner_name = map.optionalFrom("partner_name")
        shows = map.optionalFrom("shows")
    }
}
struct showmodel: Mappable {
    var category_id :Int?
    var category_name :String?
    var videos :[VideoModel]?
    
    init(map: Mapper) throws {
        category_id = map.optionalFrom("category_id")
        category_name = map.optionalFrom("category_name")
        videos = map.optionalFrom("videos")
    }
}
struct showByCategoryModel: Mappable {
    var category_id :Int?
    var category_name :String?
    var type:String?
    var shows :[VideoModel]?
    
    init(map: Mapper) throws {
        category_id = map.optionalFrom("category_id")
        category_name = map.optionalFrom("category_name")
        shows = map.optionalFrom("shows")
        type = map.optionalFrom("type")

    }
}
struct subtitleModel: Mappable {

  var language_name : String?
  var short_code : String?
    var code : String?
    var subtitle_url : String?

  init(map: Mapper) throws {
    language_name = map.optionalFrom("language_name")
    short_code = map.optionalFrom("short_code")
    code = map.optionalFrom("code")
    subtitle_url = map.optionalFrom("subtitle_url")
  }
}
struct nowPlaying: Mappable {

  var video_title : String?
  var start_time : String?
    var end_time : String?
    var thumbnail : String?

  init(map: Mapper) throws {
    video_title  = map.optionalFrom("video_title")
    thumbnail = map.optionalFrom("thumbnail")
    start_time = map.optionalFrom("start_time")
    end_time = map.optionalFrom("end_time")
  }
}
