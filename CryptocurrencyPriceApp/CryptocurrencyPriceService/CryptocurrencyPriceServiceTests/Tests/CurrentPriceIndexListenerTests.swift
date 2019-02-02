//
//  CurrentPriceIndexListenerTests.swift
//  CryptocurrencyPriceServiceTests
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import XCTest
@testable import CryptocurrencyPriceService

class CurrentPriceIndexListenerTests: XCTestCase {

    func testSuccessListenerCorrect() {
        
        //Given
        let exp = expectation(description: "listen to current price index")
        let networking = NetworkingMock(result: .success)
        let service = CoindeskServiceImp(networking: networking)
        let listener = CurrentPriceIndexListenerImp(service: service,
                                                    minimalTimeInterval: 0.5)
        var counter = 0
        
        //When
        listener.start(with: 0.5, success: { (priceIndex) in
            //count how many times success was handled
            counter += 1
            
            //success should be handled 5 times during 2.1 seconds
            //0s - 1, 0.5s - 2, 1s - 3, 1.5s - 4, 2s - 5
            if counter == 5 {
                exp.fulfill()
            }
        }, failure: nil)
        
        //Then
        waitForExpectations(timeout: 2.1, handler: nil)
    }
    
    func testStopListenerCorrect() {
        
        //Given
        let networking = NetworkingMock(result: .success)
        let service = CoindeskServiceImp(networking: networking)
        let listener = CurrentPriceIndexListenerImp(service: service,
                                                    minimalTimeInterval: 0.5)
        var counter = 0
        
        //When
        listener.start(with: 0.5, success: { (priceIndex) in
            //count how many times success was handled
            counter += 1
            
            //success should be handled 3 times after 1s
            //0s - 1, 0.5s - 2, 1s - 3
            if counter == 3 {
                listener.finish()
            }
            
        }, failure: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1, execute: {
            //Then
            XCTAssertEqual(counter, 3, "success should not be handled after stop listener")
        })
    }

    func testFailedListenerCorrect() {
        
        //Given
        let networking = NetworkingMock(result: .error(MockingError.anyError))
        let service = CoindeskServiceImp(networking: networking)
        let listener = CurrentPriceIndexListenerImp(service: service,
                                                    minimalTimeInterval: 0.5)
        
        //When
        listener.start(with: 0.5, success: { _ in
            XCTFail("success block should not be called")
        }) { error in
            //Then
            XCTAssertNotNil(error, "error should not be nil")
            XCTAssertEqual((error as! LocalizedError).errorDescription, MockingError.anyError.errorDescription, "error should be thrown correctly")
        }
    }
}
