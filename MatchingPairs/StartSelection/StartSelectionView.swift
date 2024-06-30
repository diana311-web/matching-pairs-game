//
//  StartSelectionView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 30.06.2024.
//

import SwiftUI

struct StartSelectionView: View {
    @State private var isThemeSwitcherPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                NavigationLink(destination: ThemeSelectionView()) {
                    Text("Start Game")
                        .frame(width: 150, height: 30)
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: GameRankingView()) {
                    Text("Ranking")
                        .frame(width: 150, height: 30)
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .navigationTitle("Matching Pairs")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                isThemeSwitcherPresented = true
            }) {
                Image(systemName: "gearshape")
                    .foregroundColor(Color("themeWhite"))
            })
            .sheet(isPresented: $isThemeSwitcherPresented) {
                ThemeSwitcherView(isPresented: $isThemeSwitcherPresented)
            }
        }
        .onAppear {
            ThemeManager.shared.updateTheme()
        }
    }
}

#Preview {
    StartSelectionView()
}
