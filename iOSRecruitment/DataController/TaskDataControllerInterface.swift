//
//  DataControllerInterface.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

/// TaskDataController, TaskAPIService, TaskArchiver are never used directly,
/// they are always used through an interface.

import Foundation

// MARK: - Result

enum Result {
    case success(task: [Task])
    case error
}

// MARK: - TaskAPIServiceInterface

protocol TaskAPIServiceInterface {
    
    // MARK: Typealias
    
    typealias APIServiceCompletion = (([Task]) -> Void)
    
    // MARK: Public methods
    
    func getTasks(completion: @escaping APIServiceCompletion)
}

// MARK: - TaskArchiverInterface

protocol TaskArchiverInterface {

    // MARK: Typealias
    
    typealias TaskArchiverLoadingHandlerClosure = ([Task]?) -> Void
    typealias TaskArchiverSavingHandlerClosure = (Bool) -> Void
    typealias TaskArchiverResetCacheHandlerClosure = (Bool) -> Void
    
    // MARK: Public methods
    
    func loadTaskFromDisk(completion: @escaping TaskArchiverLoadingHandlerClosure)
    func saveTask(task: [Task], completion: @escaping TaskArchiverSavingHandlerClosure)
    func deleteCache(completion: @escaping TaskArchiverResetCacheHandlerClosure)
}

// MARK: - TaskDataContollerInterface

protocol TaskDataContollerInterface {
    
    // MARK: Typealias
    
    typealias TaskDataControllerLoadTaskHandlerClosure = ((Result) -> Void)
    typealias TaskDataControllerResetTaskHandlerClosure = ((Bool) -> Void)
    
    // MARK: Public methods
    
    func loadTask(completion: @escaping TaskDataControllerLoadTaskHandlerClosure)
    func deleteTask(task: Task) -> Bool
    func updateTask(task: Task, isDone: Bool) -> Task?
    func resetTask(completion: @escaping TaskDataControllerResetTaskHandlerClosure)
}

