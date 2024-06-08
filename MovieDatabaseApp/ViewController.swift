//
//  ViewController.swift
//  MovieDatabaseApp
//
//  Created by Supraja on 26/05/24.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let helper = MovieDatabaseHelper.shared
    
    private var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        searchTextField.delegate = self
        activityIndicator.stopAnimating()
    }
    
    func didReceiveMovies(_ movies: [Movie]?) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.movies = movies ?? [] /// if no movies setting empty array.
            self?.movieTableView.reloadData()
            if movies?.count ?? 0 > 0 {
                self?.movieTableView.removeNoDataPlaceholder()
            } else {
                self?.movieTableView.setNoDataPlaceholder("No movies found for : \(self?.searchTextField.text ?? "")")
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieDataTableViewCell.id, for: indexPath)
        if let movieDataTableViewCell = cell as? MovieDataTableViewCell {
            let movie = movies[indexPath.row]
            movieDataTableViewCell.prepareMovie(movie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MovieNameDatabaseViewController") as? MovieNameDatabaseViewController
        if let controller {
            controller.movie = movie
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let movieName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            activityIndicator.startAnimating()
            helper.getMovieBy(name: movieName) { [weak self] data, error in
                if let error {
                    print(error)
                    self?.didReceiveMovies(nil)
                } else if let data {
                    self?.didReceiveMovies(data.movies)
                }
            }
        }
    }
}

extension UITableView {
    func setNoDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.text = message
        label.textAlignment = .center
        label.sizeToFit()
        
        self.isScrollEnabled = false
        self.backgroundView = label
        self.separatorStyle = .none
    }
    
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
