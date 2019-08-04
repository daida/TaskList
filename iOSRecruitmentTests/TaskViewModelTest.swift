//
//  TaskViewModelTest.swift
//  iOSRecruitmentTests
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

import XCTest
@testable import iOSRecruitment

class TaskViewModelTest: XCTestCase {

    func testInitTaskViewModel() {

        let dataController = DataControllerMock()
        let task = Task(title: "Une Task", done: false, text: "Test")
        let viewModel = TaskViewModel(task: task, dataController: dataController)

        XCTAssert(viewModel.done.value == false, "Done should be false")
        XCTAssert(viewModel.title == "Une Task", "title should be equal Une Task")
        XCTAssert(viewModel.text == "Test", "title should be equal to Test")
        XCTAssert(viewModel.shouldBePresented.value == true, "Should be presented should be true")
    }

    func testIsDoneChange() {
        let dataController = DataControllerMock()

        let isDoneExpectation = expectation(description: "isDone")

        let task = Task(title: "Une Task", done: false, text: "Test")
        let viewModel = TaskViewModel(task: task, dataController: dataController)

        viewModel.done.bind { _, result in
            if result == true {
                isDoneExpectation.fulfill()
            }
        }

        viewModel.userDidTouchIsDoneSwitch(newValue: true)
        self.wait(for: [isDoneExpectation], timeout: 2)

    }

    func testDelete() {
        let dataController = DataControllerMock()

        let deleteExpectation = expectation(description: "isDone")

        let task = Task(title: "Une Task", done: false, text: "Test")
        let viewModel = TaskViewModel(task: task, dataController: dataController)

        viewModel.shouldBePresented.bind { _, result in
            if result == false {
                deleteExpectation.fulfill()
            }
        }

        viewModel.userDidPressDeleteButton()
        self.wait(for: [deleteExpectation], timeout: 2)
    }

}
