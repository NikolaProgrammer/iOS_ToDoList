//
//  AddCategoryTableViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 15.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

protocol AddCategoryTableViewControllerDelegate: class {
    func addCategoryTableViewControllerDidSaveButton(_ view: AddCategoryTableViewController, category: Category)
}

class AddCategoryTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!

    weak var delegate: AddCategoryTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButtonState()
    }
    
    
    //MARK: Actions
    @IBAction func canelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let category = Category(categoryName: nameTextField.text!)
        
        delegate?.addCategoryTableViewControllerDidSaveButton(self, category: category)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        navigationItem.rightBarButtonItem!.isEnabled = !text.isEmpty
    }
}

extension AddCategoryTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        updateSaveButtonState()
        return true
    }
    
}
