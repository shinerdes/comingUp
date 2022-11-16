

import UIKit

struct Task {
    enum Status {
        case inProgress
        case completed
    }
    

    let id: String
    let createdAt: Date
    var description: String
    var dueDate: Date
    var isFavorite: Bool
    var additionalImages: [UIImage]
    var note: String
    var status: Status
}
