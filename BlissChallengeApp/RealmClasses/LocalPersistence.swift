//
//  LocalPersistence.swift
//  BlissChallengeApp
//
//  Created by TES on 02/08/2022.
//

import UIKit
import RealmSwift

class LocalOnlyQsTask: Object {    
    @Persisted var emojiURL: String = ""
    
    convenience init(emojiURL: String) {
        self.init()
        self.emojiURL = emojiURL
    }
}
