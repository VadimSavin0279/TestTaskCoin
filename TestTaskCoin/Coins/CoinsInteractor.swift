//
//  CoinsInteractor.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CoinsBusinessLogic {
    func makeRequest(request: Coins.Model.Request.RequestType)
}

class CoinsInteractor: CoinsBusinessLogic {
    
    var presenter: CoinsPresentationLogic?
    var service: CoinsService?
    
    private var offset = 0
    
    func makeRequest(request: Coins.Model.Request.RequestType) {
        if service == nil {
            service = CoinsService()
        }
        switch request {
        case .getCoins:
            service?.getCoinsFromServer(offset: offset, complition: { coins in
                self.offset += 10
                self.presenter?.presentData(response: .processCoins(coins))
            }, complitionError: {
                self.presenter?.presentData(response: .error)
            })
        case .search(let text):
                service?.getCoinsForSearch(searchText: text, complition: { coins in
                self.presenter?.presentData(response: .processCoins(coins))
                }, complitionError: {
                    self.presenter?.presentData(response: .error)
                })
        case .refreshing:
            offset = 0
            service?.getCoinsFromServer(offset: offset, complition: { coins in
                self.offset = 10
                self.presenter?.presentData(response: .refreshCoins(coins))
            }, complitionError: {
                self.presenter?.presentData(response: .error)
            })
        }
    }
}
