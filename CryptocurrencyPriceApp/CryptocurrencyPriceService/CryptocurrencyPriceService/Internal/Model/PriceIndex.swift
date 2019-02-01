//
//  PriceIndex.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

struct CurrencyDetails: Decodable {    
    fileprivate let rate: String
}

struct PriceIndex: Decodable {
    private let bpi: [Currency.RawValue: CurrencyDetails]
    
    subscript(currency: Currency) -> String? {
        return bpi[currency.rawValue]?.rate
    }
}
