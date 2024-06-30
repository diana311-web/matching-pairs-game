//
//  CardView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 27.06.2024.
//

import SwiftUI

struct CardView: View, Equatable, Hashable {
    public static func == (lhs: CardView, rhs: CardView) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public var id = UUID()
    public var symbol: String
    
    private var backgroundColor: Color
    private var backSymbol: String = "❖"
    @State private var isFaceUp: Bool = false
    @State private var rotationDegrees: Double = 0
    
    var onTap: (_ x: CardView) -> Void
    
    public init(symbol: String, backSymbol: String, backgroundColor: Color, onTap: @escaping (_ x: CardView) -> Void) {
        self.symbol = symbol
        self.backSymbol = backSymbol
        self.backgroundColor = backgroundColor
        self.onTap = onTap
    }
    
    public func getIsFaceUp() -> Bool {
        return isFaceUp
    }
    
    public func toggleIsFaceUp() {
        isFaceUp.toggle()
    }
    
    public var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(backgroundColor)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text(String(isFaceUp ? symbol : backSymbol))
            }
        }
        .rotation3DEffect(
            Angle(degrees: rotationDegrees),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                onTap(self)
                
                rotationDegrees += 180
                isFaceUp.toggle()
            }
        }
    }
}
