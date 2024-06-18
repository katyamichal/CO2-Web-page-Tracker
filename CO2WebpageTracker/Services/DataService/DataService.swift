//
//  DataService.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//


import CoreData

protocol IDataService: AnyObject {
    func addFetchDelegate(_ delegate: IFetchResultControllerDelegate)
    
    func fetchWepPages(completionHandler: (Result<[WebPageListViewData],CoreDataErrors>) -> Void)
    func performFetch()
    func fetchWepPage(with webPageId: UUID, completionHandler: (WebPageViewData) -> Void)
    
    func add(webPage: WebPageViewData, completion: (Result<String, CoreDataErrors>) -> Void)
    func deleteWebPage(with id: UUID)
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
                WebPageListViewData(id: webPage.identifier, url: webPage.url, date: webPage.date, rating: webPage.rating)
            }))
        } catch {
            let error = error as NSError
            completionHandler(.failure(.fetchError))
        }
    }
    
    func fetchWepPage(with webPageId: UUID, completionHandler: (WebPageViewData) -> Void) {
        guard let webPage = getWebPage(with: webPageId) else { return }
        completionHandler(WebPageViewData(
            id: webPage.identifier,
            url: webPage.url,
            date: webPage.date,
            ratingLetter: webPage.rating,
            cleanerThan: webPage.cleanerThan,
            isGreen: webPage.isGreen,
            gramForVisit: webPage.gramForVisit,
            energy: webPage.energy
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
                assert(fetchResult.count == 1, "Dublicate has been found")
                isDublicated = true
            }
        } catch {
            print("error to find Dublicate")
        }
        return isDublicated
    }

    func add(webPage: WebPageViewData, completion: (Result<String, CoreDataErrors>) -> Void) {
        if findDublicate(with: webPage) == false {
            let context = PersistantContainerStorage.persistentContainer.viewContext
            let newWebPage = WebPageInfo(context: context)
            newWebPage.identifier = webPage.id
            newWebPage.url = webPage.url
            newWebPage.date = webPage.date
            newWebPage.rating = webPage.ratingLetter
            newWebPage.isGreen = webPage.isGreen
            newWebPage.gramForVisit = webPage.gramForVisit
            newWebPage.cleanerThan = webPage.cleanerThan
            newWebPage.energy = webPage.energy
            PersistantContainerStorage.saveContext()
            completion(.success("We have added web page to the list"))
        } else {
            completion(.failure(.dublicate))
        }
    }
    
    func deleteWebPage(with id: UUID) {
        print(id)
        defer { PersistantContainerStorage.saveContext() }
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let fetchRequest = WebPageInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", id.uuidString)
        do {
            let webPages = try context.fetch(fetchRequest)
            print(webPages)
            webPages.forEach { context.delete($0) }
        } catch let error as NSError {
            print("Error to delete: \(error)")
        }
    }
}

private extension DataService {
    func getWebPage(with id: UUID) -> WebPageInfo? {
        let webPageToReturn: WebPageInfo?
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WebPageInfo>
        fetchRequest = WebPageInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@" , id.uuidString)
        
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
