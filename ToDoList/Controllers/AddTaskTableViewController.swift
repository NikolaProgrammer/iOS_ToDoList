//
//  AddTaskTableViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 24.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class AddTaskTableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var priorityTableViewCell: UITableViewCell!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        nameTextField.delegate = self
        configureGestures()
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(chancgeKeyboardState))
        toolBar.items = [flexibleSpace, doneButton]
        
        notesTextView.inputAccessoryView = toolBar
        
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ChooseDate" {
            guard let dateSelectorController = segue.destination as? DateSelectorViewController else {
                fatalError("Unexpected destination")
            }
            
            dateSelectorController.shownDate = dateLabel.text
        } else {
            
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                fatalError("The save button was not presented, cancelling")
            }
            
            let name = nameTextField.text ?? ""
            let isReminded = reminderSwitch.isOn
            let date = Date.date(from: dateLabel.text!, format: Constants.fullDatePattern)
            let priority = Priority(rawValue: priorityLabel.text!)!
            let notes = notesTextView.text ?? ""
            
            task = Task(name: name, notes: notes, isReminded: isReminded, date: date, priority: priority, category: Service.categories[0])
        }

    }
    
    
    //MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerDidReturn(sender: UIStoryboardSegue) {
        if let source = sender.source as? DateSelectorViewController {
            dateLabel.text = source.label.text
            updateSaveButtonState()
        }
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        let date = dateLabel.text ?? ""
        print(date)
        saveButton.isEnabled = !text.isEmpty && date != "Date"
    }
    
    private func configureGestures() {
        let actionSheetGesture = UITapGestureRecognizer(target: self, action: #selector(showPriorityActionSheet))
        priorityTableViewCell.addGestureRecognizer(actionSheetGesture)
    }
    
    @objc private func chancgeKeyboardState() {
        if notesTextView.isFirstResponder {
            notesTextView.resignFirstResponder()
        }
    }

    @objc private func showPriorityActionSheet() {
        let actionSheet = UIAlertController(title: "Select priority", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let none = UIAlertAction(title: "None", style: .default) { action in
            self.priorityLabel.text = "None"
        }
        let low = UIAlertAction(title: "Low", style: .default) { action in
            self.priorityLabel.text = "Low"
        }
        let medium = UIAlertAction(title: "Medium", style: .default) { action in
            self.priorityLabel.text = "Medium"
        }
        let high = UIAlertAction(title: "High", style: .default) { action in
            self.priorityLabel.text = "High"
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(none)
        actionSheet.addAction(low)
        actionSheet.addAction(medium)
        actionSheet.addAction(high)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}

extension AddTaskTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateSaveButtonState()
        textField.resignFirstResponder()
        return true
    }
}














