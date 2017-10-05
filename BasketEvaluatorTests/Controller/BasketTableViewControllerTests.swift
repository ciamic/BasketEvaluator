//
//  BasketTableViewControllerTests.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 03/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import XCTest
@testable import BasketEvaluator

/// Tests for the BasketTableViewController
class BasketTableViewControllerTests: XCTestCase {
    
    var basketTableViewController: BasketTableViewController!
    var mockBasketItemDataSource: MockBasketItemDataSource!
    
    override func setUp() {
        super.setUp()
        basketTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.BasketTableViewControllerIdentifier) as! BasketTableViewController
                mockBasketItemDataSource = MockBasketItemDataSource()
        basketTableViewController.basketItemData = mockBasketItemDataSource
        basketTableViewController.beginAppearanceTransition(true, animated: false) // triggers viewDidLoad
    }
    
    override func tearDown() {
        basketTableViewController.endAppearanceTransition()
        basketTableViewController = nil
        super.tearDown()
    }
    
    func testRefreshBasketItemIsCalledOnce() {
        XCTAssertTrue(mockBasketItemDataSource.refreshBasketItemsCalled == 1, "Not one call to refresh data source items")
    }
    
    func testCorrectNumberOfItemsInTableView() {
        XCTAssertTrue(basketTableViewController.tableView.numberOfRows(inSection: 0) == mockBasketItemDataSource.basketItems.count, "Wrong number of items in basket")
    }
    
}
