//
//  InboxViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 20.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionSegmentControl: UISegmentedControl!
    
    var tasks: [(sectionName: String, tasks: [Task])] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTasksSection()
        tableView.reloadData()
    }

    //MARK: Actions
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        updateTasksSection()
    }
    
    //MARK: Private Methods
    private func updateTasksSection() {
        switch sectionSegmentControl.selectedSegmentIndex {
        case 0:
            tasks = InboxHelper.getTasks(by: \Task.date.string)
            tableView.reloadData()
        case 1:
            tasks = InboxHelper.getTasks(by: \Task.category.name)
            tableView.reloadData()
        default:
            fatalError("Unknown segment index \(sectionSegmentControl.selectedSegmentIndex)")
        }
    }
}


extension InboxViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Service.shared.removeTask(task: tasks[indexPath.section].tasks[indexPath.row])
            tableView.reloadData()
            updateTasksSection()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tasks[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskTableViewCellIdentifier) as? TaskCell else {
            fatalError("Cell is not a instance of a TaskTableViewCell")
        }
        
        let task = tasks[indexPath.section].tasks[indexPath.row]
        cell.titleLabel.text = task.name
        cell.noteLabel.text = task.notes
        cell.dateLabel.text = Date.string(from: task.date)
        
        return cell
    }

}
