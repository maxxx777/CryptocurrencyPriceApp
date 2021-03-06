//
//  Endpoint.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

enum Endpoint {
    
    case currentPriceIndex
    case historicalPriceIndex(Date, Currency)
    case historicalPriceIndexRange(Date, Date, Currency)
}

extension Endpoint {
    
    var method: Method {
        return .get
    }
    
    //as base url could be different for each endpoint, it makes sense to configure it separately (even probably in different place (not in Endpoint enum))
    //also url scheme could be configured separately
    private var baseURL: String {
        return "https://api.coindesk.com/v1/bpi"
    }
    
    private var path: String {
        switch self {
        case .currentPriceIndex:
            return "/currentprice.json"        
        case let .historicalPriceIndex(date, currency):
            let stringValueForDate = date.parameterValue
            return "/historical/close.json?start=\(stringValueForDate)&end=\(stringValueForDate)&currency=\(currency)"
        case let .historicalPriceIndexRange(startDate, endDate, currency):
            let stringValueForStartDate = startDate.parameterValue
            let stringValueForEndDate = endDate.parameterValue
            return "/historical/close.json?start=\(stringValueForStartDate)&end=\(stringValueForEndDate)&currency=\(currency)"
        }
    }
    
    var url: URL? {
        
        return URL(string: baseURL + path)
    }
}
