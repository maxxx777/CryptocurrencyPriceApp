//
//  CurrencyDetails.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

struct CurrencyDetails {
    
    let rate: String
}

extension CurrencyDetails: Decodable {}
