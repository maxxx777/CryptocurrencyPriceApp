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
        
        let service = CoindeskServiceImp()
        let currentPriceIndexListener = CurrentPriceIndexListenerImp()
        let viewModel = ItemListViewModelImp(service: service,
                                             currentPriceIndexListener: currentPriceIndexListener)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}

