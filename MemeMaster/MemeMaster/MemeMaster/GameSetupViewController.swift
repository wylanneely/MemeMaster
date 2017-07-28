//
//  GameSetupViewController.swift
//  MemeMaster
//
//  Created by ALIA M NEELY on 7/27/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

class GameSetupViewController: UIViewController {

    @IBOutlet weak var numberOfPlayersTextField: UITextField!
    @IBOutlet weak var gameNameTextField: UITextField!
    
    @IBAction func startButtonTapped(_ sender: Any) {
        guard let name = gameNameTextField.text,
            let numberOfPlayes = Int(numberOfPlayersTextField.text!) else {return}
        
        LocalGameController.shared.createGame(name: name, numberOfPlayers: numberOfPlayes)
        
    }
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
