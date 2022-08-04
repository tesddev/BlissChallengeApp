//
//  EmojiListViewController.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 03/08/2022.
//

import UIKit

class EmojiListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var emojiArray = [String]()
    var viewModel = [PersistentViewModel]()
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
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    // MARK: - ColllectionView Delegate and data source stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell
        else { return UICollectionViewCell() }
        DispatchQueue.main.async {
            cell.configureCollectionView(with: self.viewModel[indexPath.row])
        }
        return cell
    }
}
