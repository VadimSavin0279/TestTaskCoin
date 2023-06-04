//
//  DetailPresenter.swift
//  TestTaskCoin
//
//  Created by 123 on 04.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailPresentationLogic {
    func presentData(response: Detail.Model.Response.ResponseType)
}

class DetailPresenter: DetailPresentationLogic {
    weak var viewController: DetailDisplayLogic?
    
    func presentData(response: Detail.Model.Response.ResponseType) {
        switch response {
        case .processViewModel(let coinModel):
            viewController?.displayData(viewModel: .displayData(getModelWithChangingCost(viewModel: coinModel)))
        }
    }
    
    func getModelWithChangingCost(viewModel: ResponseDataModel.CoinModel) -> ResponseDataModel.CoinModel {
        guard viewModel.changePercent24Hr != "null%" else {
            return viewModel
        }
        var costStr = viewModel.priceUsd
        costStr.remove(at: costStr.startIndex)
        costStr.remove(at: costStr.startIndex)
        
        var percentStr = viewModel.changePercent24Hr ?? "0.00%"
        percentStr.remove(at: percentStr.index(percentStr.endIndex, offsetBy: -1))
        percentStr.remove(at: percentStr.index(percentStr.startIndex, offsetBy: 1))
        
        let cost = Float(costStr) ?? 0
        let percentage = Float(percentStr) ?? 0
        
        let newPercentage = 100.0 + percentage
        let oldCost = cost * 100.0 / newPercentage
        
        let dif = cost - oldCost
        var newStr = ""
        
        newStr = String(abs(dif)).roundToSignificantFigure()
        
        if percentage < 0 {
            newStr = "- " + newStr + " (" + String(abs(percentage)) + "%)"
        } else {
            newStr = "+ " + newStr + " (" + String(abs(percentage)) + "%)"
        }
        
        return ResponseDataModel.CoinModel(symbol: viewModel.symbol,
                                           name: viewModel.name,
                                           supply: viewModel.supply,
                                           marketCapUsd: viewModel.marketCapUsd,
                                           volumeUsd24Hr: viewModel.volumeUsd24Hr,
                                           priceUsd: viewModel.priceUsd,
                                           changePercent24Hr: newStr)
    }
    
}
