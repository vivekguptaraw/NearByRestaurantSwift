//
//  ApiManager.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation


class ApiManager {
    
    static var shared = ApiManager()
    private init() {}
    
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://developers.zomato.com/api/v2.1")!
    private let apiKey = "6c0b5c33c3c7acc3a824f47b0c3306b2"
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
    // Enum Endpoint
    enum Endpoint: String, CaseIterable {
        case search
    }
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    
    public func fetchRestaurants(from endPoint: Endpoint, query: [String: String], result: @escaping (Result<NearByRestaurantsResponse, APIServiceError>) -> Void) {
        let restUrl = baseURL.appendingPathComponent(endPoint.rawValue)
        let queryParam: [URLQueryItem] = query.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        fetchResources(url: restUrl, queryItems: queryParam, completion: result)
    }
    
    
    
    private func fetchResources<T: Codable>(url: URL, queryItems: [URLQueryItem]?, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        if let query = queryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "user-key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        urlSession.dataTaskZomato(with: urlRequest) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(.apiError))
            }
        }.resume()
    }
}

extension URLSession {
    func dataTaskZomato(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        })
    }
}
