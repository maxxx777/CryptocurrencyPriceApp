//
//  DateMock.swift
//  CryptocurrencyPriceServiceTests
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

extension Date {
    
    static var dayBeforeYesterday: Date {
        
        return Date(timeIntervalSinceNow: -2*24*60*60)
    }
    
    static var yesterday: Date {
        
        return Date(timeIntervalSinceNow: -1*24*60*60)
    }
    
    static var today: Date {
        
        return Date()
    }
    
    static var tomorrow: Date {
        
        return Date(timeIntervalSinceNow: 1*24*60*60)
    }
    
    static var dayAfterTomorrow: Date {
        
        return Date(timeIntervalSinceNow: 2*24*60*60)
    }
}
