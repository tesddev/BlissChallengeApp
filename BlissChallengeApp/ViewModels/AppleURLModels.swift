//
//  AppleURLModels.swift
//  BlissChallengeApp
//
//  Created by TES on 07/08/2022.
//

import Foundation

class AppleURLInput: Codable {
    let url: String
    
    init(url: String) {
        self.url = url
    }
}
