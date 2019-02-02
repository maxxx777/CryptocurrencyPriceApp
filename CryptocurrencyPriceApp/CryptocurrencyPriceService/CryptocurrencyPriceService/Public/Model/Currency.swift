//
//  Currency.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

public enum Currency: String {
    case USD, GBP, EUR
}

public extension Currency {
    
    static var defaultCurrency: Currency {
        return .EUR
    }
}

extension Currency: Decodable {}

extension Currency: CaseIterable {}
