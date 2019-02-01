//
//  Date+Extension.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

extension Date {
    
    var parameterValue: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        return dateFormatter.string(from: self)
    }
}

extension Date {
    
    var isPastDay: Bool {
        
        return Date().isFutureDay(after: self)
    }
    
    func isFutureDay(after date: Date) -> Bool {
        
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedDescending
    }
}
