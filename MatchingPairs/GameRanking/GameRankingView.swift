//
//  GameRankingView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 29.06.2024.
//

import SwiftUI

struct GameRankingView: View {
    var body: some View {
        let gamesPlayed = StorageService.shared.loadGamesPlayed()
        
        List {
            // Header row
            HStack {
                Text("Won")
                Spacer()
                Text("Score")
                Spacer()
                Text("Tries")
                Spacer()
                Text("Seconds")
                Spacer()
                Text("Date")
            }
            .font(.headline)
            .padding(.horizontal)
            
            // Ranking entries
            ForEach(gamesPlayed) { entry in
                HStack {
                    Text(entry.hasWon ? "✅" : "❌")
                    Spacer()
                    Text("\(entry.score)")
                    Spacer()
                    Text("\(entry.noOfTries)")
                    Spacer()
                    Text("\(entry.elapsedTimeSeconds)")
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
