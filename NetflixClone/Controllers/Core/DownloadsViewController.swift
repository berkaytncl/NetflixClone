//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 5.09.2023.
//

import UIKit

final class DownloadsViewController: UIViewController {

    private let service = TmdbService()
    
    private var medias: [MediaItem] = [MediaItem]()
    
    private let downloadedTable: UITableView = {
        let tableView = UITableView()
        tableView.register(MediasTableViewCell.self, forCellReuseIdentifier: MediasTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(downloadedTable)
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteMediaWith(model: medias[indexPath.row]) { result in
                switch result {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                self.medias.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
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

extension DownloadsViewController {
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingMediasFromDatabase { [weak self] result in
            switch result {
            case .success(let medias):
                self?.medias = medias
                self?.downloadedTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
