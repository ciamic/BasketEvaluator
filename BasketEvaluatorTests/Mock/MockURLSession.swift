//
//  MockURLSession.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 05/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation
@testable import BasketEvaluator

/// Mock that simulates the behaviour of a url session and exposes properties that can be used to manipulate it's behaviour
class MockURLSession: URLSessionProtocol {
    
    var lastURL: URL?
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data? = nil
    var nextError: Error? = nil
    var nextResponse: HTTPURLResponse? = nil
    
    func dataTask(with url: URL, completionHandler: @escaping CompletionHandlerForURLSession) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
    
}
