//
//  CurrencyLayerConvenience.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

typealias CompletionHandlerForAvailableCurrencyCodes = ([Currency]?, Error?) -> Void
typealias CompletionHandlerForConvert = (Decimal?, Error?) -> Void

/// MARK: - CurrencyLayerClientAPI

/// This extension exposes convenience methods to get the available currency codes of the application 
/// and to convert dollars amount in other currencies.
extension CurrencyLayerClient: CurrencyLayerClientAPI {
    
    // MARK: - API
    
    /// Fetches the available currency codes and stores them in the availableCurrencies array.
    /// - Parameter completionHandler: the completion handler called as a response of the request
    func getAvailableCurrencies(completionHandler: @escaping CompletionHandlerForAvailableCurrencyCodes) {
        
        let method = CurrencyLayerConstants.ListMethod
        
        var parameters = [String:AnyObject]()
        parameters[CurrencyLayerConstants.APIKey] = CurrencyLayerConstants.APIKeyValue as AnyObject
        
        let _ = taskForGETMethod(method: method, parameters: parameters) { result, error in
            
            if let error = error {
                completionHandler(nil, error)
            } else {
                if result != nil, let json = self.convertDataToJSON(data: result!) as? [String:AnyObject] {
                    // make sure that "success" = true in the JSON file
                    guard let success = json[CurrencyJSON.Success], success as? Bool == true else {
                        completionHandler(nil,
                                          NSError(domain: Errors.GetAvailableCurrenciesDomain,
                                                  code: 0,
                                                  userInfo: [NSLocalizedDescriptionKey: Errors.ResponseNotSuccessful]))
                        return
                    }
                    // try to create the currencies from the JSON
                    let availableCurrencies = Currency.currencies(fromResults: json)
                    completionHandler(availableCurrencies, nil)
                } else {
                    // cannot convert JSON in dictionary
                    completionHandler(nil,
                                      NSError(domain: Errors.GetAvailableCurrenciesDomain,
                                              code: 0,
                                              userInfo: [NSLocalizedDescriptionKey: Errors.CouldNotConvertInAValidResponse]))
                }
            }
            
        }
        
    }
    
    /// Converts the specified amount (in dollars) in the specified currency using the current conversion rate.
    /// - Parameter amountInDollars: the amount (in dollars) to be converted
    /// - Parameter toCurrency: the currency in which convert
    /// - Parameter completionHandler: the completion handler called as a response of the request
    func convert(amountInDollars amount: Decimal,
                 toCurrency currency: Currency,
                 completionHandler: @escaping CompletionHandlerForConvert) {
        
        let method = CurrencyLayerConstants.LiveMethod
        
        var parameters = [String:AnyObject]()
        parameters[CurrencyLayerConstants.APIKey] = CurrencyLayerConstants.APIKeyValue as AnyObject
        parameters[CurrencyLayerConstants.Currencies] = currency.code.rawValue as AnyObject
        
        let _ = taskForGETMethod(method: method, parameters: parameters) { result, error in
            
            if let error = error {
                completionHandler(nil, error)
            } else {
                if result != nil, let json = self.convertDataToJSON(data: result!) as? [String:AnyObject] {
                    // make sure that "success" = true in the JSON file
                    guard let success = json[CurrencyJSON.Success], success as? Bool == true else {
                        completionHandler(nil,
                                          NSError(domain: Errors.ConvertDomain,
                                                  code: 0,
                                                  userInfo: [NSLocalizedDescriptionKey: Errors.ResponseNotSuccessful]))
                        return
                    }
                    // try to get the converted value from the JSON
                    if let quotes = json[CurrencyJSON.Quotes] as? [String:Double], !quotes.isEmpty {
                        let convertedAmount = Decimal(quotes.first!.value) * amount
                        completionHandler(convertedAmount, nil)
                    } else {
                        // cannot retreive quotes in dictionary
                        completionHandler(nil,
                                          NSError(domain: Errors.ConvertDomain,
                                                  code: 0,
                                                  userInfo: [NSLocalizedDescriptionKey: Errors.CouldNotGetTheConvertedValue]))
                    }
                } else {
                    // cannot convert JSON in dictionary
                    completionHandler(nil,
                                      NSError(domain: Errors.ConvertDomain,
                                              code: 0,
                                              userInfo: [NSLocalizedDescriptionKey: Errors.CouldNotConvertInAValidResponse]))
                }
            }
            
        }
        
    }
    
}
