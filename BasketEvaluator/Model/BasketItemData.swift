//
//  BasketItemData.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// The protocol related to the BasketItemData class
protocol BasketItemDataSource  {
    
    // the available basket items
    var basketItems: [BasketItem] { get }
    
    // the total price of the items contained in the basket cart in dollars
    var basketItemsTotalPriceInDollars: Decimal { get }
    
    // the number of items contained in the basket cart
    var basketItemsTotalQuantity: Int { get }
    
    // refreshes the available refreshBasketItems
    func refreshBasketItems()
    
    // update the quantity of an item
    func updateQuantityOfBasketItem(atIndex index: Int, withQuantity newQuantity: Int)
    
}

/// The BasketItemData contains the virtual basket of the application.
class BasketItemData: BasketItemDataSource {
    
    // MARK: - Properties
    
    // the available basket items
    var basketItems = [BasketItem]()
    
    // the store client to whom ask for items
    let storeClient: StoreClientAPI
    
    // MARK: - Initializers

    init(storeClient: StoreClientAPI) {
        self.storeClient = storeClient
    }
    
    // update the quantity of an item
    func updateQuantityOfBasketItem(atIndex index: Int, withQuantity newQuantity: Int) {
        basketItems[index].quantity = newQuantity
    }
    
}
