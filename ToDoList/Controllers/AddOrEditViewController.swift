//
//  AddTaskTableViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 24.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

protocol AddOrEditViewControllerDelegate: class {
    func addOrEditViewControllerDidSaveButton(_ view: AddOrEditViewController, task: Task)
    
    func addOrEditViewControllerDidCancelButton(_ view: AddOrEditViewController)
}

class AddOrEditViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var priorityLabel: UILabel!

    var task: Task?
    var category: Category?
    
    weak var delegate: AddOrEditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = task?.name
        reminderSwitch.isOn = task?.isReminded ?? false
        dateLabel.text = Date.string(from: (task?.date ?? Date()), format: Constants.fullDatePattern)
        priorityLabel.text = task?.priority.rawValue ?? "None"
        notesTextView.text = task?.notes
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closeTextViewKeyboard))
        toolBar.items = [flexibleSpace, doneButton]
        notesTextView.inputAccessoryView = toolBar
    
        title = "Add Item"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))

        self.tableView.tableFooterView = UIView()
        
        updateSaveButtonState()
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.chooseDateSegueIdentifier {
            guard let dateSelectorController = segue.destination as? DateSelectorViewController else {
                fatalError("Unexpected destination")
            }
            
            dateSelectorController.selectedDateString = dateLabel.text
        }

    }
    
    
    //MARK: Actions
    @IBAction func datePickerDidReturn(sender: UIStoryboardSegue) {
        if let source = sender.source as? DateSelectorViewController {
            dateLabel.text = source.label.text
        }
    }
    @IBAction func showPriorityActionList(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "Select priority", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        for priority in Priority.values {
            let action = UIAlertAction(title: priority, style: .default) { action in
                self.priorityLabel.text = priority
            }
            actionSheet.addAction(action)
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    @objc private func saveButtonTapped() {
        let name = nameTextField.text!
        let isReminded = reminderSwitch.isOn
        let date = Date.date(from: dateLabel.text!, format: Constants.fullDatePattern)
        let priority = Priority(rawValue: priorityLabel.text!)!
        let notes = notesTextView.text ?? ""
        let isFinished = task?.isFinished ?? false
        
        if task != nil {
            task?.name = name
            task?.isReminded = isReminded
            task?.date = Date.date(from: dateLabel.text!, format: Constants.fullDatePattern)
            task?.priority = priority
            task?.notes = notes
            task?.isFinished = isFinished
        } else {
            let category = self.category ?? service.categories[0]
            task = Task(name: name, notes: notes, isReminded: isReminded, isFinished: isFinished, date: date, priority: priority, category: category)
        }

        delegate?.addOrEditViewControllerDidSaveButton(self, task: task!)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.addOrEditViewControllerDidCancelButton(self)
    }
    
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        navigationItem.rightBarButtonItem!.isEnabled = !text.isEmpty 
    }
    
    @objc private func closeTextViewKeyboard() {
        notesTextView.resignFirstResponder()
    }
    
}

extension AddOrEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateSaveButtonState()
        textField.resignFirstResponder()
        return true
    }
}
