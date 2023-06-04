//
//  CoinsWorker.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class CoinsService {
    private let apiManager = APIManager()
    public func getCoinsFromServer(offset: Int,
                                   complition: @escaping ([ResponseDataModel.CoinModel]) -> (),
                                   complitionError: @escaping () -> ()) {
        apiManager.sendRequest(with: CoinsProvider.getCoins(offset), decodeType: ResponseDataModel.self) { result in
            switch result {
            case .success(let data):
                complition(data.data)
            case .failure(let error):
                print(error.localizedDescription)
                complitionError()
            }
        }
    }
    
    public func getCoinsForSearch(searchText: String,
                                  complition: @escaping ([ResponseDataModel.CoinModel]) -> (),
                                  complitionError: @escaping () -> ()) {
        apiManager.sendRequest(with: CoinsProvider.search(searchText), decodeType: ResponseDataModel.self) { result in
            switch result {
            case .success(let data):
                complition(data.data)
            case .failure(let error):
                print(error.localizedDescription)
                complitionError()
            }
        }
    }
}
