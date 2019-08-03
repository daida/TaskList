//
//  TaskListViewModel.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

class TaskViewModel {
    
    private(set) var title: String
    let done: Observable<Bool>
    private(set) var text: String

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
}

class TaskListViewModel {
    
    var taskViewModel: [TaskViewModel] = []
    
    var shouldDisplaySpiner: Observable<Bool> = Observable(true)
    var shouldReloadTask: Observable<Bool> = Observable(false)
    var shouldDisplayErrorMessage: Observable<Bool> = Observable(false)
    
    let dataController: TaskDataController
    
    init(dataController: TaskDataController) {
        self.dataController = dataController
    }
    
    func loadTask() -> Void {
        self.shouldDisplaySpiner.value = true
        self.shouldReloadTask.value = false
        self.shouldDisplayErrorMessage.value = false
        self.dataController.loadTask { result in
            
            switch result {
            case .success(task: let task):
                self.taskViewModel = task.map { TaskViewModel(task: $0, dataController: self.dataController) }
                self.shouldDisplaySpiner.value = false
                self.shouldReloadTask.value = true
            case .error:
                self.shouldDisplayErrorMessage.value = true
                print("Error can't load Task")
            }
        }
    }
}
