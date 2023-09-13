//
//  Media.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 8.09.2023.
//

import Foundation

struct MediaResponse: Decodable {
    let medias: [Media]
    
    enum CodingKeys: String, CodingKey {
        case medias = "results"
    }
}

struct Media: Decodable {
    let id: Int
    let title: String?
    let originalTitle: String?
    let mediaType: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }
}
