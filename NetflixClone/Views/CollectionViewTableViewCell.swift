//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 6.09.2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(preview: PreviewYoutube)
}

final class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    public weak var delegate: CollectionViewTableViewCellDelegate?
    
    private let service = TmdbService()
    
    private var medias: [Media] = [Media]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
}

extension CollectionViewTableViewCell {
    public func configure(with medias: [Media]) {
        self.medias = medias
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else { return UICollectionViewCell() }
        guard let posterPath = medias[indexPath.item].posterPath else { return UICollectionViewCell() }
        
        cell.configure(with: posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let media = medias[indexPath.row]
        
        guard let titleName = media.originalTitle ?? media.title else { return }
        
        service.getMovie(with: titleName + " trailer") { [weak self] result in
            guard let self = self else { return }
            guard let videoElement = result?.items.first else { return }
            let overview = media.overview ?? ""
            
            let preview = PreviewYoutube(title: titleName, youtubeVideo: videoElement, titleOverview: overview)
            
            self.delegate?.collectionViewTableViewCellDidTapCell(preview: preview)
        }
    }
}
