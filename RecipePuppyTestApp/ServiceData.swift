//
//  ApiManager.swift
//  RecipePuppyTestApp
//
//  Created by Pyvovarov Andrii on 28.02.18.
//  Copyright © 2018 Pyvovarov Andrii. All rights reserved.
//

import Alamofire
import RealmSwift

class ServiceData {
    
    class func downloadFullList() {
        getFullList(completion: { result in
            if let recipes = result?.recipes {
                try! Realm().write() {
                    for recipe in recipes {
                       try! Realm().add(recipe, update: true)
                    }
                }
            }
        })
    }
 
    class func getFullList(completion: @escaping DownloadComplete) {
        getJsonFromRequest(url: BASE_API_URL_STRING, completion)
    }
    
    class func getSearchList(searchWord: String, completion: @escaping DownloadComplete) {
        getJsonFromRequest(url: BASE_API_URL_SEARCH_STRING + searchWord, completion)
    }
    
    fileprivate class func getJsonFromRequest(url: String, _ completion: @escaping DownloadComplete) {
        Alamofire.request(url).responseString { response in
            switch response.result {
                case .success:
                    if let json = response.result.value {
                        let recipes = RecipePuppyResponse(JSONString: json)
                                completion(recipes)
                            }
                case .failure(let error):
                    completion(nil)
                print(error.localizedDescription)
            }
        }
    }
}
