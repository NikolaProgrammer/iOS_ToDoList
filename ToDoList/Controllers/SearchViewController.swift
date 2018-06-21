//
//  SearchViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 13.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var filteredTasks: [Task] = []
    
    //MARK: Initializators
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search task..."
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["Active tasks", "Completed"]
        
        searchController.searchBar.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let destinationController = segue.destination as? ShowTaskDetailTableViewController else {
            fatalError("Unexpected destination \(String(describing: segue.identifier))")
        }
        
        guard let selectedTask = sender as? TaskCell else {
            fatalError("Unexpected sender \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedTask) else {
            fatalError("Selected task is not displayed on the screen")
        }
        
        let task: Task = !isFiltering() ? Service.shared.tasks[indexPath.row] : filteredTasks[indexPath.row]

        destinationController.task = task
    }
    
    //MARK: Private Methods
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        let doesScopeBarScopeFilter = searchController.searchBar.selectedScopeButtonIndex >= 0
        return searchController.isActive && (searchBarIsEmpty() || doesScopeBarScopeFilter)
    }
    
    private func filterContentForSearchText(_ searchingText: String, scope: String) {
        filteredTasks = Service.shared.tasks.filter({ (task) -> Bool in
            let isCompletedTask = (scope == "Completed")
            let doesScopeMatch = (task.isFinished == isCompletedTask)
            
            guard searchBarIsEmpty() else {
                return doesScopeMatch && task.name.lowercased().contains(searchingText.lowercased())
            }
            return doesScopeMatch
        })
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, scope: scope)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskTableViewCellIdentifier) as? TaskCell else {
            fatalError("Cell is not a instance of a TaskTableViewCell")
        }
        
        let task: Task = !isFiltering() ? Service.shared.tasks[indexPath.row] : filteredTasks[indexPath.row]
        
        cell.titleLabel.text = task.name
        cell.noteLabel.text = task.notes
        cell.dateLabel.text = Date.string(from: task.date)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isFiltering() {
            return Service.shared.tasks.count
        }
        return filteredTasks.count
    }
}
