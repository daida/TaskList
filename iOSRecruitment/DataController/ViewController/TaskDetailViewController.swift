//
//  TaskDetailViewController.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TaskDetailViewControllerDetailDelegate

protocol TaskDetailViewControllerDetailDelegate: class {
    func userDidDeleteTask()
}

// MARK: - TaskDetailViewController

class TaskDetailViewController: UIViewController {
    
    // MARK: - Style
    
    private struct Style {
        static let backgroundColor = UIColor.white
        static let textViewBackgroundColor = UIColor.lightGray
        static let textViewTextColor = UIColor.black
        static let titleTextColor = UIColor.white
        static let deleteTextColor = UIColor.red
        static let deleteButtonTextFont = UIFont.boldSystemFont(ofSize: 18)
        static let textViewFont = UIFont.systemFont(ofSize: 15)
        static let textViewCornerRadius: CGFloat = 7.0
        static let deleteButtonBackgroundColor = UIColor.lightGray
        static let deleteButtonCornerRadius: CGFloat = 7.0
    }
    
    // MARK: Public properties
    
    weak var delegate: TaskDetailViewControllerDetailDelegate? = nil
    
    // MARK: Private properties
    
    private let taskViewModel: TaskViewModelInterface
    
    // MARK: UIView
    
    private let titleLabel: UILabel = {
        let dest = UILabel()
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    private let textView: UITextView = {
        let dest = UITextView()
        dest.textAlignment = .left
        dest.isEditable = false
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    private let doneLabel: UILabel = {
        let dest = UILabel()
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    private let isDoneSwitch: UISwitch = {
        let dest = UISwitch(frame: .zero)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    private let deleteButton: UIButton = {
        let dest = UIButton(type: .custom)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    // MARK: Init
    
    init(taskViewModel: TaskViewModelInterface) {
        self.taskViewModel = taskViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupModel() {
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
    
    private func setupLayout() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10))
        constraints.append(self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(self.titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 10))
        constraints.append(self.titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -10))
        
        constraints.append(self.textView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10))
        constraints.append(self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10))
        constraints.append(self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10))
        
        
        constraints.append(self.doneLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10))
        constraints.append(self.doneLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10))
        constraints.append(self.doneLabel.centerYAnchor.constraint(equalTo: self.isDoneSwitch.centerYAnchor))
        
        constraints.append(self.isDoneSwitch.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 10))
        
        constraints.append(self.isDoneSwitch.leadingAnchor.constraint(equalTo: self.doneLabel.trailingAnchor, constant: 10))

        
        constraints.append(self.deleteButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10))
        
        constraints.append(self.deleteButton.widthAnchor.constraint(equalToConstant: 90))
        
        constraints.append(self.deleteButton.centerYAnchor.constraint(equalTo: self.isDoneSwitch.centerYAnchor))
        constraints.append(self.deleteButton.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10))
        
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupSwitch() {
        self.isDoneSwitch.addTarget(self, action: #selector(handleUserDidTouchSwitch), for: .valueChanged)
    }
    
    private func setupDeleteButton() {
        self.deleteButton.setTitle("DELETE", for: .normal)
        self.deleteButton.addTarget(self, action: #selector(handleUserDidTouchDeleteButton), for: .touchUpInside)
    }
    
    private func setupStyle() {
        self.view.backgroundColor = Style.backgroundColor
        self.textView.backgroundColor = Style.textViewBackgroundColor
        self.deleteButton.setTitleColor(Style.deleteTextColor, for: .normal)
        self.deleteButton.titleLabel?.font = Style.deleteButtonTextFont
        self.textView.textColor = Style.textViewTextColor
        self.textView.font = Style.textViewFont
        self.textView.layer.cornerRadius = Style.textViewCornerRadius
        self.deleteButton.backgroundColor = Style.deleteButtonBackgroundColor
        self.deleteButton.layer.cornerRadius = Style.deleteButtonCornerRadius
    }
    
    private func setupView() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.isDoneSwitch)
        self.view.addSubview(self.textView)
        self.view.addSubview(self.deleteButton)
        self.view.addSubview(self.doneLabel)
        self.title = "Task Detail"
        self.doneLabel.text = "Done"
    }
    
    // MARK: User action
    
   @objc private func handleUserDidTouchSwitch() {
        self.taskViewModel.userDidTouchIsDoneSwitch(newValue: self.isDoneSwitch.isOn)
    }
    
    @objc private func handleUserDidTouchDeleteButton() {
        self.taskViewModel.userDidPressDeleteButton()
    }

    // MARK: UIViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupModel()
        self.setupLayout()
        self.setupSwitch()
        self.setupDeleteButton()
        self.setupStyle()
    }    
}
