//
//  File.swift
//  MemeMaster
//
//  Created by ALIA M NEELY on 7/27/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//
// The Local Game Controller is responsible for delegating evering that happens between the current game and the user



import Foundation
import CloudKit
import UIKit

class LocalGameController {
    
    static var shared = LocalGameController()
    var game: Game?
    //fill from the cloud
    var pendingGames: [Game] = []
    var memes: [Meme] = []
    var players: [Player] = []
    var bestMemes: [BestMeme] = []
    
    // get the name first
    var localPlayerName: String?
    // create the player after the game has been created
    var localPlayer: Player?
    
    //MARK: - CRUD Functions
    
    //Crate
    func createNewGame(name: String, numberOfPlayers: Int) {
        guard let creator = localPlayerName else {return}
        let game = Game(name: name, numberOfPlayers: numberOfPlayers, creator: creator)
        let localPlayer = Player(name: creator, gameRefrence: game.cloudKidRecord)
        
        self.game = game
        self.localPlayer = localPlayer
        CKContainer.default().publicCloudDatabase.save(game.cloudKidRecord, completionHandler: { (ckrecord, error) in
            if let error = error { NSLog("Error saving 'game' to public CLOUDKIT Database: \(error.localizedDescription)")}
        })
        CKContainer.default().publicCloudDatabase.save(localPlayer.cloudKitRecord, completionHandler: { (ckrecord, error) in
            if let error = error { NSLog("Error saving 'player' to public CLOUDKIT Database: \(error.localizedDescription)")}
        })
    }
    
    func addPlayerToGame(playerName: String, gameRecord: CKRecord){
        let player = Player(name: playerName, gameRefrence: gameRecord)
        CKContainer.default().publicCloudDatabase.save(player.cloudKitRecord) { (record, error) in
            if let error = error {NSLog("Error Saving 'Player' to CLOUDKIT: \(error.localizedDescription)")}
        }
    }
    func createMeme(gameRecord: CKRecord, image: UIImage, firstText: String, secondText: String, textColor: UIColor, creator: String) {
        let meme = Meme(image: image, firstText: firstText, secondText: secondText, gameReference: gameRecord, textColor: textColor, creator: creator)
        CKContainer.default().publicCloudDatabase.save(meme.cloudKitRecord) { (record, error) in
            if let error = error {NSLog("Error Saving 'Meme' to CLOUDKIT: \(error.localizedDescription)")}
        }
    }
    func voteBestMeme(gameRecord: CKRecord, image: UIImage, firstText: String, secondText: String, textColor: UIColor, creator: String) {
        let meme = BestMeme(image: image, firstText: firstText, secondText: secondText, gameReference: gameRecord, textColor: textColor, creator: creator)
        CKContainer.default().publicCloudDatabase.save(meme.cloudKitRecord) { (record, error) in
            if let error = error {NSLog("Error Saving 'BestMeme' to CLOUDKIT: \(error.localizedDescription)")}
        }
    }
    
    //Read
    func loadAllGames(){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Game.cKRecordTypeKey, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil){ (ckRecords, error) in
            if let error = error { NSLog("Error Fetching 'games'from CLOUDKIT: \(error.localizedDescription)")}
            guard let gameRecordIds = ckRecords else {return}
            let games = gameRecordIds.flatMap({Game(CKRecord: $0)})
            self.pendingGames = games
        }
    }
    
    func loadSpecificGame(gameRecordId: UUID) {
        let recordID = CKRecordID(recordName: gameRecordId.uuidString)
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (ckGameRecord, error) in
            if let error = error { NSLog("Error Fetching 'game'from CLOUDKIT: \(error.localizedDescription)")}
            guard let gameRecordId = ckGameRecord else {return}
             self.game = Game(CKRecord: gameRecordId)
        }
    }
    
    // new func to go search cloudkit for messages in array of chats, then set the messages to the chat array.
    
    func fetchPlayersIn(game: Game, completion: @escaping () -> Void) {
        let gameReference = CKReference(recordID: game.ckGameRecordID, action: .none)
        let predicate = NSPredicate(format: "gameReference == %@", gameReference)
        let query = CKQuery(recordType: Player.cKRecordTypeKey, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error { print(error.localizedDescription); completion() }
            else {
                guard let records = records else { completion(); return }
                let players = records.flatMap({ Player(cloudkitRecord: $0)})
                // set all the players in the local game to what the cloud references has
                LocalGameController.shared.players = players
                completion()
            }
        }
    }
    
    
    func fetchMemesIn(game: Game, completion: @escaping () -> Void) {
        let gameReference = CKReference(recordID: game.ckGameRecordID, action: .none)
        let predicate = NSPredicate(format: "gameReference == %@", gameReference)
        let query = CKQuery(recordType: Meme.cKRecordTypeKey, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error { print(error.localizedDescription); completion() }
            else {
                guard let records = records else { completion(); return }
                let memes = records.flatMap({ Meme(cloudKitRecord: $0)})
                // set all the memes in the local game controller to reflect what cloudkit saved
                LocalGameController.shared.memes = memes
                completion()
            }
        }
    }
    
    func fetchBestMemesIn(game: Game, completion: @escaping () -> Void) {
        let gameReference = CKReference(recordID: game.ckGameRecordID, action: .none)
        let predicate = NSPredicate(format: "gameReference == %@", gameReference)
        let query = CKQuery(recordType: BestMeme.cKRecordTypeKey, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error { print(error.localizedDescription); completion() }
            else {
                guard let records = records else { completion(); return }
                let memes = records.flatMap({ BestMeme(cloudKitRecord: $0)})
                // set all the memes in the local game controller to reflect what cloudkit saved
                LocalGameController.shared.bestMemes = memes
                completion()
            }
        }
    }

    
    // Subscription :: Possibly put in a new model
    
    static let GamesWereUpdatedNotification = Notification.Name("GamesWereUpdated")
    
    static func subscribeToGameModification() {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: Game.cKRecordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        CKContainer.default().publicCloudDatabase.save(subscription) { (_, error) in
            if let error = error { NSLog("Error Subscribing to Creation of Memes: \(error.localizedDescription)") }
        }
    }
    
    
    
}



