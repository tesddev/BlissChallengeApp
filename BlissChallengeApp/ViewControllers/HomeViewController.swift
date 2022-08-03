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
    
    lazy var getEmojiButton: AppButton = {
        let button = AppButton()
        button.setTitle("RANDOM EMOJI", for: .normal)
        button.addTarget(self, action: #selector(didTapGetEmojiButton), for: .touchUpInside)
        return button
    }()
    
    let emojiImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect())
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
                print("here is the data \(data)")
                self.emojiImageView.image = UIImage(data: data)
            }
        }
    }
    
    func constraintViews() {
        view.addSubview(getEmojiButton)
        view.addSubview(emojiImageView)
        
        NSLayoutConstraint.activate([
            getEmojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getEmojiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            getEmojiButton.heightAnchor.constraint(equalToConstant: 50),
            getEmojiButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            emojiImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            emojiImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiImageView.widthAnchor.constraint(equalToConstant: 200),
            emojiImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func didTapGetEmojiButton() {
        displayRandomEmoji()
    }
}
