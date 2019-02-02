//
//  MockingError.swift
//  CryptocurrencyPriceAppTests
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

enum MockingError: LocalizedError {
    case anyError
    
    var errorDescription: String? {
        switch self {
        case .anyError:
            return "any error description"
        }
    }
}
