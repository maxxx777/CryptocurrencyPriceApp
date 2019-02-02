//
//  ItemListViewActions.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

protocol ItemListViewActions: class {
    var didSelectItem: ((Date, String) -> Void)? { get set }
}
