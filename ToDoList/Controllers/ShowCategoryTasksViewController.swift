//
//  ShowCategoryTasksViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 19.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class ShowCategoryTasksViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var sectionTasks: [(section: String, tasks: [Task])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category?.name
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        updateTasks()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.isEditing = !tableView.isEditing
        super.setEditing(tableView.isEditing, animated: true)
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var destinationController: AddOrEditViewController
        
        switch segue.identifier {
        case Constants.addTaskSegueIdentifier:
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination")
            }
            destinationController = navigationController.topViewController as! AddOrEditViewController
            destinationController.category = category
        case Constants.showTaskDetailsIdentifier:
            guard let destination = segue.destination as? AddOrEditViewController else {
                fatalError("Unexpected destination")
            }
            destinationController = destination
            guard let selectedTask = sender as? TaskTableViewCell else {
                fatalError("Unexpected sender \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedTask) else {
                fatalError("Selected task is not displayed on the screen")
            }
            destinationController.task = sectionTasks[indexPath.section].tasks[indexPath.row]
        default:
            fatalError("Unknown identifier \(String(describing: segue.identifier))")
        }
        
        destinationController.delegate = self
    }
    
    //MARK: Private Methods
    
    private func updateTasks() {
        sectionTasks = Service.shared.getTasksByCategory(category: category!)
    }
}

extension ShowCategoryTasksViewController: AddOrEditViewControllerDelegate {
    func addOrEditViewControllerDidSaveButton(_ view: AddOrEditViewController, task: Task) {
        if (navigationController?.viewControllers.contains(view))! {
            Service.shared.updateTask(task: task)
        } else {
            Service.shared.addTask(task: task)
        }
        
        view.hideView()
        
        updateTasks()
        tableView.reloadData()
    }

    func addOrEditViewControllerDidCancelButton(_ view: AddOrEditViewController) {
        view.hideView()
    }

    
}

extension ShowCategoryTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let task = sectionTasks[indexPath.section].tasks[indexPath.row]
        
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { [weak self] (rowAction, indexPath) in
            Service.shared.finishTask(task: task)
            
            self?.updateTasks()
            tableView.reloadData()
        }
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { [weak self] (rowAction, indexPath) in
            Service.shared.removeTask(task: task)
            
            self?.updateTasks()
            tableView.reloadData()
        }
        deleteAction.backgroundColor = .red
        
        var rowActions: [UITableViewRowAction] = []
        rowActions.append(deleteAction)
        if indexPath.section == 0 {
            rowActions.append(doneAction)
        }
        
        return rowActions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTasks[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTasks[section].section
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskTableViewCellIdentifier) as? TaskTableViewCell else {
            fatalError("Cell is not a instance of a TaskTableViewCell")
        }
        
        let task = sectionTasks[indexPath.section].tasks[indexPath.row]
        
        cell.titleLabel.text = task.name
        cell.dateLabel.text = Date.string(from: (task.date))
        cell.noteLabel.text = task.notes
        
        return cell
    }
}
