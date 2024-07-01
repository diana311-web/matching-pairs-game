//
//  ThemeModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import Foundation

public struct ThemeModel: Codable, Identifiable, Equatable {
    
    public static func == (lhs: ThemeModel, rhs: ThemeModel) -> Bool {
        lhs.symbols == rhs.symbols &&
        lhs.cardColor == rhs.cardColor &&
        lhs.cardSymbol == rhs.cardSymbol &&
        lhs.title == rhs.title
    }
    
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
struct CardColor: Codable, Equatable {
    let blue, green, red: Double
    
    public init(blue: Double, green: Double, red: Double) {
           self.blue = blue
           self.green = green
           self.red = red
       }
}
