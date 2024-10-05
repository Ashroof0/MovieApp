//
//  MoviesRepo.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 05/10/2024.
//

import Foundation
import CoreData

class MovieRepo {
    static let shared = MovieRepo()
    
    private init() {}
    
    func fetchMoviesFromCoreData(completion: @escaping (Result<[Movie], ErrorMessage>) -> Void) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let movies = try CoreDataStack.shared.context.fetch(fetchRequest)
            completion(.success(movies.map { Movie(id: Int($0.id), title: $0.title ?? "", posterPath: $0.posterPath) }))
        } catch {
            completion(.failure(.unableToSaveMoviesData))
        }
    }

    
    func saveMoviesToCoreData(movies: [Movie]) {
        for movie in movies {
            // Check if the movie already exists in Core Data
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

            do {
                let existingMovies = try CoreDataStack.shared.context.fetch(fetchRequest)

                // Only save if the movie does not already exist
                if existingMovies.isEmpty {
                    let movieEntity = MovieEntity(context: CoreDataStack.shared.context)
                    movieEntity.id = Int32(movie.id)
                    movieEntity.title = movie.title
                    movieEntity.posterPath = movie.posterPath
                } else {
                    print("Movie with ID \(movie.id) already exists, skipping save.")
                }
            } catch {
                print("Failed to fetch movies: \(error)")
            }
        }

        // Save context only if there are changes
        do {
            try CoreDataStack.shared.context.save()
            print("JK Saved some")
        } catch {
            print("Failed to save movies: \(error)")
        }
    }
}
