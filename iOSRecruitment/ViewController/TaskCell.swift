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
    
    static let cellReuseIdentifer = String(describing: self)
    
    let label: UILabel = {
        let dest = UILabel(frame: .zero)
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    let isDoneSwitch: UISwitch = {
        let dest = UISwitch()
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

    func setupLayout() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10))
        constraints.append(self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))
        
        constraints.append(self.isDoneSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10))
        constraints.append(self.isDoneSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupView() {
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.isDoneSwitch)
        self.backgroundColor = UIColor.blue
    }
    
    @objc func userDidTouchSwitch() {
        self.taskViewModel?.userDidTouchIsDoneSwitch(newValue: self.isDoneSwitch.isOn)
    }
    
    func setupSwitch() {
        self.isDoneSwitch.addTarget(self, action: #selector(userDidTouchSwitch), for: .valueChanged)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupLayout()
        self.setupSwitch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
