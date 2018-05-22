
import UIKit

class Service: ServiceProtocol {
  
    //MARK: Properties
    static let shared = Service()
    
    var tasks: [Task]!
    private static var categories: [Category] = [
        Category(categoryId: 0, categoryName: "Inbox"),
        Category(categoryId: 1, categoryName: "Work"),
        Category(categoryId: 2, categoryName: "My")
    ]
    
    //MARK: Private Initializators
    private init() {
        tasks = loadDefaultTasks()
    }
    
    //MARK: ServiceProtocol Methods
    func addTask(task: Task) {
        tasks.append(task)
        
        guard let index = Service.categories.index(of: task.category) else {
            fatalError("No such category")
        }
            
        Service.categories[index].includedTasks.append(task)
    }
    
    func removeTask(task: Task) {}
    
    func finishTask(task: Task) {}
    
    //MARK: Private Methods
    private func loadDefaultTasks() -> [Task] {
        
        let firstTask = Task(taskName: "My first task", taskNotes: "My first note", taskCompletionDate: Date.date(from: "15.04.2018"), category: Service.categories[0])
        let secondTask = Task(taskName: "My second task", taskNotes: "My second note", taskCompletionDate: Date.date(from: "17.05.2018"), category: Service.categories[1])
        let thirdTask = Task(taskName: "My third task", taskNotes: "My third note", taskCompletionDate: Date.date(from: "15.06.2018"), category: Service.categories[2])
        let finishedTask = Task(taskName: "My finished task", taskNotes: "My note", taskCompletionDate: Date.date(from: "12.05.2018"), category: Service.categories[0])
        
        Service.categories[0].includedTasks += [firstTask, finishedTask]
        Service.categories[1].includedTasks += [secondTask]
        Service.categories[2].includedTasks += [thirdTask]
        
        return [firstTask, secondTask, thirdTask, finishedTask]
    }
    
}

/**
 extension Date - formatter, time, date, equal
 create folders structure
 models - relations
 service - protocol common
 nspredicate
 */
