//
//  CoinModel.swift
//  TestTaskCoin
//
//  Created by 123 on 02.06.2023.
//

import Foundation

struct ResponseDataModel: Codable {
    let data: [CoinModel]
    
    struct CoinModel: Codable {
        let symbol: String
        let name: String
        let supply: String?
        let marketCapUsd: String?
        let volumeUsd24Hr: String?
        let priceUsd: String
        let changePercent24Hr: String?
    }
}
