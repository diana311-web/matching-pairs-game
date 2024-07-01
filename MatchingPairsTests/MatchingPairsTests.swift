//
//  MatchingPairsTests.swift
//  MatchingPairsTests
//
//  Created by Elena Diana Morosanu on 27.06.2024.
//

import XCTest
@testable import MatchingPairs

final class MatchingPairsTests: XCTestCase {
    var theme: ThemeModel?
    var cardColor: CardColor?
    var cardSymbol: String = ""
    var symbols: [String] = []
    var title: String = ""
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        symbols = ["🎃", "👻", "👿", "💀"]
        title = "Halloween"
        cardColor = CardColor(blue: 0.01, green: 0.549, red: 0.9686)
        cardSymbol = "⬛️"
        theme = ThemeModel(cardColor: cardColor!, cardSymbol: cardSymbol, symbols: symbols, title: title)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        theme = nil
    }

    func testThemeModelInit() throws {
        XCTAssertEqual(theme?.cardColor.blue, 0.01)
        XCTAssertEqual(theme?.cardColor.green, 0.549)
        XCTAssertEqual(theme?.cardColor.red, 0.9686)
        XCTAssertEqual(theme?.title, title)
        XCTAssertEqual(theme?.cardSymbol, cardSymbol)
        XCTAssertEqual(theme?.symbols, symbols)
    }
    
    func testThemeModelEncoding() throws {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(theme)
        
        XCTAssertNotNil(data)

        if let jsonString = String(data: data!, encoding: .utf8) {
           XCTAssertNotNil(jsonString)
        } else {
           XCTFail("Failed to encode JSON")
        }
    }
    
    func testThemeModelDecoding() throws {
        var result = "{\"card_symbol\":\"⬛️\",\"title\":\"Halloween\",\"symbols\":[\"🎃\",\"👻\",\"👿\",\"💀\"],\"card_color\":{\"red\":0.9686,\"blue\":0.01,\"green\":0.549}}".data(using: .utf8)
     
        let data = try? JSONDecoder().decode(ThemeModel.self, from: result!)
        XCTAssertEqual(data, theme)
    }
    
    func testGameScore() throws {
        var gameState = GameState()
        gameState.gridSize = 8
        gameState.noOfTries = 5
        gameState.elapsedTimeSeconds = 15
        gameState.totalGameSeconds = 30
        gameState.hasWon = true
        
        XCTAssertEqual(gameState.score, 10)
        
        gameState.hasWon = false
        XCTAssertEqual(gameState.score, 5)
        
        gameState.elapsedTimeSeconds = 0
        gameState.noOfTries = 0
        XCTAssertEqual(gameState.score, 0)
    }
    
    func testTimer() throws {
        let timerViewModel = TimerViewModel.shared
        
        XCTAssert(timerViewModel.showAlert == false && timerViewModel.secondsCountdown == 0)
        timerViewModel.secondsCountdown = 10
        timerViewModel.startTimer(countdown: 3)
        XCTAssert(timerViewModel.secondsCountdown > 0)
        
        let timerExpectation = expectation(description: "Timer expectation")

        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { timer in
            timerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 4.0) { error in
            if let error = error {
                XCTFail("Timeout waiting for timer: \(error)")
            }
            
            XCTAssertEqual(timerViewModel.showAlert, true)
            XCTAssertEqual(timerViewModel.secondsCountdown, 0)
        }
    }
    
    func testThemeSelectionViewModel() throws {
        let themeSelection = ThemeSelectionViewModel(urlString: EndpointURL)
        
        XCTAssertTrue(themeSelection.themes.count == 0)
        themeSelection.fetchData()
        XCTAssertTrue(themeSelection.themes.count > 0)
    }
}
