//
//  QueuedUserMemesViewController.swift
//  MemeMaster
//
//  Created by Bradley GIlmore on 7/24/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

class QueuedUserMemesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadButton), name: MemeController.memesWereUpdatedNotification, object: nil)
        guard let game = LocalGameController.shared.game else {return}
        LocalGameController.shared.fetchMemesIn(game: game) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func reloadButton() {
        self.collectionView.reloadData()
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func refreshButton(_ sender: Any) {
        guard let game = LocalGameController.shared.game else {return}
        LocalGameController.shared.fetchMemesIn(game: game) {
            DispatchQueue.main.async {
                  self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LocalGameController.shared.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as? MemeCollectionViewCell else { return UICollectionViewCell()}
        let meme = LocalGameController.shared.memes[indexPath.row]
        cell.memeImageView.image = meme.image
        cell.firstTestLabel.text = meme.firstText
        cell.secondTextLabel.text = meme.secondText
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = LocalGameController.shared.memes[indexPath.row]
        guard let memeImage = meme.image else {return}
        guard let game = LocalGameController.shared.game else {return}
        LocalGameController.shared.voteBestMeme(gameRecord: game.cloudKidRecord, image: memeImage, firstText: meme.firstText, secondText: meme.secondText, textColor: meme.textColor, creator: meme.creator)
        performSegue(withIdentifier: "toResults", sender: self)
        LocalGameController.shared.fetchBestMemesIn(game: game) {}
    }
    
    
}
