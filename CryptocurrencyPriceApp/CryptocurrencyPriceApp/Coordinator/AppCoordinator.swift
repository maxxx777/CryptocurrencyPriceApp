//
//  AppCoordinator.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    private let navigationController = UINavigationController()
    private let factory = AppFactory()
    
    init(window: UIWindow?) {
        
        window?.rootViewController = navigationController
    }
    
    func start() {
        
        let viewController = factory.itemListViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

