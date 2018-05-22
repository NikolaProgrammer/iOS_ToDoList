
import UIKit

protocol ServiceProtocol {
    
    func getTodayTasks() -> [Task]
    
    func addTask(task: Task)
    
    func removeTask(task: Task)
    
    func finishTask(task: Task)
    
}
