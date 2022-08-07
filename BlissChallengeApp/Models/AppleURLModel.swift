//
//  AppleURLModel.swift
//  BlissChallengeApp
//
//  Created by TES on 07/08/2022.
//

import Foundation

// MARK: - AppleURLElement
struct AppleURLElement: Codable {
    let name: String
}

typealias AppleURL = [AppleURLElement]
