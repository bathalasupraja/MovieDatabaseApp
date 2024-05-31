//
//  MovieNameDatabaseHelper.swift
//  MovieDatabaseApp
//
//  Created by Supraja on 26/05/24.
//

import Foundation

struct MovieName: Codable {
    var title: String?
    var year: String?
    var rated: String?
    var released: String?
    var genre: String?
    var director: String?
    var actors: String?
    var language: String?
    var awards: String?
    var poster: String?
    var imdbID: String?
    var boxOffice: String?
    
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case genre = "Genre"
        case director = "Director"
        case actors = "Actors"
        case language = "Language"
        case awards = "Awards"
        case poster = "Poster"
        case imdbID = "imdbID"
        case boxOffice = "BoxOffice"
    }
}

struct Ratings: Codable {
    var source: String?
    var movieNames: [MovieName]?
    var value: String?
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

class SearchMovieNameDatabaseHelper {
    
    static var shared = SearchMovieNameDatabaseHelper()
    
    private init() {
        
    }
    
    func getIdBy(id: String, completion: @escaping(Ratings?, String?) ->()) {
        let headers = [
            "X-RapidAPI-Key": "5705338e54msh3a15410beec2a87p182995jsn2a8d93a73aa7",
            "X-RapidAPI-Host": "movie-database-alternative.p.rapidapi.com"
        ]
        
        guard let url = URL(string: "https://movie-database-alternative.p.rapidapi.com/?s=\(id)&r=json&page=1") else { completion(nil, "Unable to create URL.")
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, responce, error) -> Void in
            if (error != nil) {
                completion(nil, error?.localizedDescription)
            } else if let data {
                do {
                    let Ratings = try JSONDecoder().decode(Ratings.self, from: data)
                    completion(Ratings, nil)
                } catch {
                    completion(nil, error.localizedDescription)
                }
            } else {
                completion(nil, "No data received!")
            }
        })
        dataTask.resume()
    }
}
