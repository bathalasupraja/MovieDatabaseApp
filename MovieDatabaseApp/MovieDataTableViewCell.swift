//
//  MovieDataTableViewCell.swift
//  MovieDatabaseApp
//
//  Created by Supraja on 26/05/24.
//

import UIKit

class MovieDataTableViewCell: UITableViewCell {
    
    static let id = "MovieDataTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imdbIdLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
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
    
    func prepareMovie(_ movie: Movie) {
        nameLabel.text = movie.title
        yearLabel.text = movie.year
        imdbIdLabel.text = movie.imdbID
        
        /// Download image
        downloadQueue.async { [weak self] in
            if let urlString = movie.poster, let url = URL(string: urlString) {
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
