//
//  TaskListViewController.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import UIKit

protocol TaskListViewControllerDelegate: class {
    func userDidTapOnTask(task: TaskViewModel)
}

class TaskListViewController: UIViewController {
    
    let viewModel: TaskListViewModel
    
    weak var delegate: TaskListViewControllerDelegate?
    
    let titleLabel: UILabel = {
        let dest = UILabel(frame: .zero)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        let dest = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    let spiner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView(style: .gray)
        spiner.translatesAutoresizingMaskIntoConstraints = false
        return spiner
    }()
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.cellReuseIdentifer)
    }
    
    func setupLayout() {
        // Label
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10))
        constraints.append( self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        
        // Collection View
        constraints.append(self.collectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10))
        constraints.append(self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        constraints.append(self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        
        // Spiner
        constraints.append(self.spiner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(self.spiner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupView() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.spiner)
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.clear
        self.titleLabel.text = "TUTU"
        self.titleLabel.backgroundColor = UIColor.purple
    }
    
    private func showSpiner() {
        self.spiner.startAnimating()
        self.spiner.isHidden = false
    }
    
    private func hideSpiner() {
        self.spiner.stopAnimating()
        self.spiner.isHidden = true
    }
    
    private func handleSpinerDisplay(result: Bool) {
        result ? self.showSpiner() : self.hideSpiner()
    }
    
    private func handleTaskReloading(result: Bool) {
        if result == true {
            self.collectionView.reloadData()
        }
    }
    
    func setupViewModel() {
        self.viewModel.shouldDisplaySpiner.bind { [weak self] _, result in
            guard let `self` = self else { return }
            DispatchQueue.main.async { self.handleSpinerDisplay(result: result) }
        }
        
        self.viewModel.shouldReloadTask.bind { [weak self] _, result in
            guard let `self` = self else { return }
            DispatchQueue.main.async { self.handleTaskReloading(result: result) }
        }
        
        self.handleSpinerDisplay(result: self.viewModel.shouldDisplaySpiner.value)
        self.handleTaskReloading(result: self.viewModel.shouldReloadTask.value)
        
        self.viewModel.loadTask()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupLayout()
        self.setupViewModel()
        self.setupCollectionView()
    }

    
    
}

extension TaskListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {        
        return self.viewModel.taskViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.cellReuseIdentifer, for: indexPath)
        guard let castedCell = cell as? TaskCell else { return cell }
   
        guard indexPath.item >= 0, indexPath.item < self.viewModel.taskViewModel.count else { return cell }
        
        let cellModel = self.viewModel.taskViewModel[indexPath.item]
    
        castedCell.configure(model: cellModel)
        return castedCell
    }
    
    
}

extension TaskListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item >= 0, indexPath.item < self.viewModel.taskViewModel.count else { return }
        let taskViewModel = self.viewModel.taskViewModel[indexPath.item]
        self.delegate?.userDidTapOnTask(task: taskViewModel)
    }
    
}

extension TaskListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 35)
    }
}