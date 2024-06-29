//
//  ThemeModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import Foundation

public struct ThemeModel: Codable, Identifiable {
    public let id: UUID = UUID()
    let cardColor: CardColor
    let cardSymbol: String
    var symbols: [String]
    let title: String

    enum CodingKeys: String, CodingKey {
        case cardColor = "card_color"
        case cardSymbol = "card_symbol"
        case symbols, title
    }
}

// MARK: - CardColor
struct CardColor: Codable {
    let blue, green, red: Double
}
