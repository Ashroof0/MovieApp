//
//  NowViewModel.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 02/10/2024.
//

import Foundation
import CoreData
import UIKit

enum MovieCategory: String {
    case nowPlaying = "now_playing"
    case popular = "popular"
    case upcoming = "upcoming"
}

class MovieViewModel {
    
    var movies: [Movie] = []
    var movieloading: (() -> Void) = {}
    var showError: ((String) -> Void)?
    var isLoading = false
    
    var errorMessage: String?
    private let networkService = NetworkService.shared

    func fetchMovies(category: MovieCategory, completion: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil
        
        networkService.fetchData(endpoint: category.rawValue, model: MoviesList.self) { [weak self] (result: Result<MoviesList, ErrorMessage>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let moviesList):
                    self?.movies = moviesList.results
                    self?.saveMoviesToCoreData(movies: moviesList.results)
                    self?.movieloading()
                case .failure(let error):
                    self?.errorMessage = error.rawValue
                    self?.showError?(error.rawValue) 
                }
                completion()
            }
        }
    }

    func getMovieImage(posterPath: String, completion: @escaping (UIImage?) -> Void) {
        NetworkService.shared.downloadImage(from: posterPath) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
                self.showError?(ErrorMessage.invalidResponse.rawValue)
                completion(nil)
            }
        }
    }
    
    func startNetworkMonitoring() {
        NetworkMonitor.shared.startMonitoring { [weak self] isConnected in
            if !isConnected {
                self?.showError?("You are in offline mode now. No internet connection.")
                self?.fetchMoviesFromCoreData()
            }
        }
    }

}


extension MovieViewModel {
    func fetchMoviesFromCoreData() {
        MovieRepo.shared.fetchMoviesFromCoreData { [weak self] (result: Result<[Movie], ErrorMessage>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.movieloading()
                case .failure(let error):
                    self?.errorMessage = error.rawValue
                    self?.showError?(error.rawValue)
                }
            }
        }
    }


    
    func saveMoviesToCoreData(movies: [Movie]) {
        MovieRepo.shared.saveMoviesToCoreData(movies: movies)
    }
}

