//
//  MatchingPairsViewModel.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import Foundation
import Combine
import MatchingCard

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
    private let urlString: String
    private var cancellables = Set<AnyCancellable>()
    
    private var cachedThemes: [ThemeModel]?
    private var lastCacheUpdate: Date?
    
    private var storageCachedThemes = StorageService(storageKey: Constants.cachedThemesKey)
    private var storageLastUpdate = StorageService(storageKey: Constants.lastCacheUpdateKey)
    
    init(urlString: String) {
        self.urlString = urlString
        self.lastCacheUpdate = stringToDate(storageLastUpdate.load(String.self))
        self.cachedThemes = storageCachedThemes.loadArray(ThemeModel.self)
    }
    
    
    let formatDate = "yyyy-MM-dd HH:mm:ss"
    func stringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: dateString)
    }

    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: date)
    }

    func fetchData() {
        // TODO: Daca nu are conexiune, reseteaza timer-ul

        if let cachedThemes = cachedThemes, !cachedThemes.isEmpty, let lastCacheUpdate = lastCacheUpdate, lastCacheUpdate.timeIntervalSinceNow > -Constants.cacheNoOfSeconds {
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
            storageLastUpdate.save(dateToString(lastCacheUpdate))
            storageCachedThemes.saveArray(cachedThemes)
        }
    }
}
