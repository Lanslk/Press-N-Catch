//
//  HighScoreViewModel.swift
//  press n catch
//
//  Created by yuteng Lan on 5/9/2024.
//

import Foundation
import CloudKit

class HighScoreViewModel: ObservableObject {
    
    var name: String = ""
    var score: Double = 0
    var highScore: Double = 0
}
