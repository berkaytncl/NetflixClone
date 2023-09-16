//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 14.09.2023.
//

import Foundation

struct YoutubeSearchResponse: Decodable {
    let items: [VideoElement]
}

struct VideoElement: Decodable {
    let kind: String
    let etag: String
    let id: IdVideoElement
}

struct IdVideoElement: Decodable {
    let kind: String
    let videoId: String
}
