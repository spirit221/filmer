//
//  GetTop25Detailed.swift
//  Filmer
//
//  Created by Sergey Gusev on 10.03.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import Foundation
import UIKit
class GetTop25Detailed  {
    let searchUrl = "https://itunes.apple.com/lookup?id="
    typealias dictionaryJSON = [String:Any]
    var movies: [Films] = []
    let decode = DecodeJSON()
    func download(id: String, finished: @escaping (([Films])->Void)){
        let group = DispatchGroup()
        guard let jsonURL = URL(string: searchUrl + id) else {
            print("error in name")
            return
        }
        URLSession.shared.dataTask(with: jsonURL, completionHandler: { (data, _, error) in
            guard let data = data else { return }
            let jsonALL: [dictionaryJSON] = self.decode.getRandomFilm(data: data)
            for single in jsonALL {
                let longDescription = single["longDescription"] as? String ?? "No Description"
                guard let releaseDate = single["releaseDate"] as? String,
                    let primaryGenreName = single["primaryGenreName"] as? String else {
                        print("error in json[artistName1]")
                        return
                }
                group.enter()
                self.movies.append(Films(nameFilm: "", poster: #imageLiteral(resourceName: "picture1"), voteAverage: id, releaseDate: releaseDate, overview: longDescription, primaryGenreName: primaryGenreName))
                group.leave()
                group.notify(queue: .main, execute: {
                    finished(self.movies)
                })
            }
        }).resume()
        
    }
}
