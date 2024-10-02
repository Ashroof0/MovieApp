//
//  NetworkManager.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 02/10/2024.
//

import Foundation
import UIKit

//https://api.themoviedb.org/3/movie/popular?api_key=95a89943de5af0ccb83f6a10a3c30c21

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private let baseUrl = "https://api.themoviedb.org/3/movie/"
    private let apiKey = "95a89943de5af0ccb83f6a10a3c30c21"
    private let imageUrlHeader = "https://image.tmdb.org/t/p/"
    private let posterSize = "w500"
    
    func fetchData<T: Codable>(endpoint: String ,model : T.Type ,completion: @escaping (Result<T, ErrorMessage>) -> Void) {
        let urlString = baseUrl + endpoint + "?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let _ = response else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    func downloadImage(from posterPath: String, completion: @escaping (Result<UIImage?, Error>) -> Void){
        
        guard let url = URL(string: imageUrlHeader + posterSize + posterPath) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let _ = self else { return }
            
            
            if let _ = error{ return }
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else{ return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            completion(.success(image))
            
        }
        task.resume()
    }
}
