
import UIKit

class Service: ServiceProtocol {

    //MARK: Properties
    static let shared = Service()
    
    var tasks: [Task] = []
    var categories: [Category] = [
        Category(categoryId: 0, categoryName: "Inbox", includedTasks: []),
        Category(categoryId: 1, categoryName: "Work", includedTasks: []),
        Category(categoryId: 2, categoryName: "My", includedTasks: [])
    ]
    
    //MARK: Private Initializators
    private init() {

        tasks = loadDefaultTasks()
    }
    
    //MARK: ServiceProtocol Methods
    
//    func updateCategory(category: Category) -> Category {
//        return categories[findCategory(category: category)]
//    }
    
    func addCategory(category: Category) {
        categories.append(category)
    }
    
    func removeCategory(category: Category) {
        for (index, task) in tasks.enumerated() {
            if category.includedTasks.contains(task) {
                tasks.remove(at: index)
            }
        }
        
        categories.remove(at: findCategory(category: category))
    }
    
    func getCategories() -> [(String, [Category])] {
        var items: [(String, [Category])] = []
        items.append(("Inbox", [categories[0]]))
        
        if categories.count > 1 {
            var otherCategories: [Category] = []
            for category in categories[1...] {
                otherCategories.append(category)
            }
            items.append(("Other", otherCategories))
        }
        
        return items
    }
    
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
    
    func getTasksByCategory(category: Category) -> [(String, [Task])] {
        let categoryIndex = findCategory(category: category)
        let tasks = categories[categoryIndex].includedTasks
        
        let todayCompletedTasks = tasks.filter { (task) -> Bool in
            return task.isFinished
        }
        
        let todayIncopmletedTasks = tasks.filter { (task) -> Bool in
            return !task.isFinished
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
      
        categories[findCategory(category: task.category)].includedTasks.append(task)
    }
    
    func updateTask(task: Task) {
        guard var taskIndex = tasks.index(where: { (currentTask) -> Bool in
            return task.id == currentTask.id
        }) else {
            fatalError("No such task")
        }
        
        tasks[taskIndex] = task
        
        let categoryIndex = findCategory(category: task.category)
        taskIndex = categories[categoryIndex].includedTasks.index(where: { (currentTask) -> Bool in
            return task.id == currentTask.id
        })!
        
        categories[categoryIndex].includedTasks[taskIndex] = task
    }
    
    func removeTask(task: Task) {
        var taskIndex = findTask(task: task, in: tasks)
        tasks.remove(at: taskIndex)
        
        let categoryIndex = findCategory(category: task.category)
        taskIndex = findTask(task: task, in: categories[categoryIndex].includedTasks)
        
        categories[categoryIndex].includedTasks.remove(at: taskIndex)
    }
    
    func finishTask(task: Task) {
        tasks[findTask(task: task, in: tasks)].isFinished = true
        
        let categoryIndex = findCategory(category: task.category)
        let taskIndex = findTask(task: task, in: categories[categoryIndex].includedTasks)
        categories[categoryIndex].includedTasks[taskIndex].isFinished = true
    }
    
    //MARK: Private Methods
    private func findCategory(category: Category) -> Int {
        guard let index = categories.index(of: category) else {
            fatalError("No such category")
        }
        
        return index
    }
    private func findTask(task: Task, in array: [Task]) -> Int {
        guard let index = array.index(of: task) else {
            fatalError("No such task in array \(array.description)")
        }
        
        return index
    }
    
    private func loadDefaultTasks() -> [Task] {
        
        let firstTask = Task(name: "My fist task", notes: "My first note", isReminded: true, isFinished: false, date: Date.date(from: "15.05.2018"), priority: .none, category: categories[0])
        let secondTask = Task(name: "My second task", notes: "My second note", isReminded: true, isFinished: false, date: Date.date(from: "15.04.2018"), priority: .none, category: categories[1])
        let thirdTask = Task(name: "My third task", notes: "My third note", isReminded: true, isFinished: false, date: Date.date(from: "15.06.2018"), priority: .none, category: categories[2])
        let finishedTask = Task(name: "My finished task", notes: "My note", isReminded: true, isFinished: true, date: Date.date(from: "15.01.2018"), priority: .none, category: categories[0])
        
        categories[0].includedTasks += [firstTask, finishedTask]
        categories[1].includedTasks += [secondTask]
        categories[2].includedTasks += [thirdTask]
        
        return [firstTask, secondTask, thirdTask, finishedTask]
    }
    
}

