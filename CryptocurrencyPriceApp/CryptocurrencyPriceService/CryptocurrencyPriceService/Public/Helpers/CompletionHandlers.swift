//
//  CompletionHandlers.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

public typealias Success<T> = ((T) -> Void)
public typealias Failure = ((Error) -> Void)
