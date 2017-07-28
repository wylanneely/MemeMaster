//
//  Game.swift
//  MemeMaster
//
//  Created by ALIA M NEELY on 7/27/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//
// The Game Object is responsable for holding everything that needs to be shared and saved between each Game

import Foundation
import CloudKit

class Game {
    
    //MARK: - Properties
    var memeUUIDStrings: [String] = []
    let name: String
    let numberOfPlayers: Int
    let gameRecordID: UUID
    var gameIDString: String {
        return self.gameRecordID.uuidString
    }
    var cloudKidRecord: CKRecord {
        let recordID = CKRecordID(recordName: self.gameIDString)
        let record = CKRecord(recordType: Game.cKRecordTypeKey, recordID: recordID)
        record.setValue(name, forKey: kName)
        record.setValue(memeUUIDStrings, forKey: kMemes)
        record.setValue(gameIDString, forKey: kGameIDString)
        record.setValue(numberOfPlayers, forKey: kNumberOFPlayers)
        return record
    }
    
    //MARK: - Inits
    init?(CKRecord: CKRecord) {
        guard let gameIdString = CKRecord[kGameIDString] as? String,
            let memeIDs = CKRecord[kMemes] as? [String],
            let name = CKRecord[kName] as? String,
            let numberOfPlayers = CKRecord[kNumberOFPlayers] as? Int else { return nil }
        guard let gameUUID = UUID(uuidString: gameIdString) else { return nil }
        
        self.memeUUIDStrings = memeIDs
        self.gameRecordID = gameUUID
        self.name = name
        self.numberOfPlayers = numberOfPlayers
        
    }
    
    init(gameRecordID: UUID = UUID(), name: String, numberOfPlayers: Int) {
        self.gameRecordID = gameRecordID
        self.name = name
        self.numberOfPlayers = numberOfPlayers
    }
    
    //MARK: - Functions
    func addMemeIDToGame(meme: Meme) {
        //Save the uuid OF the Meme as a String
        self.memeUUIDStrings.append(meme.recordId.uuidString)
    }
    
    //MARK: - Keys
    static let cKRecordTypeKey = "Game"
    private let kMemes = "memes"
    private let kName = "name"
    private let kNumberOFPlayers = "numberOfPlayers"
    private let kGameIDString = "gameIDString"
    
}




