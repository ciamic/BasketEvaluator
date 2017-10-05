//
//  CheckoutViewControllerTests.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 04/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import XCTest
@testable import BasketEvaluator

/// Tests for the CheckoutViewController
class CheckoutViewControllerTests: XCTestCase {
    
    var checkoutViewController: CheckoutViewController!
    var mockBasketItemDataSource: MockBasketItemDataSource!
    var mockCurrencyLayerClientAPI: CurrencyLayerClientAPI!
    
    override func setUp() {
        super.setUp()
        checkoutViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.CheckoutViewControllerIdentifier) as! CheckoutViewController
        
        mockBasketItemDataSource = MockBasketItemDataSource()
        checkoutViewController.basketItemData = mockBasketItemDataSource
        
        mockCurrencyLayerClientAPI = MockCurrencyLayerClientAPI()
        checkoutViewController.currencyLayerClient = mockCurrencyLayerClientAPI
        
        checkoutViewController.beginAppearanceTransition(true, animated: false) // triggers viewDidLoad
    }
    
    override func tearDown() {
        checkoutViewController.endAppearanceTransition()
        checkoutViewController = nil
        super.tearDown()
    }
    
    func testAmountLabelIsShowingCorrectOriginalAmount () {
        currencyFormatter.currencyCode = "USD"
        let currentValue = currencyFormatter.number(from: checkoutViewController.amountLabel.text!)
        let expectedValue = mockBasketItemDataSource.basketItemsTotalPriceInDollars
        XCTAssertTrue(currentValue!.decimalValue == expectedValue, "Not the correct amount shown in label")
    }
    
    private func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Wait")
        let endTime = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: endTime) {
            waitExpectation.fulfill()
        }
        wait(for: [waitExpectation], timeout: duration + 1) // +1 just to be sure
    }
    
    func testAmountLabelIsShowingCorrectConvertedAmount () {
        
        let currencyPickerController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.CurrencyPickerControllerIdentifier) as! CurrencyPickerController
        let _ = currencyPickerController.view // triggers viewDidLoad
        
        let convertExpectation = expectation(description: "Converted Amount")
        let euro = Currency(name: "Euro", code: CurrencyCode(rawValue: "EUR")!)
        checkoutViewController.currencyPickerController(currencyPickerController, didPickCurrency: euro)
        
        wait(for: 2) // this is needed because the label will update dispatching on the main thread so we wait for it's update
        
        mockCurrencyLayerClientAPI.convert(amountInDollars: mockBasketItemDataSource.basketItemsTotalPriceInDollars, toCurrency: euro) { convertedValue, error in
            currencyFormatter.currencyCode = "EUR"
            let currentValue = currencyFormatter.number(from: self.checkoutViewController.amountLabel.text!)!.decimalValue
            let expectedValue = convertedValue!
            XCTAssertTrue(currentValue == expectedValue, "Not the correct amount shown in label")
            convertExpectation.fulfill()
        }
        
        wait(for: [convertExpectation], timeout: 1.0)
    }
    
}
