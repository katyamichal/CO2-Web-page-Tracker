//
//  FRCDelegate.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit
import CoreData

protocol IFetchResultControllerDelegate {
    func beginUpdating()
    func endUpdating()
    func insertObject(at index: IndexPath, with object: WebPageListViewData)
    func objectDidChange(at index: IndexPath, with object: WebPageListViewData)
    func deleteRow(at index: IndexPath)
}

final class FRCDelegate: NSObject, NSFetchedResultsControllerDelegate {
    var delegate: IFetchResultControllerDelegate?
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.beginUpdating()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdating()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath, let webPage = anObject as? WebPageInfo {
                delegate?.insertObject(at: indexPath, with: WebPageListViewData(id: webPage.identifier, url: webPage.url, date: webPage.date, rating: webPage.rating))
            }
        case .update:
            if let indexPath = indexPath, let webPage = anObject as? WebPageInfo {
                delegate?.objectDidChange(at: indexPath, with: WebPageListViewData(id: webPage.identifier, url: webPage.url, date: webPage.date, rating: webPage.rating))
            }
        case .delete:
            if let indexPath {
                delegate?.deleteRow(at: indexPath)
            }
            
        case .move:
            break
        @unknown default:
            fatalError()
        }
    }
}
