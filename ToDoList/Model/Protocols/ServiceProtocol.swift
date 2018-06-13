
import UIKit

protocol ServiceProtocol {
    
    // CRUD, restful
    func getTodayTasks() -> [(String, [Task])]
    func addTask(task: Task)
    func removeTask(task: Task)
    func updateTask(task: Task)
    
    func finishTask(task: Task)
    
}
