//
//  TaskCell.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation
import UIKit

class TaskCell: UICollectionViewCell {
    
    private struct Style {
        static let backgroundColor = UIColor.lightGray
        static let titleColor = UIColor.white
        static let deleteButtonTextColor = UIColor.red
        static let deleteButtonFont = UIFont.boldSystemFont(ofSize: 18)
        static let cellCornerRadius: CGFloat = 12.0
    }
    
    static let cellReuseIdentifer = String(describing: self)
    
    private let label: UILabel = {
        let dest = UILabel(frame: .zero)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    private let isDoneSwitch: UISwitch = {
        let dest = UISwitch()
        dest.translatesAutoresizingMaskIntoConstraints = false
        dest.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        return dest
    }()
    
    private let deleteButton: UIButton = {
        let dest = UIButton(type: .custom)
        dest.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()
    
    private weak var taskViewModel: TaskViewModel?

    override func prepareForReuse() {
        self.taskViewModel?.done.clearAllObserver()
        self.taskViewModel = nil
    }
    
    func configure(model: TaskViewModel) {
        self.label.text = model.title
        self.isDoneSwitch.isOn = model.done.value
        self.taskViewModel = model
        model.done.bind { [weak self] _, newValue in
            guard let `self` = self, newValue != self.isDoneSwitch.isOn else { return }
            DispatchQueue.main.async { self.isDoneSwitch.isOn = newValue }
        }
    }

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
    
    private func setupView() {
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.isDoneSwitch)
        self.contentView.addSubview(self.deleteButton)
    }
    
    @objc func userDidTouchSwitch() {
        self.taskViewModel?.userDidTouchIsDoneSwitch(newValue: self.isDoneSwitch.isOn)
    }
    
    @objc func userDidTouchDeleteButton() {
        self.taskViewModel?.userDidPressDeleteButton()
    }
    
    private func setupSwitch() {
        self.isDoneSwitch.addTarget(self, action: #selector(userDidTouchSwitch), for: .valueChanged)
    }
    
    private func setupDeleteButton() {
        self.deleteButton.setTitle("DELETE", for: .normal)
        self.deleteButton.addTarget(self, action: #selector(userDidTouchDeleteButton), for: UIControl.Event.touchUpInside)
    }
    
    private func setupStyle() {
        self.contentView.backgroundColor = Style.backgroundColor
        self.label.textColor = Style.titleColor
        self.deleteButton.setTitleColor(Style.deleteButtonTextColor, for: .normal)
        self.contentView.clipsToBounds = true
        self.deleteButton.titleLabel?.font = Style.deleteButtonFont
        self.contentView.layer.cornerRadius = Style.cellCornerRadius
    }
    
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
