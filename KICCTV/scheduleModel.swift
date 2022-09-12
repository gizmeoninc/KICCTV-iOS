//
//  scheduleModel.swift
//  AUSFLIX
//
//  Created by GIZMEON on 31/01/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//
import Foundation
import Mapper

struct scheduleModel: Mappable {
  let end_time : String?
  let channel_id : Int?
  let start_time : String?
  let video_id : Int?
  let schedule_date : String?
  let video_title : String?
  let duration : String?
  let video_duration : String?
   let thumbnail : String?



  // Implement this initializer
  init(map: Mapper) throws {
    end_time = map.optionalFrom("end_time")
    channel_id = map.optionalFrom("channel_id")
    start_time = map.optionalFrom("start_time")
    video_id = map.optionalFrom("video_id")
    schedule_date = map.optionalFrom("schedule_date")
    video_title = map.optionalFrom("video_title")
    duration = map.optionalFrom("duration")
    video_duration = map.optionalFrom("video_duration")
    thumbnail = map.optionalFrom("thumbnail")
  }
}

