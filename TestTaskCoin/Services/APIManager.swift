//
//  APIManager.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//

import Foundation

enum Result<T: Codable> {
    case success(T)
    case failure(Error)
}

final class APIManager {
    public func sendRequest<T, U>(with target: T, decodeType: U.Type, completion: @escaping (Result<U>) -> ()) where T: Provider, U: Decodable {
        let defaultSession = URLSession(configuration: .default)
        if var urlComp = URLComponents(string: target.baseURL + target.path) {
            var queryItems: [URLQueryItem] = []
            for (key, value) in target.params {
                if let str = value as? String {
                    queryItems.append(URLQueryItem(name: key, value: str))
                }
            }
            urlComp.queryItems = queryItems
            
            guard let url = urlComp.url else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = target.method.rawValue
            urlRequest.allHTTPHeaderFields = target.headers
            
            defaultSession.dataTask(with: urlRequest) { data, response, error in
                switch error {
                case .none:
                    do {
                        guard let data = data else { return }
                        let json = try JSONDecoder().decode(U.self, from: data)
                        completion(.success(json))
                    } catch {
                        completion(.failure(error))
                    }
                case .some(let wrapped):
                    completion(.failure(wrapped))
                }
                    
            }.resume()
            
        }
    }
}
