//
//  ErrorView.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit

@IBDesignable

class ErrorView: UIView {

    @IBOutlet weak var buttonRetry: UIButton?
    @IBOutlet weak var labelText: UILabel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
}

extension ErrorView: NibLoadable {}

private extension ErrorView {
    
    func configureView() {
        
        setupViewFromNib()
    }
}
