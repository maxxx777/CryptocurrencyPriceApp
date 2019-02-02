//
//  ItemListViewModelTests.swift
//  CryptocurrencyPriceAppTests
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import XCTest
@testable import CryptocurrencyPriceApp

class ItemListViewModelTests: XCTestCase {

    func testCorrectFetchData() {
        
        let exp = expectation(description: "fetch data")
        let service = CoindeskServiceMock(result: .success)
        let listener = CurrentPriceIndexListenerMock(result: .success)
        let viewModel = ItemListViewModelImp(service: service,
                                             currentPriceIndexListener: listener,
                                             today: Stubs.todayStub(),
                                             numberOfDays: 14)
        
        viewModel.fetchData(success: {
            
            XCTAssertEqual(viewModel.numberOfItems(), 14, "number of items is wrong")
            
            let todayCellViewModel = viewModel.cellViewModel(at: 0)
            XCTAssertEqual(todayCellViewModel?.dateText, "2019-01-20", "date is wrong")
            XCTAssertEqual(todayCellViewModel?.price, "94.7398", "price is wrong")
            
            let lastCellViewModel = viewModel.cellViewModel(at: 13)
            XCTAssertEqual(lastCellViewModel?.dateText, "2019-01-07", "date is wrong")
            XCTAssertEqual(lastCellViewModel?.price, "4041.4583", "price is wrong")
            
            exp.fulfill()
            
        }, failure: nil)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testErrorFetchData() {
        
        let exp = expectation(description: "fetch data")
        let service = CoindeskServiceMock(result: .error(MockingError.anyError))
        let listener = CurrentPriceIndexListenerMock(result: .success)
        let viewModel = ItemListViewModelImp(service: service,
                                             currentPriceIndexListener: listener,
                                             today: Stubs.todayStub(),
                                             numberOfDays: 14)
        
        viewModel.fetchData(success: nil) { (errorText) in
            XCTAssertEqual(errorText, MockingError.anyError.errorDescription, "error text is wrong")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testFailFetchHistory() {
        
        let exp = expectation(description: "fetch data")
        let service = CoindeskServiceMock(result: .failHistoryFetch(MockingError.anyError))
        let listener = CurrentPriceIndexListenerMock(result: .success)
        let viewModel = ItemListViewModelImp(service: service,
                                             currentPriceIndexListener: listener,
                                             today: Stubs.todayStub(),
                                             numberOfDays: 14)
        
        viewModel.fetchData(success: nil) { (errorText) in
            XCTAssertEqual(errorText, MockingError.anyError.errorDescription, "error text is wrong")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testFailFetchCurrent() {
        
        let exp = expectation(description: "fetch data")
        let service = CoindeskServiceMock(result: .failCurrentFetch(MockingError.anyError))
        let listener = CurrentPriceIndexListenerMock(result: .success)
        let viewModel = ItemListViewModelImp(service: service,
                                             currentPriceIndexListener: listener,
                                             today: Stubs.todayStub(),
                                             numberOfDays: 14)
        
        viewModel.fetchData(success: nil) { (errorText) in
            XCTAssertEqual(errorText, MockingError.anyError.errorDescription, "error text is wrong")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testCorrectListenCurrentUpdates() {
        
        let exp = expectation(description: "fetch data")
        let service = CoindeskServiceMock(result: .success)
        let listener = CurrentPriceIndexListenerMock(result: .success)
        let viewModel = ItemListViewModelImp(service: service,
                                             currentPriceIndexListener: listener,
                                             today: Stubs.todayStub(),
                                             numberOfDays: 14)
        
        viewModel.fetchData(success: {
            
            viewModel.listenCurrentUpdates(success: {
                XCTAssertEqual(viewModel.numberOfItems(), 14, "number of items is wrong")
                
                let todayCellViewModel = viewModel.cellViewModel(at: 0)
                XCTAssertEqual(todayCellViewModel?.dateText, "2019-01-20", "date is wrong")
                XCTAssertEqual(todayCellViewModel?.price, "94.7398", "price is wrong")
                
                let lastCellViewModel = viewModel.cellViewModel(at: 13)
                XCTAssertEqual(lastCellViewModel?.dateText, "2019-01-07", "date is wrong")
                XCTAssertEqual(lastCellViewModel?.price, "4041.4583", "price is wrong")
                
                exp.fulfill()
                
            }, failure: nil)
            
        }, failure: nil)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testErrorListenCurrentUpdates() {
        
        let exp = expectation(description: "listen current updates")
        let service = CoindeskServiceMock(result: .success)
        let listener = CurrentPriceIndexListenerMock(result: .error(MockingError.anyError))
        let viewModel = ItemListViewModelImp(service: service,
                                             currentPriceIndexListener: listener,
                                             today: Stubs.todayStub(),
                                             numberOfDays: 14)
        
        viewModel.fetchData(success: {
            
            viewModel.listenCurrentUpdates(success: nil, failure: { (errorText) in
                XCTAssertEqual(errorText, MockingError.anyError.errorDescription, "error text is wrong")
                exp.fulfill()
            })
            
        }, failure: nil)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    //TODO: add more tests to cover the following cases:
    // - price is missing in current price index
    // - data is missing in history price index
    // - listen current price index returns multiple callbacks in intervals
    // - listen current price index stops returns callbacks if finish method called
    // - listen current price index method is called before fetch data method called
}
