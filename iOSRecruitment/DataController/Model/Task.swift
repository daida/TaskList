//
//  Task.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

struct Task: Equatable, Encodable, Decodable {
    private let identifier: String
    let title: String
    let done: Bool
    let text: String
    
    init(identifier: String = UUID().uuidString, title: String, done: Bool, text: String) {
        self.title = title
        self.done =  done
        self.text = text
        self.identifier = identifier
    }
    
    func completeTask() -> Task {
        return Task(identifier: self.identifier, title: self.title, done: true, text: self.text)
    }
    
    func unCompleteTask() -> Task {
        return Task(identifier: self.identifier, title: self.title, done: false, text: self.text)
    }
}
