//
//  MockCurrencyLayerClientAPI.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 04/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation
@testable import BasketEvaluator

/// Mock that simulates the behaviour of a currency layer client and related properties and functions
class MockCurrencyLayerClientAPI: CurrencyLayerClientAPI {
    
    /// returns the available currencies codes of the currency layer
    func getAvailableCurrencies(completionHandler: @escaping CompletionHandlerForAvailableCurrencyCodes) {
        let euro = Currency(name: "Euro", code: CurrencyCode(rawValue: "EUR")!)
        let dollar = Currency(name: "Dollar", code: CurrencyCode(rawValue: "USD")!)
        completionHandler([euro, dollar], nil)
    }
    
    /// converts a dollar amount into one of the supported currencies using the up to date conversion rate
    func convert(amountInDollars amount: Decimal, toCurrency currency: Currency, completionHandler: @escaping CompletionHandlerForConvert) {
        completionHandler(amount * 2, nil)
    }
    
}
