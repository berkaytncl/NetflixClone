//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 5.09.2023.
//

import UIKit

final class SearchViewController: UIViewController {

    private let service = TmdbService()
    
    private var medias: [Media] = [Media]()
    
    private let discoverTable: UITableView = {
        let tableView = UITableView()
        tableView.register(MediasTableViewCell.self, forCellReuseIdentifier: MediasTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .black
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
}

extension SearchViewController {
    private func fetchDiscoverMovies() {
        service.getDiscoverMovies { [weak self] result in
            guard let result = result, let self = self else { return }
            self.medias = result.medias

            DispatchQueue.main.async {
                self.discoverTable.reloadData()
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediasTableViewCell.identifier, for: indexPath) as? MediasTableViewCell else { return UITableViewCell() }
        
        let media = medias[indexPath.row]
        let title = media.title ?? media.originalTitle ?? "Unkown title name"
        let posterPath = media.posterPath ?? ""
        
        cell.configure(with: PosterMedia(title: title, posterPath: posterPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let media = medias[indexPath.row]
        
        guard let titleName = media.originalTitle ?? media.title else { return }
        let overview = media.overview
        
        service.getMovie(with: titleName) { [weak self] result in
            guard let videoElement = result?.items.first else { return }
            DispatchQueue.main.async {
                let vc = PreviewViewController()
                vc.configure(with: PreviewYoutube(title: titleName, youtubeVideo: videoElement, titleOverview: overview ?? ""))
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
                let resultController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultController.delegate = self
        
        service.getDiscoverMovies(with: query) { result in
            guard let medias = result?.medias else { return }
            DispatchQueue.main.async {
                resultController.medias = medias
                resultController.searchResultsCollectionView.reloadData()
            }
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(preview: PreviewYoutube) {
        DispatchQueue.main.async {
            let vc = PreviewViewController()
            vc.configure(with: preview)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
