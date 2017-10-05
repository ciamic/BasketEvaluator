//
//  MockCurrencyDataSource.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 03/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation
@testable import BasketEvaluator

/// Mock that simulates the behaviour of a currency data source and related properties and functions
class MockCurrencyDataSource: CurrencyDataSource {
    
    var availableCurrencies: [Currency] = [
        Currency(name: "Euro", code: CurrencyCode(rawValue: "EUR")!),
        Currency(name: "Dollar", code: CurrencyCode(rawValue: "USD")!)
    ]
    
    var refreshAvailableCurrenciesCalled = 0
    func refreshAvailableCurrencies() {
        refreshAvailableCurrenciesCalled = refreshAvailableCurrenciesCalled + 1
    }
    
}
