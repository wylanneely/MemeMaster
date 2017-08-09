//
//  MemeController.swift
//  MemeMaster
//
//  Created by Bradley GIlmore on 7/24/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit
import CloudKit

class MemeController{
    
    static var shared = MemeController()
    static let memesWereUpdatedNotification = Notification.Name("MemesWereUpdated")
    var memes: [Meme] = [] {
        didSet {
            DispatchQueue.main.async{NotificationCenter.default.post(name: Notification.Name("MemesWereUpdated"), object: self)}
        }}
    
    //create
    func createMeme(image: UIImage, firstText: String, secondText: String)  {
    //    let meme = Meme(image: image, firstText: firstText, secondText: secondText)
     //   LocalGameController.shared.game?.addMemeIDToGame(meme: meme)
        
    //    saveToCloudKit(meme: meme)
    }
    
    //save
    func saveToCloudKit(meme: Meme) {
        CKContainer.default().publicCloudDatabase.save(meme.cloudKitRecord) { (record, error) in
            if let error = error { NSLog("Error Saving Record to CLOUDKIT: \(error.localizedDescription) ") }
            else { self.memes.append(meme) }
        }
    }
    
    
    //fetch
    
    func fetchMemesFromCLoudKit(completion: @escaping () -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Meme.cKRecordTypeKey, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error { NSLog("Error Fetching from CLOUDKIT: \(error.localizedDescription)")}
            guard let records = records else { return }
            let memes = records.flatMap({ Meme(cloudKitRecord: $0) })
            self.memes = memes
        }
    }
    
    static func subscribeToMemeCreations() {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: Meme.cKRecordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "A New Meme Has Been Created!"
        notificationInfo.soundName = "default"
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        CKContainer.default().publicCloudDatabase.save(subscription) { (_, error) in
            if let error = error { NSLog("Error Subscribing to Creation of Memes: \(error.localizedDescription)") }
        }
    }
}
