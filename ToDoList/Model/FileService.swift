//
//  FileService.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 22.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import Foundation

class FileService: ServiceProtocol {
    
    //MARK: Properties
    static let shared = FileService()
    
    private static let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let taskArchiveURL =  documentDirectory.appendingPathComponent("Tasks")
    private static let categoryArchiveURL =  documentDirectory.appendingPathComponent("Categories")
    
    var tasks: [Task] = []
    var categories: [Category] = []
    
    //MARK: Private Initializators
    private init() {
        loadData()
    }
    
    //MARK: Service Protocol Methods
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
        
        saveData()
    }
    
    func removeTask(task: Task) {
        var taskIndex = findTask(task: task, in: tasks)
        tasks.remove(at: taskIndex)
        
        let categoryIndex = findCategory(category: task.category)
        taskIndex = findTask(task: task, in: categories[categoryIndex].includedTasks)
        
        categories[categoryIndex].includedTasks.remove(at: taskIndex)
        
        saveData()
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
        
        saveData()
    }
    
    func finishTask(task: Task) {
        tasks[findTask(task: task, in: tasks)].isFinished = true
        
        let categoryIndex = findCategory(category: task.category)
        let taskIndex = findTask(task: task, in: categories[categoryIndex].includedTasks)
        categories[categoryIndex].includedTasks[taskIndex].isFinished = true
        
        saveData()
    }
    
    func addCategory(category: Category) {
        categories.append(category)
        
        saveData()
    }
    
    func removeCategory(category: Category) {
        for (index, task) in tasks.enumerated() {
            if category.includedTasks.contains(task) {
                tasks.remove(at: index)
            }
        }
        
        categories.remove(at: findCategory(category: category))
        
        saveData()
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
    
//    func updateCategory(category: Category) -> Category {
//        return categories[findCategory(category: category)]
//    }
    
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
    
    private func loadData() {

        if let loadedTasks = NSKeyedUnarchiver.unarchiveObject(withFile: FileService.taskArchiveURL.path) as? [Task] {
            tasks = loadedTasks
        }
            
        if let loadedCategories = NSKeyedUnarchiver.unarchiveObject(withFile: FileService.categoryArchiveURL.path) as? [Category] {
            categories = loadedCategories
        } else {
            categories.append(Category(categoryId: 0, categoryName: "Inbox", includedTasks: []))
        }
        
    }
    
    private func saveData() {
        let isTasksSaved = NSKeyedArchiver.archiveRootObject(tasks, toFile: FileService.taskArchiveURL.path)
        let isCategoriesSaved = NSKeyedArchiver.archiveRootObject(categories, toFile: FileService.categoryArchiveURL.path)
        
        if !isTasksSaved || !isCategoriesSaved {
            fatalError("Cannot save data")
        }
    }
}
