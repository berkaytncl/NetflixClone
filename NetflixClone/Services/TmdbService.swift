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

    private func handleWithData(_ data: Data) -> MediaResponse? {
        do {
            let media = try JSONDecoder().decode(MediaResponse.self, from: data)
            return media
        } catch {
            handleWithError(error)
            return nil
        }
    }
    
    private func handleWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}
