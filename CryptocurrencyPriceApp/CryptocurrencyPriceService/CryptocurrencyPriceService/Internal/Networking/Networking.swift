//
//  NetworkingService.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

protocol Networking {
    
    func call(_ endpoint: Endpoint, completion: @escaping (Result) -> Void)
}

class NetworkingImp: Networking {
    
    private let urlSession = URLSession.shared
    
    func call(_ endpoint: Endpoint, completion: @escaping (Result) -> Void) {
        
        guard let url = endpoint.url else {
            completion(.failure(NetworkingError.wrongEndpointURL))
            return
        }
        
        let task = urlSession.dataTask(with: url,
                                       completionHandler: { (data_, _, error_) in
            
            // checking for status code reponse could be added in case of neccessarity of more complex implementation of network layer
                                        
            guard let data = data_ else {
                guard let error = error_ else {
                    completion(Result.failure(NetworkingError.unknown))
                    return
                }
                completion(Result.failure(error))
                return
            }
            
            completion(Result.success(data))
        })
        
        task.resume()
    }
}
