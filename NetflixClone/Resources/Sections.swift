//
//  Sections.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 11.09.2023.
//

import Foundation

protocol SectionProperties {
    var mediaSections: String { get }
}

enum Sections: Int, CaseIterable {
    case trendingMovies
    case trendingTv
    case popular
    case upcomingMovies
    case topRated
}

extension Sections: SectionProperties {
    var mediaSections: String {
        switch self {
        case .trendingMovies:
            return "Trending movies"
        case .trendingTv:
            return "Trending tv"
        case .popular:
            return "Popular"
        case .upcomingMovies:
            return "Upcoming movies"
        case .topRated:
            return "Top rated"
        }
    }
}
