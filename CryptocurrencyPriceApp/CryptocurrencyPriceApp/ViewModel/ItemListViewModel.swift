//
//  ItemListViewModel.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
import CryptocurrencyPriceService

protocol ItemListViewModel { }

class ItemListViewModelImp {
    
    private let service: CoindeskService
    private let currentPriceIndexListener: CurrentPriceIndexListener
    
    init(service: CoindeskService,
         currentPriceIndexListener: CurrentPriceIndexListener) {
        
        self.service = service
        self.currentPriceIndexListener = currentPriceIndexListener
    }
}

extension ItemListViewModelImp: ItemListViewModel { }
