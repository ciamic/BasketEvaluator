//
//  CurrencyData.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// The protocol related to the CurrencyData class
protocol CurrencyDataSource  {
    
    // the available currencies
    var availableCurrencies: [Currency] { get }
    
    // refreshes the available currencies
    func refreshAvailableCurrencies()
    
}

/// The CurrencyData contains the available currencies of the application.
class CurrencyData: CurrencyDataSource {
    
    // MARK: - Properties
    
    // the available currencies
    var availableCurrencies = [Currency]()
    
    // the currency layer client to whom ask available currencies
    let currencyLayerClient: CurrencyLayerClientAPI
    
    // MARK: - Initializers
    
    init(currencyLayerClient: CurrencyLayerClientAPI) {
        self.currencyLayerClient = currencyLayerClient
    }
    
}
