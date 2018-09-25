//
//  Constants.swift
//  RecipePuppyTestApp
//
//  Created by Pyvovarov Andrii on 30.02.18.
//  Copyright © 2018 Pyvovarov Andrii. All rights reserved.
//

let BASE_API_URL_STRING = "http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=3"
let BASE_API_URL_SEARCH_STRING = "http://www.recipepuppy.com/api/?q="

typealias DownloadComplete = (_ recipe: RecipePuppyResponse?) -> Void
