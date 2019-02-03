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
    let time: Date?
    
    init(date: Date,
         price: String,
         currency: Currency,
         time: Date? = nil) {
        
        self.date = date
        self.price = price
        self.currency = currency
        self.time = time
    }
    
    var dateText: String {
        
        if date.isToday {
            guard let time = time else { return "Now" }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            return "Today, " + dateFormatter.string(from: time)
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
