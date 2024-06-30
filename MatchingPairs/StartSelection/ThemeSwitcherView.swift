//
//  ThemeSwitcherView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 30.06.2024.
//

import SwiftUI

struct ThemeSwitcherView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    setTheme(.light)
                }) {
                    Text("Light Mode")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 10)
                
                Button(action: {
                    setTheme(.dark)
                }) {
                    Text("Dark Mode")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 10)
                
                Button(action: {
                    setTheme(.system)
                }) {
                    Text("System Default")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Select Theme")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }
    
    private func setTheme(_ theme: Theme) {
        ThemeManager.shared.setTheme(theme)
        isPresented = false
    }
}
#Preview {
    ThemeSwitcherView(isPresented: .constant(true))
}
