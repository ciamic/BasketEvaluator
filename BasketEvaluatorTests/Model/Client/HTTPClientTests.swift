//
//  HTTPClientTests.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 05/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import XCTest
@testable import BasketEvaluator

/// Tests for the HTTPClient
class HTTPClientTests: XCTestCase {
    
    var httpClient: HTTPClient!
    var mockUrlSession: MockURLSession!
    
    private var httpURL200Response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    override func setUp() {
        super.setUp()
        mockUrlSession = MockURLSession()
        httpClient = HTTPClient(urlSession: mockUrlSession)
    }
    
    override func tearDown() {
        httpClient = nil
        super.tearDown()
    }
    
    func testTaskForGETResumeIsCalledOnce() {
        let resumeExpectation = expectation(description: "taskForGETMethod Resume is called once")
        
        mockUrlSession.nextResponse = httpURL200Response
        
        let _ = httpClient.taskForGETMethod(method: "testMethod", parameters: [:]) { (data, error) in
            if error != nil {
                resumeExpectation.fulfill()
            }
        }
        
        wait(for: [resumeExpectation], timeout: 1.0)
        XCTAssert(mockUrlSession.nextDataTask.resumeWasCalled == 1)
    }
    
    func testTaskForGETReturnsTheData() {
        let dataExpectation = expectation(description: "taskForGETMethod returns the data")
        
        let dummyData = [String:AnyObject]()
        let json = try! JSONSerialization.data(withJSONObject: dummyData, options: [])
        
        mockUrlSession.nextResponse = httpURL200Response
        mockUrlSession.nextData = json
        
        let _ = httpClient.taskForGETMethod(method: "testMethod", parameters: [:]) { (data, error) in
            if data != nil {
                dataExpectation.fulfill()
            }
        }
        
        wait(for: [dataExpectation], timeout: 1.0)
    }
    
    func testTaskForGETReturnsTheError() {
        let errorExpectation = expectation(description: "taskForGETMethod returns the error")
        
        mockUrlSession.nextResponse = httpURL200Response
        mockUrlSession.nextError = NSError(domain: "MyDomain", code: 0, userInfo: nil)
        
        let _ = httpClient.taskForGETMethod(method: "testMethod", parameters: [:]) { (data, error) in
            if error != nil {
                errorExpectation.fulfill()
            }
        }
        
        wait(for: [errorExpectation], timeout: 1.0)
    }
    
    func testTaskForGETNoDataNoErrorReturnsAnError() {
        let errorExpectation = expectation(description: "taskForGETMethod no data no error does return the error")
        
        mockUrlSession.nextResponse = httpURL200Response
        
        let _ = httpClient.taskForGETMethod(method: "testMethod", parameters: [:]) { (data, error) in
            if error != nil {
                errorExpectation.fulfill()
            }
        }
        
        wait(for: [errorExpectation], timeout: 1.0)
    }
    
    func testTaskForGETWithStatusCodeLessThan200ReturnsAnError() {
        let errorExpectation = expectation(description: "taskForGETMethod returns error if status code < 200")
        
        mockUrlSession.nextResponse = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 199, httpVersion: nil, headerFields: nil)
        
        let _ = httpClient.taskForGETMethod(method: "testMethod", parameters: [:]) { (data, error) in
            if error != nil {
                errorExpectation.fulfill()
            }
        }
        
        wait(for: [errorExpectation], timeout: 1.0)
    }
    
    func testTaskForGETWithStatusCodeMoreThan299ReturnsAnError() {
        let errorExpectation = expectation(description: "taskForGETMethod returns error if status code > 299")
        
        mockUrlSession.nextResponse = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 300, httpVersion: nil, headerFields: nil)
        
        let _ = httpClient.taskForGETMethod(method: "testMethod", parameters: [:]) { (data, error) in
            if error != nil {
                errorExpectation.fulfill()
            }
        }
        
        wait(for: [errorExpectation], timeout: 1.0)
    }
    
}
