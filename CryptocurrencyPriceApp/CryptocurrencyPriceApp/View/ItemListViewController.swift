//
//  ItemListViewController.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController, ItemListViewActions {
    
    //dependencies
    //dependencies property is force unwrapped because we are sure factory will provide that
    var viewModel: ItemListViewModel!
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var errorView: ErrorView?
    @IBOutlet weak var loadingView: LoadingView?
    
    //ItemListViewActions
    var didSelectItem: ((Date, String) -> Void)?
    
    //Constants
    fileprivate let CellReuseIdentifier = "CellId"
    
    //Properties
    fileprivate var viewState: ViewState = .initiating {
        didSet {
            switch viewState {
            case .data:
                tableView?.isHidden = false
                tableView?.reloadData()
                loadingView?.isHidden = true
                errorView?.isHidden = true
            case .loading:
                tableView?.isHidden = true
                loadingView?.isHidden = false
                errorView?.isHidden = true
            case let .error(errorText):
                tableView?.isHidden = true
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

extension ItemListViewController {
    
    func configureView() {
        
        navigationItem.title = "Bitcoin Price Index"
        
        viewState = .loading
        
        errorView?.buttonRetry?.addTarget(self,
                                          action: #selector(retryFetchData),
                                          for: .touchUpInside)
    }
    
    func fetchData() {
        
        viewModel.fetchData(success: { [weak self] in
            self?.viewState = .data
            self?.listenCurrentUpdates()
        }) { [weak self] errorText in
            self?.viewState = .error(errorText)
        }
    }
    
    func listenCurrentUpdates() {
        
        viewModel.listenCurrentUpdates(success: { [weak self] in
            self?.reloadFirstRow()
        }) { [weak self] errorText in
            self?.viewState = .error(errorText)
        }
    }
    
    func reloadFirstRow() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView?.reloadRows(at: [indexPath], with: .fade)
    }
    
    @objc func retryFetchData() {
        
        viewState = .loading
        fetchData()
    }
}

extension ItemListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath.row) else { return }
        didSelectItem?(cellViewModel.date, cellViewModel.price)
    }
}

extension ItemListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier, for: indexPath)  as! ItemTableViewCell
        
        let cellViewModel = viewModel.cellViewModel(at: indexPath.row)
        
        cell.viewModel = cellViewModel
        
        return cell
    }
}
