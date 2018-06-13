

import UIKit

struct Category {
    
    //MARK: Properties
    var categoryId: Int
    var categoryName: String
    var includedTasks: [Task] = []
    
    //MARK: Initializators
    init(categoryId: Int, categoryName: String) {
        self.categoryId = categoryId
        self.categoryName = categoryName
    }
}

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.categoryId == rhs.categoryId &&
               lhs.categoryName == rhs.categoryName
    }
}
