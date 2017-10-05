//
//  ApplicationFactory.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 03/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// Exposes objects (via protocols) accessible from the factory
protocol ApplicationFactoryService {
    
    // the currency data model
    var currencyData: CurrencyDataSource { get }
    
    // the basket item data model
    var basketItemData: BasketItemDataSource { get }
    
    // the store client of the application
    var storeClient: StoreClientAPI { get }
    
    // the currency layer client of the application
    var currencyLayerClient: CurrencyLayerClientAPI { get }
    
}

/// The Factory of the Application
class ApplicationFactory {
    
    // MARK: - Properties
    
    // the data factory
    fileprivate let dataFactory: DataFactory
    
    // the client factory
    fileprivate let clientFactory: ClientFactory
    
    // MARK: - Initializers
    
    init(urlSession: URLSessionProtocol) {
        clientFactory = ClientFactory(urlSession: .shared)
        dataFactory = DataFactory(currencyLayerClient: clientFactory.currencyLayerClient,
                                  storeClient: clientFactory.storeClient)
    }
    
}

extension ApplicationFactory: ApplicationFactoryService {
    
    // the currency data model
    var currencyData: CurrencyDataSource { return dataFactory.currencyData }
    
    // the basket item data model
    var basketItemData: BasketItemDataSource { return dataFactory.basketItemData }
    
    // the store client of the application
    var storeClient: StoreClientAPI { return clientFactory.storeClient }
    
    // the currency layer client of the application
    var currencyLayerClient: CurrencyLayerClientAPI { return clientFactory.currencyLayerClient }
    
}
