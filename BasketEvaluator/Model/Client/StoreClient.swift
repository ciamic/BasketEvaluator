//
//  StoreClient.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 28/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// The protocol that defines the API of a store client
protocol StoreClientAPI {
    
    /// returns the available items of the store client
    func getAvailableItems(completionHandler: CompletionHandlerForItems)

}

/// The Client of the imaginary store that allows to request for the available items
class StoreClient: HTTPClient {
    
    // MARK: - Initializers
    
    override init(urlSession: URLSessionProtocol) {
        super.init(urlSession: urlSession)
    }
    
}
