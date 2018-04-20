//
//  TableViewCell.swift
//  Filmer
//
//  Created by Sergey Gusev on 07.03.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import Foundation
import UIKit
class TableViewCell: UITableViewCell {
    let imageCache = NSCache<NSString, UIImage>()
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func commonInit(title: String, poster: UIImage) {
        movieName.text = title
        movieImageView.image = poster
    }
}
