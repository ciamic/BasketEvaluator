//
//  CurrencyLayerClient.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// The protocol that defines the API of a currency helper layer
protocol CurrencyLayerClientAPI {
    
    /// returns the available currencies codes of the currency layer
    func getAvailableCurrencies(completionHandler: @escaping CompletionHandlerForAvailableCurrencyCodes)
    
    /// converts a dollar amount into one of the supported currencies using the up to date conversion rate
    func convert(amountInDollars amount: Decimal, toCurrency currency: Currency, completionHandler: @escaping CompletionHandlerForConvert)
    
}

/// The Client of the Currency Layer API that allows to query for currencies and currencies conversions.
class CurrencyLayerClient: HTTPClient {
    
    // MARK: - Initializers
    
    override init(urlSession: URLSessionProtocol) {
        super.init(urlSession: urlSession)
    }
    
    // MARK: - Utility
    
    override func getURLComponents(withPathExtension pathExtension: String? = nil) -> URLComponents {
        var components = super.getURLComponents(withPathExtension: pathExtension)
        components.host = CurrencyLayerConstants.APIHost // apilayer.net
        components.path = CurrencyLayerConstants.APIPath + (pathExtension ?? "") // /api/\"(pathExtension)"
        return components
    }
    
}
