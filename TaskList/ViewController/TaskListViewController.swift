//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TaskListViewControllerDelegate

/// Used to communicate betwen `TaskListViewController` and the coordinator
protocol TaskListViewControllerDelegate: class {
    func userDidTapOnTask(task: TaskViewModelInterface)
}

// MARK: - TaskListViewController

/// Display a `Task` list, and allow the user to delete or consult task
class TaskListViewController: UIViewController {

    // MARK: - Style

    /// Represent the graphical Style of the View (color, corner radius, font, etc..)
    private struct Style {
        static let backgroundColor = UIColor.white
        static let collectionViewBackgroundColor = UIColor.white
        static let titleTextColor = UIColor.black
    }

    // MARK: Public properties

    /// used to comunicate with the Coordinator
    weak var delegate: TaskListViewControllerDelegate?

    // MARK: Private properties

    /// the `TaskListViewController` stay updated by observing some properties,
    /// and some order are given by the viewModel delegate.
    /// User actions are sent to the viewModel
    private var viewModel: TaskListViewModelInterface

    // MARK: Private properties

    // MARK: UIView

    /// Display a static text
    private let titleLabel: UILabel = {
        let dest = UILabel(frame: .zero)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    /// Display the Task list
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        let dest = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    /// Display a spinner during task loading
    private let spiner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView(style: .gray)
        spiner.translatesAutoresizingMaskIntoConstraints = false
        return spiner
    }()

    // MARK: Init

    /// Init of the ViewController
    ///
    /// - Parameter viewModel: Concrete implementation of `TaskListViewModelInterface`
    init(viewModel: TaskListViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    // MARK: Setup

    /// Setup delegate, dataSource and register the Cell class
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.cellReuseIdentifer)
    }

    /// Add a reset button to the Navigation bar
    private func setupResetButton() {
        let logoutBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .done,
            target: self,
            action: #selector(userDidTapOnResetButton))

        self.navigationItem.leftBarButtonItem  = logoutBarButtonItem
    }

    /// Setup the View layout
    private func setupLayout() {

        // Label
        var constraints = [NSLayoutConstraint]()

        constraints.append(self.titleLabel.topAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10))

        constraints.append( self.titleLabel.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor))

        // Collection View
        constraints.append(self.collectionView.topAnchor.constraint(
            equalTo: self.titleLabel.bottomAnchor, constant: 10))

        constraints.append(self.collectionView.bottomAnchor.constraint(
            equalTo: self.view.bottomAnchor))

        constraints.append(self.collectionView.leadingAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.leadingAnchor))

        constraints.append(self.collectionView.trailingAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.trailingAnchor))

        // Spiner
        constraints.append(self.spiner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(self.spiner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    /// Setup the view style according to the `Style` struct
    private func setupStyle() {
        self.view.backgroundColor = Style.backgroundColor
        self.collectionView.backgroundColor = Style.collectionViewBackgroundColor
        self.titleLabel.textColor = Style.titleTextColor
    }

    /// Setup the view hierarchy
    private func setupView() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.spiner)
    }

    private func setupAccessibility() {
        self.view.isAccessibilityElement = false
        self.view.accessibilityIdentifier = "TaskList"
        self.collectionView.isAccessibilityElement = false
        self.collectionView.accessibilityIdentifier = "TaskListCollection"
    }

    /// Bind some action to Observable property, set the delegate,
    /// And launch the loading process on the viewModel
    private func setupViewModel() {

        self.viewModel.shouldDisplaySpiner.bind { [weak self] _, result in
            guard let `self` = self else { return }
            DispatchQueue.main.async { self.handleSpinerDisplay(result: result) }
        }

        self.handleSpinerDisplay(result: self.viewModel.shouldDisplaySpiner.value)

        self.viewModel.shouldDisplayTaskList.bind { [weak self] _, result in

            DispatchQueue.main.async {
                guard let `self` = self else { return }

                UIView.animate(withDuration: 0.35) {
                    self.collectionView.alpha = result ? 1.0 : 0.0
                }
            }
        }

        self.collectionView.alpha = self.viewModel.shouldDisplayTaskList.value ? 1.0 : 0.0

        self.viewModel.delegate = self

        self.viewModel.loadTask()
    }

    /// Setup static text on the label and on title property for the navigation bar
    func setupStaticText() {
        self.titleLabel.text = "Display the Task List"
        self.title = "Tasks List"
    }

    // MARK: SpinerHandler

    /// Show the spiner and start the animation
    private func showSpiner() {
        self.spiner.startAnimating()
        self.spiner.isHidden = false
    }

    /// Hide the spiner and stop the animation
    private func hideSpiner() {
        self.spiner.stopAnimating()
        self.spiner.isHidden = true
    }

    /// Hide of show the spiner according to the result value
    ///
    /// - Parameter result: true -> show false -> hide
    private func handleSpinerDisplay(result: Bool) {
        result ? self.showSpiner() : self.hideSpiner()
    }

    // MARK: ErrorView Handler

    /// Present an Error message
    private func handleErrorMessage() {
        let alert = UIAlertController(
            title: nil,
            message: "Impossible de charger les taches",
            preferredStyle: .alert)

        let retry = UIAlertAction(title: "Réessayer",
                                  style: UIAlertAction.Style.default) { [weak self] _ in
            guard let `self` = self else { return }
            self.viewModel.loadTask()
        }
        let cancel = UIAlertAction(title: "OK",
                                   style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(retry)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: User action handler

    /// Handler for the navBar reset button
    @objc private func userDidTapOnResetButton() {
        self.viewModel.userWantToResetTask()
    }

    // MARK: UIViewController override

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupLayout()
        self.setupViewModel()
        self.setupCollectionView()
        self.setupResetButton()
        self.setupStyle()
        self.setupStaticText()
        self.setupAccessibility()
    }
}

// MARK: - UICollectionViewDataSource

extension TaskListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.taskViewModel.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.cellReuseIdentifer, for: indexPath)
        guard let castedCell = cell as? TaskCell else { return cell }

        guard indexPath.item >= 0, indexPath.item < self.viewModel.taskViewModel.count else { return cell }

        let cellModel = self.viewModel.taskViewModel[indexPath.item]

        castedCell.configure(model: cellModel)
        return castedCell
    }

}

// MARK: - UICollectionViewDelegate

extension TaskListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item >= 0, indexPath.item < self.viewModel.taskViewModel.count else { return }
        let taskViewModel = self.viewModel.taskViewModel[indexPath.item]
        self.delegate?.userDidTapOnTask(task: taskViewModel)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension TaskListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width - 20, height: 50)
    }
}

// MARK: - TaskListViewModelDelegate

extension TaskListViewController: TaskListViewModelDelegate {
    func userWantDeleteIndexPath(_ indexPath: IndexPath) {
        self.collectionView.deleteItems(at: [indexPath])
    }

    func taskNeedToBeUpdated() {
        self.collectionView.reloadData()
    }

    func displayErrorView() {
        self.handleErrorMessage()
    }
}
