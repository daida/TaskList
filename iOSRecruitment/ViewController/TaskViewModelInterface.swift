//
//  TaskViewModelInterface.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

/// TaskViewModel, TaskListViewModel are never used directly,
/// they are always used through an interface.

// MARK: - TaskListViewModelInterface

protocol TaskListViewModelInterface {

    // MARK: Init

    init(dataController: TaskDataContollerInterface)

    // MARK: Methods

    func userWantToResetTask()
    func loadTask()

    // MARK: Read only properties

    var taskViewModel: [TaskViewModelInterface] { get }
    var shouldDisplaySpiner: Observable<Bool> { get }
    var shouldDisplayTaskList: Observable<Bool> { get }

    // MARK: Read / Write properties

    var delegate: TaskListViewModelDelegate? { get set }
}

// MARK: - TaskViewModelInterface

protocol TaskViewModelInterface {

    // MARK: Init

    init(task: Task, dataController: TaskDataContollerInterface)

    // MARK: Read only properties

    var title: String { get }
    var done: Observable<Bool> { get }
    var text: String { get }
    var shouldBePresented: Observable<Bool> { get }

    // MARK: Public methods

    // MARK: User Actions

    func userDidTouchIsDoneSwitch(newValue: Bool)
    func userDidPressDeleteButton()
}
