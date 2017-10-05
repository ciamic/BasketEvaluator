//
//  BasketItemDataConvenience.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 01/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// This extension exposes convenience methods to refresh the available basket items 
/// and properties to access the total price of the basket (in dollars) and the amount of items in it.
extension BasketItemData {
    
    // MARK: - Properties
    
    var basketItemsTotalPriceInDollars: Decimal {
        return basketItems.reduce(0) { (result, basketItem) -> Decimal in
            return result + basketItem.item.priceInDollars * Decimal(basketItem.quantity)
        }
    }
    
    var basketItemsTotalQuantity: Int {
        return basketItems.reduce(0) { (result, basketItem) -> Int in
            return result + basketItem.quantity
        }
    }
    
    // MARK: - Refreshes the Model (i.e. the [BasketItem])
    
    /// Refreshes the items contained in the basket items property.
    /// It uses notifications in order to inform who is interested in such changes.
    /// In particular, a notification is sent before starting with the update
    /// and another one is sent at the end of the update.
    /// The latter one can be a Successful update notification or a Failure one.
    
    func refreshBasketItems() {
        basketItems = [BasketItem]()
        sendDataNotification(notificationName: Notifications.BasketItemsWillUpdateData,
                             withObject: nil,
                             userInfo: nil)
        storeClient.getAvailableItems { result, error in
            guard error == nil else {
                basketItems = [BasketItem]()
                sendDataNotification(notificationName: Notifications.BasketItemsUpdateFail,
                                     withObject: nil,
                                     userInfo: [NSLocalizedDescriptionKey:error!.localizedDescription])
                return
            }
            if let result = result {
                basketItems = result.map { BasketItem(item: $0, quantity: 0) }
                sendDataNotification(notificationName: Notifications.BasketItemsUpdateSuccess,
                                     withObject: nil,
                                     userInfo: nil)
            } else {
                basketItems = [BasketItem]()
                sendDataNotification(notificationName: Notifications.BasketItemsUpdateFail,
                                     withObject: nil,
                                     userInfo: nil)
            }
        }
    }
    
}
