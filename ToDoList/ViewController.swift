//
//  ViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 10.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Actions
    @IBAction func showLicenseAgreement(_ sender: UIButton) {
        let controller = LicenseAgreementLiViewController()
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showAboutUsInformation(_ sender: UIBarButtonItem) {
       let controller = AboutUsViewController()
       navigationController?.show(controller, sender: self)
    }
    
}

