//
//  TaskViewModelInterface.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 04/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

protocol TaskListViewModelInterface {
    
    init(dataController: TaskDataContollerInterface)
    func userWantToResetTask()
    func loadTask()

    var taskViewModel: [TaskViewModel] { get }
    var shouldDisplaySpiner: Observable<Bool> { get }
    var shouldDisplayTaskList: Observable<Bool> { get }
    
    var delegate: TaskListViewModelDelegate? { get set }
}

protocol TaskViewModelInterface {
    
    init(task: Task, dataController: TaskDataContollerInterface)
    
    var title: String { get }
    var done: Observable<Bool> { get }
    var text: String { get }
    var shouldBePresented: Observable<Bool> { get }
    
    func userDidTouchIsDoneSwitch(newValue: Bool)
    func userDidPressDeleteButton()
}
