//
//  Item.swift
//  Snake2
//
//  Created by Matt Hogg on 25/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
