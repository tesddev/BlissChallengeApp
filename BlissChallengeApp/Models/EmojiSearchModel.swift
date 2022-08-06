//
//  EmojiSearchModel.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 06/08/2022.
//

import Foundation

struct EmojiSearchModel: Codable {
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
