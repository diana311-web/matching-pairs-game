//
//  GameRankingView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 29.06.2024.
//

import SwiftUI

struct GameRankingView: View {
    var body: some View {
        let gamesPlayed = StorageGameService.shared.loadGamesPlayed()
        
        List {
            // Header row
            HStack {
                Text("Won")
                Spacer()
                Text("Score")
                Spacer()
                Text("Date")
            }
            .font(.headline)
            .padding(.horizontal)
            
            // Ranking entries
            ForEach(gamesPlayed.sorted(by: {
                if $0.hasWon != $1.hasWon {
                    return $0.hasWon && !$1.hasWon
                } else if $0.score != $1.score {
                    return $0.score > $1.score
                } else {
                    return $0.startDateTime > $1.startDateTime
                }
            })) { entry in
                HStack {
                    Text(entry.hasWon ? "✅" : "❌")
                    Spacer()
                    Text("\(entry.score)")
                    Spacer()
                    Text(entry.formattedDate)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Game Ranking")
    }
}

#Preview {
    GameRankingView()
}
