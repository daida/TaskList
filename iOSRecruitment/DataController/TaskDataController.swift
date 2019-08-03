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
    
    var Task: [Task] = []
    
    func loadTask(completion: @escaping (Result) -> Void) {
        self.apiService.getTasks { dest in
            self.Task = dest
            DispatchQueue.main.async { completion(.success(task: self.Task)) }
        }
    }
    
    func deleteTask(Task: Task) {
        
    }
    
    func updateTask(Task: Task) {
        
    }
    
    
}
