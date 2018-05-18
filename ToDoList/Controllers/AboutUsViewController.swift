//
//  AboutUsViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 10.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

@IBDesignable class AboutUsViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var logoView: UIView!
    
    //MARK: Initializators
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "AboutUsViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "AboutUsViewController", bundle: nil)
    }
    
}
