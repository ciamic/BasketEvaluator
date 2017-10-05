//
//  CurrencyDataConvenience.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 01/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// This extension exposes convenience methods to refresh the available currencies of the CurrencyData.
extension CurrencyData {
    
    // MARK: - Refreshes the Model (i.e. the [Currency])
    
    /// Refreshes the items contained in the currencies property.
    /// It uses notifications in order to inform who is interested in such changes.
    /// In particular, a notification is sent before starting with the update
    /// and another one is sent at the end of the update.
    /// The latter one can be a Successful update notification or a Failure one.
    
    /// There are a couple other approaches that could have been followed in
    /// the implementation / handling of available currencies, since the available 
    /// currencies do not change over time (or, if they do, they do only in rare occasions) 
    /// * The availableCurrencies could have been a fixed instead of fetching every time from the network.
    /// But this has been avoided since the assignment required to show the use of the CurrencyLayer API.
    /// * The network response could have been cached locally (in memory or in disk) possibily with an expiration time.
    /// This would have been the preferred approach but being short in time it has been not yet implemented,
    /// giving priority to the other functionalities of the application.
    
    // MARK: - TODO store the network response in a local cache with an expiration time since the available currencies will rarely change or avoid the network request and use a fixed list of available currencies. It fires the network request in order to show the use of the Currency Layer API for the assignment.
    
    func refreshAvailableCurrencies() {
        availableCurrencies = [Currency]()
        sendDataNotification(notificationName: Notifications.AvailableCurrenciesWillUpdateData,
                             withObject: nil,
                             userInfo: nil)
        currencyLayerClient.getAvailableCurrencies { [weak self] result, error in
            guard error == nil else {
                sendDataNotification(notificationName: Notifications.AvailableCurrenciesUpdateFail,
                                     withObject: nil,
                                     userInfo: [NSLocalizedDescriptionKey:error!.localizedDescription])
                return
            }
            if let result = result {
                self?.availableCurrencies = result
                self?.availableCurrencies.sort(by: { (currencyA, currencyB) -> Bool in // order by currency code
                    return currencyA.code.rawValue < currencyB.code.rawValue
                })
                sendDataNotification(notificationName: Notifications.AvailableCurrenciesUpdateSuccess,
                                     withObject: nil,
                                     userInfo: nil)
            } else {
                sendDataNotification(notificationName: Notifications.AvailableCurrenciesUpdateFail,
                                     withObject: nil,
                                     userInfo: nil)
            }
        }
    }
    
}
