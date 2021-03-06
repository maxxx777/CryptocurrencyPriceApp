//
//  DateExtensionTests.swift
//  CryptocurrencyPriceServiceTests
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import XCTest
@testable import CryptocurrencyPriceService

class DateExtensionTests: XCTestCase {

    func testCorrectParameterValue() {
        
        //Given
        let date = Date(timeIntervalSince1970: 1549017910.8756309)
        
        //Then
        XCTAssertEqual(date.parameterValue, "2019-02-01", "Date has wrong parameter value")
    }
    
    func testIsPastDayTrue() {
        
        //Then
        XCTAssert(Date.yesterday.isPastDay, "It should be past day")
    }
    
    func testIsPastDayFalse() {
        
        //Then
        XCTAssertFalse(Date.tomorrow.isPastDay, "It should not be past day")
        XCTAssertFalse(Date.today.isPastDay, "It should not be past day")
    }
    
    func testIsFutureDayTrue() {
        
        //Then
        XCTAssert(Date.tomorrow.isFutureDay(after: Date.today), "It should be future day")
    }
    
    func testIsFutureDayFalse() {
        
        //Then
        XCTAssertFalse(Date.yesterday.isFutureDay(after: Date.today), "It should not be future day")
        XCTAssertFalse(Date.today.isFutureDay(after: Date.today), "It should not be future day")
    }
    
    func testIsTodayTrue() {
        
        //Then
        XCTAssert(Date.today.isToday, "It should be today")
    }
    
    func testIsTodayFalse() {
        
        //Then
        XCTAssertFalse(Date.tomorrow.isToday, "It should not be today")
        XCTAssertFalse(Date.yesterday.isToday, "It should not be today")
    }
    
    func testIsYesterdayTrue() {
        
        //Then
        XCTAssert(Date.yesterday.isYesterday, "It should be yesterday")
    }
    
    func testIsYesterdayFalse() {
        
        //Then
        XCTAssertFalse(Date.dayBeforeYesterday.isYesterday, "It should not be yesterday")
        XCTAssertFalse(Date.today.isYesterday, "It should not be yesterday")
    }
}
