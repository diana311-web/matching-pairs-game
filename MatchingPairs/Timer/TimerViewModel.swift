//
//  TimerViewModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import Foundation

private struct Constants
{
    static let countdown = 30
}

class TimerViewModel: ObservableObject {
    private var timer: Timer?
    // TODO: Make them private
    @Published var secondsCountdown: Int = 0
    @Published var showAlert: Bool = false
    static let shared = TimerViewModel()
    
    private init() { }
    
    func startTimer() {
        showAlert = false
        secondsCountdown = Constants.countdown

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if self.secondsCountdown > 0 {
                secondsCountdown -= 1
            } else {
                showAlert = true
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func getElapsedSeconds() -> Int {
        return Constants.countdown - secondsCountdown
    }
}
