//
//  Model.swift
//  RecipePuppyTestApp
//
//  Created by Pyvovarov Andrii on 26.02.18.
//  Copyright © 2018 Pyvovarov Andrii. All rights reserved.
//

import ObjectMapper
import RealmSwift

class RecipePuppyResponse: Mappable {
    var recipes: [Recipe]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        recipes <- map["results"]
    }
}

class Recipe: Object, Mappable {
    
    dynamic var href: String?
    dynamic var ingredients: String?
    dynamic var thumbnail: String?
    dynamic var title: String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        href <- map["href"]
        ingredients <- map["ingredients"]
        thumbnail <- map["thumbnail"]
        title <- map["title"]
    }
    
    override static func primaryKey() -> String? {
        return "href"
    }
}



