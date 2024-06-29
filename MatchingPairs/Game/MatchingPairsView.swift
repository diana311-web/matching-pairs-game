//
//  MatchingPairsView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 27.06.2024.
//

import SwiftUI
import MatchingCard

private struct Constants
{
    static let spacing = 10.0
    static let minWidth = 60.0
    static let minHeight = 70.0
    static let noOfRowsPortrait = 3
    static let noOfRowsLandscape = 2
}

public struct MatchingPairsView: View {
    private var buttonTitle: String {
        return startGame ? "Reset" : "Start"
    }
    @State private var startGame: Bool = false
    @ObservedObject var viewModel: MatchingPairsViewModel
    @ObservedObject var timerViewModel = TimerViewModel.shared
    
    var showAlert: Bool {
        return timerViewModel.showAlert || viewModel.hasWonTheGame
    }

    var showAlertBinding: Binding<Bool> {
        Binding<Bool>(
            get: { self.showAlert },
            set: { _ in }
        )
    }

    var alertType: AlertType? {
        return
            timerViewModel.showAlert ? .timerElapsed :
            viewModel.hasWonTheGame ? .gameWon : 
            nil
    }
    
    public var body: some View {
        VStack {
            Text(viewModel.themeModel.title)
                .font(.title)
                .padding(.top, 10)
            Text("Score: \(viewModel.score)")
                .padding(.top, 2)
                .font(.title2)
            TimerView()
                .hidden(!startGame)
       
            VStack {
                    GeometryReader { geometry in
                        let isPortrait = geometry.size.height > geometry.size.width
                        let rows = isPortrait ? Constants.noOfRowsPortrait : Constants.noOfRowsLandscape
                        let columns = calculateColumns(for: viewModel.cardsView.count, rows: rows)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Constants.spacing), count: columns), spacing: Constants.spacing) {
                            ForEach(Array(viewModel.cardsView.enumerated()), id: \.0)  { index, card in
                                card
                                    .frame(width: cardWidth(for: geometry.size, columns: columns, minWidth: Constants.minWidth),
                                           height: cardHeight(for: geometry.size, rows: rows, minHeight: Constants.minHeight))
                                    .padding(5)
                                    .id(card.id)
                                    .hidden(viewModel.matchedCards[card] ?? false)
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .disabled(!startGame || viewModel.blockScreen)
            buttonView
                
        }.onAppear {
            viewModel.initGame()
        }
        .alert(isPresented: showAlertBinding, content: {
            switch alertType {
            case .timerElapsed:
                return Alert(title: Text("Time's expired"),
                             message: Text("Game over"),
                             dismissButton: .default(Text("OK"), action: {
                           startNewGame(hasWon: false)
                       }))
            case .gameWon:
                timerViewModel.stopTimer()
                return Alert(title: Text("You won 🎉🎉"),
                      message: Text("You have won the game"),
                      dismissButton: .default(Text("OK"), action: {
                    startNewGame(hasWon: true)
                }))
            case nil:
                return Alert(title: Text(""))
            }
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
        .frame(width: 120, height: 40)
        .foregroundColor(.white)
        .background(.gray)
        .cornerRadius(8.0)
        .padding(EdgeInsets(top: 30, leading: 20, bottom: -10, trailing: 20))
    }
    
    func startNewGame(hasWon: Bool) {
        viewModel.saveGameState(hasWon: hasWon)
        startGame.toggle()
        viewModel.initGame()
    }

    func calculateColumns(for count: Int, rows: Int) -> Int {
        return Int((CGFloat(count) / CGFloat(rows)).rounded(.up))
    }
    
    func cardWidth(for size: CGSize, columns: Int, minWidth: CGFloat) -> CGFloat {
        let totalSpacing = CGFloat(columns - 1) * Constants.spacing + CGFloat(columns) * Constants.spacing
        let availableWidth = size.width - totalSpacing
        let calculatedWidth = availableWidth / CGFloat(columns)
        return max(calculatedWidth, minWidth)
    }
    
    func cardHeight(for size: CGSize, rows: Int, minHeight: CGFloat) -> CGFloat {
        let totalSpacing = CGFloat(rows - 1) * Constants.spacing + CGFloat(rows) * Constants.spacing
        let availableHeight = size.height - totalSpacing
        let calculatedHeight = availableHeight / CGFloat(rows)
        return max(calculatedHeight, minHeight)
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
    MatchingPairsView(viewModel: MatchingPairsViewModel(themeModel: ThemeModel(cardColor: CardColor(blue: 0.01, green: 0.549, red: 0.9686), cardSymbol: "⬛️", symbols: ["🎃", "👻", "👿", "💀", "🎃", "👻", "👿", "💀", "🎃", "👻", "👿", "💀"], title: "Halloween")))
}
