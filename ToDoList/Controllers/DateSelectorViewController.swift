//
//  DateSelectorViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 28.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class DateSelectorViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    var shownDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = shownDate
    }
    
    //MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        label.text = Date.string(from: sender.date, format: Constants.fullDatePattern)
    }
    
}
