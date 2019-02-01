//
//  Endpoint.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

enum Endpoint {
    
    var method: Method {
        return .get
    }
    
    //as base url could be different for each endpoint, it makes sense to configure it separately (even probably in different place (not in Endpoint enum))
    //also url scheme could be configured separately
    private var baseURL: String { return "" }
    
    private var path: String { return "" }
    
    var url: URL? {
        
        return URL(string: baseURL + path)
    }
}
