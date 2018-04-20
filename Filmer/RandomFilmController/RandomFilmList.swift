//
//  RandomFilmList.swift
//  Filmer
//
//  Created by Sergey Gusev on 07.03.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//
import UIKit
import Foundation
class RandomFilmList {
    
    var imageCache = NSMutableDictionary()
    let decode = DecodeJSON()
    typealias dictionaryJSON = [String:Any]
    func getFilmId(finished: @escaping ((Films)->Void)){
        let group = DispatchGroup()
        let randomNumber = Int(arc4random_uniform(UInt32(100)))
        print(randomNumber)
        guard let jsonURL = URL(string: Constants.hostUrl + Constants.apiKey + Constants.parameters + Constants.page + "\(randomNumber)") else {
            print("error in listFilmId")
            return
        }
        URLSession.shared.dataTask(with: jsonURL, completionHandler: { (data, _, _) in
            guard let data = data else { return }
            let jsonALL = self.decode.getRandomFilm(data: data)
            
            let randomFilm = Int(arc4random_uniform(UInt32(jsonALL.count)))
            if randomFilm < 1 {
                print("\n\n\n\n\n\n1111111w")
                return
            }
            guard let filmName = jsonALL[randomFilm]["title"] as? String  else { return }
            guard let poster = jsonALL[randomFilm]["poster_path"] as? String else {
                print("poster fault")
                return
            }
            print(jsonALL[randomFilm])
            let voteAverage = jsonALL[randomFilm]["vote_average"] as? String ?? ""
            let releaseDate = jsonALL[randomFilm]["release_date"] as? String ?? "nil"
            let overview = jsonALL[randomFilm]["overview"] as? String ?? "nil"
            group.enter()
            guard let url = URL(string: Constants.posterUrl + poster) else { return }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
                guard let data = data, let posterImage = UIImage(data: data) else { return }
                let film = Films(nameFilm: filmName, poster: posterImage, voteAverage: voteAverage, releaseDate: releaseDate, overview: overview, primaryGenreName: "nil")
                group.leave()
                group.notify(queue: .main, execute: {
                    finished(film)
                })
            }).resume()
        }).resume()
    }
}
