//
//  CoinsProvider.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//
import Foundation

enum Config: String {
    case acceptEncoding = "gzip"
    case token = "Bearer dea065db-3844-43a1-a3c6-bbef5cbce259"
}

enum HTTPMethod: String{
    case get = "get"
}

protocol Provider {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
}

enum CoinsProvider: Provider {
    case getCoins(Int)
    case search(String)
}

extension CoinsProvider {
    
    var baseURL: String {
        return "https://api.coincap.io/v2"
    }
    
    var path: String {
        switch self {
        case .getCoins, .search:
            return "/assets"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCoins, .search:
            return .get
        }
    }
    
    var headers: [String: String] {
        return ["Authorization": Config.token.rawValue, "Accept-Encoding": Config.acceptEncoding.rawValue]
    }
    
    var params: [String: Any] {
        switch self {
        case .getCoins(let offset):
            return ["offset": "\(offset)", "limit": "\(10)"]
        case .search(let text):
            return["search": text]
        }
    }
}
