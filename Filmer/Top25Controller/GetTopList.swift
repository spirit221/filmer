//
//  GetTopList.swift
//  Filmer
//
//  Created by Sergey Gusev on 07.03.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import Foundation
import UIKit

class GetTopList {
    let imageCache = NSCache<NSString, UIImage>()
    let searchUrl = "https://rss.itunes.apple.com/api/v1/us/movies/top-movies/all/25/explicit.json"
    typealias dictionaryJSON = [String:Any]
    var movies: [Films] = []
    let decode = DecodeJSON()
    func download(finished: @escaping (([Films])->Void)){
        let group = DispatchGroup()
        self.movies.removeAll()
        guard let jsonURL = URL(string: searchUrl) else {
            print("error in name")
            return
        }
        URLSession.shared.dataTask(with: jsonURL, completionHandler: { (data, _, error) in
            guard let data = data
                else {
                    print("no internet")
                    return
            }
            let jsonALL: [dictionaryJSON] = self.decode.getResult(data: data)
            for single in jsonALL {
                print(single)
                guard let nameFilm = single["name"] as? String,
                    //                    let id = single["id"] as? Int,
                    let artworkUrl = single["artworkUrl100"] as? String else {
                        print("error in json[artistName1]")
                        return
                }
                guard let id = single["id"] as? String else {return}
                print(id)
                let mySubstring = artworkUrl.replacingOccurrences(of: "200x200bb", with: "100x100bb")
                guard let url = URL(string: mySubstring) else {
                    print("error in json[artistName2]")
                    return
                }
                group.enter()
                URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
                    guard let data = data, let artworkUrl100 = UIImage(data: data) else {
                        print("error in download top film poster")
                        return }
                    self.movies.append(Films(nameFilm: nameFilm, poster: artworkUrl100, voteAverage: id, releaseDate: "nil", overview: "nil", primaryGenreName: "nil"))
                    group.leave()
                }).resume()
                group.notify(queue: .main, execute: {
                    finished(self.movies)
                })
            }
        }).resume()
        
    }
}
