//
//  CurrentPriceIndexListener.swift
//  CryptocurrencyPriceService
//
//  Created by MAXIM TSVETKOV on 01.02.19.
//  Copyright © 2019 MAXIM TSVETKOV. All rights reserved.
//

import Foundation

//as coindesk api updates price index once a minute (https://www.coindesk.com/api), it does not make sense to fetch index more often than one minute
fileprivate let CoindeskMinimalTimeInterval: TimeInterval = 60.0

public protocol CurrentPriceIndexListener {
    
    func start(with interval: TimeInterval,
               success: Success<CurrentPriceIndex>?,
               failure: Failure?)
    func finish()
}

public class CurrentPriceIndexListenerImp {
    
    fileprivate var success: Success<CurrentPriceIndex>?
    fileprivate var failure: Failure?
    
    fileprivate var service: PriceIndexService
    fileprivate var minimalTimeInterval: TimeInterval
    fileprivate var timeInterval: TimeInterval
    
    fileprivate var timer: Timer?
    
    fileprivate var stop = true
    
    public init() {
        self.service = PriceIndexServiceImp()
        self.minimalTimeInterval = CoindeskMinimalTimeInterval
        self.timeInterval = CoindeskMinimalTimeInterval
    }
    
    init(service: PriceIndexService,
         minimalTimeInterval: TimeInterval = CoindeskMinimalTimeInterval) {
        self.service = service
        self.minimalTimeInterval = minimalTimeInterval
        self.timeInterval = minimalTimeInterval
    }
    
    deinit {
        invalidateTimer()
    }
}

public extension CurrentPriceIndexListener {
    
    func start(success: Success<CurrentPriceIndex>?,
               failure: Failure?) {
        start(with: CoindeskMinimalTimeInterval, success: success, failure: failure)
    }
}

extension CurrentPriceIndexListenerImp: CurrentPriceIndexListener {
    
    public func start(with timeInterval: TimeInterval,
               success: Success<CurrentPriceIndex>?,
               failure: Failure?) {
        
        stop = false
        
        self.timeInterval = max(timeInterval, minimalTimeInterval)
        
        self.success = success
        self.failure = failure
        
        fetchCurrentPriceIndex()
    }
    
    public func finish() {
        
        stop = true
        
        invalidateTimer()
    }    
}

fileprivate extension CurrentPriceIndexListenerImp {
    
    @objc func fetchCurrentPriceIndex() {
        
        if stop {
            return
        }
        
        service.fetchCurrentPriceIndex(success: { [weak self] (currentPriceIndex) in
            self?.handleSuccessFetchCurrentPriceIndex(with: currentPriceIndex)
        }) { [weak self] (error) in
            self?.handleFailedFetchCurrentPriceIndex(with: error)
        }
    }
    
    private func handleSuccessFetchCurrentPriceIndex(with currentPriceIndex: CurrentPriceIndex) {
        
        scheduleTimer()
            
        emit(currentPriceIndex: currentPriceIndex)
    }
    
    private func handleFailedFetchCurrentPriceIndex(with error: Error) {
        
        invalidateTimer()
            
        emit(error: error)
    }
    
    private func emit(currentPriceIndex: CurrentPriceIndex) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.success?(currentPriceIndex)
        }
    }
    
    private func emit(error: Error) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.failure?(error)
        }
    }
}

fileprivate extension CurrentPriceIndexListenerImp {
    
    func scheduleTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(fetchCurrentPriceIndex),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    func invalidateTimer() {
        
        timer?.invalidate()
        timer = nil
    }
}

