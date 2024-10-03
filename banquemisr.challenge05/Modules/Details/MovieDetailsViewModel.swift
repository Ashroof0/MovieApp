//
//  MovieDetailsViewModel.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 03/10/2024.
//

import UIKit

class MovieDetailsViewModel {
    var movieDetails: MovieDetails?
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, ErrorMessage>) -> Void) {
        print("Fetching details for movie ID: \(movieId)") // Debugging line
        NetworkService.shared.getMovieDetails(for: movieId) { result in
            switch result {
            case .success(let details):
                print("Fetched Movie Details: \(details)") // Log the fetched details
                completion(.success(details))
            case .failure(let error):
                print("Error fetching movie details: \(error)") // Log the error
                completion(.failure(error))
            }
        }
    }

    
    func downloadImage(from posterPath: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        NetworkService.shared.downloadImage(from: posterPath, completion: completion)
    }
}
