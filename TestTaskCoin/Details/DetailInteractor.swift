//
//  DetailInteractor.swift
//  TestTaskCoin
//
//  Created by 123 on 04.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailBusinessLogic {
    func makeRequest(request: Detail.Model.Request.RequestType)
}

class DetailInteractor: DetailBusinessLogic {
    
    var presenter: DetailPresentationLogic?
    var service: DetailService?
    
    func makeRequest(request: Detail.Model.Request.RequestType) {
        if service == nil {
            service = DetailService()
        }
        switch request {
        case .processViewModel(let coinModel):
            presenter?.presentData(response: .processViewModel(coinModel))
        }
    }
    
}
