//
//  GameState.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 29.06.2024.
//

import Foundation

struct GameState: Codable, Identifiable
{
    var id = UUID()
    var hasWon = false
    var startDateTime = Date()
    var gridSize = 0
    var noOfTries = 0
    var elapsedTimeSeconds = 0

    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM" // TODO: HH:mm
        return formatter.string(from: startDateTime)
    }
    
    var score: Int {
        if elapsedTimeSeconds == 0 || noOfTries == 0 {
            return 0
        }
        
        let timeWeight: Double = 0.6
        let movesWeight: Double = 0.4

        let timeFactor = max(0, 1 - (timeWeight * Double(elapsedTimeSeconds) / 1000))
        let movesFactor = max(0, 1 - (movesWeight * Double(noOfTries) / 100))

        let score = Double(gridSize) * timeFactor * movesFactor
        
        return max(0, Int(score.rounded()))
    }
}
