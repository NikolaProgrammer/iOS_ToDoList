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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTodayTasks()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        var destinationController: TaskTableViewController
        
        switch segue.identifier {
        case Constants.addTaskSegueIdentifier:
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination")
            }
            destinationController = navigationController.topViewController as! TaskTableViewController
        case Constants.showTaskDetailsIdentifier:
            guard let destination = segue.destination as? TaskTableViewController else {
                fatalError("Unexpected destination")
            }
            destinationController = destination
            guard let selectedTask = sender as? TaskTableViewCell else {
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
extension TodayTasksViewController: UITableViewDataSource {
    
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskTableViewCellIdentifier) as? TaskTableViewCell else {
            fatalError("Cell is not a instance of a TaskTableViewCell")
        }
        let task = todayTasks[indexPath.section].1[indexPath.row]

        cell.titleLabel.text = task.name
        cell.noteLabel.text = task.notes
        cell.dateLabel.text = Date.string(from: task.date)

        return cell
    }
    
}

extension TodayTasksViewController: TaskViewControllerDelegate {
    
    func taskViewControllerDidCancelButton(_ view: TaskTableViewController) {
        if (tableView.indexPathForSelectedRow != nil) {
            view.navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func taskViewControllerDidSaveButton(_ view: TaskTableViewController) {
        if (tableView.indexPathForSelectedRow != nil) {
            Service.shared.changeTask(oldTask: view.task!, newTask: view.newTask!)
            
            updateTodayTasks()
            tableView.reloadData()
            
            view.navigationController?.popViewController(animated: true)
        } else {
            Service.shared.addTask(task: view.newTask!)
            
            updateTodayTasks()
            tableView.reloadData()
            
            view.dismiss(animated: true, completion: nil)
        }
 
    }
}
