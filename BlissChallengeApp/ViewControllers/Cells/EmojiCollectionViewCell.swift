//
//  EmojiCollectionViewCell.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 04/08/2022.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "EmojiCollectionViewCell"
    
    private var emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - METHODS
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Constants.AppColors.backgroundColor
        addSubview(emojiImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customizeConstraint()
    }
    
    func customizeConstraint() {
        emojiImageView.frame = contentView.frame
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.cornerRadius = 10
    }
    
    public func configureCollectionView(with viewModel: PersistentViewModel) {
        let urlString = viewModel.url
        let url = URL(string: urlString)!
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                // Create Image and Update Image View
                self.emojiImageView.image = UIImage(data: data)
            }
        }
    }
    
    public func configureCollectionView(with url: String) {
//        let urlString = viewModel.avatarURL
        let url = URL(string: url)!
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                // Create Image and Update Image View
                self.emojiImageView.image = UIImage(data: data)
            }
        }
    }
    
    override func prepareForReuse() {
        emojiImageView.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
