//
//  DataControllerInterface.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

enum Result {
    case success(task: [Task])
    case error
}

protocol TaskAPIServiceInterface {
    typealias APIServiceCompletion = (([Task]) -> Void)
    func getTasks(success: @escaping APIServiceCompletion)
}

protocol TaskArchiverInterface {
    typealias TaskArchiverLoadingHandlerClosure = ([Task]?) -> Void
    typealias TaskArchiverSavingHandlerClosure = (Bool) -> Void
    typealias TaskArchiverResetCacheHandlerClosure = (Bool) -> Void
    
    func loadTaskFromDisk(completion: @escaping TaskArchiverLoadingHandlerClosure)
    func saveTask(task: [Task], completion: @escaping TaskArchiverSavingHandlerClosure)
    func deleteCache(completion: @escaping TaskArchiverResetCacheHandlerClosure)
}

protocol TaskDataContollerInterface {
    typealias TaskDataControllerLoadTaskHandlerClosure = ((Result) -> Void)
    typealias TaskDataControllerResetTaskHandlerClosure = ((Bool) -> Void)
    
    func loadTask(completion: @escaping TaskDataControllerLoadTaskHandlerClosure)
    func deleteTask(task: Task) -> Bool
    func updateTask(task: Task, isDone: Bool) -> Task?
    func resetTask(completion: @escaping TaskDataControllerResetTaskHandlerClosure)
}

