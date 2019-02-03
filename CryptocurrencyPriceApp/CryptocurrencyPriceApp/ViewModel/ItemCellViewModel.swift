//
//  ItemCellViewModel.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
import CryptocurrencyPriceService

struct ItemCellViewModel {
    
    let date: Date
    let price: String
    let currency: Currency
    
    var dateText: String {
        
        if date.isToday {
            return "Now"
        } else if date.isYesterday {
            return "Yesterday"
        } else {
            return date.parameterValue
        }        
    }
    
    var priceText: String {
        return price + " " + currency.rawValue
    }
}
