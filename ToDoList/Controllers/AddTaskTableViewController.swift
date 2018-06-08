//
//  AddTaskTableViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 24.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

protocol AddTaskViewControllerDelegate: class {
    func addTaskViewControllerDidSaveButton(_ view: AddTaskTableViewController)
}

class AddTaskTableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var priorityLabel: UILabel!

    var task: Task?
    var saveButton: UIBarButtonItem!
    
    weak var delegate: AddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = Date.string(from: Date(), format: Constants.fullDatePattern)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closeTextViewKeyboard))
        toolBar.items = [flexibleSpace, doneButton]
        notesTextView.inputAccessoryView = toolBar
    
        title = "Add Item"
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
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
        let name = nameTextField.text ?? ""
        let isReminded = reminderSwitch.isOn
        let date = Date.date(from: dateLabel.text!, format: Constants.fullDatePattern)
        let priority = Priority(rawValue: priorityLabel.text!)!
        let notes = notesTextView.text ?? ""
        
        task = Task(name: name, notes: notes, isReminded: isReminded, date: date, priority: priority, category: Service.categories[0])
        
        delegate?.addTaskViewControllerDidSaveButton(self)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty 
    }
    
    @objc private func closeTextViewKeyboard() {
        if notesTextView.isFirstResponder {
            notesTextView.resignFirstResponder()
        }
    }

    
}

extension AddTaskTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateSaveButtonState()
        textField.resignFirstResponder()
        return true
    }
}
