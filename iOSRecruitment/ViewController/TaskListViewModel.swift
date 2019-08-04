//
//  TaskListViewModel.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

// MARK: - TaskListViewModelDelegate

/// Used to communicate with `TaskListViewController`
protocol TaskListViewModelDelegate: class {
    func userWantDeleteIndexPath(_ indexPath: IndexPath)
    func taskNeedToBeUpdated()
    func displayErrorView()
}

// MARK: - TaskListViewModel

/// This ViewModel handle the displaying of a Task list
final class TaskListViewModel: TaskListViewModelInterface {

    // MARK: Public properties

    /// Used to communicate with the ViewController
    weak var delegate: TaskListViewModelDelegate?

    /// In a list context, it will be used to populate cells
    private(set) var taskViewModel: [TaskViewModelInterface] = []

    /// Observable property describe if a spiner should be displayed
    private(set) var shouldDisplaySpiner: Observable<Bool> = Observable(true)

    /// Observable property describe if the task list should be displayed
    private(set) var shouldDisplayTaskList: Observable<Bool> = Observable(false)

    // MARK: Private properties

    /// Used to fetch task, and reset Task cache
    private let dataController: TaskDataContollerInterface

    // MARK: Init

    /// Init
    ///
    /// - Parameter dataController: a concrete implentation of `TaskDataContollerInterface`
    init(dataController: TaskDataContollerInterface) {
        self.dataController = dataController
    }

    // MARK: Private methods

    /// For every `TaskViewModel` the `TaskListViewModel` will bind on the property
    /// `shouldBePresented` if the value is set to false the corresponding `TaskViewModel`
    /// is removed from the array of `TaskViewModel` and the viewController is notify,
    /// so it will be able to update the `UICollectionView`
    ///
    /// - Parameter taskViewModel: a concrete implementation of `TaskViewModelInterface`
    private func handleDeleteTaskViewModel(taskViewModel: TaskViewModelInterface) {
        guard let taskViewModel = taskViewModel as? TaskViewModel else { return }
        guard let tab = self.taskViewModel as? [TaskViewModel] else { return }
        guard let index = (tab.firstIndex { $0 == taskViewModel }) else { return }
        self.taskViewModel.remove(at: index)
        self.delegate?.userWantDeleteIndexPath(IndexPath(item: index, section: 0))
    }

    /// Generate `TaskViewModel` from `Task` and subscribe to the `shouldBePresented` Observable property
    ///
    /// - Parameter task: `Task` array model
    private func generateTaskViewModel(task: [Task]) {
        self.taskViewModel = task.map { TaskViewModel(task: $0, dataController: self.dataController) }
        self.taskViewModel.forEach { taskModel in
            taskModel.shouldBePresented.bind(observer: { [weak self] _, newValue in
                guard let `self` = self else { return }
                if newValue == false {
                    self.handleDeleteTaskViewModel(taskViewModel: taskModel)
                }
            })
        }
    }

    // MARK: Public methods

    // MARK: User Actions

    /// Called when the user tap on the reset button,
    /// delete all cached task and reload them from the Api.
    func userWantToResetTask() {
        self.dataController.resetTask { result in
            if result == true {
                self.loadTask()
            }
        }
    }

    /// Start loading task by setting all Observable property in "loading" mode
    /// Then update them when the task are loaded, some delegate methods are also called
    func loadTask() {

        self.shouldDisplaySpiner.value = true
        self.shouldDisplayTaskList.value = false
        self.taskViewModel.forEach { $0.shouldBePresented.clearAllObserver() }
        self.taskViewModel.removeAll()
        self.dataController.loadTask { result in
            self.shouldDisplaySpiner.value = false
            switch result {
            case .success(task: let dest):
                self.generateTaskViewModel(task: dest)
                self.shouldDisplayTaskList.value = true
                self.delegate?.taskNeedToBeUpdated()
            case .error:
                self.delegate?.displayErrorView()
                print("Error can't load Task")
            }
        }
    }
}
