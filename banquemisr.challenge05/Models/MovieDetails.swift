//
//  Details.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 02/10/2024.
//

import Foundation

struct MovieDetails: Codable{
    let id: Int
    let title: String
    let releaseDate: String
    let genres: [Genre]
    let overview: String
    let posterPath: String?
    let runtime: Int
    let voteAverage: Double
    let revenue: Int
}


struct Genre: Codable{
    let id: Int
    let name: String
}
