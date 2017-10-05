//
//  MockURLSessionDataTask.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 05/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation
@testable import BasketEvaluator

/// Mock that simulates the behaviour of a data task and related properties and functions
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    var resumeWasCalled: UInt = 0
    
    func resume() {
        resumeWasCalled = resumeWasCalled + 1
    }
    
}
