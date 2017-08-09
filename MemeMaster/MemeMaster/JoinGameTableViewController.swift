//
//  JoinGameTableViewController.swift
//  MemeMaster
//
//  Created by ALIA M NEELY on 7/27/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit
import CloudKit

class JoinGameTableViewController: UITableViewController, joinGameDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalGameController.shared.loadAllGames()
    }
    
    //Delegate Function
    func joinGame(gameRecord: CKRecord) {
        guard let name = LocalGameController.shared.localPlayerName else {return}
        LocalGameController.shared.addPlayerToGame(playerName: name, gameRecord: gameRecord)
        let game = Game(CKRecord: gameRecord)
        LocalGameController.shared.game = game
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //FIX
        return "GameName"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalGameController.shared.pendingGames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "joinGameCell", for: indexPath) as? PlayerTableViewCell else {return UITableViewCell()}
        let game = LocalGameController.shared.pendingGames[indexPath.row]
        cell.delegate = self
        //THIS IS Desplaying the name of the game you want to join
        
        cell.playerNameLabel.text = game.name
        cell.gameRecord = game.cloudKidRecord
        return cell
    }

    

}
