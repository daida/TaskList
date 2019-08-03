//
//  TaskDataController.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

enum Result {
    case success(task: [Task])
    case error
}

class TaskDataController {

    let apiService = TaskAPIService()
    let archiver = TaskArchiver()
    
    var task: [Task] = []
    
    func loadTask(completion: @escaping (Result) -> Void) {
        self.apiService.getTasks { dest in
            self.task = dest
            DispatchQueue.main.async { completion(.success(task: self.task)) }
        }
    }
    
    func deleteTask(task: Task) {
        guard let index = self.task.firstIndex(where: { $0 == task } ) else {
            print("Error can't find the right task to update")
            return
        }
        self.task.remove(at: index)
        print("index \(index) successfully removed")
    }
    
    func updateTask(task: Task, isDone: Bool) -> Task? {
        guard let index = self.task.firstIndex(where: { $0 == task } ) else {
            print("Error can't find the right task to update")
            return nil
        }
        self.task[index] = isDone ? task.completeTask() : task.unCompleteTask()
        print("Modification du modele OK")
        return self.task[index]
    }
    
}
