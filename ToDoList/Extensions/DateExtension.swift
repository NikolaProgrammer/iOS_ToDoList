
import UIKit

private let format = "dd.MM.yyyy"

extension Date {
    
    private static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
    static func date(from string: String) -> Date {
        return getDateFormatter().date(from: string)!
    }
    
    static func string(from date: Date) -> String {
        return getDateFormatter().string(from: date)
    }
    
}
