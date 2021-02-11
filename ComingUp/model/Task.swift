//
//  Task.swift
//  AdvancedToDoApp
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

struct Task {
    enum Status {
        case inProgress
        case completed
    }
    
    // UUID().uuidString을 이용해주세요
    let id: String
    let createdAt: Date
    var description: String
    var dueDate: Date
    var isFavorite: Bool
    var additionalImages: [UIImage]
    var note: String
    var status: Status
}
