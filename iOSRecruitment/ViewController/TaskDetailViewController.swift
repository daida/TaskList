//
//  TaskDetailViewController.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import UIKit

protocol TaskDetailViewControllerDetailDelegate: class {
    func userDidDeleteTask()
}

class TaskDetailViewController: UIViewController {
    
    let taskViewModel: TaskViewModel
    
    weak var delegate: TaskDetailViewControllerDetailDelegate? = nil
    
    let titleLabel: UILabel = {
        let dest = UILabel()
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    let textView: UITextView = {
        let dest = UITextView()
        dest.isEditable = false
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    let isDoneSwitch: UISwitch = {
        let dest = UISwitch(frame: .zero)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    let deleteButton: UIButton = {
        let dest = UIButton(type: .custom)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    init(taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupModel() {
        self.isDoneSwitch.isOn = self.taskViewModel.done.value
        self.titleLabel.text = self.taskViewModel.title
        self.textView.text = self.taskViewModel.text
        
        self.taskViewModel.shouldBePresented.bind { [weak self] _, newValue in
            guard let `self` = self else { return }
            if newValue == false {
                self.delegate?.userDidDeleteTask()
            }
            
        }
    }
    
    func setupLayout() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10))
        constraints.append(self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(self.titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 10))
        constraints.append(self.titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -10))
        
        constraints.append(self.textView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10))
        constraints.append(self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10))
        constraints.append(self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10))
        
        constraints.append(self.isDoneSwitch.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 10))
        constraints.append(self.isDoneSwitch.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10))
        constraints.append(self.isDoneSwitch.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10))
        
        constraints.append(self.deleteButton.leadingAnchor.constraint(equalTo: self.isDoneSwitch.trailingAnchor, constant: 10))
        
        constraints.append(self.deleteButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupView() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.isDoneSwitch)
        self.view.addSubview(self.textView)
        self.view.addSubview(self.deleteButton)
        
        self.view.backgroundColor = UIColor.white
        self.titleLabel.backgroundColor = UIColor.orange
        self.textView.backgroundColor = UIColor.green
        self.isDoneSwitch.backgroundColor = UIColor.purple
        self.deleteButton.backgroundColor = UIColor.green
        
        self.deleteButton.setTitle("DELETE", for: UIControl.State.normal)
        
        self.title = "Task Detail"
    }
    
   @objc private func handleUserDidTouchSwitch() {
        self.taskViewModel.userDidTouchIsDoneSwitch(newValue: self.isDoneSwitch.isOn)
    }
    
    @objc private func handleUserDidTouchDeleteButton() {
        self.taskViewModel.userDidPressDeleteButton()
    }
    
    private func setupSwitch() {
        self.isDoneSwitch.addTarget(self, action: #selector(handleUserDidTouchSwitch), for: .valueChanged)
    }
    
    private func setupDeleteButton() {
        self.deleteButton.addTarget(self, action: #selector(handleUserDidTouchDeleteButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupModel()
        self.setupLayout()
        self.setupSwitch()
        self.setupDeleteButton()
    }
}
