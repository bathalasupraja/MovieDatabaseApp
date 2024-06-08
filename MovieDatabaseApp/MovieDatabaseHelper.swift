//
//  MovieDatabaseHelper.swift
//  MovieDatabaseApp
//
//  Created by Supraja on 26/05/24.
//

import Foundation

struct MovieDetails: Codable {
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
    var movieDetails: [MovieDetails]?
    var value: String?
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

// What is shared instance or singleton?
// Singleton is a design pattern that ensures a class can have only one object instance throughout the app memory and provide all the code functionality through a single point of access to it.

struct Movie: Codable {
    var poster: String?
    var title: String?
    var type: String?
    var year: String?
    var imdbID: String?
    
    enum CodingKeys: String, CodingKey {
        case poster = "Poster"
        case title = "Title"
        case type = "Type"
        case year = "Year"
        case imdbID = "imdbID"
    }
}

struct ResponseData: Codable {
    var response: String?
    var movies: [Movie]? /// originally it should be search, but for naming convension changed as movies.
    var totalResults: String?
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case movies = "Search"
        case totalResults = "totalResults"
    }
}

class MovieDatabaseHelper {
    
    static var shared = MovieDatabaseHelper()
    
    private init() {
        
    }
    
    func getMovieBy(name: String, completion: @escaping(ResponseData?, String?) ->()) {
        let headers = [
            "X-RapidAPI-Key": "5705338e54msh3a15410beec2a87p182995jsn2a8d93a73aa7",
            "X-RapidAPI-Host": "movie-database-alternative.p.rapidapi.com"
        ]
        
        guard let url = URL(string: "https://movie-database-alternative.p.rapidapi.com/?s=\(name)&r=json&page=1") else { completion(nil, "Unable to create URL.")
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(nil, error?.localizedDescription)
            } else if let data {
                do {
                    let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
                    completion(responseData, nil)
                } catch {
                    completion(nil, error.localizedDescription)
                }
            } else {
                completion(nil, "No data received!")
            }
        })
        dataTask.resume()
    }
    
    
    func getMovieBy(id: String, completion: @escaping(Ratings?, String?) ->()) {
        
        let headers = [
            "x-rapidapi-key": "5705338e54msh3a15410beec2a87p182995jsn2a8d93a73aa7",
            "x-rapidapi-host": "imdb-top-100-movies.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://imdb-top-100-movies.p.rapidapi.com/\(id)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })
        
        dataTask.resume()
    }
}
