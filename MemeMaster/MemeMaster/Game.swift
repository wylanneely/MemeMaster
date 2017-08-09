//
//  Game.swift
//  MemeMaster
//
//  Created by ALIA M NEELY on 7/27/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.

//  Note: - The Game object does not directly reference the memes in the cloud


import Foundation
import CloudKit

class Game {
    
    //MARK: - Properties
    let name: String
    var numberOfPlayers: Int = 2
    let creator: String
    
    // locally stored, not stored on cloud
    var players: [Player] = []
    
    // cloudKit Properties
    let gameRecordUUID: UUID
    var ckGameRecordID: CKRecordID {
        let ckRecordID = CKRecordID(recordName: self.gameRecordUUID.uuidString)
        return ckRecordID
    }
    var cloudKidRecord: CKRecord {
        let record = CKRecord(recordType: Game.cKRecordTypeKey, recordID: ckGameRecordID)
        record.setValue(name, forKey: kName)
        record.setValue(creator, forKey: kCreatorName)
        record.setValue(numberOfPlayers, forKey: kNumberOFPlayers)
        record.setValue(gameRecordUUID.uuidString, forKey: kGameIDString)
        return record
    }
    
    //MARK: - Inits
    init?(CKRecord: CKRecord) {
        guard let gameIdString = CKRecord[kGameIDString] as? String,
            let gameName = CKRecord[kName] as? String,
            let creatorName = CKRecord[kCreatorName] as? String,
            let numberOfPlayers = CKRecord[kNumberOFPlayers] as? Int else { return nil }
        guard let gameUUID = UUID(uuidString: gameIdString) else {return nil}
        
        self.creator = creatorName
        self.gameRecordUUID = gameUUID
        self.name = gameName
        self.numberOfPlayers = numberOfPlayers
    }
    
    init(name: String, numberOfPlayers: Int, creator: String) {
        //this uuid is to set the record id
        self.gameRecordUUID = UUID()
        self.name = name
        self.numberOfPlayers = numberOfPlayers
        self.creator = creator
    }

    //MARK: - Keys
    static let cKRecordTypeKey = "Game"
    private let kName = "gameName"
    private let kCreatorName = "creatorName"
    private let kNumberOFPlayers = "numberOfPlayers"
    private let kGameIDString = "gameIDString"
    
}

