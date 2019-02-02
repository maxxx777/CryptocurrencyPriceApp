//
//  ItemListViewController.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    //dependencies
    //dependencies property is force unwrapped because we are sure factory will provide that
    var viewModel: ItemListViewModel!
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView?
    
    //Constants
    fileprivate let CellReuseIdentifier = "CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ItemListViewController: UITableViewDelegate {
    
}

extension ItemListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier, for: indexPath) 
        
        return cell
    }
}
