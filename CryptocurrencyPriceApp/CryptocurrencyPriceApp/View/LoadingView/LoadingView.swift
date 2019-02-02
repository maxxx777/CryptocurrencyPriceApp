//
//  LoadingView.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit

@IBDesignable

class LoadingView: UIView {
    
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

extension LoadingView: NibLoadable {}

private extension LoadingView {
    
    func configureView() {
        
        setupViewFromNib()
        
        labelText?.text = "Loading..."
    }
}
