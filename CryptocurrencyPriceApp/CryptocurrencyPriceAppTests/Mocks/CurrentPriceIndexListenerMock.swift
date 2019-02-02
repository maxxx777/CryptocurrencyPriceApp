//
//  CurrentPriceIndexListenerMock.swift
//  CryptocurrencyPriceAppTests
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
import CryptocurrencyPriceService

class CurrentPriceIndexListenerMock: CurrentPriceIndexListener {

    enum MockingResult {
        case success
        case error(MockingError)
    }
    
    var result: MockingResult
    
    init(result: MockingResult) {
        self.result = result
    }
    
    func start(with interval: TimeInterval,
               success: ((CurrentPriceIndex) -> ())?,
               failure: Failure?) {
        
        switch result {
        case .success:
            success?(Stubs.currentPriceIndexStub())
        case let .error(error):
            failure?(error)
        }
    }
    
    func finish() {
        
    }
    
}
