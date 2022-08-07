//
//  EmojiListViewController.swift
//  BlissChallengeApp
//
//  Created by TES on 03/08/2022.
//

import UIKit

class AvatarListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let userDefaults = UserDefaults.standard
    var viewModel = [SearchedEmojiViewModel]()
    
    var arrayOfSearchedAvatarURL = [String]()
    var arrayOfSearchedAvatarName = [String]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 90, height: 90)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.frame = view.bounds
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Constants.AppColors.backgroundColor
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        guard let searchedAvatarURL = userDefaults.object(forKey: "UDArrayOfSearchedAvatarsURL"), let searchedAvatarName =  userDefaults.object(forKey: "UDArrayOfSearchedAvatarsName") else {
            print("error full ground")
            return
        }
        arrayOfSearchedAvatarURL = searchedAvatarURL as! [String]
        arrayOfSearchedAvatarName = searchedAvatarName as! [String]
        
    }
    
    // MARK: - ColllectionView Delegate and data source stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfSearchedAvatarURL.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.arrayOfSearchedAvatarURL.remove(at: indexPath.row)
        self.arrayOfSearchedAvatarName.remove(at: indexPath.row)
        self.userDefaults.set(self.arrayOfSearchedAvatarName, forKey: "UDArrayOfSearchedAvatarsName")
        self.userDefaults.set(self.arrayOfSearchedAvatarURL, forKey: "UDArrayOfSearchedAvatarsURL")
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell
        else { return UICollectionViewCell() }
        DispatchQueue.main.async {
            cell.configureCollectionView(with: self.arrayOfSearchedAvatarURL[indexPath.row])
        }
        return cell
    }
}
