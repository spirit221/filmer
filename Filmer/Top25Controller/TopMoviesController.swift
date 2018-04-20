//
//  TopMoviesController.swift
//  Filmer
//
//  Created by Sergey Gusev on 07.03.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import Foundation
import UIKit
class TopMoviesController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var movies: [Films] = []
    let getTopList = GetTopList()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top 25 movies"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
        
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
//        tableView.addSubview(refreshControl)
       // collectionView.refreshControl = refreshControlrefresh
        
        self.navigationController?.delegate = self
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "tableViewCell")
        getMoviesTop()
    }
    @objc func refresh(sender:AnyObject) {
        getMoviesTop()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? TableViewCell
        cell?.commonInit(title: movies[indexPath.item].nameFilm, poster: movies[indexPath.item].poster)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let top25Detailed = Top25DetailedController(nibName: "Top25DetailedController", bundle: nil)
        top25Detailed.commonInit(title: movies[indexPath.item].nameFilm, poster: movies[indexPath.item].poster, id: movies[indexPath.item].voteAverage)
        //detailed.commonInit(overview: overview, releaseDate: releaseDate, poster: poster)
        self.navigationController?.pushViewController(top25Detailed, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getMoviesTop() {
        movies.removeAll()
        getTopList.download() { [weak self] movies in
            self?.activityIndicator.removeFromSuperview()
            self?.movies = movies
            self?.tableView.separatorStyle = .singleLine
            self?.tableView.reloadData()
            
        }
    }
}

