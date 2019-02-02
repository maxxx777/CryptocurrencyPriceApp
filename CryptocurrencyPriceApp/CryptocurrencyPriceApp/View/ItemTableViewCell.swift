//
//  ItemTableViewCell.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    var viewModel: ItemCellViewModel? {
        didSet {
            self.textLabel?.text = viewModel?.date
            self.detailTextLabel?.text = viewModel?.price            
        }
    }
}
