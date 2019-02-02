//
//  HistoricalPriceIndex.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

public struct HistoricalPriceIndex {
    
    fileprivate let bpi: [String: Float]
}

public extension HistoricalPriceIndex {
    
    subscript(date: Date) -> String? {
        
        if let price = bpi[date.parameterValue] {
            return String(describing: price)
        } else {
            return nil
        }
    }
    
    subscript(date: String) -> String? {
        
        if let price = bpi[date] {
            return String(describing: price)
        } else {
            return nil
        }        
    }
}

extension HistoricalPriceIndex: Decodable {}
