//
//  TmdbService.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 10.09.2023.
//

import Foundation

struct Constants {
    static let baseURL = "https://api.themoviedb.org"
    static let API_KEY = "16daa02252e02e95b5b541106c7dc6e0"
    static let YoutubeAPI_KEY = "AIzaSyCOGRaRn9R04YxmqrjKj2YaixXIQOd3Lzs"
    static let YoutubeBaseURL = "https://www.googleapis.com/youtube/v3/search?"
}

final class TmdbService {
    
    func APICall(type: APICallType, completion: @escaping (MediaResponse?) -> ()) {
        guard let url = URL(string: type.url) else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }

    func getDiscoverMovies(with query: String? = nil, completion: @escaping (MediaResponse?) -> ()) {
        let url: URL
        if let query = query?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            guard let searchUrl = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
            url = searchUrl
        } else {
            guard let searchUrl = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
            url = searchUrl
        }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    func getMovie(with query: String, completion: @escaping (YoutubeSearchResponse?) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
}

extension TmdbService {
    private func handleWithData(_ data: Data) -> MediaResponse? {
        do {
            let media = try JSONDecoder().decode(MediaResponse.self, from: data)
            return media
        } catch {
            handleWithError(error)
            return nil
        }
    }
    
    private func handleWithData(_ data: Data) -> YoutubeSearchResponse? {
        do {
            let youtubeSearch = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
            return youtubeSearch
        } catch {
            handleWithError(error)
            return nil
        }
    }
    
    private func handleWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}
