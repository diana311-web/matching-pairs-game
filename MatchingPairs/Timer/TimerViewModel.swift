//
//  TimerViewModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import Foundation

class TimerViewModel: ObservableObject {
    private var timer: Timer?
    @Published var secondsCountdown: Int = 0
    @Published var showAlert: Bool = false
    static let shared = TimerViewModel()
    
    private init() { }
    
    func startTimer() {
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
}
