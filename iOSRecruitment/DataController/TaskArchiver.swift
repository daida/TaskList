//
//  TaskArchiver.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

struct TaskArchiver {
    
    typealias TaskArchiverLoadingHandlerClosure = ([Task]?) -> Void
    typealias TaskArchiverSavingHandlerClosure = (Bool) -> Void
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    let dispatchQueue = DispatchQueue(label: "TaskArchiver", qos: DispatchQoS.userInitiated)
    
    let archiveFileURL: URL = {
        do {
            let dest = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            return dest.appendingPathComponent("tasks.json")
        } catch {
            fatalError("Can't retrive document path")
        }
        
    }()
    
    func loadTaskFromDisk(completion: @escaping TaskArchiverLoadingHandlerClosure) {
        do {
            let data = try Data(contentsOf: self.archiveFileURL)
            let task = try self.jsonDecoder.decode([Task].self, from: data)
            self.dispatchQueue.async {
                completion(task)
            }
        }
        catch {
            completion(nil)
        }

    }
    
    func saveTask(task: [Task], completion: TaskArchiverSavingHandlerClosure) {
        do {
            let dest = try self.jsonEncoder.encode(task)
            try dest.write(to: self.archiveFileURL)
            completion(true)
        } catch {
            print("Error -> \(error.localizedDescription)")
            completion(false)
        }

    }
    
}
