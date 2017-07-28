//
//  File.swift
//  MemeMaster
//
//  Created by ALIA M NEELY on 7/27/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation
import CloudKit

class LocalGameController {
    
    static var shared = LocalGameController()
    
    //hen join game is clicked This is set to game
    
    var game: Game?
    
    var pendingGames: [Game] = []
    
    
    var memes: [Meme] = [] {
        didSet{
            loadMemes()
        }
    }
    
    func createGame(name: String, numberOfPlayers: Int) {
        let game = Game(gameRecordID: UUID() , name: name, numberOfPlayers: numberOfPlayers)
        self.game = game
        CKContainer.default().publicCloudDatabase.save(game.cloudKidRecord) { (ckRecord, error) in
            if let error = error { NSLog("Error Saving 'game' to CLOUDKIT: \(error.localizedDescription)") }
        }
    }
    
//    func loadGame(gameRecordId: UUID) {
//
//        self.game = Game(CKRecord: gameRecordId)
//    }
    
    func loadAllGames(){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Game.cKRecordTypeKey, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (ckRecords, error) in
            if let error = error { NSLog("Error Fetching from CLOUTKIT: \(error.localizedDescription)")}
            guard let gameRecordIds = ckRecords else {return}
            
            let games = gameRecordIds.flatMap({Game(CKRecord: $0)})

            self.pendingGames = games
        }
        
    }
    
    func loadMemes() {
        guard let memeUUIDs = game?.memeUUIDStrings else {return}
        //load the uuids used to find the game memes
        var memeRecordIds: [CKRecordID] = []
        //turn the [String] into a [CKRecord] for the fetch request
        for memeID in memeUUIDs {
            let recordID = CKRecordID(recordName: memeID)
            memeRecordIds.append(recordID)
        }
        //fix maybe
        let predicate = NSPredicate(format: "recordID IN %@", memeRecordIds)
        let query = CKQuery(recordType: Meme.cKRecordTypeKey, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (ckRecords, error) in
            if let error = error { NSLog("Error Fetching 'memes' from CLOUDKIT: \(error.localizedDescription)")}
            guard let memeRecords = ckRecords else { return }
            let memes = memeRecords.flatMap({Meme(cloudKitRecord: $0)})
            self.memes = memes
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}



