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
    
    // fetch historical price index for specific range of dates and in specific currency
    func fetchHistoricalPriceIndex(between startDate: Date, and endDate: Date, in currency: Currency, success: Success<HistoricalPriceIndex>, failure: Failure)
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
    
    // fetch historical price index for specific range of dates and in specific currency
    func fetchHistoricalPriceIndex(between startDate: Date, and endDate: Date, success: Success<HistoricalPriceIndex>, failure: Failure) {
        fetchHistoricalPriceIndex(between: startDate, and: endDate, in: Currency.defaultCurrency, success: success, failure: failure)
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
        
        call(endpoint, success: success, failure: failure)
    }
    
    func fetchHistoricalPriceIndex(for date: Date, in currency: Currency, success: Success<HistoricalPriceIndex>, failure: Failure) {
        
        let endpoint = Endpoint.historicalPriceIndex(date, currency)
        
        call(endpoint, success: success, failure: failure)
    }
    
    func fetchHistoricalPriceIndex(between startDate: Date, and endDate: Date, in currency: Currency, success: Success<HistoricalPriceIndex>, failure: Failure) {
        
        let endpoint = Endpoint.historicalPriceIndexRange(startDate, endDate, currency)
        
        call(endpoint, success: success, failure: failure)
    }
}

fileprivate extension CoindeskServiceImp {
    
    func call<T: Decodable>(_ endpoint: Endpoint, success: Success<T>, failure: Failure) {
        
        networking.call(endpoint) { [weak self] result in
            
            switch result {
            case let .success(data):
                
                self?.handleSuccess(result: data, into: success, or: failure)
                
            case let .failure(error):
                
                failure?(error)
            }
        }
    }
    
    func handleSuccess<T: Decodable>(result data: Data, into success: Success<T>, or failure: Failure) {
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            success?(result)
        } catch let jsonDecodingError {
            failure?(jsonDecodingError)
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
