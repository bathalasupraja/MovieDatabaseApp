//
//  MovieNameDatabaseViewController.swift
//  MovieDatabaseApp
//
//  Created by Supraja on 26/05/24.
//

import UIKit

class MovieNameDatabaseViewController: UIViewController {
    
    @IBOutlet weak var movieNameTableView: UITableView!
    
    private let helper = MovieDatabaseHelper.shared
    
    private var movieDetails = [MovieDetails]()
    
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie, let id = movie.imdbID {
            self.title = movie.title
            helper.getMovieBy(id: id) { rattings, error in
                print(rattings)
            }
        }
        
        movieNameTableView.dataSource = self
        movieNameTableView.delegate = self
    }
    
    func didReceiveMovieById(_ movieDetail: [MovieDetails]?) {
        DispatchQueue.main.async { [weak self] in
            self?.movieDetails = movieDetail ?? []
            self?.movieNameTableView.reloadData()
            if movieDetail?.count ?? 0 > 0 {
                self?.movieNameTableView.removeNoDataPlaceholder()
            } else {
                self?.movieNameTableView.setNoDataPlaceholder("\(self?.title ?? "") details not found!")
            }
        }
    }
}

extension MovieNameDatabaseViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieNameTableViewCell.id, for: indexPath)
        if let movieNameTableViewCell = cell as? MovieNameTableViewCell {
            let movieDetail = movieDetails[indexPath.row]
            movieNameTableViewCell.prepareMovieDetails(movieDetail)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        420
    }
}
