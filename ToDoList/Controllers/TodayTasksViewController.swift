//
//  ViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 10.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class TodayTasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var todayTasks: [Task] = []
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
   
    //MARK: Initializators
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "todaySection"), tag: 0)
    }
    
    override func viewDidLoad() {
        todayTasks = Service.shared.tasks.filter({ (task) -> Bool in
            return task.taskCompletionDate <= Date()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayTasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "TaskTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("Cell is not a instance of a TaskTableViewCell")
        }
        
        let task = todayTasks[indexPath.row]
        
        cell.titleLabel.text = task.taskName
        cell.noteLabel.text = task.taskNotes
        cell.dateLabel.text = Date.string(from: task.taskCompletionDate)
        
        
        return cell
    }
    
    //MARK: Actions
    @IBAction func showLicenseAgreement(_ sender: UIButton) {
        let controller = LicenseAgreementLiViewController()
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showAboutUsInformation(_ sender: UIBarButtonItem) {
       let controller = AboutUsViewController()
       navigationController?.show(controller, sender: self)
    }
    
}

