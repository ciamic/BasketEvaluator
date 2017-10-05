//
//  MockBasketItemDataSource.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 03/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation
@testable import BasketEvaluator

/// Mock that simulates the behaviour of a basket item and related properties and functions
class MockBasketItemDataSource: BasketItemDataSource {

    var basketItems: [BasketItem] = [
        
        BasketItem(item: Item(id: 1,
                              name: "Item1",
                              priceInDollars: 0.5,
                              unitOfMeasurement: "Bag",
                              stockAmount: 20,
                              imageUrl: nil),
                   quantity: 0),
        
        BasketItem(item: Item(id: 2,
                              name: "Item2",
                              priceInDollars: 1,
                              unitOfMeasurement: "Can",
                              stockAmount: 20,
                              imageUrl: nil),
                   quantity: 1),
        
        BasketItem(item: Item(id: 3,
                              name: "Item3",
                              priceInDollars: 1.5,
                              unitOfMeasurement: "Dozen",
                              stockAmount: 20,
                              imageUrl: nil),
                   quantity: 2),
        
        BasketItem(item: Item(id: 4,
                              name: "Item4",
                              priceInDollars: 2,
                              unitOfMeasurement: "Bottle",
                              stockAmount: 20,
                              imageUrl: nil),
                   quantity: 3)
    ]
    
    var basketItemsTotalPriceInDollars: Decimal = 8.50
    
    var basketItemsTotalQuantity: Int = 6
    
    var refreshBasketItemsCalled = 0
    
    func refreshBasketItems() {
        refreshBasketItemsCalled = refreshBasketItemsCalled + 1
    }
    
    var updateQuantityOfBasketItemCalled = 0
    
    func updateQuantityOfBasketItem(atIndex index: Int, withQuantity newQuantity: Int) {
        updateQuantityOfBasketItemCalled = updateQuantityOfBasketItemCalled + 1
    }
    
}
