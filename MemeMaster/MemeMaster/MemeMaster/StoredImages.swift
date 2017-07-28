//
//  StoredImages.swift
//  MemeMaster
//
//  Created by Bradley GIlmore on 7/24/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

struct StoredImages {

    
    static let images = [#imageLiteral(resourceName: "willyWonka"),
                         #imageLiteral(resourceName: "winterIsComing"), // 1 index
                         #imageLiteral(resourceName: "futuramaFry"),
                         #imageLiteral(resourceName: "grandmaComputer"),
                         #imageLiteral(resourceName: "thadBeGreatGuy"),
                         #imageLiteral(resourceName: "suspiciousKid")] // 5 index
    
    func getImageFrom(index: Int)-> UIImage {
        switch index {
        case 0:
            return #imageLiteral(resourceName: "willyWonka")
        case 1:
            return #imageLiteral(resourceName: "winterIsComing")
        case 2:
            return #imageLiteral(resourceName: "futuramaFry")
        case 3:
            return #imageLiteral(resourceName: "grandmaComputer")
        case 4:
            return #imageLiteral(resourceName: "thadBeGreatGuy")
        case 5:
            return #imageLiteral(resourceName: "suspiciousKid")
        default:
            NSLog("Error: Wrong index passed in")
            return #imageLiteral(resourceName: "grandmaComputer")
        }
    }
    
    func getIndexFrom(image: UIImage) -> Int {
        
        switch image {
        case #imageLiteral(resourceName: "willyWonka"):
            return 0
        case #imageLiteral(resourceName: "winterIsComing"):
            return 1
        case #imageLiteral(resourceName: "futuramaFry"):
            return 2
        case #imageLiteral(resourceName: "grandmaComputer"):
            return 3
        case #imageLiteral(resourceName: "thadBeGreatGuy"):
            return 4
        case #imageLiteral(resourceName: "suspiciousKid"):
            return 5
        default:
            NSLog("Error: Cant Find Image")
            return 3
        }
        
    }
    
    
}

