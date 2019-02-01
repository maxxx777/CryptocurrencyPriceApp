//
//  NetworkingMock.swift
//  CryptocurrencyPriceServiceTests
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
@testable import CryptocurrencyPriceService

enum MockingError: LocalizedError {
    case anyError
    
    var errorDescription: String? {
        switch self {
        case .anyError:
            return "any error description"
        }
    }    
}

enum MockingResult {
    case success
    case error(MockingError)
}

class NetworkingMock: Networking {

    var result: MockingResult
    
    init(result: MockingResult) {
        self.result = result
    }

    func call(_ endpoint: Endpoint, completion: @escaping (Result) -> Void) {
        
        switch endpoint {
        case .currentPriceIndex, .currentPriceIndexIn(_):
            switch result {
            case .success:
                let data = self.data(from: "CurrentPriceIndexStubbedResponse")
                completion(Result.success(data!))
            case let .error(error):
                completion(Result.failure(error))
            }
        case .historicalPriceIndex(_, _):
            switch result {
            case .success:
                let data = self.data(from: "HistoricalPriceIndexStubbedResponse")
                completion(Result.success(data!))
            case let .error(error):
                completion(Result.failure(error))
            }
        case .historicalPriceIndexRange(_, _, _):
            switch result {
            case .success:
                let data = self.data(from: "HistoricalPriceIndexRangeStubbedResponse")
                completion(Result.success(data!))
            case let .error(error):
                completion(Result.failure(error))
            }
        }
    }
    
}

fileprivate extension NetworkingMock {
    
    func data(from filename: String) -> Data? {
        
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.url(forResource: filename, withExtension: "json") else { return nil }
        return try? Data(contentsOf: filePath)
    }
}
