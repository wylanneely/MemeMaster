//
//  ResultsViewController.swift
//  MemeMaster
//
//  Created by ALIA M NEELY on 8/9/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var championsMemeImageView: UIImageView!
    @IBOutlet weak var championsMemeFirstTextLabel: UILabel!
    @IBOutlet weak var championsMemeSecondTextLabel: UILabel!
    
    @IBOutlet weak var secondPlaceMemeImageView: UIImageView!
    @IBOutlet weak var thirdPlaceMemeImageView: UIImageView!
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        guard let game = LocalGameController.shared.game else { return }
        LocalGameController.shared.fetchBestMemesIn(game: game) {
            
            let bestMemes = self.compareAndUpdateMemeWinners()
            let bestMeme = bestMemes[0]
            let secondBestMeme = bestMemes[1]
            
            DispatchQueue.main.async {
                self.championsMemeImageView.image = bestMeme.image
                self.championsMemeFirstTextLabel.text = bestMeme.firstText
                self.championsMemeSecondTextLabel.text = bestMeme.secondText
                
                self.secondPlaceMemeImageView.image = secondBestMeme.image
            }
        }
    }
    
    
    func compareAndUpdateMemeWinners() -> [BestMeme]{
        let bestMemes = LocalGameController.shared.bestMemes
        var bestMemesCount: [String : Int] = [:]
        var bestMeme = BestMeme()
        var secondBestMeme = BestMeme()
        
        for meme in bestMemes {
            if bestMemesCount[meme.combinedText] == nil {
                bestMemesCount[meme.combinedText] = 1
            } else {
                bestMemesCount[meme.combinedText]! += 1
            }
        }
        
        let sortedMemes = bestMemesCount.flatMap({$0}).sorted{ $0.0.1 < $0.1.1 }
        
        for meme in bestMemes {
            if meme.combinedText == sortedMemes[0].key {
                bestMeme = meme
            }
            if meme.combinedText == sortedMemes[1].key {
                secondBestMeme = meme
            }
        }
        return [bestMeme,secondBestMeme]
    }
    
    
    
    
    
}


