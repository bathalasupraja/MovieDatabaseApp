//
//  MovieNameTableViewCell.swift
//  MovieDatabaseApp
//
//  Created by Supraja on 26/05/24.
//

import UIKit

class MovieNameTableViewCell: UITableViewCell {
    
    static let id = "MovieNameTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var awardsLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var boxOfficeLabel: UILabel!
    @IBOutlet weak var imdbIDLabel: UILabel!
    
    let downloadQueue = DispatchQueue(label: "com.image.download.queue", qos: .background)

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 6
        posterImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareMovieName(_ movieName: MovieName) {
        titleLabel.text = movieName.title
        yearLabel.text = movieName.year
        ratedLabel.text = movieName.rated
        releasedLabel.text = movieName.released
        genreLabel.text = movieName.genre
        directorLabel.text = movieName.director
        actorsLabel.text = movieName.actors
        languageLabel.text = movieName.language
        awardsLabel.text = movieName.awards
        languageLabel.text = movieName.language
        boxOfficeLabel.text = movieName.boxOffice
        imdbIDLabel.text = movieName.imdbID
        
        /// Download image
        downloadQueue.async { [weak self] in
            if let urlString = movieName.poster, let url = URL(string: urlString) {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async { [weak self] in
                        self?.posterImageView.image = UIImage(data: data)
                    }
                } catch {
                   print("unable to load poster \(url)")
                }
            }
        }
    }
}
