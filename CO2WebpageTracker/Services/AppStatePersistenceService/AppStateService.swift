//
//  AppStateService.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 21.06.2024.
//

import Foundation
//protocol IAppStateService {
//    func save(appState: AppState)
//    func retrieve() -> [LocaleProduct]?
//}

final class AppStateService  {
    static let shared = AppStateService()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = Constants.UserDefaultKeys.appState
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func save(appState: AppState) {
        do {
            var appStates = retrieveAll() ?? []
            
            // Check if appState for the URL already exists
            if let index = appStates.firstIndex(where: { $0.url == appState.url }) {
                // Update the existing appState
                appStates[index] = appState
            } else {
                // Append the new appState
                appStates.append(appState)
            }
            
            let data = try encoder.encode(appStates)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save app state: \(error)")
        }
    }
    
    func retrieve(with url: String) -> AppState? {
        guard let appStates = retrieveAll() else { return nil }
        return appStates.first { $0.url == url }
    }
    
    func delete(with url: String) {
        guard var appStates = retrieveAll() else { return }
        appStates.removeAll { $0.url == url }
        do {
            let data = try encoder.encode(appStates)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to delete app state: \(error)")
        }
    }
}

private extension AppStateService {
    func retrieveAll() -> [AppState]? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            let appStates = try decoder.decode([AppState].self, from: data)
            print(appStates)
            return appStates
        } catch {
            print("Failed to retrieve app states: \(error)")
        }
        return nil
    }
}
