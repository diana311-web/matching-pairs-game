//
//  MatchingPairsViewModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//
import Combine
import SwiftUI
import MatchingCard

private struct Constants
{
    static let noOfMatchingCards = 2
    static let delayMatchingPair = 0.7
}

enum AlertType {
    case timerElapsed
    case gameWon
}

class MatchingPairsViewModel: ObservableObject {
    @Published var cardsView: [CardView]
    @Published var matchedCards = [CardView: Bool]()
    @Published var score: Int = 0
    @Published var blockScreen: Bool = false
    @ObservedObject var timerViewModel = TimerViewModel.shared
    
    var hasWonTheGame: Bool {
        return noOfCards > 0 && matchedCards.count == noOfCards
    }
    
    var noOfCards: Int {
        return cardsView.count
    }
    
    var totalCountdown: Int {
        return noOfCards * 3
    }
    
    private var cancellable: AnyCancellable?
    
    var lastCard: CardView?
    var themeModel: ThemeModel
    
    var gameState = GameState()
    
    init(themeModel: ThemeModel) {
        self.themeModel = themeModel
        cardsView = []
    }
    
    func initGame()
    {
        gameState = GameState()

        cardsView.removeAll()
        cardsView = themeModel.symbols.map { CardView(symbol: $0, backSymbol: themeModel.cardSymbol, backgroundColor: Color(themeModel.cardColor)) { card in
            self.chooseCard(card)
        } }.shuffled()
        
        score = 0
        matchedCards = [:]
        timerViewModel.stopTimer()
    }
    
    func startGame() {
        initGame()
        timerViewModel.startTimer(countdown: totalCountdown)
    }
    
    func saveGameState(hasWon: Bool) {
        gameState.hasWon = hasWon
        gameState.gridSize = noOfCards
        gameState.elapsedTimeSeconds = totalCountdown - timerViewModel.secondsCountdown

        StorageGameService.shared.saveGamePlayed(gameState)
    }
    
    func chooseCard(_ selectedCard: CardView) {
        if !selectedCard.getIsFaceUp() {
            if selectedCard == lastCard {
                lastCard = nil
            } else if selectedCard.symbol == lastCard?.symbol {
                blockScreen = true
                cancellable = Just(())
                    .delay(for: .seconds(Constants.delayMatchingPair), scheduler: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.blockScreen = false
                        self?.cardsMatched(selectedCard)
                    }
            } else if lastCard != nil {
                gameState.noOfTries += 1
                blockScreen = true
                cancellable = Just(())
                    .delay(for: .seconds(Constants.delayMatchingPair), scheduler: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.blockScreen = false
                        selectedCard.toggleIsFaceUp()
                        self?.lastCard?.toggleIsFaceUp()
                        self?.lastCard = nil
                    }
            } else {
                lastCard = selectedCard
            }
        } else {
            lastCard = nil
        }
    }
    
    func cardsMatched(_ selectedCard: CardView) {
        matchedCards[selectedCard] = true
        if let lastCard = lastCard {
            matchedCards[lastCard] = true
            score += 1
        }
        lastCard = nil
    }
    
}
