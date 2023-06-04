//
//  CoinsPresenter.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CoinsPresentationLogic {
    func presentData(response: Coins.Model.Response.ResponseType)
}

class CoinsPresenter: CoinsPresentationLogic {
    weak var viewController: CoinsDisplayLogic?
    
    func presentData(response: Coins.Model.Response.ResponseType) {
        switch response {
        case .processCoins(let coins):
            viewController?.displayData(viewModel: .dispalyCoins(processModel(coins: coins)))
        case .refreshCoins(let coins):
            viewController?.displayData(viewModel: .displayRefreshingCoins(processModel(coins: coins)))
        case .error:
            viewController?.displayData(viewModel: .error)
        }
    }
        
    private func processModel(coins: [ResponseDataModel.CoinModel]) -> [ResponseDataModel.CoinModel] {
        var processedCoins: [ResponseDataModel.CoinModel] = []
        coins.forEach({
            processedCoins.append(ResponseDataModel.CoinModel(symbol: $0.symbol,
                                                              name: $0.name,
                                                              supply: addPostfix(to: $0.supply),
                                                              marketCapUsd: "$" + addPostfix(to: $0.marketCapUsd),
                                                              volumeUsd24Hr: "$" + addPostfix(to: $0.volumeUsd24Hr),
                                                              priceUsd: "$ " + $0.priceUsd.roundToSignificantFigure(),
                                                              changePercent24Hr: processPercent(changePercent24Hr: $0.changePercent24Hr ?? "") + "%"
                                                             ))
            
        })
        return processedCoins
    }
    
    private func addPostfix(to string: String?) -> String {
        if let string = string {
            var processedString = string
            let index = processedString.firstIndex(of: ".") ?? string.index(string.startIndex, offsetBy: string.count)
            let countNumbers = index.utf16Offset(in: processedString)
            
            if countNumbers > 3 && countNumbers < 7 {
                processedString.insert(".", at: processedString.index(index, offsetBy: -3))
                processedString = processedString.round(with: 2)
                processedString += "k"
            } else if countNumbers > 6 && countNumbers < 10 {
                processedString.insert(".", at: processedString.index(index, offsetBy: -6))
                processedString = processedString.round(with: 2)
                processedString += "m"
            } else if countNumbers > 9 && countNumbers < 13 {
                processedString.insert(".", at: processedString.index(index, offsetBy: -9))
                processedString = processedString.round(with: 2)
                processedString += "b"
            } else if countNumbers > 12 && countNumbers < 16 {
                processedString.insert(".", at: processedString.index(index, offsetBy: -12))
                processedString = processedString.round(with: 2)
                processedString += "t"
            } else {
                processedString = processedString.round(with: 2)
            }
            
            return processedString
        }
        
        return "null"
    }
    
    private func processPercent(changePercent24Hr: String) -> String {
        var newStr = changePercent24Hr
        if newStr.first == "-" {
            newStr.insert(" ", at: newStr.index(newStr.startIndex, offsetBy: 1))
            
        } else {
            newStr = "+ " + newStr
        }
        return newStr.round(with: 2)
    }
}
