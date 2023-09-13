//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 5.09.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let service = TmdbService()
    
    private var trendingMoviesMedia: [Media] = [Media]()
    private var trendingTvsMedia: [Media] = [Media]()
    private var popularMedia: [Media] = [Media]()
    private var upcomingMoviesMedia: [Media] = [Media]()
    private var topRatedMedia: [Media] = [Media]()
    
    private var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        configureTableView()
        configureNavBar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        fetchAllData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

extension HomeViewController {
    private func configureNavBar() {
        let image = UIImage(named: "netflixLogo")?
            .withRenderingMode(.alwaysOriginal)
            .resizeTo(size: CGSize(width: 45, height: 45))
        let barButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = barButtonItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureTableView() {
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.backgroundColor = .clear
    }
    
    private func fetchAllData() {
        trendingMoviesMedia.removeAll()
        trendingTvsMedia.removeAll()
        popularMedia.removeAll()
        upcomingMoviesMedia.removeAll()
        topRatedMedia.removeAll()
        
        let group = DispatchGroup()
        
        group.enter()
        self.fetchData(type: .getTrendingMoviesURL) {
            group.leave()
        }
        
        group.enter()
        self.fetchData(type: .getTrendingTvsURL) {
            group.leave()
        }
        
        group.enter()
        self.fetchData(type: .getPopularURL) {
            group.leave()
        }
        
        group.enter()
        self.fetchData(type: .getUpcomingMoviesURL) {
            group.leave()
        }
        
        group.enter()
        self.fetchData(type: .getTopRatedURL) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.homeFeedTable.reloadData()
        }
    }
    
    private func fetchData(type: APICallType, completion: @escaping () -> ())  {
        service.APICall(type: type) { [weak self] result in
            guard let result = result, let self = self else { return }
            switch type.rawValue {
            case 0:
                trendingMoviesMedia.append(contentsOf: result.medias)
            case 1:
                trendingTvsMedia.append(contentsOf: result.medias)
            case 2:
                popularMedia.append(contentsOf: result.medias)
            case 3:
                upcomingMoviesMedia.append(contentsOf: result.medias)
            case 4:
                topRatedMedia.append(contentsOf: result.medias)
            default:
                break
            }
            completion()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.configure(with: trendingMoviesMedia)
        case 1:
            cell.configure(with: trendingTvsMedia)
        case 2:
            cell.configure(with: popularMedia)
        case 3:
            cell.configure(with: upcomingMoviesMedia)
        case 4:
            cell.configure(with: topRatedMedia)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sections.allCases[section].mediaSections
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
