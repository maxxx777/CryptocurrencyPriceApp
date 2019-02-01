//
//  EndpointTests.swift
//  CryptocurrencyPriceServiceTests
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import XCTest
@testable import CryptocurrencyPriceService

class EndpointTests: XCTestCase {

    func testCurrentPriceIndexInEUREndpointHasCorrectURLString() {
        
        //Given
        let endpoint = Endpoint.currentPriceIndexIn(.EUR)
        
        //Then
        XCTAssertEqual(endpoint.url?.absoluteString, "https://api.coindesk.com/v1/bpi/currentprice/EUR.json")
    }


}
