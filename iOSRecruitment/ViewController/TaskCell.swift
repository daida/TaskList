//
//  TaskCell.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TaskCell

/// Display a summary of the task, and allow user to perform isDone and delete actions
class TaskCell: UICollectionViewCell {

    // MARK: - Style
    
    /// Represent the graphical Style of the View (color, corner radius, font, etc..)
    private struct Style {
        static let backgroundColor = UIColor.lightGray
        static let titleColor = UIColor.white
        static let deleteButtonTextColor = UIColor.red
        static let deleteButtonFont = UIFont.boldSystemFont(ofSize: 18)
        static let cellCornerRadius: CGFloat = 12.0
    }
    
    // MARK: Private properties
    
    /// `TaskCell` stay updated by observing some properties.
    /// User actions are sent to the viewModel.
    private var taskViewModel: TaskViewModelInterface?
    
    // MARK: Static public properties
    
    /// Reuse Identifer used for `UICollectionView` dequeuing
    static let cellReuseIdentifer = String(describing: self)

    // MARK: Private properties
    
    // MARK: UIView
    
    /// Display task title
    private let label: UILabel = {
        let dest = UILabel(frame: .zero)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    /// Display if the Task is done or not, it the value of the switch change
    /// the viewModel is notify.
    private let isDoneSwitch: UISwitch = {
        let dest = UISwitch()
        dest.translatesAutoresizingMaskIntoConstraints = false
        dest.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        return dest
    }()
    
    /// Display a button with the text "DELETE" if the user tap on it the viewModel is notify.
    private let deleteButton: UIButton = {
        let dest = UIButton(type: .custom)
        dest.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    // MARK: UICollectionViewCell override

    override func prepareForReuse() {
        self.taskViewModel?.done.clearAllObserver()
        self.taskViewModel = nil
    }
    
    // MARK: Configure method
    
    /// Configure method called from the UICollectionViewDataSource method:
    /// `cellForItemAt`
    ///
    /// - Parameter model: `TaskViewModelInterface` concrete implentation.
    func configure(model: TaskViewModelInterface) {
        self.label.text = model.title
        self.isDoneSwitch.isOn = model.done.value
        self.taskViewModel = model
        model.done.bind { [weak self] _, newValue in
            guard let `self` = self, newValue != self.isDoneSwitch.isOn else { return }
            DispatchQueue.main.async { self.isDoneSwitch.isOn = newValue }
        }
    }
    
    // MARK: Setup the view layout

    private func setupLayout() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10))
        constraints.append(self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))
        
        constraints.append(self.deleteButton.leadingAnchor.constraint(greaterThanOrEqualTo: self.label.trailingAnchor, constant: 10))
        constraints.append(self.deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraints.append(self.deleteButton.trailingAnchor.constraint(equalTo: self.isDoneSwitch.leadingAnchor, constant: -10))
        
        constraints.append(self.isDoneSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10))
        constraints.append(self.isDoneSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Setup the view hierarchy
    private func setupView() {
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.isDoneSwitch)
        self.contentView.addSubview(self.deleteButton)
    }
    
    /// Setup the switch target
    private func setupSwitch() {
        self.isDoneSwitch.addTarget(self, action: #selector(userDidTouchSwitch), for: .valueChanged)
    }
    
    /// Setup the delete button text and target
    private func setupDeleteButton() {
        self.deleteButton.setTitle("DELETE", for: .normal)
        self.deleteButton.addTarget(self, action: #selector(userDidTouchDeleteButton), for: UIControl.Event.touchUpInside)
    }
    
    /// Setup the style according to the Struct Style
    private func setupStyle() {
        self.contentView.backgroundColor = Style.backgroundColor
        self.label.textColor = Style.titleColor
        self.deleteButton.setTitleColor(Style.deleteButtonTextColor, for: .normal)
        self.contentView.clipsToBounds = true
        self.deleteButton.titleLabel?.font = Style.deleteButtonFont
        self.contentView.layer.cornerRadius = Style.cellCornerRadius
    }
    
    // MARK: User actions
    
    /// Handle user action when the user touch the switch
    @objc func userDidTouchSwitch() {
        self.taskViewModel?.userDidTouchIsDoneSwitch(newValue: self.isDoneSwitch.isOn)
    }
    
    /// Handle user action when the user touch the delete button
    @objc func userDidTouchDeleteButton() {
        self.taskViewModel?.userDidPressDeleteButton()
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupLayout()
        self.setupSwitch()
        self.setupDeleteButton()
        self.setupStyle()
      }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
