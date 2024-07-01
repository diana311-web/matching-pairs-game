//
//  MatchingPairsViewModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//
import Combine
import MatchingCard
import SwiftUI

private struct Constants
{
    static let noOfRetries = 3
    static let cachedThemesKey = "cachedThemes"
    static let lastCacheUpdateKey = "lastCacheUpdate"
    static let cacheNoOfSeconds = 1800.0 // 30 minutes
}

class ThemeSelectionViewModel: ObservableObject {
    enum ScreenState {
        case loading
        case loaded
    }
    @Published var themes: [ThemeModel] = []
    @Published var errorState: ErrorMessage?
    @Published var state: ScreenState = .loading
    @Published var selectedTheme: ThemeModel?
    private var networkMonitor = NetworkMonitor.shared
    private let urlString: String
    private var cancellables = Set<AnyCancellable>()
    
    private var cachedThemes: [ThemeModel]?
    private var lastCacheUpdate: Date?
    
    private var storageCachedThemes = StorageService(storageKey: Constants.cachedThemesKey)
    private var storageLastUpdate = StorageService(storageKey: Constants.lastCacheUpdateKey)
    
    init(urlString: String) {
        self.urlString = urlString
        self.lastCacheUpdate = storageLastUpdate.load(String.self)?.toDate()
        self.cachedThemes = storageCachedThemes.loadArray(ThemeModel.self)
    }

    func fetchData() {
        if let cachedThemes = cachedThemes, !cachedThemes.isEmpty, let lastCacheUpdate = lastCacheUpdate, (!networkMonitor.isConnected || lastCacheUpdate.timeIntervalSinceNow > -Constants.cacheNoOfSeconds) {
            self.state = .loaded
            themes = cachedThemes
            print("Using cached themes, time remaining \(Int(lastCacheUpdate.timeIntervalSinceNow + Constants.cacheNoOfSeconds))")
            return
        }
        
        URLNetworkManager.shared.fetchData(from: urlString)
            .retry(Constants.noOfRetries)
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
                
                print("Got new themes")
                
                themes = setThemes(data)
                
                cachedThemes = themes
                lastCacheUpdate = Date()
                
                saveCache()
            }
            .store(in: &cancellables)
    }
    
    func setThemes(_ data: [ThemeModel]) -> [ThemeModel] {
        return data.map { theme in
            var modifiedTheme = theme
            modifiedTheme.symbols = theme.symbols.flatMap { [$0, $0] }
            return modifiedTheme
        }
    }
    
    func saveCache() {
        if let lastCacheUpdate = lastCacheUpdate, let cachedThemes = cachedThemes, !cachedThemes.isEmpty {
            storageLastUpdate.save(lastCacheUpdate.toString())
            storageCachedThemes.saveArray(cachedThemes)
        }
    }
}
