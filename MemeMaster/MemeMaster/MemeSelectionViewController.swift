//
//  MemeSelectionViewController.swift
//  MemeMaster
//
//  Created by Bradley GIlmore on 7/24/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

class MemeSelectionViewController: UIViewController, MemeImageSelectedDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ColorDelegate, UITextFieldDelegate  {
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        colorPicker.delegate = self
        view.addGestureRecognizer(tap)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Properties
    
    var memeController = MemeController()
    
    //MARK: - ColorDelegate Stuff
    
    fileprivate var selectedIndex = 0 {
        didSet {
            currentColor = selectedIndex == 0 ? .white : .black
        }
    }
    
    fileprivate var currentColor = UIColor.white {
        didSet {
            firstTextField.textColor = currentColor
            secondTextFiled.textColor = currentColor
        }
    }

    func pickedColor(color: UIColor) {
        firstTextLabel.textColor = color
        secondTextLabel.textColor = color
    }
    
    //MARK: - TextField Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        firstTextLabel.text = firstTextField.text
        secondTextLabel.text = secondTextFiled.text
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        self.firstTextLabel.text = self.firstTextField.text
        self.secondTextLabel.text = self.secondTextFiled.text
    }
    
    //MARK: - CollectionView Delegate / DataSource
    
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
    //ProtocolDelegateFuntion 
    func memeImageButtonTappped(cell: MemeImagesCollectionViewCell) {
        guard let image = cell.image.image else {return}
        self.memeImageView.image = image
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextFiled: UITextField!
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    
    //MARK: - Create Meme
    
    //MARK: - IBActions
    
    @IBAction func createMemeButtonTapped(_ sender: Any) {
        guard let firstText = firstTextField.text,
            let secondText = secondTextFiled.text,
            let textColor = firstTextField.textColor,
            let image = memeImageView.image else {return}
        guard let game = LocalGameController.shared.game,
            let creatorName = LocalGameController.shared.localPlayer?.displayName else {return}
        
        LocalGameController.shared.createMeme(gameRecord: game.cloudKidRecord, image: image, firstText: firstText, secondText: secondText, textColor: textColor, creator: creatorName)
        
        
    }
}



