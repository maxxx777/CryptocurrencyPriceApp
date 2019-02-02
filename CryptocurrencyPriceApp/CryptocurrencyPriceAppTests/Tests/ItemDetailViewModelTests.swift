//
//  ItemDetailViewModelTests.swift
//  CryptocurrencyPriceAppTests
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import XCTest
@testable import CryptocurrencyPriceApp

class ItemDetailViewModelTests: XCTestCase {

    func testCorrectFetchDetails() {
        
        let exp = expectation(description: "fetch details")
        let service = CoindeskServiceMock(result: .success)
        let listener = CurrentPriceIndexListenerMock(result: .success)
        let viewModel = ItemDetailViewModelImp(service: service,
                                               currentPriceIndexListener: listener,
                                               date: Stubs.yesterdayStub(),
                                               prices: [.EUR:"1234.56"],
                                               today: Stubs.todayStub())
        
        viewModel.fetchDetails(success: {
            
            XCTAssertEqual(viewModel.dateText, "2019-01-19", "date text is wrong")
            
            XCTAssertEqual(viewModel.eurPrice, "1234.56 EUR", "EUR price text is wrong")
            XCTAssertEqual(viewModel.usdPrice, "128.2597 USD", "USD price text is wrong")
            XCTAssertEqual(viewModel.gbpPrice, "128.2597 GBP", "GBP price text is wrong")
            
            exp.fulfill()
        }, failure: nil)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testErrorFetchData() {
        
        let exp = expectation(description: "fetch details")
        let service = CoindeskServiceMock(result: .error(MockingError.anyError))
        let listener = CurrentPriceIndexListenerMock(result: .success)
        let viewModel = ItemDetailViewModelImp(service: service,
                                               currentPriceIndexListener: listener,
                                               date: Stubs.yesterdayStub(),
                                               prices: [.EUR:"1234.56"],
                                               today: Stubs.todayStub())
        
        viewModel.fetchDetails(success: nil) { (errorText) in
            XCTAssertEqual(errorText, MockingError.anyError.errorDescription, "error text is wrong")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }

}

