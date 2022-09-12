//
//  ChannelVideos.swift
//  MyVideoApp
//
//  Created by Gizmeon on 15/02/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit

class ChannelVideos: NSObject {
    
    var ad_link : String?
    var email : String?
    var first_name : String?
    var user_image : String?
    var video_description : String?
    var video_id : String?
    var video_name : String?
    var video_title : String?
    var thumbnail : String?

    
    // Returns an initialized video.
    init(ad_link: String, email: String!, first_name: String, user_image: String ,video_description: String ,video_id: String ,video_name: String ,video_title: String,thumbnail:String?) {
        self.ad_link = ad_link
        self.email = email
        self.first_name = first_name
        self.user_image = user_image
        self.video_description = video_description
        self.video_id = video_id
        self.video_name = video_name
        self.video_title = video_title
        self.thumbnail = thumbnail as String?
    }

}
