//
//  MemeSelectionViewController.swift
//  MemeMaster
//
//  Created by Bradley GIlmore on 7/24/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

class MemeSelectionViewController: UIViewController, MemeImageSelectedDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    
    var memeController = MemeController()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoredImages.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeImageCell", for: indexPath) as? MemeImagesCollectionViewCell else { return UICollectionViewCell()}
        cell.delegate = self
        let image = StoredImages.images[indexPath.row]
        cell.image.image = image
        
        return cell
    }
    
    func memeImageButtonTappped(cell: MemeImagesCollectionViewCell) {
        guard let image = cell.image.image else {return}
        self.memeImageView.image = image
    }
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func dismissKeyboard() {
        view.endEditing(true)
        self.firstTextLabel.text = self.firstTextField.text
        self.secondTextLabel.text = self.secondTextFiled.text
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextFiled: UITextField!
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    
            //MARK: - Create Meme
    
    @IBAction func createMemeButtonTapped(_ sender: Any) {
        guard let firstText = firstTextField.text,
            let secondText = secondTextFiled.text,
            let image = memeImageView.image else {return}
        
        MemeController.shared.createMeme(image: image, firstText: firstText, secondText: secondText)
        
    }
}



