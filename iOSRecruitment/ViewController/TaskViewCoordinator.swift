//
//  TaskViewCoordinator.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}

class TaskCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let dataController: TaskDataController = TaskDataController()
    let taskListController: TaskListViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let viewModel = TaskListViewModel(dataController: self.dataController)
        self.taskListController = TaskListViewController(viewModel: viewModel)
    }
    
    func start() {
        self.taskListController.delegate = self
        self.navigationController.pushViewController(self.taskListController, animated: false)
    }
}

extension TaskCoordinator: TaskListViewControllerDelegate {
    func userDidTapOnTask(task: TaskListViewModel) {
        
    }
}
