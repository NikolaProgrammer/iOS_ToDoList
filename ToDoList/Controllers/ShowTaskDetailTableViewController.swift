//
//  ShowDetaltTableViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 14.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class ShowTaskDetailTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var isRemindSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameLabel.text = task?.name
        isRemindSwitch.isOn = task?.isReminded ?? false
        dateLabel.text = Date.string(from: task?.date ?? Date(), format: Constants.fullDatePattern)
        priorityLabel.text = task?.priority.rawValue
        notesTextView.text = task?.notes

    }

}
