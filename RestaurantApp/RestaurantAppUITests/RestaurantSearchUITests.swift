//
//  RestaurantSearchUITests.swift
//  RestaurantAppUITests
//
//  Created by Ravi Vora on 12/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import XCTest
@testable import RestaurantApp

class RestaurantSearchUITests: XCTestCase {

    var customKeywordsUtils: CustomKeywordsUtils? = CustomKeywordsUtils.init()
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        customKeywordsUtils?.deleteOnlyApp()
    }

    func testExample() {
        
    }

    func testForRestaurantSearchListScreen() {
        
        // Load Search TableView
        
        let searchTableView = app.tables.matching(identifier: "tableView--restaurantSearchTableView")
        let searchLocationCell = searchTableView.cells.element(matching: .cell, identifier: "RestaurantSearchCell0")
        
        // Type text on SearchController
        
        let searchBar = app.searchFields["Search nearby restaurants"]
        customKeywordsUtils?.waitAndTap(element: searchBar)
        _ = customKeywordsUtils?.waitForElementToAppear(searchBar,timeout: 30)
        searchBar.typeText("Bonchon")
        customKeywordsUtils?.waitAndTap(element: searchLocationCell)
        
        // Load Restaurant MapView
        
        let annotation = app.otherElements.matching(identifier: "mkPinAnnotationView--pinView").firstMatch
        XCTAssertTrue(annotation.exists)
        annotation.tap()
        
        // waiting time
        let exp = self.expectation(description: "myExpectation")
        
        let queue = DispatchQueue(label: "com.cloud.RestaurantApp")
        let delay: DispatchTimeInterval = .seconds((6))
        queue.asyncAfter(deadline: .now() + delay) {
            XCTAssertTrue(true)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 8) { [] error in
            print("X: async expectation")
            XCTAssertTrue(true)
        }
    }
}
