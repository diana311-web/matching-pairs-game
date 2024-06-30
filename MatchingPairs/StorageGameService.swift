//
//  StorageGameService.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 29.06.2024.
//

import Foundation
import MatchingCard

class StorageGameService
{
    static var shared = StorageGameService()
    private var storage = StorageService(storageKey: "playedGames")
    private init() { }
    
    public func loadGamesPlayed() -> [GameState] {
        return storage.loadArray(GameState.self)
    }
    
    public func saveGamePlayed(_ gameState: GameState) {
        storage.append(gameState)
    }
}
