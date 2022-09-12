//
//  TokenDataModel.swift
//  PoppoTv
//
//  Created by Firoze Moosakutty on 07/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct TokenDataModel: Mappable {
    
    var rewarded_status :String?
    var app_id :String?
    var banner_id :String?
    var rewarded_id :String?
    var interstitial_id :String?
    var mobpub_interstitial_status :String?
    var mobpub_interstitial_id :String?
    var mobpub_banner_id :String?
    var interstitial_status : String?
    var token : String?
    var pubid : String?
    
    init(map: Mapper) throws {
       
        rewarded_status = map.optionalFrom("rewarded_status")
        app_id = map.optionalFrom("app_id")
        banner_id = map.optionalFrom("banner_id")
        rewarded_id = map.optionalFrom("rewarded_id")
        interstitial_id = map.optionalFrom("interstitial_id")
        mobpub_interstitial_status = map.optionalFrom("mobpub_interstitial_status")
        mobpub_interstitial_id = map.optionalFrom("mobpub_interstitial_id")
        mobpub_banner_id = map.optionalFrom("mobpub_interstitial_id")
        interstitial_status = map.optionalFrom("mobpub_interstitial_id")
        token = map.optionalFrom("token")
        pubid = map.optionalFrom("pubid")
        
    }
}



