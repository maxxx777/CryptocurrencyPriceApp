//
//  ViewState.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

enum ViewState {
    case initiating
    case loading
    case data
    case error(String)
}
