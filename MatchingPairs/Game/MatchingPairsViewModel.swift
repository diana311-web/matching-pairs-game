//
//  MatchingPairsViewModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//
import Combine
import SwiftUI
import MatchingCard

class MatchingPairsViewModel: ObservableObject {
    @Published var cardsView: [CardView]
    @Published var matchedCards = [CardView: Bool]()
    @Published var score: Int = 0
    @Published var blockScreen: Bool = false
    @ObservedObject var timerViewModel = TimerViewModel.shared
    
    private var cancellable: AnyCancellable?
    
    var lastCard: CardView?
    var themeModel: ThemeModel
    
    init(themeModel: ThemeModel) {
        self.themeModel = themeModel
        cardsView = []
    }
    
    func initGame()
    {
        cardsView.removeAll()
        cardsView =  themeModel.symbols.map { CardView(symbol: $0, backSymbol: themeModel.cardSymbol, backgroundColor: Color(themeModel.cardColor)) { card in
            self.chooseCard(card)
        } }.shuffled()
        
        score = 0
        matchedCards = [:]
        timerViewModel.stopTimer()
        timerViewModel.secondsCountdown = 0
    }
    
    func startGame() {
        initGame()
        timerViewModel.secondsCountdown = 3
        timerViewModel.startTimer()
    }
    
    func chooseCard(_ selectedCard: CardView) {
        if !selectedCard.getIsFaceUp() {
            if selectedCard == lastCard {
                lastCard = nil
            } else if selectedCard.symbol == lastCard?.symbol {
                blockScreen = true
                cancellable = Just(())
                    .delay(for: .seconds(1), scheduler: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.blockScreen = false
                        self?.cardsMatched(selectedCard)
                    }
            } else if lastCard != nil {
                blockScreen = true
                cancellable = Just(())
                    .delay(for: .seconds(0.7), scheduler: RunLoop.main)
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
