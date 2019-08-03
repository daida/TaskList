//
//  Task.swift
//  iOSRecruitment
//
//  Created by Nicolas Bellon on 03/08/2019.
//  Copyright © 2019 cheerz. All rights reserved.
//

import Foundation

struct Task {
    let identifier: String = UUID().uuidString
    
    var title: String
    var done = false
    var text =
    """
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ultricies blandit velit, eu viverra mi feugiat non. Cras et venenatis eros, et facilisis nunc. Curabitur ac ornare tellus. Nullam posuere enim et nisi aliquet lobortis. Ut id tincidunt ipsum. Ut at libero in ligula fringilla luctus vel sit amet nunc. Proin sed ex quam. Etiam a consequat sapien. Nam tristique, nibh vitae sagittis sagittis, risus nulla consequat purus, eu molestie metus diam tincidunt lectus. Nam massa urna, porta sit amet lorem sit amet, pellentesque consectetur mi. Sed malesuada, mauris vel volutpat laoreet, urna nisl dictum nisl, eu auctor lectus sapien vitae leo. Quisque ultrices vestibulum nisl egestas bibendum.
 """

    
    init(_ title: String) {
        self.title = title
    }
}
