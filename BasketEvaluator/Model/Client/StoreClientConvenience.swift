//
//  StoreClientConvenience.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

typealias CompletionHandlerForItems = ([Item]?, Error?) -> Void

// MARK: - StoreClientAPI

/// This extension exposes convenience methods to get the available items of the application.
extension StoreClient: StoreClientAPI {
    
    // MARK: - Dummy implementation
    
    /// This method should fetch the up to date available items from the internet
    /// and return them in the completion handler. Ideally, it should fetch the JSON resource
    /// and pass it to the static constructor of the Item struct (or, for already existing items,
    /// identified by their IDs, update the stock amount quantity).
    /// For demo purposes, it creates and returns them on the fly.
    func getAvailableItems(completionHandler: CompletionHandlerForItems) {
        
        let dummyItems = [
            Item(id: 1, name: "Peas", priceInDollars: 0.95, unitOfMeasurement: "Bag", stockAmount: 20, imageUrl: nil),
            Item(id: 2, name: "Eggs", priceInDollars: 2.10, unitOfMeasurement: "Dozen", stockAmount: 120, imageUrl: nil),
            Item(id: 3, name: "Milk", priceInDollars: 1.30, unitOfMeasurement: "Bottle", stockAmount: 50, imageUrl: nil),
            Item(id: 4, name: "Beans", priceInDollars: 0.73, unitOfMeasurement: "Can", stockAmount: 15, imageUrl: nil)
        ]
        
        completionHandler(dummyItems, nil)
    }
    
}
