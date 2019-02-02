//
//  CoindeskServiceMock.swift
//  CryptocurrencyPriceAppTests
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
import CryptocurrencyPriceService

class CoindeskServiceMock: CoindeskService {
    
    enum MockingResult {
        case success
        case failHistoryFetch(MockingError)
        case failCurrentFetch(MockingError)
        case error(MockingError)
    }
    
    var result: MockingResult
    
    init(result: MockingResult) {
        self.result = result
    }
    
    func fetchHistoricalPriceIndex(between startDate: Date,
                                   and endDate: Date,
                                   in currency: Currency,
                                   success: ((HistoricalPriceIndex) -> ())?,
                                   failure: Failure?) {
        
        switch result {
        case .success, .failCurrentFetch(_):
            success?(Stubs.historicalPriceIndexStub())
        case .failHistoryFetch(let error), .error(let error):
            failure?(error)
        }
    }
    
    func fetchHistoricalPriceIndex(for date: Date, in currency: Currency, success: ((HistoricalPriceIndex) -> ())?, failure: Failure?) {
        
        switch result {        
        case .error(let error):
            failure?(error)
        default:
            success?(Stubs.historicalPriceIndexOneDayStub())
        }
        
    }
    
    func fetchCurrentPriceIndex(in currency: Currency?,
                                success: ((CurrentPriceIndex) -> ())?,
                                failure: Failure?) {
        
        switch result {
        case .success, .failHistoryFetch(_):
            success?(Stubs.currentPriceIndexStub())
        case .failCurrentFetch(let error), .error(let error):
            failure?(error)
        }
    }
}
