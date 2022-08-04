//
//  RoundGreenButton.swift
//  SDKProject
//
//  Created by Tes on 01/08/2022.
//

import UIKit

class AppButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Reset Password", for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
