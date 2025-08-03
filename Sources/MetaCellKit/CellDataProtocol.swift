import Foundation

public protocol CellDataProtocol {
    // This protocol serves as a marker for data types that can be bound to MetaCellKit
    // The actual data binding happens through reflection in the MetaCellKit implementation
    // This allows for automatic date formatting and flexible content handling
}

// MARK: - Default Implementations for Common Types

extension String: CellDataProtocol {}
extension Int: CellDataProtocol {}
extension Double: CellDataProtocol {}
extension Date: CellDataProtocol {}

// MARK: - Date Formatting Utilities

public class DateFormattingUtility {
    public static let shared = DateFormattingUtility()
    
    private let shortFormatter: DateFormatter
    private let mediumFormatter: DateFormatter
    private let longFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    private init() {
        shortFormatter = DateFormatter()
        shortFormatter.dateFormat = "dd MMM"
        
        mediumFormatter = DateFormatter()
        mediumFormatter.dateFormat = "dd MMM yyyy"
        
        longFormatter = DateFormatter()
        longFormatter.dateStyle = .full
        longFormatter.timeStyle = .none
        
        timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
    }
    
    public func formatDate(_ date: Date, style: DateFormatStyle = .medium) -> String {
        switch style {
        case .short:
            return shortFormatter.string(from: date)
        case .medium:
            return mediumFormatter.string(from: date)
        case .long:
            return longFormatter.string(from: date)
        case .time:
            return timeFormatter.string(from: date)
        case .relative:
            return formatRelativeDate(date)
        }
    }
    
    private func formatRelativeDate(_ date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 60 {
            return "Just now"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)m ago"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)h ago"
        } else if timeInterval < 604800 {
            let days = Int(timeInterval / 86400)
            return "\(days)d ago"
        } else {
            return mediumFormatter.string(from: date)
        }
    }
}

public enum DateFormatStyle {
    case short      // "15 Jan"
    case medium     // "15 Jan 2024"
    case long       // "Monday, January 15, 2024"
    case time       // "3:30 PM"
    case relative   // "2h ago", "3d ago", etc.
}