//
//  DetailedViewController.swift
//  Filmer
//
//  Created by Sergey Gusev on 07.03.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    var overview: String = ""
    var releaseDate: String = ""
    var poster: UIImage?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        overviewLabel.text = overview
        dateLabel.text = "Date of release: " + releaseDate
        image.image = poster
    }
    func commonInit(overview: String, releaseDate: String, poster: UIImage) {
        self.overview = overview
        self.releaseDate = releaseDate
        self.poster = poster
    }
    deinit {
        print("deinit called")
    }
    
}
