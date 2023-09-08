//
//  Movie.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 8.09.2023.
//

import Foundation

struct TrendingMoviesResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let originalName: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int
    let voteAverage: Double
    let firstAirDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
    }
}
