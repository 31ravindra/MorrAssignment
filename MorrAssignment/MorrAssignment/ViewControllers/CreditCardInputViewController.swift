//
//  CreditCardInputViewController.swift
//  MorrAssignment
//
//  Created by Ravindra Patidar on 30/11/20.
//  Copyright © 2020 Ravindra Patidar. All rights reserved.
//

import UIKit

class CreditCardInputViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        
       
    }
    
    
    func setupNavigationBar() {
        
        self.navigationItem.title = Constants.screenTitle
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    
}
