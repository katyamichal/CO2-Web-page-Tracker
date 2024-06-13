//
//  NetworkService.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 12.06.2024.
//

import Foundation
protocol INetworkService: AnyObject {
    var backgroundCompletionHandler: ((UUID, WebsiteData?, APIError?) -> Void)? { get set }
    var progressHandler: ((UUID, Double) -> Void)? { get set }
    func performRequest(with keyword: String, id: UUID)
}

final class NetworkService: NSObject, INetworkService {
    
    var backgroundCompletionHandler: ((UUID, WebsiteData?, APIError?) -> Void)?
    var progressHandler: ((UUID, Double) -> Void)?
    
    private var tasks = [UUID: URLSessionDownloadTask]()
    private let decoder = JSONDecoder()
    private let networkMonitor = NetworkMonitor.shared
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: Constants.URLSessionsIndentifiers.session)
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func performRequest(with keyword: String, id: UUID) {
        if networkMonitor.isConnected == false {
            backgroundCompletionHandler?(id, nil, .noInternetConnection())
            return
        }
        guard let url = createURL(with: keyword, id: id) else {
            backgroundCompletionHandler?(id, nil, .invalidURL())
            return
        }
        let task: URLSessionDownloadTask
        task = urlSession.downloadTask(with: url)
        task.resume()
        tasks.updateValue(task, forKey: id)
    }
}

extension NetworkService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let webpageId = tasks.first(where: { $0.value == downloadTask })?.key else { return }
        do {
            let data = try Data(contentsOf: location)
            // print(String(data: data, encoding: .utf8))
            let searchResults = try decoder.decode(WebsiteData.self, from: data)
           print(searchResults)
            backgroundCompletionHandler?(webpageId, searchResults, nil)
        } catch {
            backgroundCompletionHandler?(webpageId, nil, .invalidResponse())
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard
            totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown,
            let webpageId = tasks.first(where: { $0.value == downloadTask })?.key
        else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        progressHandler?(webpageId, progress)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard
            let webpageId = tasks.first(where: { $0.value == task })?.key,
            let response = task.response as? HTTPURLResponse
        else { return }
        
        switch response.statusCode {
        case 300...399:
            backgroundCompletionHandler?(webpageId, nil, .urlSessionError("\(response.statusCode)"))
        case 400...499:
            backgroundCompletionHandler?(webpageId, nil, .invalidResponse("\(response.statusCode)"))
        case 500...599:
            backgroundCompletionHandler?(webpageId, nil, .serverError("\(response.statusCode)"))
        default:
            break
        }
    }
}

private extension NetworkService {
    func createURL(with keyword: String, id: UUID) -> URL? {
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
