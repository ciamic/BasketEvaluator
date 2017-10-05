//
//  Constants.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 27/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// Constants used throughout the application

// MARK: - Storyboard

struct Storyboard {
    
    static let BasketTableViewControllerIdentifier = "BasketTableViewControllerIdentifier"
    static let CheckoutViewControllerIdentifier = "CheckoutViewControllerIdentifier"
    static let CurrencyPickerControllerIdentifier = "CurrencyPickerControllerIdentifier"
    
    static let CheckoutViewControllerSegueIdentifier = "PresentCheckoutViewControllerSegueIdentifier"
    static let BasketItemTableViewCellIdentifier = "BasketItemTableViewCellIdentifier"
    static let CurrencyPickerControllerCellIdentifier = "CurrencyPickerControllerCellIdentifier"
    static let CurrencyPickerNavControllerIdentifier = "CurrencyPickerNavControllerIdentifier"
    static let OneItem = "1 item"
    static let MultipleItems = "items"
    static let PriceToUnitSeparator = " x "
    static let Error = "Error"
    
}

// MARK: - HTTPClient

struct HTTPConstants {
    
    static let APIScheme = "http"
    static let APISchemeWithSlash = "http://"
    static let TaskForGETMethod = "taskForGETMethod"
    static let InvalidStatusCode = "Your request returned a status code other than 2xx!"
    static let EmptyData = "No data was returned by the request!"
    
}

// MARK: - CurrencyLayer

struct CurrencyLayerConstants {
    
    static let APIKey = "access_key"
    static let Currencies = "Currencies"
    static let APIKeyValue = "5e75b23b09436a7fb2583c96c15910bc"
    static let ListMethod = "list"
    static let LiveMethod = "live"
    static let APIHost = "apilayer.net"
    static let APIPath = "/api/"
    static let QuestionMark = "?"
    static let EqualsSign = "="

}

// MARK: - Currency Codes

struct CurrencyCodes {
    
    static let USD = "USD"
    
}

// MARK: - Notifications

struct Notifications {
    
    static let BasketItemsWillUpdateData = "BasketItemsWillUpdateData"
    static let BasketItemsUpdateSuccess = "BasketItemsUpdateSuccess"
    static let BasketItemsUpdateFail = "BasketItemsUpdateFail"
    static let AvailableCurrenciesWillUpdateData = "AvailableCurrenciesWillUpdateData"
    static let AvailableCurrenciesUpdateSuccess = "AvailableCurrenciesUpdateSuccess"
    static let AvailableCurrenciesUpdateFail = "AvailableCurrenciesUpdateFail"
    static let StockLevelChanged = "StockLevelChanged"
    
}

// MARK: - Currency

struct CurrencyJSON {
    
    static let Currencies = "currencies"
    static let Success = "success"
    static let Quotes = "quotes"
    
}

// MARK: - Errors

struct Errors {

    static let ConvertDomain = "Convert"
    static let GetAvailableCurrenciesDomain = "getAvailableCurrencies"
    static let PleaseTryAgain = "Please try again."
    static let ResponseNotSuccessful = "Response not successful. " + Errors.PleaseTryAgain
    static let CouldNotConvertInAValidResponse = "Could not convert in a valid response. " + Errors.PleaseTryAgain
    static let CouldNotGetTheConvertedValue = "Could not get the converted value. " + Errors.PleaseTryAgain
    
}

// MARK: - Alerts

struct AlertMessages {
    
    static let ActionConfirmTitle = "OK"
    static let AlertTitle = "Error"
    static let GenericAlertMessage = "Try again."
    
}
