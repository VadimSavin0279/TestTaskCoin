//
//  DetailModels.swift
//  TestTaskCoin
//
//  Created by 123 on 04.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Detail {
    
    enum Model {
        struct Request {
            enum RequestType {
                case processViewModel(ResponseDataModel.CoinModel)
            }
        }
        struct Response {
            enum ResponseType {
                case processViewModel(ResponseDataModel.CoinModel)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayData(ResponseDataModel.CoinModel)
            }
        }
    }
    
}
