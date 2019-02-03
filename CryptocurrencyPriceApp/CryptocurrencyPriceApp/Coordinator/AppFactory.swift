//
//  AppFactory.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit
import CryptocurrencyPriceService

class AppFactory {
    
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    func itemListViewController() -> ItemListViewController {
        
        let service = PriceIndexServiceImp()
        let currentPriceIndexListener = CurrentPriceIndexListenerImp()
        let viewModel = ItemListViewModelImp(service: service,
                                             currentPriceIndexListener: currentPriceIndexListener)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func itemDetailViewController(with date: Date, prices: [Currency: String]) -> ItemDetailViewController {
        
        let service = PriceIndexServiceImp()
        let currentPriceIndexListener = CurrentPriceIndexListenerImp()
        let viewModel = ItemDetailViewModelImp(service: service,
                                               currentPriceIndexListener: currentPriceIndexListener,
                                               date: date,
                                               prices: prices)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}

