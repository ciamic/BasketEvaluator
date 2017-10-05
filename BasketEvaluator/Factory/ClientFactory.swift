//
//  ClientFactory.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 03/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// The ClientFactory stores reference to the Clients used throughout the application.
class ClientFactory {
    
    // MARK: - Properties
    
    // the store client of the application
    let storeClient: StoreClientAPI
    
    // the currency layer client of the application
    let currencyLayerClient: CurrencyLayerClientAPI
    
    // MARK: - Initializers
    
    init(urlSession: URLSession) {
        storeClient = StoreClient(urlSession: urlSession)
        currencyLayerClient = CurrencyLayerClient(urlSession: urlSession)
    }
    
}
