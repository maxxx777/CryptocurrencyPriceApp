//
//  ItemDetailViewController.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    //dependencies
    //dependencies property is force unwrapped because we are sure factory will provide that
    var viewModel: ItemDetailViewModel!
    
    //IBOutlets
    @IBOutlet weak var errorView: ErrorView?
    @IBOutlet weak var loadingView: LoadingView?
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var labelDate: UILabel?
    @IBOutlet weak var labelEUR: UILabel?
    @IBOutlet weak var labelUSD: UILabel?
    @IBOutlet weak var labelGBP: UILabel?
    
    //Properties
    fileprivate var viewState: ViewState = .initiating {
        didSet {
            switch viewState {
            case .data:
                contentView?.isHidden = false
                loadingView?.isHidden = true
                errorView?.isHidden = true
            case .loading:
                contentView?.isHidden = true
                loadingView?.isHidden = false
                errorView?.isHidden = true
            case let .error(errorText):
                contentView?.isHidden = true
                loadingView?.isHidden = true
                errorView?.isHidden = false
                errorView?.labelText?.text = errorText
            default: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        fetchData()
    }
}

extension ItemDetailViewController {
    
    func configureView() {
        
        navigationItem.title = "Details"
        
        viewState = .loading
        
        errorView?.buttonRetry?.addTarget(self,
                                          action: #selector(retryFetchData),
                                          for: .touchUpInside)
    }
    
    func fetchData() {
        
        viewModel.fetchDetails(success: { [weak self] in
            self?.viewState = .data
            self?.updateView()
        }) { [weak self] errorText in
            self?.viewState = .error(errorText)
        }        
    }
    
    func updateView() {
        
        labelDate?.text = viewModel.dateText
        labelEUR?.text = viewModel.eurPrice
        labelUSD?.text = viewModel.usdPrice
        labelGBP?.text = viewModel.gbpPrice
    }
    
    @objc func retryFetchData() {
        
        viewState = .loading
        fetchData()
    }
}
