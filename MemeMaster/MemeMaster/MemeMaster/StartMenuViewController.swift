//
//  StartMenuViewController.swift
//  MemeMaster
//
//  Created by Bradley GIlmore on 7/24/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

class StartMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBOutlet weak var playerNameTextField: UITextField!
    
    //MARK: - IBOutlets
    
    //MARK: - IBActions
    
    @IBAction func joinGameButtonTapped(_ sender: Any) {
        guard let name = playerNameTextField.text else { return }
        Player.shared.displayName = name
    }
    @IBAction func instructionButtonTapped(_ sender: Any) {
        
        
        
    }
    

}
