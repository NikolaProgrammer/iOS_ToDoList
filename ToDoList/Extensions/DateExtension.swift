
import UIKit

private let format = "dd.MM.yyyy"

extension Date {
    
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }
    
    var string: String {
        return Date.string(from: self)
    }
    
    private static func getDateFormatter(pattern: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter
    }
    
    static func date(from string: String, format: String = format) -> Date {
        return Date.getDateFormatter(pattern: format).date(from: string)!
    }
    
    static func string(from date: Date, format: String = format) -> String {
        return Date.getDateFormatter(pattern: format).string(from: date)
    }
    
}

