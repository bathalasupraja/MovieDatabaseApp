//
//  MovieNameDatabaseViewController.swift
//  MovieDatabaseApp
//
//  Created by Supraja on 26/05/24.
//

import UIKit

class MovieNameDatabaseViewController: UIViewController {
    
    @IBOutlet weak var MovieNameTableView: UITableView!
    
    private let helper = SearchMovieNameDatabaseHelper.shared
    
    private var movieNames = [MovieName]()

    override func viewDidLoad() {
        super.viewDidLoad()
        MovieNameTableView.dataSource = self
        MovieNameTableView.delegate = self
    }
}

extension MovieNameDatabaseViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieNameTableViewCell.id, for: indexPath)
        if let movieNameTableViewCell = cell as? MovieNameTableViewCell {
            let movieName = movieNames[indexPath.row]
            movieNameTableViewCell.prepareMovieName(movieName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        335
    }
}
