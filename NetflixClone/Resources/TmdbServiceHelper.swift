//
//  TmdbServiceHelper.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 11.09.2023.
//

import Foundation

protocol APICallProperties {
    var url: String { get }
}

enum APICallType: Int {
    case getTrendingMoviesURL
    case getTrendingTvsURL
    case getPopularURL
    case getUpcomingMoviesURL
    case getTopRatedURL
}

extension APICallType: APICallProperties {
    var url: String {
        switch self {
        case .getTrendingMoviesURL:
            return "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)"
        case .getTrendingTvsURL:
            return "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)"
        case .getPopularURL:
            return "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        case .getUpcomingMoviesURL:
            return "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        case .getTopRatedURL:
            return "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        }
    }
}
