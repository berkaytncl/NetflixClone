//
//  MediaCollectionViewCell.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 10.09.2023.
//

import UIKit

final class MediaCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MediaCollectionViewCell"
    
    private let posterImageView: PosterImageView = {
        let imageView = PosterImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
            
        posterImageView.image = nil
        posterImageView.cancelDownloading()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = bounds
    }
    
    public func configure(with string: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(string)") else { return }
        posterImageView.downloadImage(url: url)
    }
}
