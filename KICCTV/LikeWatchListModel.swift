//
//  LikeWatchListModel.swift
//  AUSFLIX
//
//  Created by GIZMEON on 31/01/20.
//  Copyright © 2020 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct LikeWatchListModel: Mappable {
    let liked_flag : Int?
    let watchlist_flag : Int?

    // Implement this initializer
    init(map: Mapper) throws {
        liked_flag = map.optionalFrom("liked_flag")
        watchlist_flag = map.optionalFrom("watchlist_flag")
    }
}
