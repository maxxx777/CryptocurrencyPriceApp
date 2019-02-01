//
//  CoindeskServiceTests.swift
//  CryptocurrencyPriceServiceTests
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import XCTest
@testable import CryptocurrencyPriceService

class CoindeskServiceTests: XCTestCase {

    func testSuccessFetchCurrentPriceIndexCorrect() {
        
        let networking = NetworkingMock(result: .success)
        let service = CoindeskServiceImp(networking: networking)
        service.fetchCurrentPriceIndex(success: { (priceIndex) in
            XCTAssertNotNil(priceIndex, "price index should not be nil")
            XCTAssertEqual(priceIndex[Currency.EUR]!, "94.7398", "price in EUR should be fethed correctly")
            XCTAssertEqual(priceIndex[Currency.USD]!, "126.5235", "price in EUR should be fethed correctly")
            XCTAssertEqual(priceIndex[Currency.GBP]!, "79.2495", "price in EUR should be fethed correctly")
        }) { _ in
            XCTFail("failure block should not be called")
        }
    }
    
    func testFailFetchCurrentPriceIndexCorrect() {
        
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        service.fetchCurrentPriceIndex(success: { (priceIndex) in
            XCTFail("success block should not be called")
        }) { error in
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).localizedDescription, MockingError.anyError.localizedDescription, "error should be thrown correctly")
        }
        
    }

}