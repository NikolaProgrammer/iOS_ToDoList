//
//  UIViewControllerExtension.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 19.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideView() {
        if ((navigationController?.viewControllers.count)! > 1) {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
}
