//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 17.09.2023.
//

import UIKit
import CoreData

final class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    private init() {}
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    func downloadMediaWith(model media: Media, completion: @escaping (Result<(), Error>) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MediaItem(context: context)
        
        item.id = Int64(media.id)
        item.mediaType = media.mediaType
        item.originalTitle = media.originalTitle
        item.overview = media.overview
        item.posterPath = media.posterPath
        item.title = media.title
        item.voteAverage = media.voteAverage
        item.voteCount = Int64(media.voteCount)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func deleteMediaWith(model media: MediaItem, completion: @escaping (Result<(), Error>) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(media)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    func fetchingMediasFromDatabase(completion: @escaping (Result<[MediaItem], Error>) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MediaItem>
        request = MediaItem.fetchRequest()
        
        do {
            let medias = try context.fetch(request)
            completion(.success(medias))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
}
