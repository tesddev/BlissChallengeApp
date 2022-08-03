//
//  ViewController.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 01/08/2022.
//

import UIKit
import CoreData
import RealmSwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userDefaults = UserDefaults.standard
    var persistedEmojiURLs: [EmojiURL]?
    
    private var emojiDetails = Emojis()
    private var viewModels = [URLTableViewCellViewModel]()
    private var persistentVM = [PersistentViewModel]()
    
    
    var emojiURLs: [String] = []
    var emojiURLsArrayForUD: [String] = []
    
    lazy var getEmojiButton: AppButton = {
        let button = AppButton()
        button.setTitle("Get Emoji", for: .normal)
        button.addTarget(self, action: #selector(didTapGetEmojiButton), for: .touchUpInside)
        return button
    }()
    
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .red
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let UDEmojis = userDefaults.object(forKey: "userDefaultsEmojiDictionary")
        print("here is UD 1 emojis - \(String(describing: UDEmojis))")
        view.backgroundColor = Constants.AppColors.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        constraintViews()
        setupTableView()
        
        if let UDEmojis = UDEmojis {
            self.emojiURLsArrayForUD = UDEmojis as! [String]
            
            self.persistentVM = ((emojiURLsArrayForUD).compactMap({
                PersistentViewModel(
                    url: $0
                )
            }))
            tableView.reloadData()
        } else {
            populateTableViewFromAPI()
        }
        print("here is emoji test array - \(self.emojiURLsArrayForUD)")
    }
    
    func populateTableViewFromAPI() {
        NetworkManager.shared.fetchEmojis { [weak self] data in
            switch data {
            case .success(let emojis):
                self?.emojiDetails = emojis
                
                // Create and Write Dictionary
                let dictionaryValues = Array(emojis.values)
                
                self?.persistentVM = dictionaryValues.compactMap({val in
                    PersistentViewModel(
                        url: val
                    )
                })
                
                self?.userDefaults.set(dictionaryValues, forKey: "userDefaultsEmojiDictionary")
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("The error is \(error.localizedDescription)")
            }
        }
    }
    
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: getEmojiButton.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func constraintViews() {
        view.addSubview(getEmojiButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            getEmojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getEmojiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            getEmojiButton.heightAnchor.constraint(equalToConstant: 50),
            getEmojiButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    @objc func didTapGetEmojiButton() {
        populateTableViewFromAPI()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persistentVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = persistentVM[indexPath.row].url
        return cell ?? UITableViewCell()
    }
}

class URLTableViewCellViewModel {
    // MARK: - Properties
    let url: String
    init(
        url: String
    ){
        self.url = url
    }
}

class PersistentViewModel {
    // MARK: - Properties
    let url: String
    init(
        url: String
    ){
        self.url = url
    }
}
