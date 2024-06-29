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
    var startDateTime: Date = Date() // TODO: Make it getter
    var score: Int = 0
    var noOfTries: Int = 0
    var elapsedTimeSeconds: Int = 0
    var hasWon: Bool = false
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // TODO: dd-MM-yyyy
        return formatter.string(from: startDateTime)
    }
}
