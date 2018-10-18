//
//  NetworkManager.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import Foundation


// Types
enum Result<T> {
    case success(T)
    case error(Error)
}

typealias ResultCallback<T> = (Result<T>) -> Void

enum NetworkStackError: Error {
    case invalidRequest
    case dataMissing
}


// Webservice
protocol WebserviceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>)
}

class NetworkManager: WebserviceProtocol {
    
    private let urlSession: URLSession
    private let parser: Parser
    
    init(urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.urlSession = urlSession
        self.parser = Parser()
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>) {
        
        guard let request = endpoint.request else {
            OperationQueue.main.addOperation({ completion(.error(NetworkStackError.invalidRequest)) })
            return
        }
        
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                OperationQueue.main.addOperation({ completion(.error(error)) })
                return
            }
            
            guard let data = data else {
                OperationQueue.main.addOperation({ completion(.error(NetworkStackError.dataMissing)) })
                return
            }
            self.parser.json(data: data, completion: completion)
        }
        
        task.resume()
    }
}

struct Parser {
    let jsonDecoder = JSONDecoder()
    func json<T: Decodable>(data: Data, completion: @escaping ResultCallback<T>) {
        do {
            let fiyuuResponseModel = try? jsonDecoder.decode(T.self, from: data)
            OperationQueue.main.addOperation { completion(.success(fiyuuResponseModel!)) }
        } catch let parseError {
            OperationQueue.main.addOperation { completion(.error(parseError)) }
        }
    }
}


// Endpoint
protocol Endpoint {
    var request: URLRequest? { get }
    var httpMethod: String { get }
    var queryItems: [URLQueryItem]? { get }
    var requestHeaders: [String: String]? { get }
    var requestBody: Data? { get }
    var scheme: String { get }
    var host: String { get }
}

extension Endpoint {
    func request(forPath path: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = requestBody
        if let headers = requestHeaders {
            for (key,value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}

// MARK: - BrandsEndpoint
enum MoviesEndpoint {
    case nowPlaying
    case search(queryText: String)
}

extension MoviesEndpoint: Endpoint {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.themoviedb.org"
    }
    
    var request: URLRequest? {
        switch self {
        case .nowPlaying:
            return request(forPath: "/3/movie/now_playing")
        case .search:
            return request(forPath: "/search/movie")
        }
    }
    
    var httpMethod: String {
        switch self {
        case .nowPlaying:
            return "GET"
        case .search:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        var defaultQueryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: "5f289b2f6c23c55221c40a1843e5d21a")]
        switch self {
        case .nowPlaying:
            return defaultQueryItems
        case .search(let queryText):
            defaultQueryItems.append(URLQueryItem(name: "query", value: queryText))
            return defaultQueryItems
        }
    }
    
    var requestHeaders: [String: String]? {
        let defaultHeaders: [String: String] = [:]
        switch self {
        case .nowPlaying:
            return defaultHeaders
        case .search:
            return defaultHeaders
        }
    }
    
    var requestBody: Data? {
        switch self {
        case .nowPlaying:
            return nil
        case .search:
            return nil
        }
    }
}
