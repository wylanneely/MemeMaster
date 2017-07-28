//
//  Player.swift
//  MemeMaster
//
//  Created by ALIA M NEELY on 7/27/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//


//  The Player object is in charge of representing a player signed into the game. 
// Id has the name, and a uuid of the name to find it in cloud kit


import Foundation
import CloudKit

class Player {
    
    static var shared = Player()
    
    let displayName: String
    var recordUUId: UUID = UUID()
    
    var cloudKitRecord: CKRecord {
        
        let recordId = CKRecordID(recordName: recordUUId.uuidString)
        
        let record = CKRecord(recordType: Player.cKRecordTypeKey, recordID: recordId)
        record.setValue(displayName, forKey: kName )
        record.setValue(recordUUId.uuidString, forKey: kRecordIdString)
        return record
    }
    
    init(name: String = "NoName"){
        self.displayName = name
    }
    
    init?(cloudkitRecord: CKRecord) {
        guard let name = cloudkitRecord[kName] as? String,
              let recordIDString = cloudkitRecord[kRecordIdString] as? String else {return nil}
        guard let recordUUId = UUID(uuidString: recordIDString) else {return nil}
        self.displayName = name
        self.recordUUId = recordUUId
    }
    
    // Keys
    static let cKRecordTypeKey = "Player"
    private let kName = "name"
    private let kRecordIdString = "recordIdString"
    
}


