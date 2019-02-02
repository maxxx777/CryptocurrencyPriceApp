//
//  AppCoordinator.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit
import CryptocurrencyPriceService

class AppCoordinator {
    
    private let navigationController = UINavigationController()
    private let factory = AppFactory()
    
    init(window: UIWindow?) {
        
        window?.rootViewController = navigationController
    }
    
    func start() {
        
        let viewController = factory.itemListViewController()
        viewController.didSelectItem = { [weak self] (date, price) in
            self?.showDetailScreenWith(date: date, price: price)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

fileprivate extension AppCoordinator {
    
    func showDetailScreenWith(date: Date, price: String) {
        
        let viewController = factory.itemDetailViewController(with: date, prices: [Currency.defaultCurrency: price])
        navigationController.pushViewController(viewController, animated: true)
    }
}

