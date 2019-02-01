//
//  CoindeskService.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

typealias Success<T> = ((T) -> Void)?
typealias Failure = ((Error) -> Void)?

protocol CoindeskService {
    
    // fetch current price index for specific currency
    func fetchCurrentPriceIndex(in currency: Currency?, success: Success<CurrentPriceIndex>, failure: Failure)
    
    // fetch historical price index for specific date and in specific currency
    func fetchHistoricalPriceIndex(for date: Date, in currency: Currency, success: Success<HistoricalPriceIndex>, failure: Failure)
}

extension CoindeskService {
    
    // fetch current price index for EUR, USD, GBP
    func fetchCurrentPriceIndex(success: Success<CurrentPriceIndex>, failure: Failure) {
        fetchCurrentPriceIndex(in: nil, success: success, failure: failure)
    }
    
    // fetch historical price index for specific date and in default currency
    func fetchHistoricalPriceIndex(for date: Date, success: Success<HistoricalPriceIndex>, failure: Failure) {
        fetchHistoricalPriceIndex(for: date, in: Currency.defaultCurrency, success: success, failure: failure)
    }
}

class CoindeskServiceImp {
    
    fileprivate var networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
}

extension CoindeskServiceImp: CoindeskService {
    
    func fetchCurrentPriceIndex(in currency: Currency?,
                                success: ((CurrentPriceIndex) -> Void)?,
                                failure: ((Error) -> Void)?) {
        
        let endpoint = Endpoint.makeCurrentPriceIndexEndpoint(with: currency)
        
        networking.call(endpoint) { result in
            
            switch result {
            case let .success(data):
                
                do {
                    let priceIndex = try JSONDecoder().decode(CurrentPriceIndex.self, from: data)
                    success?(priceIndex)
                } catch let jsonDecodingError {
                    failure?(jsonDecodingError)
                }

            case let .failure(error):
                
                failure?(error)
            }
        }
    }
    
    func fetchHistoricalPriceIndex(for date: Date, in currency: Currency, success: Success<HistoricalPriceIndex>, failure: Failure) {
        
        let endpoint = Endpoint.historicalPriceIndex(date, currency)
        
        networking.call(endpoint) { result in
            
            switch result {
            case let .success(data):
                
                do {
                    let priceIndex = try JSONDecoder().decode(HistoricalPriceIndex.self, from: data)
                    success?(priceIndex)
                } catch let jsonDecodingError {
                    failure?(jsonDecodingError)
                }
                
            case let .failure(error):
                
                failure?(error)
            }
        }
    }
}

fileprivate extension Endpoint {
    
    // factory to choose endpoint to get current price index depending on whether currency is specified or not
    static func makeCurrentPriceIndexEndpoint(with currency: Currency?) -> Endpoint {
        
        if let currency = currency {
            return Endpoint.currentPriceIndexIn(currency)
        } else {
            return Endpoint.currentPriceIndex
        }
    }
}
