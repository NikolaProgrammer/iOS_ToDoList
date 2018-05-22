
import UIKit

private let format = "dd.MM.yyyy"

extension Date {
    
    private static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
    static func date(from string: String, formatter: DateFormatter = getDateFormatter()) -> Date {
        return formatter.date(from: string)!
    }
    
    static func string(from date: Date, formatter: DateFormatter = getDateFormatter()) -> String {
        return formatter.string(from: date)
    }
    
}
