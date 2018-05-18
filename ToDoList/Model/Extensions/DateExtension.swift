
import UIKit

extension Date {
    
    private static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    
    static func date(from string: String) -> Date {
        let formatter = getDateFormatter()
        return formatter.date(from: string)!
    }
    
    static func string(from date: Date) -> String {
        let formatter = getDateFormatter()
        return formatter.string(from: date)
    }
    
}
