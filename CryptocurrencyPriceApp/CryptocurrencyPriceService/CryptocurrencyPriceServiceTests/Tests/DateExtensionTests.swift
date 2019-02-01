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

    func testExtensionReturnsCorrectParameterValue() {
        
        //Given
        let date = Date(timeIntervalSince1970: 0)
        
        //Then
        XCTAssertEqual(date.parameterValue, "1970-01-01", "Date has wrong parameter value")
    }
}
