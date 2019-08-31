//
//  DataControllerMock.swift
//  TaskListTests
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

@testable import TaskList

struct DataControllerMock: TaskDataContollerInterface {

    var error: Bool = false

    func loadTask(completion: @escaping TaskDataControllerLoadTaskHandlerClosure) {
        if error == true {
            completion(.error)
            return
        }
        completion(.success(task: [Task(title: "Une tache de test", done: false, text: "Une tache")]))
    }

    func deleteTask(task: Task) -> Bool {
        return true
    }

    func updateTask(task: Task, isDone: Bool) -> Task? {
        return isDone ? task.completeTask() : task.unCompleteTask()
    }
    func resetTask(completion: @escaping TaskDataControllerResetTaskHandlerClosure) {
        completion(true)
    }
}
