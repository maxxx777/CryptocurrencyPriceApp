//
//  NibLoadable.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit

protocol NibLoadable: class {
    
    static var nib: UINib { get }
}

extension NibLoadable {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibLoadable where Self: UIView {
    
    func setupViewFromNib() {
        
        let rootView = Self.nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        rootView.frame = bounds
        rootView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(rootView)
    }
}
