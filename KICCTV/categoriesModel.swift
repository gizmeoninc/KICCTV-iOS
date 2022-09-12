//
//  categoriesModel.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 18/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct categoriesModel: Mappable {

  var category_name : String?
  var category_id : Int?


  init(map: Mapper) throws {
    category_name = map.optionalFrom("category_name")
    category_id = map.optionalFrom("category_id")
  }
}

struct categoryModel: Mappable {

  var categoryname : String?
  var categoryid : Int?
    var image :String?


  init(map: Mapper) throws {
    categoryname = map.optionalFrom("categoryname")
    categoryid = map.optionalFrom("categoryid")
    image = map.optionalFrom("image")

  }
}

struct awardModel: Mappable {
    var award_name : String?
    var award_description : String?
    var thumbnail :String?
    var year : Int?
    init(map: Mapper) throws {
        award_name = map.optionalFrom("award_name")
        award_description = map.optionalFrom("award_description")
        thumbnail = map.optionalFrom("thumbnail")
        year = map.optionalFrom("year")
    }
}
struct castModel: Mappable {
    var name : String?
    var role : String?
    var image :String?
    var id : Int?
    init(map: Mapper) throws {
        name = map.optionalFrom("name")
        role = map.optionalFrom("role")
        image = map.optionalFrom("image")
        id = map.optionalFrom("id")
    }
}
struct keyArtWorkModel: Mappable {
    var description : String?
    var title : String?
    var image :String?
    var id : Int?
    init(map: Mapper) throws {
        description = map.optionalFrom("description")
        title = map.optionalFrom("title")
        image = map.optionalFrom("image")
        id = map.optionalFrom("id")
    }
}
