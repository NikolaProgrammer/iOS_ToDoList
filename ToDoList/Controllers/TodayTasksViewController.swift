//
//  ViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 10.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class TodayTasksViewController: UIViewController {
    
    var todayTasks: [Task] = []
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
   
    //MARK: Initializators
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: Constants.todaySectionImageName), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTodayTasks()
    }
    
    //MARK: Actions
    @IBAction func showLicenseAgreement(_ sender: UIButton) {
        let controller = LicenseAgreementLiViewController()
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func unwindToTodayTaskList(sender: UIStoryboardSegue){
        if let sourceController = sender.source as? AddTaskTableViewController, let task = sourceController.task {
            Service.shared.addTask(task: task)
            updateTodayTasks()
            tableView.reloadData()
        }
    }
    
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
        return todayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskTableViewCellIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("Cell is not a instance of a TaskTableViewCell")
        }
        
        let task = todayTasks[indexPath.row]
        
        cell.titleLabel.text = task.name
        cell.noteLabel.text = task.notes
        cell.dateLabel.text = Date.string(from: task.date)
        
        
        return cell
    }
    
}









