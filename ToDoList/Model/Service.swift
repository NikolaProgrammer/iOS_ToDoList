
import UIKit

class Service: ServiceProtocol {
    
    //MARK: Properties
    static let shared = Service()
    
    var tasks: [Task]!
    static var categories: [Category] = [
        Category(categoryId: 0, categoryName: "Inbox"),
        Category(categoryId: 1, categoryName: "Work"),
        Category(categoryId: 2, categoryName: "My")
    ]
    
    //MARK: Private Initializators
    private init() {
        tasks = loadDefaultTasks()
    }
    
    //MARK: ServiceProtocol Methods
    
    func getTodayTasks() -> [(String, [Task])] {
        
        let todayCompletedTasks = tasks.filter { (task) -> Bool in
            return task.date <= Date().tomorrow && task.isFinished
        }
        
        let todayIncopmletedTasks = tasks.filter { (task) -> Bool in
            return task.date <= Date().tomorrow && !task.isFinished
        }
  
        var items: [(String, [Task])] = []
        items.append(("", todayIncopmletedTasks))
        if !todayCompletedTasks.isEmpty {
            items.append(("Completed", todayCompletedTasks))
        }
        
        return items
    }
    
    func addTask(task: Task) {
        tasks.append(task)
        
        guard let index = Service.categories.index(of: task.category) else {
            fatalError("No such category")
        }
            
        Service.categories[index].includedTasks.append(task)
    }
    
    func updateTask(task: Task) {
        guard let taskIndex = tasks.index(where: { (currentTask) -> Bool in
            return task.id == currentTask.id
        }) else {
            fatalError("No such task")
        }
        
        tasks[taskIndex] = task
    }
    
    func removeTask(task: Task) {
        tasks.remove(at: findTask(task: task))
    }
    
    func finishTask(task: Task) {
        tasks[findTask(task: task)].isFinished = true
    }
    
    //MARK: Private Methods
    private func findTask(task: Task) -> Int {
        guard let index = tasks.index(of: task) else {
            fatalError("No such task")
        }
        
        return index
    }
    
    private func loadDefaultTasks() -> [Task] {
        
        let firstTask = Task(name: "My fist task", notes: "My first note", isReminded: true, isFinished: false, date: Date.date(from: "15.05.2018"), priority: .none, category: Service.categories[0])
        let secondTask = Task(name: "My second task", notes: "My second note", isReminded: true, isFinished: false, date: Date.date(from: "15.04.2018"), priority: .none, category: Service.categories[1])
        let thirdTask = Task(name: "My third task", notes: "My third note", isReminded: true, isFinished: false, date: Date.date(from: "15.06.2018"), priority: .none, category: Service.categories[2])
        let finishedTask = Task(name: "My finished task", notes: "My note", isReminded: true, isFinished: true, date: Date.date(from: "15.01.2018"), priority: .none, category: Service.categories[0])
        
        Service.categories[0].includedTasks += [firstTask, finishedTask]
        Service.categories[1].includedTasks += [secondTask]
        Service.categories[2].includedTasks += [thirdTask]
        
        return [firstTask, secondTask, thirdTask, finishedTask]
    }
    
}

