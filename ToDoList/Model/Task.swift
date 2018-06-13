
import UIKit

struct Task: Equatable {
    
    //MARK: Properties
    var id = arc4random()
    var name: String 
    var notes: String
    var isReminded: Bool
    var isFinished: Bool
    var date: Date
    var priority: Priority
    var category: Category
    
    
    //MARK: Initializators
    init(name: String, notes: String, isReminded: Bool, isFinished: Bool, date: Date, priority: Priority, category: Category) {
        self.name = name
        self.notes = notes
        self.isReminded = isReminded
        self.isFinished = isFinished
        self.date = date
        self.priority = priority
        self.category = category
    }
}
