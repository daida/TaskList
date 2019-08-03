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
    
    func configure(model: TaskViewModel) {
        self.label.text = model.title
    }

    func setupLayout() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor))
        constraints.append(self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))
    
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupView() {
        self.contentView.addSubview(self.label)
        self.backgroundColor = UIColor.blue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
