//
//  VideoModel.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 01/03/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct VideoModel: Mappable {
  let ad_link : String?
    let news_id : Int?
    let event_id : Int?
    let live_url : String?
    let teaser_duration : String?
  let email : String?
    let season : Int?
     let user_email : String?
  let first_name : String?
  let user_image : String?
  let video_description : String?
    let description : String?
    let single_video : Int?
  let video_id : Int?
  let video_name : String?
  let video_title : String?
  let thumbnail : String?
  let banner : String?
  let video_tag : String?
    let week : String?
  let video_duration : String?
   let watched_duration : Int?
  let view_count : Int?
    let watched_percentage : Int?
    let duration_text : String?
  let user_id : Int?
  let live_link: String?
  let logo :String?
    let logo_thumb :String?
    let thumbnail_350_200 :String?
  let channel_name :String?
  let channel_id :Int?
  let live_flag :Int?
  let category :String?
  let categoryid :Int?
  let categoryname :String?
  let name:String?
  let partner_id :String?
  let genre_icon :String?
  let language_id :Int?
  let language_name :String?
  let language_icon :String?
  var status :String?
  var liked_flag :Int?
  var disliked_flag : Int?
  var query :String?
  var countryCode :String?
  var lat :Int?
  var lon :Int?
  var selected :Bool?
  var validity :Int?
  let show_id :Int?
  let show_name : String?
  let genre_id :Int?
  let delete_status:Int?
  let rewarded_status:Int?
  let premium_flag:Int?
   let is_free_video : Bool?
    let free_video : Bool?
  let hide_subscription : Bool?
  let subscriptions :[SubscriptionDetailsModel]?

  let year : String?
  let director: String?
  let show_cast: String?
  let parental_control : String?
  let synopsis : String?
  let teaser : String?
  let theme_name : String?
  let producer : String?
  let audio : String?
  let subtitle : String?
  let resolution : String?
  let video_flag : Int?
  let image : String?
  let theme : String?
  let category_id : [Int]?
  let languageid : [Int]?
  let category_name : [String]?
  let languagename : [String]?
  let teaser_flag : Int?
  let teaser_status_flag : Int?
  let watchlist_flag : Int?
  let payper_flag:Int?
  let rental_flag: Int?
    var videos :[VideoModel]?
    var shows :[VideoModel]?
    var subtitles :[subtitleModel]?
    let now_playing : nowPlaying?

    let starttime : String?
    let endtime : String?
    let day : String?
    let type : String?
    let images :[String]?
    let video_tags:[String]?
  // Implement this initializer
  init(map: Mapper) throws {
      event_id = map.optionalFrom("event_id")
    subtitles = map.optionalFrom("subtitles")
    now_playing = map.optionalFrom("now_playing")
    watched_duration = map.optionalFrom("watched_duration")
      watched_percentage = map.optionalFrom("watched_percentage")
      duration_text = map.optionalFrom("duration_text")
      news_id = map.optionalFrom("news_id")
      live_url = map.optionalFrom("live_url")
    type = map.optionalFrom("type")
    images = map.optionalFrom("images")
      video_tags = map.optionalFrom("video_tags")
    starttime = map.optionalFrom("starttime")
    endtime = map.optionalFrom("endtime")
    ad_link = map.optionalFrom("ad_link")
    email = map.optionalFrom("email")
      season = map.optionalFrom("season")
    user_email = map.optionalFrom("user_email")
    first_name = map.optionalFrom("first_name")
    user_image = map.optionalFrom("user_image")
    video_description = map.optionalFrom("video_description")
    description = map.optionalFrom("description")
    video_id = map.optionalFrom("video_id")
    single_video = map.optionalFrom("single_video")
      is_free_video = map.optionalFrom("is_free_video")
      free_video = map.optionalFrom("free_video")
    video_name = map.optionalFrom("video_name")
    video_title = map.optionalFrom("video_title")
    teaser_duration = map.optionalFrom("teaser_duration")
    thumbnail = map.optionalFrom("thumbnail")
    banner = map.optionalFrom("banner")
    video_tag = map.optionalFrom("video_tag")
    video_duration = map.optionalFrom("video_duration")
    view_count = map.optionalFrom("view_count")
    user_id = map.optionalFrom("user_id")
    live_link = map.optionalFrom("live_link")
    logo = map.optionalFrom("logo")
    week = map.optionalFrom("week")
    hide_subscription = map.optionalFrom("hide_subscription")
    subscriptions = map.optionalFrom("subscriptions")

    logo_thumb = map.optionalFrom("logo_thumb")
    thumbnail_350_200 = map.optionalFrom("thumbnail_350_200")


    channel_name = map.optionalFrom("channel_name")
    channel_id = map.optionalFrom("channel_id")
    live_flag = map.optionalFrom("live_flag")
    category = map.optionalFrom("category")
    categoryid = map.optionalFrom("categoryid")
    partner_id = map.optionalFrom("partner_id")
    name = map.optionalFrom("name")

    genre_icon = map.optionalFrom("genre_icon")
    language_id = map.optionalFrom("language_id")
    language_name = map.optionalFrom("language_name")
    language_icon = map.optionalFrom("language_icon")
    status = "false"
    liked_flag = map.optionalFrom("liked_flag")
    disliked_flag = map.optionalFrom("disliked_flag")
    image = map.optionalFrom("image")
    
    theme_name = map.optionalFrom("theme_name")
    query = map.optionalFrom("query")
    countryCode = map.optionalFrom("countryCode")
    lat = map.optionalFrom("lat")
    lon = map.optionalFrom("lon")
    selected = map.optionalFrom("selected")
    validity = map.optionalFrom("validity")
    show_id = map.optionalFrom("show_id")
    show_name = map.optionalFrom("show_name")
    genre_id = map.optionalFrom("genre_id")
    delete_status = map.optionalFrom("delete_status")
    rewarded_status = map.optionalFrom("rewarded_status")
    premium_flag = map.optionalFrom("premium_flag")
    payper_flag = map.optionalFrom("payper_flag")
    rental_flag = map.optionalFrom("rental_flag")
    
    year = map.optionalFrom("year")
    show_cast = map.optionalFrom("show_cast")
    director = map.optionalFrom("director")
    parental_control = map.optionalFrom("parental_control")
    synopsis = map.optionalFrom("synopsis")
    teaser = map.optionalFrom("teaser")
    producer = map.optionalFrom("producer")
    audio = map.optionalFrom("audio")
    subtitle = map.optionalFrom("subtitle")
    resolution = map.optionalFrom("resolution")
    video_flag = map.optionalFrom("video_flag")
    theme = map.optionalFrom("theme")
    category_name = map.optionalFrom("category_name")
    category_id = map.optionalFrom("category_id")
    languagename = map.optionalFrom("languagename")
    languageid = map.optionalFrom("languageid")
    categoryname = map.optionalFrom("categoryname")
    teaser_flag = map.optionalFrom("teaser_flag")
    teaser_status_flag = map.optionalFrom("teaser_status_flag")
    watchlist_flag = map.optionalFrom("watchlist_flag")
    videos = map.optionalFrom("videos")
    shows = map.optionalFrom("shows")
    day = map.optionalFrom("day")


  }
}
