//
//  CurrencyLayerClientTests.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 05/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import XCTest
@testable import BasketEvaluator

/// Tests for the CurrencyLayerClient
class CurrencyLayerClientTests: XCTestCase {
    
    var currencyLayerClient: CurrencyLayerClientAPI!
    var mockUrlSession: MockURLSession!
    
    private var httpURL200Response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    override func setUp() {
        super.setUp()
        mockUrlSession = MockURLSession()
        currencyLayerClient = CurrencyLayerClient(urlSession: mockUrlSession)
    }
    
    override func tearDown() {
        currencyLayerClient = nil
        super.tearDown()
    }
    
    // MARK: - Available Currencies
    
    func testAvailableCurrenciesRequestedAtCorrectURL() {
        let urlExpectation = expectation(description: "Correct available currencies URL")
        let expectedUrl =
            HTTPConstants.APISchemeWithSlash +
            CurrencyLayerConstants.APIHost +
            CurrencyLayerConstants.APIPath +
            CurrencyLayerConstants.ListMethod +
            CurrencyLayerConstants.QuestionMark +
            CurrencyLayerConstants.APIKey +
            CurrencyLayerConstants.EqualsSign
        
        currencyLayerClient.getAvailableCurrencies { (currencies, error) in
            urlExpectation.fulfill()
        }
        
        wait(for: [urlExpectation], timeout: 1.0)
        XCTAssert(mockUrlSession.lastURL!.absoluteString.contains(expectedUrl))
    }
    
    func testAvailableCurrenciesReturnsCorrectData() {
        let dataExpectation = expectation(description: "Correct available currencies data")
        var dummyData = [String:AnyObject]()
        dummyData["success"] = true as AnyObject
        dummyData["currencies"] = ["USD": "United States Dollars",
                                   "EUR": "Euro" ] as AnyObject
        let json = try! JSONSerialization.data(withJSONObject: dummyData, options: [])
        
        mockUrlSession.nextData = json
        mockUrlSession.nextResponse = httpURL200Response
        
        var dummyCurrencies: [Currency]?
        currencyLayerClient.getAvailableCurrencies { (currencies, error) in
            if currencies != nil {
                dummyCurrencies = currencies
            }
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 1.0)
        XCTAssert(dummyCurrencies != nil)
        XCTAssert(dummyCurrencies!.count == 2)
        XCTAssert(dummyCurrencies![0].code.rawValue == "USD")
        XCTAssert(dummyCurrencies![1].code.rawValue == "EUR")
    }
    
    func testAvailableCurrenciesReturnsErrorWithNonSuccessfulResponse() {
        let dataExpectation = expectation(description: "Available currencies returns error with non successful response")
        var dummyData = [String:AnyObject]()
        dummyData["success"] = false as AnyObject
        dummyData["currencies"] = ["USD": "United States Dollars",
                                   "EUR": "Euro" ] as AnyObject
        let json = try! JSONSerialization.data(withJSONObject: dummyData, options: [])
        
        mockUrlSession.nextData = json
        mockUrlSession.nextResponse = httpURL200Response

        currencyLayerClient.getAvailableCurrencies { (currencies, error) in
            if error != nil {
                dataExpectation.fulfill()
            }
        }
        
        wait(for: [dataExpectation], timeout: 1.0)
    }
    
    // MARK: - Convert
    
    func testConvertRequestedAtCorrectURL() {
        let urlExpectation = expectation(description: "Correct convert URL")
        let expectedUrl =
            HTTPConstants.APISchemeWithSlash +
                CurrencyLayerConstants.APIHost +
                CurrencyLayerConstants.APIPath +
                CurrencyLayerConstants.LiveMethod +
                CurrencyLayerConstants.QuestionMark +
                CurrencyLayerConstants.APIKey +
                CurrencyLayerConstants.EqualsSign
        
        let currency = Currency(name: "United States Dollars", code: CurrencyCode(rawValue: "USD")!)
        currencyLayerClient.convert(amountInDollars: 10, toCurrency: currency, completionHandler: { (convertedValue, error) in
            urlExpectation.fulfill()
        })
        
        wait(for: [urlExpectation], timeout: 1.0)
        XCTAssert(mockUrlSession.lastURL!.absoluteString.contains(expectedUrl))
    }
    
    func testConvertCorrectData() {
        let dataExpectation = expectation(description: "Correct convert data")
        var dummyData = [String:AnyObject]()
        dummyData["success"] = true as AnyObject
        dummyData["quotes"] = ["USDUSD": 1,
                               "USDEUR": 2] as AnyObject
        let json = try! JSONSerialization.data(withJSONObject: dummyData, options: [])
        
        mockUrlSession.nextData = json
        mockUrlSession.nextResponse = httpURL200Response
        
        
        let currency = Currency(name: "Euro", code: CurrencyCode(rawValue: "EUR")!)
        currencyLayerClient.convert(amountInDollars: 10, toCurrency: currency) { (convertedValue, error) in
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 1.0)
    }
    
    func testConvertCorrectValue() {
        let valueExpectation = expectation(description: "Correct convert value")
        var dummyData = [String:AnyObject]()
        dummyData["success"] = true as AnyObject
        dummyData["quotes"] = ["USDEUR": 2] as AnyObject
        let json = try! JSONSerialization.data(withJSONObject: dummyData, options: [])
        
        mockUrlSession.nextData = json
        mockUrlSession.nextResponse = httpURL200Response
        
        let currency = Currency(name: "Euro", code: CurrencyCode(rawValue: "EUR")!)
        var actualValue: Decimal = 0
        let expectedValue: Decimal = 20
        currencyLayerClient.convert(amountInDollars: expectedValue / 2, toCurrency: currency) { (convertedValue, error) in
            actualValue = convertedValue!
            valueExpectation.fulfill()
        }
        
        wait(for: [valueExpectation], timeout: 1.0)
        XCTAssert(actualValue == expectedValue)
    }
    
}
