//
//  CoindeskService.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

public protocol CoindeskService {
    
    // fetch current price index for EUR, USD, GBP
    func fetchCurrentPriceIndex(success: Success<CurrentPriceIndex>?, failure: Failure?)
    
    // fetch historical price index for specific date and in specific currency
    func fetchHistoricalPriceIndex(for date: Date, in currency: Currency, success: Success<HistoricalPriceIndex>?, failure: Failure?)
    
    // fetch historical price index for specific range of dates and in specific currency
    func fetchHistoricalPriceIndex(between startDate: Date, and endDate: Date, in currency: Currency, success: Success<HistoricalPriceIndex>?, failure: Failure?)
}

public extension CoindeskService {
    
    // fetch historical price index for specific date and in default currency
    func fetchHistoricalPriceIndex(for date: Date, success: Success<HistoricalPriceIndex>?, failure: Failure?) {
        fetchHistoricalPriceIndex(for: date, in: Currency.defaultCurrency, success: success, failure: failure)
    }
    
    // fetch historical price index for specific range of dates and in specific currency
    func fetchHistoricalPriceIndex(between startDate: Date, and endDate: Date, success: Success<HistoricalPriceIndex>?, failure: Failure?) {
        fetchHistoricalPriceIndex(between: startDate, and: endDate, in: Currency.defaultCurrency, success: success, failure: failure)
    }
}

public class CoindeskServiceImp {
    
    fileprivate var networking: Networking
    
    enum Errors: LocalizedError {
        case wrongDateParameter
        
        var errorDescription: String? {
            switch self {
            case .wrongDateParameter:
                return "Can not get result for this date"
            }
        }
    }
    
    public init() {
        self.networking = NetworkingImp()
    }
    
    init(networking: Networking) {
        self.networking = networking
    }
}

extension CoindeskServiceImp: CoindeskService {
    
    public func fetchCurrentPriceIndex(success: ((CurrentPriceIndex) -> Void)?,
                                       failure: ((Error) -> Void)?) {
        
        let endpoint = Endpoint.currentPriceIndex
        
        call(endpoint, success: success, failure: failure)
    }
    
    public func fetchHistoricalPriceIndex(for date: Date, in currency: Currency, success: Success<HistoricalPriceIndex>?, failure: Failure?) {
        
        //add client checking, as coindesk remote api returns error if date is equal or more than today
        guard date.isPastDay else {
            handle(error: Errors.wrongDateParameter, into: failure)
            return
        }
        
        let endpoint = Endpoint.historicalPriceIndex(date, currency)
        
        call(endpoint, success: success, failure: failure)
    }
    
    public func fetchHistoricalPriceIndex(between startDate: Date, and endDate: Date, in currency: Currency, success: Success<HistoricalPriceIndex>?, failure: Failure?) {
        
        //add client checking, as coindesk remote api returns error either if date is equal or more than today, or start date more than end date
        guard startDate.isPastDay && endDate.isFutureDay(after: startDate) else {
            handle(error: Errors.wrongDateParameter, into: failure)
            return
        }
        
        let endpoint = Endpoint.historicalPriceIndexRange(startDate, endDate, currency)
        
        call(endpoint, success: success, failure: failure)
    }
}

fileprivate extension CoindeskServiceImp {
    
    func call<T: Decodable>(_ endpoint: Endpoint, success: Success<T>?, failure: Failure?) {
        
        networking.call(endpoint) { [weak self] result in
            
            switch result {
            case let .success(data):
                
                self?.decode(result: data, into: success, or: failure)
                
            case let .failure(error):
                
                self?.handle(error: error, into: failure)
            }
        }
    }
    
    func decode<T: Decodable>(result data: Data, into success: Success<T>?, or failure: Failure?) {
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            handle(result: result, into: success)
        } catch let jsonDecodingError {
            handle(error: jsonDecodingError, into: failure)
        }
    }
    
    func handle<T: Decodable>(result:T, into success: Success<T>?) {
        
        DispatchQueue.main.async {
            success?(result)
        }
    }
    
    func handle(error:Error, into failure: Failure?) {
        
        DispatchQueue.main.async {
            failure?(error)
        }
    }
}
