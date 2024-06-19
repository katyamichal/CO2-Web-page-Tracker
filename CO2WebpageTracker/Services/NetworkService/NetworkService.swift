//
//  NetworkService.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 12.06.2024.
//

import Foundation
protocol INetworkService: AnyObject {
    var backgroundCompletionHandler: ((WebsiteData?, APIError?) -> Void)? { get set }
    func performRequest(with stringURL: String)
    func pauseLoading()
    func resumeLoading()
}

final class NetworkService: NSObject, INetworkService {
    
    var backgroundCompletionHandler: ((WebsiteData?, APIError?) -> Void)?
    
    private var currentTaskStatus: (keyword: String, paused: Bool, resumeData: Data?)?
    private var currentTask: URLSessionDownloadTask?
    private let decoder = JSONDecoder()
    private let networkMonitor = NetworkMonitor.shared
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: Constants.URLSessionsIndentifiers.session)
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func performRequest(with stringURL: String) {
        if networkMonitor.isConnected == false {
            backgroundCompletionHandler?(nil, .noInternetConnection())
            return
        }
        guard let url = createURL(with: stringURL) else {
            backgroundCompletionHandler?(nil, .invalidURL())
            return
        }
        
        let resumeData = currentTaskStatus?.resumeData
        let task: URLSessionDownloadTask
        if let resumeData {
            task = urlSession.downloadTask(withResumeData: resumeData)
        } else {
            task = urlSession.downloadTask(with: url)
        }
        currentTask = task
        task.resume()
        currentTaskStatus = (keyword: stringURL, paused: false, resumeData: resumeData)
    }
    
    
    func pauseLoading() {
        guard let status = currentTaskStatus, let task = currentTask else { return }
        task.cancel { [weak self] resumeData in
            self?.currentTaskStatus = (keyword: status.keyword, paused: true, resumeData: resumeData)
        }
    }
    
    func resumeLoading() {
        guard let status = currentTaskStatus else { return }
        currentTaskStatus = (keyword: status.keyword, paused: false, resumeData: status.resumeData)
        performRequest(with: status.keyword)
    }
}

extension NetworkService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
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
    func createURL(with stringURL: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.websitecarbon.com"
        urlComponents.path = "/site"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "url", value: stringURL)
        ]
        return urlComponents.url
    }
}
