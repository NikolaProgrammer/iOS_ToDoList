//
//  InboxHelper.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 20.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import Foundation

class InboxHelper {
    
    static func getTasks(by section: KeyPath<Task, String>) -> [(String, [Task])] {
        var items: [(name: String, tasks: [Task])] = []
        
        for task in Service.shared.tasks {
            let sectionName = task[keyPath: section]
            
            let isContainsCheker: ((name: String, tasks: [Task])) -> Bool = { (item) -> Bool in
                return item.name == sectionName
            }
            
            if let index = items.index(where: isContainsCheker) {
                items[index].tasks.append(task)
            } else {
                items.append((sectionName, [task]))
            }
        }
        
        return items
    }
  
}
