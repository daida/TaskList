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
        
        self.archiver.loadTaskFromDisk { localTask in
            
            if let localTask = localTask {
                self.task = localTask
                DispatchQueue.main.async { completion(.success(task: self.task)) }
                return
            }
            
            self.apiService.getTasks { remoteTask in
                self.task = remoteTask
                DispatchQueue.main.async { completion(.success(task: self.task)) }
            }
        }
    }
    
    func deleteTask(task: Task) -> Bool {
        guard let index = self.task.firstIndex(where: { $0 == task } ) else {
            print("Error can't find the right task to update")
            return false
        }
        self.task.remove(at: index)
        self.saveTask() { result in
            if result == true {
                print("index \(index) successfully removed")
            } else {
                print("index \(index) error on removed opperation")
            }
        }
        return true
    }
    
    func updateTask(task: Task, isDone: Bool) -> Task? {
        guard let index = self.task.firstIndex(where: { $0 == task } ) else {
            print("Error can't find the right task to update")
            return nil
        }
        self.task[index] = isDone ? task.completeTask() : task.unCompleteTask()
        self.saveTask() { result in
            if result == true {
                print("index-> \(index) isDone -> \(isDone) Save OK")
            } else {
                print("index-> \(index) isDone -> \(isDone) Save KO")
            }
        }
        return self.task[index]
    }
    
    func saveTask(completion: @escaping (Bool) -> Void) {
        self.archiver.saveTask(task: self.task, completion: completion)
     }
    
    func resetTask(completion: @escaping ((Bool) -> Void)) {
        self.archiver.deleteCache(completion: completion)
    }
    
}
