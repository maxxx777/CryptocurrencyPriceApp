//
//  TodayViewModel.swift
//  TodayWidget
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
import CryptocurrencyPriceService

typealias SuccessCompletion = ((String) -> Void)
typealias FailureCompletion = ((String) -> Void)

protocol TodayViewModel {
    
    func listenCurrentUpdates(success: SuccessCompletion?, failure: FailureCompletion?)
}

class TodayViewModelImp {
    
    fileprivate let currentPriceIndexListener = CurrentPriceIndexListenerImp()
    fileprivate let DefaultErrorMessage = "Something went wrong"
    
    fileprivate enum Errors: LocalizedError {
        case missingData
        
        var errorDescription: String? {
            switch self {
            case .missingData:
                return "Data is missing"
            }
        }
    }
    
    deinit {
        finishListenCurrentUpdates()
    }
}

extension TodayViewModelImp: TodayViewModel {
    
    func listenCurrentUpdates(success: SuccessCompletion?, failure: FailureCompletion?) {
        
        currentPriceIndexListener.start(with: 10.0,
                                        success: { [weak self] currentPriceIndex in
                                            guard let price = currentPriceIndex[Currency.defaultCurrency] else {
                                                self?.handle(error: Errors.missingData, into: failure)
                                                return
                                            }
                                            self?.handle(price: price, into: success)                                            
        }) { [weak self] error in
            self?.finishListenCurrentUpdates()
            self?.handle(error: error, into: failure)
        }
    }
    
    fileprivate func finishListenCurrentUpdates() {
        
        currentPriceIndexListener.finish()
    }
}

//MARK: Compltetion handlers

fileprivate extension TodayViewModelImp {
    
    func handle(price: String, into success: SuccessCompletion?) {
        
        let priceText = displayPriceText(with: price)
        success?(priceText)
    }
    
    func handle(error: Error, into failure: FailureCompletion?) {
        
        guard let localizedError = error as? LocalizedError else {
            failure?(DefaultErrorMessage)
            return
        }
        failure?(localizedError.errorDescription ?? DefaultErrorMessage)
    }
}

//Helpers

fileprivate extension TodayViewModelImp {
    
    func displayPriceText(with price: String) -> String {
        
        return "Now 1 BTC = \(price) \(Currency.defaultCurrency)"
    }
}
