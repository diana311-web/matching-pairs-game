//
//  SelectedTheme.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 30.06.2024.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var selectedTheme: Theme = .system
    
    let storageKey = "selectedTheme"
    
    static let shared = ThemeManager()
    private init() {
        if let savedTheme = UserDefaults.standard.string(forKey: storageKey),
           let theme = Theme(rawValue: savedTheme) {
            selectedTheme = theme
        }
    }
    
    public func setTheme(_ theme: Theme) {
        selectedTheme = theme
        updateTheme()
        
        UserDefaults.standard.set(theme.rawValue, forKey: storageKey)
    }
    
    public func updateTheme() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
             switch selectedTheme {
             case .light:
                 windowScene.keyWindow?.overrideUserInterfaceStyle = .light
             case .dark:
                 windowScene.keyWindow?.overrideUserInterfaceStyle = .dark
             case .system:
                 windowScene.keyWindow?.overrideUserInterfaceStyle = .unspecified
             }
         }
    }
}

enum Theme: String, CaseIterable, Identifiable {
    case light, dark, system
    var id: String { self.rawValue }
}
