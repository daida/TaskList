//
//  TaskViewModel.swift
//  TaskList
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

/// Provide dynamic display information for the cell and the detail view,
/// handle user action and call the DataController if it's required
/// This view model is used to represent a single task
final class TaskViewModel: TaskViewModelInterface {

    // MARK: Public properties

    /// Title of the task To display
    private(set) var title: String

    /// Observable value to set the switch in the right position
    private(set) var done: Observable<Bool>

    /// Task text to display
    private(set) var text: String

    /// When the user tap on delete the delete button the model `Task` is deleted,
    /// If the deletion goes well, this property is set to false.
    /// `TaskListViewModel` observe this property and will remove this viewModel from his array
    private(set) var shouldBePresented = Observable<Bool>(true)

    // MARK: Private properties

    /// DataController used to edit the `Task` model when the user edit it.
    private let dataController: TaskDataContollerInterface

    /// The Task Model, if the model change the viewModel update itself
    /// and some Observalbe property are trigged
    private var task: Task {
        didSet {
            self.title = self.task.title
            self.text = self.task.text
            self.done.value = self.task.done
        }
    }

    // MARK: Init

    /// Init
    ///
    /// - Parameters:
    ///   - task: `Task` Model
    ///   - dataController: a `TaskDataContollerInterface` concrete implementation
    init(task: Task, dataController: TaskDataContollerInterface) {
        self.title = task.title
        self.done = Observable<Bool>(task.done)
        self.text = task.text
        self.task = task
        self.dataController = dataController
    }

    // MARK: Public methods

    // MARK: User Action

    /// Handle action when the uset touch the switch
    ///
    /// - Parameter newValue: isDone true or false
    func userDidTouchIsDoneSwitch(newValue: Bool) {
        self.task = self.dataController.updateTask(task: self.task, isDone: newValue) ?? self.task
    }

    /// Handle user action when the user tap on delete button,
    /// if the DataController deletion is ok, then the Observable property `shouldBePresented` is set to false
    func userDidPressDeleteButton() {
        if self.dataController.deleteTask(task: self.task) {
            self.shouldBePresented.value = false
        }
    }
}
