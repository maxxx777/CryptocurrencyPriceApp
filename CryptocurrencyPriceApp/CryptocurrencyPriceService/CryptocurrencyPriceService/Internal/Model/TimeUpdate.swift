//
//  TimeUpdate.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 03.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

enum TimeUpdate: String {
    
    case updated, updatedISO, updateduk
}

extension TimeUpdate: Decodable {}
