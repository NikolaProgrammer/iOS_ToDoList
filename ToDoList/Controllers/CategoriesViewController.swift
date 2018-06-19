//
//  CategoriesViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 15.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [(name: String, categories: [Category])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCategories()
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.isEditing = !tableView.isEditing
        super.setEditing(tableView.isEditing, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case Constants.addCategorySegueIdentifier:
            guard let destinationNavigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            let destinationController = destinationNavigationController.topViewController as! AddCategoryTableViewController
            destinationController.delegate = self
        case Constants.showCatagoryTasksSegueIdentifier:
            guard let destinationController = segue.destination as? ShowCategoryTasksViewController else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            guard let selectedTask = sender as? CategoryTableViewCell else {
                fatalError("Unexpected sender")
            }
            guard let indexPath = tableView.indexPath(for: selectedTask) else {
                fatalError("Selected task is not displayed on the screen")
            }
            
            destinationController.category = categories[indexPath.section].categories[indexPath.row]
        default:
            fatalError("Unknown segue \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Private Methods
    private func updateCategories() {
        categories = Service.shared.getCategories()
    }
}

extension CategoriesViewController: AddCategoryTableViewControllerDelegate {
    func addCategoryTableViewControllerDidSaveButton(_ view: AddCategoryTableViewController, category: Category) {
        Service.shared.addCategory(category: category)
        updateCategories()
        tableView.reloadData()
        
        view.dismiss(animated: true, completion: nil)
    }
    
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Service.shared.removeCategory(category: categories[indexPath.section].categories[indexPath.row])
            updateCategories()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryTableViewCellIdentifier) as? CategoryTableViewCell else {
            fatalError("Cell is not a instance of a CategoryTableViewCell")
        }
        
        let category = categories[indexPath.section].categories[indexPath.row]
        
        cell.categoryNameLabel.text = category.name
        cell.tasksCountLabel.text = "(\(category.includedTasks.count))"
        
        return cell
    }
    
    
}
