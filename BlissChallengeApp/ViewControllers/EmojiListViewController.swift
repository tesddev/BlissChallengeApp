//
//  EmojiListViewController.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 03/08/2022.
//

import UIKit

class EmojiListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var constantEmojiViewModel = [PersistentViewModel]()
    var viewModel = [PersistentViewModel]()
    
    var refreshControl: UIRefreshControl?
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
        constantEmojiViewModel = viewModel
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl ?? UIRefreshControl())
    }
    
    @objc func refresh(sender:AnyObject) {
        self.viewModel = self.constantEmojiViewModel
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    // MARK: - ColllectionView Delegate and data source stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.remove(at: indexPath.row)
        collectionView.reloadData()
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
