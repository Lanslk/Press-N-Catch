//
//  Record.swift
//  press n catch
//
//  Created by yuteng Lan on 5/9/2024.
//

import Foundation
import SwiftData

@Model
class Record: Identifiable {
    var id: String
    var name: String = ""
    var score: Int = 0
    var level: String = ""
    
    init() {
        id = UUID().uuidString
    }
}
