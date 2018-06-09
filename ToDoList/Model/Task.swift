
import UIKit

struct Task: Equatable {
    
    //MARK: Properties
    var name: String 
    var notes: String
    var isReminded: Bool
    var isFinished: Bool
    var date: Date
    var priority: Priority
    var category: Category

}
