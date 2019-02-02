//
//  Stubs.swift
//  CryptocurrencyPriceAppTests
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
import CryptocurrencyPriceService

struct Stubs {
    
    static func historicalPriceIndexStub() -> HistoricalPriceIndex {
        
        let data = Helper.data(from: "HistoricalPriceIndexRangeStubbedResponse")
        return try! JSONDecoder().decode(HistoricalPriceIndex.self, from: data!)
    }
    
    static func currentPriceIndexStub() -> CurrentPriceIndex {
        
        let data = Helper.data(from: "CurrentPriceIndexStubbedResponse")
        return try! JSONDecoder().decode(CurrentPriceIndex.self, from: data!)
    }
    
}

fileprivate class Helper {
    
    static func data(from filename: String) -> Data? {
        
        let bundle = Bundle(for: self)
        guard let filePath = bundle.url(forResource: filename, withExtension: "json") else { return nil }
        return try? Data(contentsOf: filePath)
    }

}
