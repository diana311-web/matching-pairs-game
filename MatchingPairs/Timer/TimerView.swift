//
//  TimerView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel = TimerViewModel.shared

    var body: some View {
        VStack {
               Text("\(viewModel.secondsCountdown)")
                   .font(.system(size: 20, weight: .bold, design: .monospaced))
                   .foregroundColor(.black)
                   .padding()
                   .background(
                       Circle()
                           .fill(Color.white)
                           .shadow(color: .gray.opacity(0.8), radius: 10, x: 0, y: 10)
                   )
           }
           .onDisappear {
               viewModel.stopTimer()
           }
       }
}

#Preview {
    TimerView()
}
