//
//  TaskArchiver.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

// MARK: TaskArchiver

/// Retrive and save`Task` on the files system by using JSON format.
struct TaskArchiver: TaskArchiverInterface {

    // MARK: Private properties

    // MARK: Archiver / Decoder

    /// Encoder used to encode an array of `Task` to a JSON object
    private let jsonEncoder = JSONEncoder()

    /// Decoder used to retrive `Task` from a JSON file
    private let jsonDecoder = JSONDecoder()

    // MARK: DispatchQueue

    /// DispatchQueue used during the encoding / decoding process in order to not block the mainQueue
    private let dispatchQueue = DispatchQueue(label: "TaskArchiver", qos: DispatchQoS.userInitiated)

    // MARK: Archive file path

    /// Retrive the user document path and add the name of the file "tasks.json"
    private let archiveFileURL: URL = {
        do {
            let dest = try FileManager.default.url(for:
                FileManager.SearchPathDirectory.documentDirectory,
                                                   in: FileManager.SearchPathDomainMask.userDomainMask,
                                                                   appropriateFor: nil, create: true)
            return dest.appendingPathComponent("tasks.json")
        } catch {
            fatalError("Can't retrive document path")
        }
    }()

    // MARK: Public methods

    /// Retrive a `Task` array from the file system
    ///
    /// - Parameter completion: completion closure with an optional array of `Task`
    /// If some task was loaded the array is not nil otherwise it's nil
    func loadTaskFromDisk(completion: @escaping TaskArchiverLoadingHandlerClosure) {
        self.dispatchQueue.async {
            do {
                let data = try Data(contentsOf: self.archiveFileURL)
                let task = try self.jsonDecoder.decode([Task].self, from: data)
                completion(task)
            } catch {
                completion(nil)
            }
        }
    }

    /// Save an array of `Task` on the filesystem
    ///
    /// - Parameters:
    ///   - task: An array of `Task` to save on the file system
    ///   - completion: completion closure with a `Bool`
    /// argument true if the saving was ok false if it's was KO.
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

    /// Delete the `Task` from the file system
    ///
    /// - Parameter completion: completion closure with a `Bool` parameter true
    /// if the delete was OK false if it's KO
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
