//
//  NetworkService.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 12.06.2024.
//

import Foundation
protocol INetworkService: AnyObject {
    var backgroundCompletionHandler: ((WebsiteData?, APIError?) -> Void)? { get set }
    func performRequest(with keyword: String)
}

final class NetworkService: NSObject, INetworkService {
    
    var backgroundCompletionHandler: ((WebsiteData?, APIError?) -> Void)?
    
    private var currentTaskTask: URLSessionDownloadTask?
    private let decoder = JSONDecoder()
    private let networkMonitor = NetworkMonitor.shared
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: Constants.URLSessionsIndentifiers.session)
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func performRequest(with keyword: String) {
        if networkMonitor.isConnected == false {
            backgroundCompletionHandler?(nil, .noInternetConnection())
            return
        }
        guard let url = createURL(with: keyword) else {
            backgroundCompletionHandler?(nil, .invalidURL())
            return
        }
        let task: URLSessionDownloadTask
        task = urlSession.downloadTask(with: url)
        task.resume()
        currentTaskTask = task
    }
}

extension NetworkService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            print(String(data: data, encoding: .utf8))
            let searchResults = try decoder.decode(WebsiteData.self, from: data)
            backgroundCompletionHandler?(searchResults, nil)
        } catch {
            backgroundCompletionHandler?(nil, .invalidResponse())
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard
            let response = task.response as? HTTPURLResponse
        else { return }
        
        switch response.statusCode {
        case 300...399:
            backgroundCompletionHandler?(nil, .urlSessionError("\(response.statusCode)"))
        case 400...499:
            backgroundCompletionHandler?(nil, .invalidResponse("\(response.statusCode)"))
        case 500...599:
            backgroundCompletionHandler?(nil, .serverError("\(response.statusCode)"))
        default:
            break
        }
    }
}

private extension NetworkService {
    func createURL(with keyword: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.websitecarbon.com"
        urlComponents.path = "/site"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "url", value: keyword)
        ]
        return urlComponents.url
    }
}
