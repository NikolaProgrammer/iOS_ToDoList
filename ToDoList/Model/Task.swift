
import UIKit

class Task {
    
    //MARK: Properties
    var taskName: String
    var taskNotes: String
    var taskCompletionDate: Date
    unowned var category: Category
    
    //MARK: Initializators
    init(taskName: String, taskNotes: String, taskCompletionDate: Date, category: Category) {
        self.taskName = taskName
        self.taskNotes = taskNotes
        self.taskCompletionDate = taskCompletionDate
        self.category = category
    }
}
