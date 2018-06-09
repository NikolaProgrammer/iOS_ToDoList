
import UIKit

protocol ServiceProtocol {
    
    func getTodayTasks() -> [(String, [Task])]
    
    func addTask(task: Task)
    
    func removeTask(task: Task)
    
    func finishTask(task: Task)
    
    func changeTask(oldTask: Task, newTask: Task)
    
}
