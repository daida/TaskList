//
//  TaskDataController.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

// MARK: - TaskDataController

class TaskDataController: TaskDataContollerInterface {

    // MARK: Private properties
    
    private let apiService: TaskAPIServiceInterface
    private let archiver: TaskArchiverInterface
    
    // MARK: Public properties
    
    private(set) var task: [Task] = []
    
    // MARK: Init
    
    init(apiService: TaskAPIServiceInterface, archiver: TaskArchiverInterface) {
        self.apiService = apiService
        self.archiver = archiver
    }
    
    // MARK: Public methods
    
    func loadTask(completion: @escaping TaskDataControllerLoadTaskHandlerClosure) {
        
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
    
    func resetTask(completion: @escaping ((Bool) -> Void)) {
        self.archiver.deleteCache(completion: completion)
    }
    
    // MARK: Private methods
    
    private func saveTask(completion: @escaping (Bool) -> Void) {
        self.archiver.saveTask(task: self.task, completion: completion)
    }
    
}
