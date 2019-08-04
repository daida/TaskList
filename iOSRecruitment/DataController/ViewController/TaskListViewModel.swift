//
//  TaskListViewModel.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

// MARK: - TaskListViewModelDelegate

protocol TaskListViewModelDelegate: class {
    func userWantDeleteIndexPath(_ indexPath: IndexPath)
    func taskNeedToBeUpdated()
    func displayErrorView()
}

// MARK: - TaskListViewModel

final class TaskListViewModel: TaskListViewModelInterface {
    
    // MARK: Public properties
    
    weak var delegate: TaskListViewModelDelegate? = nil
    
    private(set) var taskViewModel: [TaskViewModel] = []
    
    private(set) var shouldDisplaySpiner: Observable<Bool> = Observable(true)
    
    private(set) var shouldDisplayTaskList: Observable<Bool> = Observable(false)
    
    // MARK: Private properties
    
    private let dataController: TaskDataContollerInterface
    
    // MARK: Init
    
    init(dataController: TaskDataContollerInterface) {
        self.dataController = dataController
    }
    
    // MARK: Private methods
    
    private func handleDeleteTaskViewModel(taskViewModel: TaskViewModel) {
        guard let index = (self.taskViewModel.firstIndex { $0 == taskViewModel }) else { return }
        self.taskViewModel.remove(at: index)
        self.delegate?.userWantDeleteIndexPath(IndexPath(item: index, section: 0))
    }
    
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
    
    func userWantToResetTask() {
        self.dataController.resetTask { result in
            if result == true {
                self.loadTask()
            }
        }
    }
    
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
