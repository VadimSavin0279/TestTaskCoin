//
//  CryptoIconURLBilder.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//

import Foundation

final class CryptoIconURLBilder {
    static func getURL(for coin: String) -> URL? {
        return URL(string: "https://cryptoicons.org/api/white/" + coin + "/200")
    }
}
