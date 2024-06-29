//
//  MatchingPairsView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 27.06.2024.
//

import SwiftUI
import MatchingCard

public struct MatchingPairsView: View {
    private var buttonTitle: String {
        return startGame ? "Reset" : ""
    }
    @State private var startGame: Bool = false
    @ObservedObject var viewModel: MatchingPairsViewModel
    @ObservedObject var timerViewModel = TimerViewModel.shared
    
    public var body: some View {
        VStack {
            Text(viewModel.themeModel.title)
                .font(.title)
                .padding()
            Text("Score: \(viewModel.score)")
                .padding()
                .font(.title2)
            TimerView()
                .hidden(!startGame)
       
            VStack {
                    GeometryReader { geometry in
                        LazyVGrid(columns: gridColumns(for: geometry.size), spacing: 3) {
                            ForEach(Array(viewModel.cardsView.enumerated()), id: \.0)  { index, card in
                                card
                                    .frame(width: cardWidth(for: geometry.size), height: cardHeight(for: geometry.size))
                                    .padding()
                                    .id(card.id)
    //                                .simultaneousGesture(
    //                                           TapGesture()
    //                                               .onEnded { _ in
    //                                                   viewModel.chooseCard(card)
    //                                                   //print("VStack tapped")
    //                                               }
    //                                       )
                                    .hidden(viewModel.matchedCards[card] ?? false)
                            }
    //                        ForEach(Array(theme.symbols.enumerated()), id: \.0)  { index, symbol in
    //                            CardView(symbol: symbol, backSymbol: theme.cardSymbol, backgroundColor: Color(theme.cardColor))
    //                                 .frame(width: cardWidth(for: geometry.size), height: cardHeight(for: geometry.size))
    //                                 .padding()
    //                                 .onTapGesture {
    //                                     print(self)
    //                                 }
    //                         }
                         }
                    }
                
            }.disabled(!startGame || viewModel.blockScreen)
            buttonView
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                
        }.onAppear {
            viewModel.initGame()
        }.alert(isPresented: $timerViewModel.showAlert, content: {
            Alert(title: Text("Time's expired"),
                  message: Text("Game over"),
                  dismissButton: .default(Text("OK"), action: {
                startGame.toggle()
                viewModel.initGame()
            }))
        })
    }
    
    
    var buttonView: some View {
        return Button(action: {
            startGame.toggle()
            if startGame {
                viewModel.startGame()
            } else {
                viewModel.initGame()
            }
        }) {
            Text(buttonTitle)
        }
        .frame(width: 120, height: 40)  //to do: add geometry reader
        .foregroundColor(.white)
        .background(.gray)
        .cornerRadius(8.0)
        .padding()
    }
    
    private func gridColumns(for size: CGSize) -> [GridItem] {
        let columnCount = size.width > size.height ? 4 : 3
        return Array(repeating: GridItem(.flexible()), count: columnCount)
    }

    // Function to determine card width based on screen width and number of columns
    private func cardWidth(for size: CGSize) -> CGFloat {
        let columnCount = size.width > size.height ? 4 : 3
        let spacing: CGFloat = 10
        let totalSpacing = spacing * CGFloat(columnCount - 1)
        let availableWidth = size.width - totalSpacing
        return availableWidth / CGFloat(columnCount)
    }

    // Function to determine card height based on card width and aspect ratio
    private func cardHeight(for size: CGSize) -> CGFloat {
        let rowCount = size.width > size.height ? 2 : 3
        let spacing: CGFloat = 10
        let totalSpacing = spacing * CGFloat(rowCount - 1)
        let availableHeight = size.height - totalSpacing
        return availableHeight / CGFloat(rowCount)
    }
}

extension Color {
    init(_ cardColor: CardColor) {
        self.init(red: cardColor.red, green: cardColor.green, blue: cardColor.blue)
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

#Preview {
    MatchingPairsView(viewModel: MatchingPairsViewModel(themeModel: ThemeModel(cardColor: CardColor(blue: 0.01, green: 0.549, red: 0.9686), cardSymbol: "⬛️", symbols: ["🎃", "👻", "👿", "💀"], title: "Halloween")))
}
