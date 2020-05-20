//
//  RestClient.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 20/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/**
  Basic API client to fetch remote resource. API client is made based on URLSession
 */

final class RESTClient {
    
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func sendRequest<T>(path: String, method: RequestMethod, param: JSON, completion: @escaping (Result<T>) -> Void) -> URLSessionTask? {
        
        let request =  URLRequest(baseUrl: baseUrl, path: path, method: method, params: param)
        
        let task =  URLSession.shared.dataTask(with: request) { data, response, error in
            /// parsing incoming data
            var serializedData: Any? = nil
            
            if let data = data {
                do {
                    serializedData = try  JSONSerialization.jsonObject(with: data, options: [])
                } catch (let error) {
                    completion(.error(.init(error: error)))
                }
                
            }
            if let httpResponse = response as? HTTPURLResponse,
                (200..<300) ~= httpResponse.statusCode, let data = serializedData as? T  {
                completion(.success(data))
            } else {
                let error = (serializedData as? JSON).flatMap(ServiceError.init) ?? ServiceError.other
                completion(.error(error))
            }
        }
        
        task.resume()
        
        return task
    }
}


extension URL {
    init(baseUrl: String, path: String, params: JSON, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get, .delete:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}


extension URLRequest {
    init(baseUrl: String, path: String, method: RequestMethod, params: JSON) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}

