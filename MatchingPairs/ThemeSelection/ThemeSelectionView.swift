//
//  ThemeSelectionView.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import SwiftUI

public let EndpointURL = "https://firebasestorage.googleapis.com/v0/b/concentrationgame-20753.appspot.com/o/themes.json?alt=media&token=6898245a-0586-4fed-b30e-5078faeba078"

struct ThemeSelectionView: View {
    @StateObject private var viewModel = ThemeSelectionViewModel(urlString: EndpointURL)
    @State private var navigateToDetail = false
    
    private let defaultTheme = ThemeModel(cardColor: CardColor(blue: 0.01, green: 0.549, red: 0.9686), cardSymbol: "⬛️", symbols: ["🎃", "👻", "👿", "💀"], title: "Halloween")
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded:
                List(viewModel.themes) { theme in
                    Button(action: {
                        viewModel.selectedTheme = theme
                        navigateToDetail = true
                    }) {
                        HStack {
                            Text(theme.title)
                                .foregroundColor(Color("themeWhite"))
                            Spacer()
                            Text(theme.symbols[0])
                        }
                    }
                }
                .navigationTitle("Select a Theme")
                .background(
                    NavigationLink(destination: MatchingPairsView(viewModel: MatchingPairsViewModel(themeModel: viewModel.selectedTheme ??
                                                                                                    defaultTheme)), isActive: $navigateToDetail) {
                            EmptyView()
                        }
                        .hidden()
                )
            }
        }
        .alert(item: Binding<ErrorMessage?>(
            get: { self.viewModel.errorState }, set: { _ in self.viewModel.errorState = nil }
        ), content: { error in
            Alert(title: Text("Ups.."),
                  message: Text(viewModel.errorState?.message ?? ""),
                  dismissButton: .default(Text("Ok"), action: {
            }))
        })
        .onAppear {
            viewModel.fetchData()
        }
    }
}

#Preview {
    ThemeSelectionView()
}
