//
//  EmojiURL+CoreDataProperties.swift
//  
//
//  Created by TES on 02/08/2022.
//
//

import Foundation
import CoreData


extension EmojiURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmojiURL> {
        return NSFetchRequest<EmojiURL>(entityName: "EmojiURL")
    }

    @NSManaged public var emojiURL: String?

}
