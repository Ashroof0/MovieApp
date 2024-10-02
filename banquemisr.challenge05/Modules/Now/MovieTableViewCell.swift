//
//  MovieTableViewCell.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 02/10/2024.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
    }
}
    
