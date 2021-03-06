//
//  ItemListViewModel.swift
//  CryptocurrencyPriceApp
//
//  Created by MAXIM TSVETKOV on 02.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation
import CryptocurrencyPriceService

protocol ItemListViewModel {
    
    func fetchData(success: SuccessCompletion?, failure: FailureCompletion?)
    func listenCurrentUpdates(success: SuccessCompletion?, failure: FailureCompletion?)
    
    func numberOfItems() -> Int
    func cellViewModel(at index: Int) -> ItemCellViewModel?
}

class ItemListViewModelImp {
    
    enum Errors: LocalizedError {
        case missingData
        
        var errorDescription: String? {
            switch self {
            case .missingData:
                return "Some data is missed. Please try again later."
            }
        }
    }
    
    private let service: PriceIndexService
    private let currentPriceIndexListener: CurrentPriceIndexListener
    
    // this property stores date of the day till that we should show price index.
    // it should be today date by default,
    // but it may be different for testing purposes
    private let today: Date
    
    // this property stores number of days for those we should show price index.
    // it is 14 days by default,
    // but it may be different for testing purposes
    private let numberOfDays: Int
    
    fileprivate var dataSource: [ItemCellViewModel] = []
    
    init(service: PriceIndexService,
         currentPriceIndexListener: CurrentPriceIndexListener,
         today: Date = Date(),
         numberOfDays: Int = 14) {
        
        self.service = service
        self.currentPriceIndexListener = currentPriceIndexListener
        self.today = today
        self.numberOfDays = numberOfDays
    }
}

extension ItemListViewModelImp: ItemListViewModel {
    
    func numberOfItems() -> Int {
        return dataSource.count
    }
    
    func cellViewModel(at index: Int) -> ItemCellViewModel? {
        return dataSource[index]
    }
    
    func fetchData(success: SuccessCompletion?,
                   failure: FailureCompletion?) {
        
        let firstDay = today.date(daysAgo: numberOfDays-1)
        service.fetchHistoricalPriceIndex(between: firstDay,
                                          and: today,
                                          success: { [weak self] historicalPriceIndex in
                                            self?.createDataSource(with: historicalPriceIndex)
                                            self?.fetchCurrentData(success: success, failure: failure)
        }) { [weak self] error in
            self?.handle(error: error, into: failure)
        }
    }
    
    func listenCurrentUpdates(success: SuccessCompletion?, failure: FailureCompletion?) {
        
        startListenCurrentUpdates(success: success, failure: failure)
    }
}

//MARK: Fetch data

fileprivate extension ItemListViewModelImp {
    
    func startListenCurrentUpdates(success: SuccessCompletion?, failure: FailureCompletion?) {
        
        currentPriceIndexListener.start(success: { [weak self] currentPriceIndex in
                                            self?.updateDataSource(with: currentPriceIndex, success: success, failure: failure)
        }) { [weak self] error in
            self?.finishListenCurrentUpdates()
            self?.handle(error: error, into: failure)
        }
    }
    
    func finishListenCurrentUpdates() {
        
        currentPriceIndexListener.finish()
    }
    
    func fetchCurrentData(success: SuccessCompletion?,
                                  failure: FailureCompletion?) {
        
        service.fetchCurrentPriceIndex(success: { [weak self] currentPriceIndex in
            
            self?.updateDataSource(with: currentPriceIndex, success: success, failure: failure)            
        }) { [weak self] error in
            self?.handle(error: error, into: failure)
        }
    }
}

//MARK: Compltetion handlers

fileprivate extension ItemListViewModelImp {
 
    func handle(success: SuccessCompletion?) {
        
        success?()
    }
    
    func handle(error:Error, into failure: FailureCompletion?) {
        
        guard let localizedError = error as? LocalizedError else {
            failure?(DefaultErrorMessage)
            return
        }
        failure?(localizedError.errorDescription ?? DefaultErrorMessage)
    }
}

//MARK: Manage Data source

fileprivate extension ItemListViewModelImp {
    
    func createDataSource(with historicalPriceIndex: HistoricalPriceIndex) {
        
        let startDate = today.date(daysAgo: numberOfDays-1)
        let days = reversedArrayOfDates(from: today, to: startDate)
        
        //it is reasonable to throw error if price in history is missing,
        //but for simplification "?" placeholder is configured
        dataSource = days.map{ ItemCellViewModel(date: $0,
                                                 price: historicalPriceIndex[$0] ?? "?",
                                                 currency: Currency.defaultCurrency) }
    }
    
    func updateDataSource(with currentPriceIndex: CurrentPriceIndex, success: SuccessCompletion?, failure: FailureCompletion?) {
        
        guard let currentPrice = currentPriceIndex[Currency.defaultCurrency] else {
            handle(error: Errors.missingData, into: failure)
            return
        }
        
        guard !dataSource.isEmpty else {
            handle(error: Errors.missingData, into: failure)
            return
        }
        
        let currentCellViewModel = ItemCellViewModel(date: today,
                                                     price: currentPrice,
                                                     currency: Currency.defaultCurrency,
                                                     time: currentPriceIndex.timeOfUpdate)
        dataSource[0] = currentCellViewModel
        
        handle(success: success)
    }
    
    private func reversedArrayOfDates(from today: Date, to firstDate: Date) -> [Date] {
        
        var result: [Date] = [today]
        
        guard today.isFutureDay(after: firstDate) else {
            return result
        }
        
        let calendar = Calendar.current
        
        var date = today
        while date.isFutureDay(after: firstDate) {
            date = calendar.date(byAdding: .day, value: -1, to: date)!
            result.append(date)
        }
        
        return result
    }
}

fileprivate extension Date {
    
    func date(daysAgo days: Int) -> Date {
        
        return self - TimeInterval(days*24*60*60)
    }
}
