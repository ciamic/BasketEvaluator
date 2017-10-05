//
//  CurrencyPickerControllerTests.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 03/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import XCTest
@testable import BasketEvaluator

/// Class used for testing the currency picker delegate protocol
class FakeCurrencyPickedDelegate: CurrencyPickerDelegate {
    
    var currencyPickerControllerDidPickCalled = 0
    func currencyPickerController(_ currencyPickerController: CurrencyPickerController,
                                  didPickCurrency currency: Currency) {
        currencyPickerControllerDidPickCalled = currencyPickerControllerDidPickCalled + 1
    }
    
    var currencyPickerControllerDidCancelCalled = 0
    func currencyPickerControllerDidCancel(_ currencyPickerController: CurrencyPickerController) {
        currencyPickerControllerDidCancelCalled = currencyPickerControllerDidCancelCalled + 1
    }
    
}

/// Tests for the CurrencyPickerController
class CurrencyPickerControllerTests: XCTestCase {
    
    var currencyPickerController: CurrencyPickerController!
    var mockCurrencyDataSource: MockCurrencyDataSource!
    var fakeCurrencyPickerDelegate: FakeCurrencyPickedDelegate!
    
    override func setUp() {
        super.setUp()
        currencyPickerController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.CurrencyPickerControllerIdentifier) as! CurrencyPickerController
        
        mockCurrencyDataSource = MockCurrencyDataSource()
        currencyPickerController.currencyData = mockCurrencyDataSource
        
        fakeCurrencyPickerDelegate = FakeCurrencyPickedDelegate()
        currencyPickerController.delegate = fakeCurrencyPickerDelegate
        
        currencyPickerController.beginAppearanceTransition(true, animated: false) // triggers viewDidLoad
    }
    
    override func tearDown() {
        currencyPickerController.endAppearanceTransition()
        currencyPickerController = nil
        super.tearDown()
    }
    
    func testRefreshAvailableCurrenciesCalledOnce() {
        XCTAssertTrue(mockCurrencyDataSource.refreshAvailableCurrenciesCalled == 1, "Not one call to refresh available currencies")
    }
    
    func testCorrectNumberOfAvailableCurrenciesInTableView() {
        XCTAssertTrue(currencyPickerController.tableView.numberOfRows(inSection: 0) == mockCurrencyDataSource.availableCurrencies.count, "Wrong number of currencies in table view")
    }
    
    func testCurrencyPickerControllerDidPickCalled() {
        XCTAssertTrue(fakeCurrencyPickerDelegate.currencyPickerControllerDidPickCalled == 0, "Did Pick already called")
        currencyPickerController.tableView(currencyPickerController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(fakeCurrencyPickerDelegate.currencyPickerControllerDidPickCalled == 1, "Did Pick not called")
    }
    
    func testCurrencyPickerControllerDidCancelCalled() {
        XCTAssertTrue(fakeCurrencyPickerDelegate.currencyPickerControllerDidCancelCalled == 0, "Did Cancel already called")
        currencyPickerController.cancelButtonTapped(UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil))
        XCTAssertTrue(fakeCurrencyPickerDelegate.currencyPickerControllerDidCancelCalled == 1, "Did Cancel not called")
    }
    
}
