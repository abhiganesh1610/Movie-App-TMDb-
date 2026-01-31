//
//  extention.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//

import Foundation

extension Int {
    
    var compactVotes: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1

        switch self {
        case 0..<1000:
            return "\(Int(self))"
        case 1000..<1_000_000:
            return "\(formatter.string(from: NSNumber(value: self/1000)) ?? "0")K"
        case 1_000_000..<1_000_000_000:
            return "\(formatter.string(from: NSNumber(value: self/1_000_000)) ?? "0")M"
        default:
            return "\(formatter.string(from: NSNumber(value: self/1_000_000_000)) ?? "0")B"
        }
    }
    
    var hoursAndMinutes: String {
        let hours = self / 60
        let minutes = self % 60
        if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes)min"
        }
    }
}



extension String {
    var formattedDate: String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
