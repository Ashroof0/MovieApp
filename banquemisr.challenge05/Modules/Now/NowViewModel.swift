//
//  NowViewModel.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 02/10/2024.
//

import Foundation
import UIKit
class MovieViewModel {
    var movies: [Movie] = []
    private var image = UIImage()
    var movieloading: (() -> Void) = {}
    var showError: ((String) -> Void)?
    var isLoading = false
    var errorMessage: String?
    private let networkService = NetworkService.shared
    
    func fetchMovies(endpoint: String, completion: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil
        
        networkService.fetchData(endpoint: endpoint, model: MoviesList.self) { [weak self] (result: Result<MoviesList, ErrorMessage>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let moviesList):
                    self?.movies = moviesList.results
                    self?.movieloading()
                case .failure(let error):
                    self?.errorMessage = error.rawValue
                    completion() // Call completion to handle UI updates
                }
                completion() // Ensure completion is called in both cases
            }
        }
    }
    func getMovieImage(posterPath: String, completion: @escaping (UIImage?) -> Void ){
        NetworkService.shared.downloadImage(from: posterPath) { [weak self] result in
            guard let self = self else { return  }
            
            switch result{
            case .success(let image):
                completion(image)
                
            case .failure(let error):
                print("error downloading image \(error.localizedDescription)")
                self.showError?(ErrorMessage.invalidResponse.rawValue)
                completion(nil)
            }
        }
    }
}
