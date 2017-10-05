//
//  BasketItemTableViewControllerUITests.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 04/10/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import XCTest

/// UI Tests for the BasketItemTableViewController. They are included for this controller since the StoreClient is only a dummy implementation in this project and does not require network requests, otherwise, the class should have been modified in order to take some dummy data as parameter in the launch environment of the XCUIApplication in order to mock the network requests.
class BasketItemTableViewControllerUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    private let CheckoutButtonLabel = "Checkout"
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        super.tearDown()
    }
    
    func testCheckoutButtonExists() {
        XCTAssert(app.buttons[CheckoutButtonLabel].exists)
    }
    
    func testCheckoutDisabledOnStart() {
        XCTAssert(app.buttons[CheckoutButtonLabel].isEnabled == false)
    }
    
    func testCheckoutEnabledWhenCartHasOneItem() {
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Increment"].tap()
        XCTAssert(app.buttons[CheckoutButtonLabel].isEnabled == true)
    }
    
    func testCheckoutEnabledWhenCartHasMultipleItems() {
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Increment"].tap()
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Increment"].tap()
        app.tables.cells.containing(.staticText, identifier:"Eggs").buttons["Increment"].tap()
        XCTAssert(app.buttons[CheckoutButtonLabel].isEnabled == true)
    }
    
    func testCheckoutDisabledAfterRemovingTheOnlyItem() {
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Increment"].tap()
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Decrement"].tap()
        XCTAssert(app.buttons[CheckoutButtonLabel].isEnabled == false)
    }
    
    func testCheckoutDisabledAfterRemovingMultipleItems() {
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Increment"].tap()
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Increment"].tap()
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Decrement"].tap()
        app.tables.cells.containing(.staticText, identifier:"Peas").buttons["Decrement"].tap()
        app.tables.cells.containing(.staticText, identifier:"Eggs").buttons["Increment"].tap()
        app.tables.cells.containing(.staticText, identifier:"Eggs").buttons["Decrement"].tap()
        XCTAssert(app.buttons[CheckoutButtonLabel].isEnabled == false)
    }
    
}
