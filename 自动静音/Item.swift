//
//  Item.swift
//  自动静音
//
//  Created by Kaillier on 2026/11/3.
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
