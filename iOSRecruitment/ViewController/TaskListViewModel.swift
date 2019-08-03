//
//  TaskListViewModel.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

struct TaskViewModel {
    
    let title: String
    let done: Bool
    let text: String
    private let task: Task
    
    init(task: Task) {
        self.title = task.title
        self.done = task.done
        self.text = task.text
        self.task = task
    }
}

class TaskListViewModel {
    
    var taskViewModel: [TaskViewModel] = []
    
    var shouldDisplaySpiner: Observable<Bool> = Observable(true)
    var shouldReloadTask: Observable<Bool> = Observable(false)
    
    let dataController: TaskDataController
    
    init(dataController: TaskDataController) {
        self.dataController = dataController
    }
    
    func loadTask() -> Void {
        self.shouldDisplaySpiner.value = true
        self.shouldReloadTask.value = false
        self.dataController.apiService.getTasks { task in
            self.taskViewModel = task.map ( TaskViewModel.init )
            self.shouldDisplaySpiner.value = false
            self.shouldReloadTask.value = true
        }
    }
}
