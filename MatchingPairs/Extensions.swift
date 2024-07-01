//
//  Extensions.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 30.06.2024.
//

import Foundation

private struct Constants {
    static let locale = "en_US_POSIX"
    static let formatDate = "yyyy-MM-dd HH:mm:ss"
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.formatDate
        dateFormatter.locale = Locale(identifier: Constants.locale)
        
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.formatDate
        dateFormatter.locale = Locale(identifier: Constants.locale)
        
        return dateFormatter.string(from: self)
    }
   
}
