//
//  SearchedEmojiViewModel.swift
//  BlissChallengeApp
//
//  Created by TES on 06/08/2022.
//

import Foundation

class SearchedEmojiViewModel: Codable {
    let avatarName: String
    let avatarURL: String
    
    init(avatarName: String, url: String) {
        self.avatarName = avatarName
        self.avatarURL = url
    }
}
