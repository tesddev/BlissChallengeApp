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
    
    var arrayOfSearchedAvatarURL = [String]()
    var arrayOfSearchedAvatarName = [String]()
    
    private let searchBar: UISearchBar = {
        let controller = UISearchBar()
        controller.searchBarStyle = .minimal
        controller.translatesAutoresizingMaskIntoConstraints = false
        controller.backgroundColor = .white
        controller.layer.cornerRadius = 10
        controller.barTintColor = .white
        controller.autocapitalizationType = .none
        return controller
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
        DispatchQueue.main.async {
            self.populateDataFromPersistenceOrAPI()
        }
        searchBar.delegate = self
        guard let searchedAvatarURL = userDefaults.object(forKey: "UDArrayOfSearchedAvatarsURL"), let searchedAvatarName =  userDefaults.object(forKey: "UDArrayOfSearchedAvatarsName") else {
            print("error full ground")
            return
        }
        arrayOfSearchedAvatarURL = searchedAvatarURL as! [String]
        arrayOfSearchedAvatarName = searchedAvatarName as! [String]
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
                /// Create Image and Update Image View
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
        searchView.addSubview(searchBar)
        
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
            
            searchBar.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
            searchBar.widthAnchor.constraint(equalTo: searchView.widthAnchor, multiplier: 0.9),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBar.centerYAnchor.constraint(equalTo: searchView.centerYAnchor)
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
    
    @objc func didTapSearchButton(){
        guard let text = searchBar.text, searchBar.text!.count > 0 else {
            showSimpleAlert("", message: "Input an avatar name to search")
            return
        }
        var availability = false
        
        for x in self.arrayOfSearchedAvatarName {
            if x.contains(text){
                showSimpleAlert("already exists", message: "")
                availability = true
                break
            }
        }
        
        if availability == false {
            NetworkManager.shared.fetchSearchedEmojis(username: text) { result in
                
                self.arrayOfSearchedAvatarURL.append(result.avatarURL)
                self.arrayOfSearchedAvatarName.append(result.login)
                print(self.arrayOfSearchedAvatarURL.count, self.arrayOfSearchedAvatarName.count)
                self.userDefaults.set(self.arrayOfSearchedAvatarName, forKey: "UDArrayOfSearchedAvatarsName")
                self.userDefaults.set(self.arrayOfSearchedAvatarURL, forKey: "UDArrayOfSearchedAvatarsURL")
                
            } errorCompletion: { err in
                self.showSimpleAlert("Data Not Found", message: "Try another string")
            }
        } else {

        }
    }
}

extension HomeViewController: UISearchBarDelegate{
    //MARK: UISearchbar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: Helper Function
    
    func showSimpleAlert(_ title:String, message:String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
