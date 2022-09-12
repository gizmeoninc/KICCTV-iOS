//
//  ShowDetailsModel.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 18/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct ShowDetailsModel: Mappable {
    let ad_link : String?
    let teaser_duration : String?
    let email : String?
    let user_email : String?
    let first_name : String?
    let user_image : String?
    let video_description : String?
    let description : String?
    let single_video : Int?
    let video_id : Int?
    let video_name : String?
    let video_title : String?
    let rating : String?
    let hide_subscription : Bool?

    let thumbnail : String?
    let banner : String?
    let video_tag : String?
    let video_duration : String?
    let view_count : Int?
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
    let number_of_rating:Int?

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
    let year : String?
    let director: String?
    let show_cast: String?
    let parental_control : String?
    let synopsis : String?
    let our_take : String?
    let imdb_rating : Double?
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
    var shows :[VideoModel]?
    var videos :[VideoModel]?
    var metadata : [VideoModel]?
    var categories : [categoriesModel]?
    var languages : [languagesModel]?
    var awards : [awardModel]?
    var cast : [castModel]?
    var keyArtWork : [keyArtWorkModel]?
    var subscriptions : [SubscriptionDetailsModel]?
    let duration_text : String?
    
    init(map: Mapper) throws {
        metadata = map.optionalFrom("metadata")
        videos = map.optionalFrom("videos")
        categories = map.optionalFrom("categories")
        languages = map.optionalFrom("languages")
        ad_link = map.optionalFrom("ad_link")
        email = map.optionalFrom("email")
        user_email = map.optionalFrom("user_email")
        first_name = map.optionalFrom("first_name")
        user_image = map.optionalFrom("user_image")
        video_description = map.optionalFrom("video_description")
        description = map.optionalFrom("description")
        video_id = map.optionalFrom("video_id")
        single_video = map.optionalFrom("single_video")
        hide_subscription = map.optionalFrom("hide_subscription")
        
        rating = map.optionalFrom("rating")
        our_take = map.optionalFrom("our_take")

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
        imdb_rating = map.optionalFrom("imdb_rating")
        number_of_rating = map.optionalFrom("number_of_rating")

        logo = map.optionalFrom("logo")
        logo_thumb = map.optionalFrom("logo_thumb")
        thumbnail_350_200 = map.optionalFrom("thumbnail_350_200")
        duration_text = map.optionalFrom("duration_text")

        
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
        shows = map.optionalFrom("shows")
        awards = map.optionalFrom("awards")
        cast = map.optionalFrom("cast")
        keyArtWork = map.optionalFrom("key_art_work")

    }
}
