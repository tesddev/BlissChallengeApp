//
//  ViewController.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 01/08/2022.
//

import UIKit
import CoreData
import RealmSwift

class HomeViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    private var persistentVM = [PersistentViewModel]()
    var emojiURLsArray: [String] = []
    
    let emojiImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect())
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var getEmojiButton: AppButton = {
        let button = AppButton()
        button.setTitle("RANDOM EMOJI", for: .normal)
        button.addTarget(self, action: #selector(didTapGetEmojiButton), for: .touchUpInside)
        return button
    }()
    
    lazy var emojiListButton: AppButton = {
        let button = AppButton()
        button.setTitle("Emoji List", for: .normal)
        button.addTarget(self, action: #selector(didTapEmojiListButton), for: .touchUpInside)
        return button
    }()
    
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchButton: AppButton = {
        let button = AppButton()
        button.setTitle("SEARCH", for: .normal)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColors.backgroundColor
        constraintViews()
        populateDataFromPersistenceOrAPI()
    }
    
    func populateDataFromPersistenceOrAPI(){
        let UDEmojis = userDefaults.object(forKey: "userDefaultsEmojiDictionary")
        if let UDEmojis = UDEmojis {
            self.emojiURLsArray = UDEmojis as! [String]
            
            self.persistentVM = ((emojiURLsArray).compactMap({
                PersistentViewModel(
                    url: $0
                )
            }))
            displayRandomEmoji()
        } else {
            fetchEmojisFromAPI()
        }
    }
    
    func fetchEmojisFromAPI() {
        NetworkManager.shared.fetchEmojis { [weak self] data in
            switch data {
            case .success(let emojis):
                // Create and Write Dictionary
                let dictionaryValues = Array(emojis.values)
                
                self?.persistentVM = dictionaryValues.compactMap({val in
                    PersistentViewModel(
                        url: val
                    )
                })
                
                self?.userDefaults.set(dictionaryValues, forKey: "userDefaultsEmojiDictionary")
                
            case .failure(let error):
                print("The error is \(error.localizedDescription)")
            }
        }
    }
    
    func displayRandomEmoji(){
        let array = persistentVM
        let randomElement = array.randomElement()!
        let emojiURL = randomElement.url
        let url = URL(string: emojiURL)!
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                // Create Image and Update Image View
                self.emojiImageView.image = UIImage(data: data)
            }
        }
    }
    
    func constraintViews() {
        view.addSubview(getEmojiButton)
        view.addSubview(emojiImageView)
        view.addSubview(emojiListButton)
        view.addSubview(searchView)
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            getEmojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getEmojiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            getEmojiButton.heightAnchor.constraint(equalToConstant: 50),
            getEmojiButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            emojiImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            emojiImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiImageView.widthAnchor.constraint(equalToConstant: 200),
            emojiImageView.heightAnchor.constraint(equalToConstant: 200),
            
            emojiListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiListButton.topAnchor.constraint(equalTo: getEmojiButton.bottomAnchor, constant: 20),
            emojiListButton.heightAnchor.constraint(equalToConstant: 50),
            emojiListButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            searchView.topAnchor.constraint(equalTo: emojiListButton.bottomAnchor, constant: 20),
            searchView.leadingAnchor.constraint(equalTo: emojiListButton.leadingAnchor),
            searchView.widthAnchor.constraint(equalTo: emojiListButton.widthAnchor, multiplier: 0.65),
            searchView.heightAnchor.constraint(equalTo: emojiListButton.heightAnchor, constant: 10),
            
            searchButton.leadingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: emojiListButton.trailingAnchor),
            searchButton.heightAnchor.constraint(equalTo: searchView.heightAnchor),
            searchButton.topAnchor.constraint(equalTo: searchView.topAnchor),
        ])
    }
    
    @objc func didTapGetEmojiButton() {
        displayRandomEmoji()
    }
    @objc func didTapEmojiListButton() {
        let vc = EmojiListViewController()
        vc.viewModel = persistentVM
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapSearchButton() {
        displayRandomEmoji()
    }
}
