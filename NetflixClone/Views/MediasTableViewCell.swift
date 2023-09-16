//
//  MediasTableViewCell.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 12.09.2023.
//

import UIKit

final class MediasTableViewCell: UITableViewCell {

    static let identifier = "MediasTableViewCell"
    
    private let playMediaButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        return label
    }()
    
    private let mediaPosterImageView: PosterImageView = {
        let imageView = PosterImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(playMediaButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mediaPosterImageView)
        
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension MediasTableViewCell {
    private func applyConstraints() {
        let mediaPosterImageViewConstraints = [
            mediaPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mediaPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mediaPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            mediaPosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let playMediaButtonConstraints = [
            playMediaButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            playMediaButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: mediaPosterImageView.trailingAnchor, constant: 5),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: playMediaButton.leadingAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(mediaPosterImageViewConstraints)
        NSLayoutConstraint.activate(playMediaButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    public func configure(with model: PosterMedia) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)") else { return }
        mediaPosterImageView.downloadImage(url: url)
        titleLabel.text = model.title
    }
}
