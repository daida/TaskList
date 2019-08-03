//
//  TaskListViewModel.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

class TaskViewModel: Equatable {
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.task == rhs.task
    }
    
    private(set) var title: String
    let done: Observable<Bool>
    private(set) var text: String
    
    private(set) var shouldBePresented = Observable<Bool>(true)

    private let dataController: TaskDataController
    private var task: Task {
        didSet {
            self.title = self.task.title
            self.text = self.task.text
            self.done.value = self.task.done
        }
    }
    
    init(task: Task, dataController: TaskDataController) {
        self.title = task.title
        self.done = Observable<Bool>(task.done)
        self.text = task.text
        self.task = task
        self.dataController = dataController
    }
    
    func userDidTouchIsDoneSwitch(newValue: Bool) {
        self.task = self.dataController.updateTask(task: self.task, isDone: newValue) ?? self.task
    }
    
    func userDidPressDeleteButton() {
        if self.dataController.deleteTask(task: self.task) {
            self.shouldBePresented.value = false
        }
    }
    
}

protocol TaskListViewModelDelegate: class {
    func userWantDeleteIndexPath(_ indexPath: IndexPath)
    func taskNeedToBeUpdated()
    func displayErrorView()
}

class TaskListViewModel {
    
    var taskViewModel: [TaskViewModel] = []
    
    weak var delegate: TaskListViewModelDelegate? = nil
    
    var shouldDisplaySpiner: Observable<Bool> = Observable(true)
    
    var shouldDisplayTaskList: Observable<Bool> = Observable(false)
    
    let dataController: TaskDataController
    
    init(dataController: TaskDataController) {
        self.dataController = dataController
    }
    
    func handleDeleteTaskViewModel(taskViewModel: TaskViewModel) {
        guard let index = (self.taskViewModel.firstIndex { $0 == taskViewModel }) else { return }
        self.taskViewModel.remove(at: index)
        self.delegate?.userWantDeleteIndexPath(IndexPath(item: index, section: 0))
    }
    
    func generateTaskViewModel(task: [Task]) {
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
    
    func userWantToResetTask() {
        self.dataController.resetTask { result in
            if result == true {
                self.loadTask()
            }
        }
    }
    
    func loadTask() -> Void {
        
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
