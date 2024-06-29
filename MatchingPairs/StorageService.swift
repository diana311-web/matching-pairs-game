//
//  StorageService.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 29.06.2024.
//

import Foundation

class StorageService
{
    static var shared = StorageService()
    private init() { }
    
    private let storageKey = "playedGames"
    private var storage = UserDefaults.standard
    
    public func loadGamesPlayed() -> [GameState] {
        if let data = storage.data(forKey: storageKey), !data.isEmpty {
            return try! JSONDecoder().decode([GameState].self, from: data)
        }
        return []
    }
    
    public func saveGamePlayed(_ gameState: GameState) {
        var playedGames = loadGamesPlayed()
        playedGames.append(gameState)
        if let data = try? JSONEncoder().encode(playedGames) {
            storage.set(data, forKey: storageKey)
        }
    }
}
