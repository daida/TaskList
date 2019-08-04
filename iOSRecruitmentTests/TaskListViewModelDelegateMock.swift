//
//  TaskListViewModelDelegateMock.swift
//  iOSRecruitmentTests
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import XCTest
@testable import iOSRecruitment

class TaskListViewModelDelgateMock: TaskListViewModelDelegate {
    
    
    var taskNeedToBeUpdatedDidCalled: Bool = false
    var displayErrorViewDidCalled: Bool = false
    var userWantToDeleteIndexPath: IndexPath? = nil
    
    let excpectDisplayTask = XCTestExpectation(description: "DisplayTask")
    let excpectDisplayError = XCTestExpectation(description: "Display Error")
    let excpectUserWantToDelete = XCTestExpectation(description: "User Wan To delete")
    
    func userWantDeleteIndexPath(_ indexPath: IndexPath) {
        self.userWantToDeleteIndexPath = indexPath
        self.excpectUserWantToDelete.fulfill()
    }
    
    func taskNeedToBeUpdated() {
        self.taskNeedToBeUpdatedDidCalled = true
        self.excpectDisplayTask.fulfill()
    }
    
    func displayErrorView() {
        self.displayErrorViewDidCalled = true
        self.excpectDisplayError.fulfill()
    }
}
