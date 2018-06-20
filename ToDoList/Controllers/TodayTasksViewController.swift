//
//  ViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 10.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class TodayTasksViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var todayTasks: [(String, [Task])] = []
    
    //MARK: Initializators
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: Constants.todaySectionImageName), tag: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTodayTasks()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        updateTodayTasks()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.isEditing = !tableView.isEditing
        super.setEditing(tableView.isEditing, animated: true)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        var destinationController: AddOrEditViewController
        
        switch segue.identifier {
        case Constants.addTaskSegueIdentifier:
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination")
            }
            destinationController = navigationController.topViewController as! AddOrEditViewController
        case Constants.showTaskDetailsIdentifier:
            guard let destination = segue.destination as? AddOrEditViewController else {
                fatalError("Unexpected destination")
            }
            destinationController = destination
            guard let selectedTask = sender as? TaskCell else {
                fatalError("Unexpected sender \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedTask) else {
                fatalError("Selected task is not displayed on the screen")
            }
            destinationController.task = todayTasks[indexPath.section].1[indexPath.row]
        default:
            fatalError("Unknown identifier \(String(describing: segue.identifier))")
        }
        
        destinationController.delegate = self
    }
    
    //MARK: Actions
    
    @IBAction func showAboutUsInformation(_ sender: UIBarButtonItem) {
       let controller = AboutUsViewController()
       show(controller, sender: self)
    }
    
    //MARK: Private Methods
    private func updateTodayTasks() {
        todayTasks = Service.shared.getTodayTasks()
    }
    
}

//MARK: - UITableViewDataSource
extension TodayTasksViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { (rowAction, indexPath) in
            Service.shared.finishTask(task: self.todayTasks[indexPath.section].1[indexPath.row])
            self.updateTodayTasks()
            tableView.reloadData()
        }
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            Service.shared.removeTask(task: self.todayTasks[indexPath.section].1[indexPath.row])
            self.updateTodayTasks()
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
        return todayTasks[section].1.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todayTasks[section].0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskTableViewCellIdentifier) as? TaskCell else {
            fatalError("Cell is not a instance of a TaskTableViewCell")
        }
        let task = todayTasks[indexPath.section].1[indexPath.row]

        cell.titleLabel.text = task.name
        cell.noteLabel.text = task.notes
        cell.dateLabel.text = Date.string(from: task.date)

        return cell
    }
    
}

extension TodayTasksViewController: AddOrEditViewControllerDelegate {
    
    func addOrEditViewControllerDidCancelButton(_ view: AddOrEditViewController) {
        view.hideView()
    }
    
    func addOrEditViewControllerDidSaveButton(_ view: AddOrEditViewController, task: Task) {
        if (navigationController?.viewControllers.contains(view))! {
            Service.shared.updateTask(task: view.task!)
        } else {
            Service.shared.addTask(task: view.task!)
        }
 
        view.hideView()
        
        updateTodayTasks()
        tableView.reloadData()
        
    }

}
