//
//  Meme.swift
//  MemeMaster
//
//  Created by Bradley GIlmore on 7/24/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.

// Meme object is a Representation of a meme, it uses stored

import UIKit
import CloudKit

class Meme {
    
    // File that Stores the images
    let storedImages = StoredImages()
    
    //MARK: - CloudKit Keys
    static let cKRecordTypeKey = "Meme"
    private let kImageIndex = "ImageIndex"
    private let kFirstText = "firstText"
    private let kSecondText = "secondText"
    private let krecordIDString = "recordIDString"
    
    //MARK: - Properties
    let image: UIImage?
    let imageIndex: Int
    var firstText: String
    var secondText: String
    var recordId: UUID = UUID()
    var cloudKitRecord: CKRecord {
        let recordID = CKRecordID(recordName: recordId.uuidString)
        let record = CKRecord(recordType: Meme.cKRecordTypeKey, recordID: recordID)
        record.setValue(imageIndex, forKey: kImageIndex)
        record.setValue(firstText, forKey: kFirstText)
        record.setValue(secondText, forKey: kSecondText)
        record.setValue(recordId.uuidString, forKey: krecordIDString)
        return record
    }
    
    //MARK: -Inits
    init(image: UIImage, firstText: String, secondText: String ) {
        self.image = image
        self.firstText = firstText
        self.secondText = secondText
        //Gets and stores an image index for the meme class / record
        self.imageIndex = storedImages.getIndexFrom(image: image)
        
    }
    
    init?(cloudKitRecord: CKRecord){
        guard let imageIndex = cloudKitRecord[kImageIndex] as? Int,
            let firstText = cloudKitRecord[kFirstText] as? String,
            let secondText = cloudKitRecord[kSecondText] as? String,
            let recordIDString = cloudKitRecord[krecordIDString] as? String else { return nil }
        guard let recordID = UUID(uuidString: recordIDString) else { return nil }
        self.imageIndex = imageIndex
        self.firstText = firstText
        self.secondText = secondText
        self.recordId = recordID
        self.image = storedImages.getImageFrom(index: imageIndex)
    }
    
    
}












