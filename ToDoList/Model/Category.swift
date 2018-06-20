

import UIKit

struct Category {
    
    //MARK: Properties
    var id: Int
    var name: String
    var includedTasks: [Task] = []
    
    //MARK: Initializators
    init(categoryId: Int, categoryName: String) {
        self.id = categoryId
        self.name = categoryName
    }
    
    init(categoryName: String) {
        self.init(categoryId: Int(arc4random_uniform(1) + 1000), categoryName: categoryName)
    }
}

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name
    }
}
