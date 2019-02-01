//
//  HistoricalPriceIndex.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

struct HistoricalPriceIndex: Decodable {
    
    fileprivate let bpi: [String: Float]
}

extension HistoricalPriceIndex {
    
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
