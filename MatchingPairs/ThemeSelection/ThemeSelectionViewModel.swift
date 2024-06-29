//
//  MatchingPairsViewModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import Foundation
import Combine

class ThemeSelectionViewModel: ObservableObject {
    enum ScreenState {
        case loading
        case loaded
    }
    @Published var themes: [ThemeModel] = []
    @Published var errorState: ErrorMessage?
    @Published var state: ScreenState = .loading
    @Published var selectedTheme: ThemeModel?
    private let urlString: String
    private var cancellables = Set<AnyCancellable>()
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func fetchData() {
        URLNetworkManager.shared.fetchData(from: urlString)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.state = .loaded
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorState = ErrorMessage(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] (data: [ThemeModel]) in
                guard let self = self else { return }
                themes = data.map { theme in
                    var modifiedTheme = theme
                    modifiedTheme.symbols = theme.symbols.flatMap { [$0, $0] }
                    return modifiedTheme
                }
                print(data)
                print("Themes", themes)
            }
            .store(in: &cancellables)
    }
    
    
}
