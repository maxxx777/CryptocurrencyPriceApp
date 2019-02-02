//
//  PriceIndex.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

public struct CurrentPriceIndex {

    private let bpi: [Currency.RawValue: CurrencyDetails]
}

public extension CurrentPriceIndex {
    
    subscript(currency: Currency) -> String? {
        return bpi[currency.rawValue]?.rate
    }
}

extension CurrentPriceIndex: Decodable {}
