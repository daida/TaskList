//
//  TaskViewModel.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

// MARK: - Equatable

extension TaskViewModel: Equatable {
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.task == rhs.task
    }
}

// MARK: - TaskViewModel

final class TaskViewModel: TaskViewModelInterface {
    
    // MARK: Public properties
    
    private(set) var title: String
    private(set) var done: Observable<Bool>
    private(set) var text: String
    private(set) var shouldBePresented = Observable<Bool>(true)

    // MARK: Private properties
    
    private let dataController: TaskDataContollerInterface
    
    private var task: Task {
        didSet {
            self.title = self.task.title
            self.text = self.task.text
            self.done.value = self.task.done
        }
    }
    
    // MARK: Init
    
    init(task: Task, dataController: TaskDataContollerInterface) {
        self.title = task.title
        self.done = Observable<Bool>(task.done)
        self.text = task.text
        self.task = task
        self.dataController = dataController
    }
    
    // MARK: Public methods
    
    // MARK: User Action
    
    func userDidTouchIsDoneSwitch(newValue: Bool) {
        self.task = self.dataController.updateTask(task: self.task, isDone: newValue) ?? self.task
    }
    
    func userDidPressDeleteButton() {
        if self.dataController.deleteTask(task: self.task) {
            self.shouldBePresented.value = false
        }
    }
}
