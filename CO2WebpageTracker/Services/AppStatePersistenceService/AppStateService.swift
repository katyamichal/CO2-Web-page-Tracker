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
            let data = try encoder.encode(appState)
            userDefaults.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieve() -> AppState? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            let appState = try decoder.decode(AppState.self, from: data)
            return appState
            
        } catch {
            print("Error to retrieve data from User Defaults")
        }
        return nil
    }
    
    func delete() {
         userDefaults.removeObject(forKey: key)
     }
}
