//
//  DataService.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//


import CoreData
import UIKit

protocol IDataService: AnyObject {
    func addFetchDelegate(_ delegate: IFetchResultControllerDelegate)
    
    func fetchWepPages(completionHandler: (Result<[WebPageListViewData],CoreDataErrors>) -> Void)
    func performFetch()
    func fetchWepPage(with webPageURL: String, completionHandler: (WebPageViewData) -> Void)
    func findDublicate(with webPage: WebPageViewData) -> Bool
    func add(webPage: WebPageViewData, completion: (String) -> Void)
    func deleteWebPage(url: String)
}

enum PersistantContainerStorage {
    
   static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CO2WebpageTracker")
        container.loadPersistentStores { _, error in
            print("Error to create persistent container: \(String(describing: error))")
        }
        return container
    }()
    
   static func saveContext() {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error to save context: \(nserror)")
            }
        }
    }
}

final class DataService: IDataService {
    
    private let frcDelegate = FRCDelegate()
    private let entityName = "WebPageInfo"
    private let maxPercentage: Int = 100
    
    private lazy var controller: NSFetchedResultsController<WebPageInfo> = {
        let sortDescriptor = NSSortDescriptor(keyPath: \WebPageInfo.date, ascending: true)
        let fetchRequest = WebPageInfo.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistantContainerStorage.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = frcDelegate
        return controller
    }()
    
    // MARK: - Fetch
    
    func addFetchDelegate(_ delegate: IFetchResultControllerDelegate) {
        frcDelegate.delegate = delegate
    }

    func performFetch() {
        do {
            try controller.performFetch()
        } catch {
            print("Error to fetch companies: \(error)")
        }
    }
    
    func fetchWepPages(completionHandler: (Result<[WebPageListViewData],CoreDataErrors>) -> Void) {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(keyPath: \WebPageInfo.date, ascending: true)
        
        let fetchRequest = WebPageInfo.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let webPages = try context.fetch(fetchRequest)
            completionHandler(.success(webPages.map { webPage in
                WebPageListViewData(url: webPage.url, date: webPage.date, rating: webPage.rating)
            }))
        } catch {
            completionHandler(.failure(.fetchError))
        }
    }
    
    func fetchWepPage(with webPageURL: String, completionHandler: (WebPageViewData) -> Void) {
        guard let webPage = getWebPage(with: webPageURL) else { return }
        var image: UIImage?
        if let imageData = webPage.image {
            image = UIImage(data: imageData)
        }
        completionHandler(WebPageViewData(
            url: webPage.url,
            date: webPage.date,
            cleanerThan: webPage.cleanerThan, 
            ratingLetter: webPage.rating,
            isGreen: webPage.isGreen,
            gramForVisit: webPage.gramForVisit,
            energy: webPage.energy, 
            image: image
        ))
    }
    // MARK: - Add
    
    func findDublicate(with webPage: WebPageViewData) -> Bool {
        let request = WebPageInfo.fetchRequest()
        request.predicate = NSPredicate(format: "url = %@", webPage.url)
        let context = PersistantContainerStorage.persistentContainer.viewContext
        var isDublicated: Bool = false
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
              //  assert(fetchResult.count == 1, "Dublicate has been found")
                isDublicated = true
            }
        } catch {
            print("error to find Dublicate")
        }
        return isDublicated
    }
    
    func add(webPage: WebPageViewData, completion: (String) -> Void) {
        if findDublicate(with: webPage) {
            deleteWebPage(url: webPage.url)
        }
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let newWebPage = WebPageInfo(context: context)
        var binaryImageData: Data?
        if let image = webPage.image {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                binaryImageData = imageData
            } else {
                print("Error converting image to data")
            }
        }
        newWebPage.url = webPage.url
        newWebPage.date = webPage.date
        newWebPage.rating = webPage.ratingLetter
        newWebPage.isGreen = webPage.isGreen
        newWebPage.gramForVisit = webPage.gramForVisit
        newWebPage.cleanerThan = webPage.cleanerThan
        newWebPage.energy = webPage.energy
        newWebPage.image = binaryImageData
        PersistantContainerStorage.saveContext()
        completion("Web Page succesefully save")
    }
    
    func deleteWebPage(url: String) {
        defer { PersistantContainerStorage.saveContext() }
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let fetchRequest = WebPageInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        do {
            let webPages = try context.fetch(fetchRequest)
            webPages.forEach { context.delete($0) }
        } catch let error as NSError {
            print("Error to delete: \(error)")
        }
    }
}

private extension DataService {
    func getWebPage(with url: String) -> WebPageInfo? {
        let webPageToReturn: WebPageInfo?
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WebPageInfo>
        fetchRequest = WebPageInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@" , url)
        do {
            let webPage = try context.fetch(fetchRequest)
            webPageToReturn = webPage.first
        } catch {
            let error = error as NSError
            print(error)
            webPageToReturn = nil
        }
        return webPageToReturn
    }
}
