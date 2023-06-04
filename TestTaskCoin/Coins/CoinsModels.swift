//
//  CoinsModels.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Coins {
    enum Model {
        struct Request {
            enum RequestType {
                case getCoins
                case search(String)
                case refreshing
            }
        }
        struct Response {
            enum ResponseType {
                case processCoins([ResponseDataModel.CoinModel])
                case refreshCoins([ResponseDataModel.CoinModel])
                case error
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case dispalyCoins([ResponseDataModel.CoinModel])
                case displayRefreshingCoins([ResponseDataModel.CoinModel])
                case error
            }
        }
    }
}

struct CoinsViewModel {
    var allData: [ResponseDataModel.CoinModel]
    var currentData: [ResponseDataModel.CoinModel]
}
