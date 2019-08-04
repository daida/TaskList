//
//  TaskArchiver.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

struct TaskArchiver: TaskArchiverInterface {
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    private let dispatchQueue = DispatchQueue(label: "TaskArchiver", qos: DispatchQoS.userInitiated)
    
    private let archiveFileURL: URL = {
        do {
            let dest = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            return dest.appendingPathComponent("tasks.json")
        } catch {
            fatalError("Can't retrive document path")
        }
    }()
    
    func loadTaskFromDisk(completion: @escaping TaskArchiverLoadingHandlerClosure) {
        self.dispatchQueue.async {
            do {
                let data = try Data(contentsOf: self.archiveFileURL)
                let task = try self.jsonDecoder.decode([Task].self, from: data)
                completion(task)
            }
            catch {
                completion(nil)
            }
        }
    }
    
    func saveTask(task: [Task], completion: @escaping TaskArchiverSavingHandlerClosure) {
        self.dispatchQueue.async {
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
    
    func deleteCache(completion: @escaping TaskArchiverResetCacheHandlerClosure) {
        self.dispatchQueue.async {
            do {
                try FileManager.default.removeItem(at: self.archiveFileURL)
                completion(true)
            } catch {
                completion(false)
                print("Error -> \(error.localizedDescription)")
            }
        }

    }
    
}
