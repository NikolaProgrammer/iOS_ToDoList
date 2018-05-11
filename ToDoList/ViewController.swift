//
//  ViewController.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 10.05.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func showLicenseAgreement(_ sender: UIButton) {
        let controller = LicenseAgreementLiViewController(nibName: "LicenseAgreementLiViewController", bundle: nil)
        present(controller, animated: true, completion: nil)
    }
    @IBAction func showAboutUsInformation(_ sender: UIBarButtonItem) {
        let controller = AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

