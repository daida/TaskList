//
//  Task.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

// MARK: - Task

struct Task: Encodable, Decodable, Equatable {

    // MARK: - Private properties

    private let identifier: String

    // MARK: Public properties

    let title: String
    let done: Bool
    let text: String

    // MARK: init

    init(identifier: String = UUID().uuidString, title: String, done: Bool, text: String) {
        self.title = title
        self.done =  done
        self.text = text
        self.identifier = identifier
    }

    // MARK: Public methods

    func completeTask() -> Task {
        return Task(identifier: self.identifier, title: self.title, done: true, text: self.text)
    }

    func unCompleteTask() -> Task {
        return Task(identifier: self.identifier, title: self.title, done: false, text: self.text)
    }
}
