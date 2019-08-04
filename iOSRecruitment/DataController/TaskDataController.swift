//
//  TaskDataController.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

// MARK: - TaskDataController

/// Provide `Task` model from the remote API or from the file
/// system (if there is nothing on the file sytem the remote API will be used)
class TaskDataController: TaskDataContollerInterface {

    // MARK: Private properties
    
    /// Controller responsible to retrive `Task` models from remote API
    private let apiService: TaskAPIServiceInterface
    
    /// Controller responsible to retrive `Task` models from file system
    private let archiver: TaskArchiverInterface
    
    // MARK: Public properties
    
    private(set) var task: [Task] = []
    
    // MARK: Init
    
    /// Init DataController
    ///
    /// - Parameters:
    ///   - apiService: Controller conform to `TaskAPIServiceInterface`
    ///     responsible to provide `Task` from remote API
    ///
    ///   - archiver: Controller conform to `TaskArchiverInterface`
    ///     responsible to provide `Task` from file system
    init(apiService: TaskAPIServiceInterface, archiver: TaskArchiverInterface) {
        self.apiService = apiService
        self.archiver = archiver
    }
    
    // MARK: Public methods
    
    /// Return `Task` model from remote API or from file system
    ///
    /// If there is cache on file system `Task` they will be used otherwise remote API will be used
    ///
    /// - Parameter completion: Completion closure with a Success / Error `enum` parameter
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
    
    /// Delete `Task` and save all `Task` on the file system
    ///
    /// - Parameter task: `Task` To delete
    /// - Returns: true if the `Task` is deleted false is something goes wrong
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
    
    /// Update isDone parameter on a `Task`
    ///
    /// - Parameters:
    ///   - task: `Task` to modify
    ///   - isDone: value to set to the isDone parameter of the model
    /// - Returns: An edited copy of the `task` the old task should
    /// not be keeped and should be replaced by the new version returned by this method
    /// return nil if something goes wrong
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
    
    /// Delete the file system cache
    ///
    /// - Parameter completion: completion closure, with a Bool parameter
    /// true if the cache is deleted false if something goes wrong
    func resetTask(completion: @escaping ((Bool) -> Void)) {
        self.archiver.deleteCache(completion: completion)
    }
    
    // MARK: Private methods
    
    /// Synchronise all the `Task` on the file system
    ///
    /// - Parameter completion: completion closure, with a bool paramete
    /// true if the saving was OK false if was KO
    private func saveTask(completion: @escaping (Bool) -> Void) {
        self.archiver.saveTask(task: self.task, completion: completion)
    }
    
}
