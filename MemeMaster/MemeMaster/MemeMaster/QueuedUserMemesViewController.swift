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

class QueuedUserMemesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadButton), name: MemeController.memesWereUpdatedNotification, object: nil)
        MemeController.shared.fetchMemesFromCLoudKit {
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeController.shared.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as? MemeCollectionViewCell else { return UICollectionViewCell()}
        
        let meme =  MemeController.shared.memes[indexPath.row]
        
        cell.memeImageView.image = meme.image
        cell.firstTestLabel.text = meme.firstText
        cell.secondTextLabel.text = meme.secondText
        
        return cell
    }
    
    func reloadButton() {
        self.collectionView.reloadData()
    }

    
}
