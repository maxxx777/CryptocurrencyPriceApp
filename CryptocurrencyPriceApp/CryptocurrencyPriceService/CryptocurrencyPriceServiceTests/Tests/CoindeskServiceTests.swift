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

    func testSuccessFetchCurrentPriceIndex() {
        
        //Given
        let networking = NetworkingMock(result: .success)
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchCurrentPriceIndex(success: { (priceIndex) in
            //Then
            XCTAssertEqual(priceIndex[Currency.EUR]!, "94.7398", "price in EUR should be fethed correctly")
            XCTAssertEqual(priceIndex[Currency.USD]!, "126.5235", "price in EUR should be fethed correctly")
            XCTAssertEqual(priceIndex[Currency.GBP]!, "79.2495", "price in EUR should be fethed correctly")
        }) { _ in
            XCTFail("failure block should not be called")
        }
    }
    
    func testFailFetchCurrentPriceIndex() {
        
        //Given
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchCurrentPriceIndex(success: { _ in
            XCTFail("success block should not be called")
        }) { error in
            //Then
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).errorDescription, MockingError.anyError.errorDescription, "error should be thrown correctly")
        }
    }
    
    func testSuccessFetchHistoricalPriceIndex() {
        
        //Given
        let networking = NetworkingMock(result: .success)
        let service = CoindeskServiceImp(networking: networking)        
        
        //When
        service.fetchHistoricalPriceIndex(for: Date.yesterday,
                                          success: { (historicalPriceIndex) in
            //Then
            XCTAssertEqual(historicalPriceIndex["2013-09-01"], "128.2597", "price should be fethed correctly")
        }) { _ in
            XCTFail("failure block should not be called")
        }
    }

    func testFailFetchHistoricalPriceIndex() {
        
        //Given
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchHistoricalPriceIndex(for: Date.yesterday,
                                          success: { _ in
            XCTFail("success block should not be called")
        }) { error in
            //Then
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).errorDescription, MockingError.anyError.errorDescription, "error should be thrown correctly")
        }
    }
    
    func testSuccessFetchHistoricalPriceIndexRange() {
        
        //Given
        let networking = NetworkingMock(result: .success)
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchHistoricalPriceIndex(between: Date.dayBeforeYesterday,
                                          and: Date.yesterday,
                                          success: { (historicalPriceIndex) in
                                            //Then
                                            XCTAssertEqual(historicalPriceIndex["2013-09-01"], "128.2597", "price should be fethed correctly")
                                            XCTAssertEqual(historicalPriceIndex["2013-09-03"], "127.5915", "price should be fethed correctly")
                                            XCTAssertEqual(historicalPriceIndex["2013-09-05"], "120.5333", "price should be fethed correctly")                                            
        }) { _ in
            XCTFail("failure block should not be called")
        }
    }
    
    func testFailFetchHistoricalPriceIndexRange() {
        
        //Given
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchHistoricalPriceIndex(between: Date.dayBeforeYesterday,
                                          and: Date.yesterday,
                                          success: { _ in
                                            XCTFail("success block should not be called")
        }) { error in
            //Then
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).errorDescription, MockingError.anyError.errorDescription, "error should be thrown correctly")
        }
    }
    
    func testFailDateIsTodayInHistoricalPriceIndex() {
        
        //Given
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchHistoricalPriceIndex(for: Date.today,
                                          success: { _ in
                                            XCTFail("success block should not be called")
        }) { error in
            //Then
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).errorDescription, CoindeskServiceImp.Errors.wrongDateParameter.errorDescription, "error should be thrown correctly")
        }
        
    }
    
    func testFailDateIsInFutureInHistoricalPriceIndex() {
        
        //Given
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchHistoricalPriceIndex(for: Date.tomorrow,
                                          success: { _ in
                                            XCTFail("success block should not be called")
        }) { error in
            //Then
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).errorDescription, CoindeskServiceImp.Errors.wrongDateParameter.errorDescription, "error should be thrown correctly")
        }
        
    }
    
    func testFailStartDateIsTodayInHistoricalPriceIndexRange() {
        
        //Given
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchHistoricalPriceIndex(between: Date.today,
                                          and: Date.tomorrow,
                                          success: { _ in
                                            XCTFail("success block should not be called")
        }) { error in
            //Then
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).errorDescription, CoindeskServiceImp.Errors.wrongDateParameter.errorDescription, "error should be thrown correctly")
        }
        
    }
    
    func testFailStartDateMoreThanEndDateInHistoricalPriceIndexRange() {
        
        //Given
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        
        //When
        service.fetchHistoricalPriceIndex(between: Date.yesterday,
                                          and: Date.dayBeforeYesterday,
                                          success: { _ in
                                            XCTFail("success block should not be called")
        }) { error in
            //Then
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).errorDescription, CoindeskServiceImp.Errors.wrongDateParameter.errorDescription, "error should be thrown correctly")
        }
        
    }
}
