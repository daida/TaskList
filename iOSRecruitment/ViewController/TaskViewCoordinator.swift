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

/// Coordinator Protocol, this protocol should always be used when a Coordinator patern is implemented
/// In this way the coordinator became compatible with an AppCoordinator
/// Here there is no need of the protocol, but it's alway better to be future proof ;)
protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}

// MARK: - TaskCoordinator

/// Manage the presentation flow. By this way there
/// is no coupling between all the `UIViewController`used during the flow.
class TaskCoordinator: Coordinator {

    // MARK: Public properties

    /// Navigation controller which be used in the presentation flow
    let navigationController: UINavigationController

    // MARK: Private properties

    /// Retrive `Task` from file sytem or remote API.
    ///
    /// dataController is intanciate with apiService and archiver dependecy injection
    /// because `TaskDataController` expect interface and not concrete type, so it's realy easy to instanciate
    /// dataController with an other implementation of apiService or archiver
    private let dataController: TaskDataContollerInterface = {
        let apiService = TaskAPIService()
        let archiver = TaskArchiver()
        return TaskDataController(apiService: apiService, archiver: archiver)
    }()

    // MARK: Init

    /// Init the Coordinator with an existing `UINavigationController`
    ///
    /// - Parameter navigationController: navigation controller which will be used to present the flow
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Public methods

    /// Required method to conform to the `Coordinator` protocol start the Task flow and present
    /// `TaskListViewController`
    func start() {
        let viewModel = TaskListViewModel(dataController: self.dataController)

        /// `TaskListViewController` expect a `TaskListViewModelInterface` not a
        /// concrete type ViewModel
        /// So here it will be realy easy to mock the ViewModel by implementing a
        /// MockViewModel conform to `TaskListViewModelInterface`
        let taskListController = TaskListViewController(viewModel: viewModel)
        taskListController.delegate = self
        self.navigationController.pushViewController(taskListController, animated: false)
    }
}

// MARK: - TaskListViewControllerDelegate

extension TaskCoordinator: TaskListViewControllerDelegate {
    func userDidTapOnTask(task: TaskViewModelInterface) {

        /// TaskDetailViewController required a TaskViewModelInterface not a concrete type ViewModel
        /// so here it will be realy easy to mock the
        /// ViewModel by implementing a MockViewModel conform to `TaskViewModelInterface`

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
