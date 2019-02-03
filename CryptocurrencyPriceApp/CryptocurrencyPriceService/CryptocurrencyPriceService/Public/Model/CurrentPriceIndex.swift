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
    private let time: [TimeUpdate.RawValue: String]
}

public extension CurrentPriceIndex {
    
    subscript(currency: Currency) -> String? {
        return bpi[currency.rawValue]?.rate
    }
    
    var timeOfUpdate: Date? {
        
        guard let dateString = time[TimeUpdate.updatedISO.rawValue] else { return nil }
        
        let formatter = ISO8601DateFormatter()
        
        return formatter.date(from: dateString)        
    }
}

extension CurrentPriceIndex: Decodable {}
