//
//  DecodeJSON.swift
//  Filmer
//
//  Created by Sergey Gusev on 04.03.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import Foundation
class DecodeJSON {
    typealias dictionaryJSON = [String:Any]

    func getFilmInfo(data: Data) -> dictionaryJSON {
        guard let jsonOfResult = try? JSONSerialization.jsonObject(with: data, options: [])  as!  dictionaryJSON else {
            print("error in serialization!")
            return ["":""]
        }
        return jsonOfResult
    }
    func getRandomFilm (data: Data) -> [dictionaryJSON] {
        guard let jsonOfResult = try? JSONSerialization.jsonObject(with: data, options: [])  as!  dictionaryJSON else {
            print("error in serialization")
            return []
        }
        guard let jsonALL = jsonOfResult["results"] as? [dictionaryJSON] else {
            print("error in serialization results2")
            return []
        }
        return jsonALL
    }
    func getResult(data: Data) -> [dictionaryJSON] {
        guard let jsonOfResult = try? JSONSerialization.jsonObject(with: data, options: [])  as!  dictionaryJSON else {
            print("error in serialization")
            return []
        }
        guard let jsonOfResult1 = jsonOfResult["feed"] as?  dictionaryJSON else {
            print("error in serialization")
            return []
        }
        guard let jsonALL = jsonOfResult1["results"] as? [dictionaryJSON] else {
            print("error in serialization results3")
            return []
        }
        return jsonALL
    }
}
