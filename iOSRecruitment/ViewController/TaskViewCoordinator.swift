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
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = TaskListViewModel(dataController: self.dataController)
        let taskListController = TaskListViewController(viewModel: viewModel)
        taskListController.delegate = self
        self.navigationController.pushViewController(taskListController, animated: false)
    }
}

extension TaskCoordinator: TaskListViewControllerDelegate {
    func userDidTapOnTask(task: TaskViewModel) {
        let detailViewController = TaskDetailViewController(taskViewModel: task)
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
}
