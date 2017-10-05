//
//  BasketItem.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 28/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

// MARK: - BasketItem

/// The BasketItem struct represents an item with an associated quantity.
struct BasketItem {
    
    let item: Item
    var quantity: Int = 0
    
}

// MARK: - Item

/// The Item struct represents an item with it's foundamental properties.
struct Item {
    
    // MARK: - Properties
    
    let id: Int
    let name: String
    let priceInDollars: Decimal
    let unitOfMeasurement: String
    private var _stockAmount: UInt
    var stockAmount: UInt { // not used in this project but notifications about changes in stock amount of the items
        // (i.e. having it always with the up to date value) can be used to make sure that the user is not allowed
        // to order more items than the stock amount during the checkout / purchase process.
        get { return _stockAmount }
        set {
            _stockAmount = newValue
            sendDataNotification(notificationName: Notifications.StockLevelChanged, withObject: self, userInfo: nil)
        }
    }
    let imageUrl: URL?
    
    // MARK: - Initializers
    
    init(id: Int, name: String, priceInDollars: Decimal, unitOfMeasurement: String, stockAmount: UInt, imageUrl: URL?) {
        self.id = id
        self.name = name
        self.priceInDollars = priceInDollars
        self.unitOfMeasurement = unitOfMeasurement
        self._stockAmount = stockAmount
        self.imageUrl = imageUrl
    }
    
    /*
    
    // The "classic" init from dictionary (i.e. JSON) and the static
    // func in order to instantiate an array of Items. In this project
    // the model is "fixed" hence we don't use the JSON initializer and
    // relative convenience methods.
     
    init(dictionary: [String:AnyObject]) {
        id = dictionary[ItemJSON.Id]
        name = dictionary[ItemJSON.Name]
        priceInDollars = dictionary[ItemJSON.Price]
        unitOfMeasurement = dictionary[ItemJSON.UnitOfMeasurement]
        stockAmount = dictionary[ItemJSON.StockAmount]
        imageUrl = dictionary[ItemJSON.ImageUrl]
    }
    
    // MARK: - Convenience
    
    static func items(fromResults results: [String:AnyObject]) -> [Item] {
        var items = [Item]()
        for result in results.values {
            items.append(Item(dictionary: result as! [String : AnyObject]))
        }
        
        return items
    }
 
    */
    
}

// MARK: - Item Equatable

// Two items are considered equals if they have the same id.
extension Item: Equatable {
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
}
