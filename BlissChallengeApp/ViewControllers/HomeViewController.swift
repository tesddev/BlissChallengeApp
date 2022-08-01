//
//  ViewController.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 01/08/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var getEmojiButton: AppButton = {
        let button = AppButton()
        button.setTitle("Get Emoji", for: .normal)
        button.addTarget(self, action: #selector(didTapGetEmojiButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColors.backgroundColor
        constraintViews()
    }
    
    func constraintViews() {
        view.addSubview(getEmojiButton)

        NSLayoutConstraint.activate([
            getEmojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getEmojiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            getEmojiButton.heightAnchor.constraint(equalToConstant: 50),
            getEmojiButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }

    
    @objc func didTapGetEmojiButton() {
        NetworkManager.shared.fetchEmojis {[weak self] emojis in
            print(emojis)
        }
    }
}
