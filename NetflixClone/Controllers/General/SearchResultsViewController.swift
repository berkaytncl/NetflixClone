//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 13.09.2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(preview: PreviewYoutube)
}

final class SearchResultsViewController: UIViewController {

    public weak var delegate: SearchResultsViewControllerDelegate?
    
    private let service = TmdbService()
    
    public var medias: [Media] = [Media]()
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 8, height: 200)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
        applyConstraints()
    }
}

extension SearchResultsViewController {
    private func applyConstraints() {        
        let searchResultsCollectionViewConstraints = [
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            searchResultsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(searchResultsCollectionViewConstraints)
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: medias[indexPath.item].posterPath ?? "")
        
        return cell
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
            
            self.delegate?.searchResultsViewControllerDidTapItem(preview: preview)
        }
    }
}
