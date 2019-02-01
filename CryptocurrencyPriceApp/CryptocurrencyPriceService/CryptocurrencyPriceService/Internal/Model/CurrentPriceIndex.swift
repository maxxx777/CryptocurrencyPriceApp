//
//  PriceIndex.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

fileprivate struct CurrencyDetails: Decodable {
    
    let rate: String
}

struct CurrentPriceIndex: Decodable {

    private let bpi: [Currency.RawValue: CurrencyDetails]
}

extension CurrentPriceIndex {
    
    subscript(currency: Currency) -> String? {
        return bpi[currency.rawValue]?.rate
    }
}
