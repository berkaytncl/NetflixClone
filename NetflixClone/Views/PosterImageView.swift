//
//  PosterImageView.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 10.09.2023.
//

import UIKit

final class PosterImageView: UIImageView {

    private var dataTask: URLSessionDataTask?
    
    func downloadImage(with urlString: String) {
        guard let url = URL(string: "asda\(urlString)") else { return }
        
        dataTask = NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async { self.image = UIImage(data: data) }
            case .failure(_):
                break
            }
        }
    }
    
    func cancelDownloading() {
        self.dataTask?.cancel()
        self.dataTask = nil
    }
}
