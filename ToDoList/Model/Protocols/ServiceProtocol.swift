
import UIKit

protocol ServiceProtocol {
    
    func getTodayTasks() -> [(String, [Task])]
    func getTasksByCategory(category: Category) -> [(String, [Task])]
    func addTask(task: Task)
    func removeTask(task: Task)
    func updateTask(task: Task)
    
    func finishTask(task: Task)
    
    func addCategory(category: Category)
    func removeCategory(category: Category)
    func getCategories() -> [(String, [Category])]
    func updateCategory(category: Category) -> Category
}
