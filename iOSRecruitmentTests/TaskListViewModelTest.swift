//
//  TaskListViewModelTest.swift
//  iOSRecruitmentTests
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import XCTest
@testable import iOSRecruitment

class TaskListViewModelTest: XCTestCase {

    func testLoadingKO() {
        var mockDataController = DataControllerMock()
        
        let mockDelegate = TaskListViewModelDelgateMock()
        
        mockDataController.error = true
        let listViewModel = TaskListViewModel(dataController: mockDataController)
        listViewModel.delegate = mockDelegate
        
        let expect1 = expectation(description: "Spiner true")
        let expect2 = expectation(description: "Spiner false")
        
        let expect3 = expectation(description: "taskList false")
        
        listViewModel.shouldDisplaySpiner.bind { _, result in
            if result == true {
                expect1.fulfill()
            }
            if result == false {
                expect2.fulfill()
            }
        }
        
        listViewModel.shouldDisplayTaskList.bind {  _, result in
            if result == false {
                expect3.fulfill()
            }
        }
        
        XCTAssert(listViewModel.taskViewModel.isEmpty, "0 TaskViewModel are expected")
        listViewModel.loadTask()
        self.wait(for: [expect1, expect2, expect3, mockDelegate.excpectDisplayError], timeout: 2)
        XCTAssert(listViewModel.taskViewModel.isEmpty, "0 TaskViewModel are expected")
    }
 
    func testLoadingOK() {
        
        let mockDataController = DataControllerMock()
        
        let mockDelegate = TaskListViewModelDelgateMock()
        
        let expect1 = expectation(description: "Spiner true")
        let expect2 = expectation(description: "Spiner false")
        
        let expect3 = expectation(description: "taskList false")
        let expect4 = expectation(description: "taskList true")
        
        let listViewModel = TaskListViewModel(dataController: mockDataController)
        listViewModel.delegate = mockDelegate

        listViewModel.shouldDisplaySpiner.bind { (_, result) in
            if result == true {
                expect1.fulfill()
            }
            if result == false {
                expect2.fulfill()
            }
        }
        
        listViewModel.shouldDisplayTaskList.bind { (_, result) in
            if result == false {
                expect3.fulfill()
            }
            if result == true {
                expect4.fulfill()
            }
        }
        
        XCTAssert(listViewModel.taskViewModel.isEmpty, "0 TaskViewModel are expected")
        listViewModel.loadTask()
        self.wait(for: [expect1, expect2, expect3, expect4, mockDelegate.excpectDisplayTask], timeout: 2)
        XCTAssert(listViewModel.taskViewModel.count == 1, "1 TaskViewModel are expected")
    }
    
    func testDeleteFromTaskViewModelTrigListViewModelDelegate() {
        let mockDataController = DataControllerMock()
        let mockDelegate = TaskListViewModelDelgateMock()
        
        let listViewModel = TaskListViewModel(dataController: mockDataController)
        listViewModel.delegate = mockDelegate
        
        listViewModel.shouldDisplayTaskList.bind { _, result in
            if result == true {
                listViewModel.taskViewModel.first?.userDidPressDeleteButton()
            }
        }
        
        listViewModel.loadTask()
         self.wait(for: [mockDelegate.excpectUserWantToDelete], timeout: 2)
        guard let indexPath = mockDelegate.userWantToDeleteIndexPath else { return
            XCTFail("indexPath should'nt be nil")
        }
        XCTAssert(indexPath.item == 0,  "item shoud be 0")
        
    }

}
