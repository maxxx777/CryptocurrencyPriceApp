//
//  ItemDetailViewModel.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
import CryptocurrencyPriceService

protocol ItemDetailViewModel {
    
    func fetchDetails(success: SuccessCompletion?, failure: FailureCompletion?)
    
    var dateText: String {get}
    var eurPrice: String {get}
    var usdPrice: String {get}
    var gbpPrice: String {get}
}

class ItemDetailViewModelImp {
    
    enum Errors: LocalizedError {
        case missingData
        
        var errorDescription: String? {
            switch self {
            case .missingData:
                return "Some data is missed. Please try again later."
            }
        }
    }
    
    fileprivate let NoDataText = "No Data"
    
    private let service: CoindeskService
    private let currentPriceIndexListener: CurrentPriceIndexListener
    private let date: Date
    var prices: [Currency: String]
    
    // this property stores date of the day till that we should show price index.
    // it should be today date by default,
    // but it may be different for testing purposes
    private let today: Date
    
    init(service: CoindeskService,
         currentPriceIndexListener: CurrentPriceIndexListener,
         date: Date,
         prices: [Currency: String],
         today: Date = Date()) {
        
        self.service = service
        self.currentPriceIndexListener = currentPriceIndexListener
        self.date = date
        self.prices = prices
        self.today = today
    }
    
    deinit {
        finishListenCurrentUpdates()
    }
}

extension ItemDetailViewModelImp: ItemDetailViewModel {
    
    func fetchDetails(success: SuccessCompletion?, failure: FailureCompletion?) {
        
        if date.parameterValue == today.parameterValue {
            listenCurrentUpdates(success: success, failure: failure)
        } else {
            fetchPrices(success: success, failure: failure)
        }
    }
    
    var dateText: String {
        return date.parameterValue
    }
    
    var eurPrice: String {
        return displayPrice(for: .EUR)
    }
    
    var usdPrice: String {
        return displayPrice(for: .USD)
    }
    
    var gbpPrice: String {
        return displayPrice(for: .GBP)
    }
    
}

fileprivate extension ItemDetailViewModelImp {
    
    func fetchPrices(success: SuccessCompletion?,
                     failure: FailureCompletion?) {
        
        fetchPricesInMissingCurrencies(success: success, failure: failure)
    }
    
    func listenCurrentUpdates(success: SuccessCompletion?, failure: FailureCompletion?) {
        
        startListenCurrentUpdates(success: success, failure: failure)
    }
}

//MARK: Fetch data

fileprivate extension ItemDetailViewModelImp {
    
    func fetchPricesInMissingCurrencies(success: SuccessCompletion?, failure: FailureCompletion?) {
        
        let currenciesWithMissingPrices = Currency.allCases.filter { prices[$0] == nil }
        
        if currenciesWithMissingPrices.isEmpty {
            handle(success: success)
        } else {
            let currencyWithMissingPrice = currenciesWithMissingPrices.last!
            fetchPrice(in: currencyWithMissingPrice, success: success, failure: failure)
        }
    }
    
    func fetchPrice(in currency: Currency, success: SuccessCompletion?, failure: FailureCompletion?) {
        
        service.fetchHistoricalPriceIndex(for: date,
                                          in: currency,
                                          success: { [weak self] historicalPriceIndex in
                                            guard let date = self?.date,
                                                let priceUpdated = self?.updatePrice(historicalPriceIndex[date], in: currency),
                                                priceUpdated else {                                                
                                                    self?.handle(error: Errors.missingData, into: failure)
                                                    return
                                            }
                                            self?.fetchPricesInMissingCurrencies(success: success, failure: failure)
        }) { error in
            self.handle(error: error, into: failure)
        }
    }
    
    func startListenCurrentUpdates(success: SuccessCompletion?, failure: FailureCompletion?) {
        
        currentPriceIndexListener.start(with: 60.0,
                                        success: { [weak self] currentPriceIndex in
                                            self?.updatePrice(with: currentPriceIndex, success: success, failure: failure)
        }) { [weak self] error in
            self?.finishListenCurrentUpdates()
            self?.handle(error: error, into: failure)
        }
    }
    
    func finishListenCurrentUpdates() {
        
        currentPriceIndexListener.finish()
    }
}

//MARK: Compltetion handlers

fileprivate extension ItemDetailViewModelImp {
    
    func handle(success: SuccessCompletion?) {
        
        success?()
    }
    
    func handle(error:Error, into failure: FailureCompletion?) {
        
        guard let localizedError = error as? LocalizedError else {
            failure?(DefaultErrorMessage)
            return
        }
        failure?(localizedError.errorDescription ?? DefaultErrorMessage)
    }
}

//MARK: Manage Data source

fileprivate extension ItemDetailViewModelImp {

    func updatePrice(_ price: String?, in currency: Currency) -> Bool {
        
        guard let price = price else { return false }
        
        prices[currency] = price
        
        return true
    }
    
    func updatePrice(with currentPriceIndex: CurrentPriceIndex, success: SuccessCompletion?, failure: FailureCompletion?) {
        
        for currency in Currency.allCases {
            guard updatePrice(currentPriceIndex[currency], in: currency) else {
                handle(error: Errors.missingData, into: failure)
                return
            }
        }
        
        handle(success: success)
    }
    
    func displayPrice(for currency: Currency) -> String {
     
        guard let price = prices[currency] else { return NoDataText }
        return price + " " + currency.rawValue
    }
}
