//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
    
    //dependencies
    let viewModel = TodayViewModelImp()
    
    //IB outlets
    @IBOutlet weak var labelPrice: UILabel?
}

extension TodayViewController: NCWidgetProviding {
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        viewModel.listenCurrentUpdates(success: { [weak self] priceText in
            
            self?.updateView(with: priceText)
            completionHandler(NCUpdateResult.newData)
        }) { [weak self] errorText in
            self?.updateView(with: errorText)
            completionHandler(NCUpdateResult.failed)
        }
    }
}

extension TodayViewController {

    func updateView(with priceText: String) {
        
        labelPrice?.text = priceText
    }
}
