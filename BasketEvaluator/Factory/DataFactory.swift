//
//  DataFactory.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 03/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// The Data Factory stores reference to the Data (i.e. Models) used throuhout the application.
class DataFactory {
    
    // MARK: - Properties
    
    // the currency data model
    let currencyData: CurrencyDataSource
    
    // the basket item data model
    let basketItemData: BasketItemDataSource
    
    // MARK: - Initializers
    
    init(currencyLayerClient: CurrencyLayerClientAPI, storeClient: StoreClientAPI) {
        currencyData = CurrencyData(currencyLayerClient: currencyLayerClient)
        basketItemData = BasketItemData(storeClient: storeClient)
    }
    
}
