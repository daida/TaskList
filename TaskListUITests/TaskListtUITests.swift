//
//  TaskListUITests.swift
//  TaskListUITests
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import XCTest

extension XCUIElementQuery {
    var countForHittables: UInt {
        return UInt(allElementsBoundByIndex.filter { $0.isHittable }.count)
    }
}

class TaskListUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        self.app.launchArguments = ["TEST_UI"]
        self.app.launch()
    }

    func testDisplayTask() {
        XCTAssert(self.app.otherElements["TaskList"].waitForExistence(timeout: 5))
        XCTAssert(self.app.collectionViews["TaskListCollection"].waitForExistence(timeout: 5))
        self.app.collectionViews["TaskListCollection"].cells.firstMatch.tap()
        XCTAssert(self.app.otherElements["TaskDetail"].waitForExistence(timeout: 5))
    }

    func testActivate() {
        self.app.collectionViews["TaskListCollection"].cells.firstMatch.tap()
        XCTAssert(self.app.otherElements["TaskDetail"].waitForExistence(timeout: 5))
        self.app.switches["isDone"].tap()
        let valueDetail = self.app.switches["isDone"].value as! String
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
        let valueList = self.app.collectionViews["TaskListCollection"].cells.firstMatch.switches.firstMatch.value as! String
        XCTAssert(valueList == valueDetail, "switch have differents values")
    }

}
