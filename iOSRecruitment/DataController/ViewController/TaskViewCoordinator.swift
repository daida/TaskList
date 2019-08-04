//
//  TaskViewCoordinator.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Coordinator

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}

// MARK: - TaskCoordinator

class TaskCoordinator: Coordinator {
    
    // MARK: Public properties
    
    let navigationController: UINavigationController
    
    // MARK: Private properties
    
    private let dataController: TaskDataContollerInterface = {
        let apiService = TaskAPIService()
        let archiver = TaskArchiver()
        return TaskDataController(apiService: apiService, archiver: archiver)
    }()
    
    // MARK: Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Public methods
    
    func start() {
        let viewModel = TaskListViewModel(dataController: self.dataController)
        let taskListController = TaskListViewController(viewModel: viewModel)
        taskListController.delegate = self
        self.navigationController.pushViewController(taskListController, animated: false)
    }
}

// MARK: - TaskListViewControllerDelegate

extension TaskCoordinator: TaskListViewControllerDelegate {
    func userDidTapOnTask(task: TaskViewModelInterface) {
        let detailViewController = TaskDetailViewController(taskViewModel: task)
        detailViewController.delegate = self
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
}
// MARK: - TaskDetailViewControllerDetailDelegate

extension TaskCoordinator: TaskDetailViewControllerDetailDelegate {
    func userDidDeleteTask() {
        self.navigationController.popViewController(animated: true)
    }
}
