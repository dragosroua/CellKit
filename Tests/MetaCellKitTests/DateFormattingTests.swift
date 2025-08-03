import XCTest
@testable import MetaCellKit
import Foundation

final class DateFormattingTests: XCTestCase {
    
    var dateFormatter: DateFormattingUtility!
    
    override func setUp() {
        super.setUp()
        dateFormatter = DateFormattingUtility.shared
    }
    
    override func tearDown() {
        dateFormatter = nil
        super.tearDown()
    }
    
    // MARK: - Date Format Style Tests
    
    func testShortDateFormat() {
        let date = createDate(year: 2024, month: 1, day: 15)
        let formatted = dateFormatter.formatDate(date, style: .short)
        
        XCTAssertEqual(formatted, "15 Jan")
    }
    
    func testMediumDateFormat() {
        let date = createDate(year: 2024, month: 1, day: 15)
        let formatted = dateFormatter.formatDate(date, style: .medium)
        
        XCTAssertEqual(formatted, "15 Jan 2024")
    }
    
    func testLongDateFormat() {
        let date = createDate(year: 2024, month: 1, day: 15)
        let formatted = dateFormatter.formatDate(date, style: .long)
        
        // Long format varies by locale, just verify it's not empty
        XCTAssertFalse(formatted.isEmpty)
        XCTAssertTrue(formatted.contains("January") || formatted.contains("Jan"))
    }
    
    func testTimeFormat() {
        let date = createDateTime(year: 2024, month: 1, day: 15, hour: 14, minute: 30)
        let formatted = dateFormatter.formatDate(date, style: .time)
        
        // Time format varies by locale and 12/24 hour setting
        XCTAssertFalse(formatted.isEmpty)
        XCTAssertTrue(formatted.contains("2:30") || formatted.contains("14:30"))
    }
    
    // MARK: - Relative Date Format Tests
    
    func testRelativeDateJustNow() {
        let date = Date().addingTimeInterval(-30) // 30 seconds ago
        let formatted = dateFormatter.formatDate(date, style: .relative)
        
        XCTAssertEqual(formatted, "Just now")
    }
    
    func testRelativeDateMinutesAgo() {
        let date = Date().addingTimeInterval(-300) // 5 minutes ago
        let formatted = dateFormatter.formatDate(date, style: .relative)
        
        XCTAssertEqual(formatted, "5m ago")
    }
    
    func testRelativeDateHoursAgo() {
        let date = Date().addingTimeInterval(-7200) // 2 hours ago
        let formatted = dateFormatter.formatDate(date, style: .relative)
        
        XCTAssertEqual(formatted, "2h ago")
    }
    
    func testRelativeDateDaysAgo() {
        let date = Date().addingTimeInterval(-172800) // 2 days ago
        let formatted = dateFormatter.formatDate(date, style: .relative)
        
        XCTAssertEqual(formatted, "2d ago")
    }
    
    func testRelativeDateWeeksAgo() {
        let date = Date().addingTimeInterval(-1209600) // 2 weeks ago
        let formatted = dateFormatter.formatDate(date, style: .relative)
        
        // Should fall back to medium format for dates older than a week
        XCTAssertTrue(formatted.contains("Jan") || formatted.contains("Feb") || formatted.contains("Dec"))
    }
    
    // MARK: - Edge Cases
    
    func testFutureDates() {
        let futureDate = Date().addingTimeInterval(86400) // Tomorrow
        let formatted = dateFormatter.formatDate(futureDate, style: .relative)
        
        // Future dates should fall back to medium format
        XCTAssertFalse(formatted.contains("ago"))
    }
    
    func testDateFormattingConsistency() {
        let testDate = createDate(year: 2024, month: 6, day: 15)
        
        let short1 = dateFormatter.formatDate(testDate, style: .short)
        let short2 = dateFormatter.formatDate(testDate, style: .short)
        
        XCTAssertEqual(short1, short2, "Date formatting should be consistent")
    }
    
    // MARK: - Integration with CellDataProtocol
    
    func testDateInCellData() {
        struct TestData: CellDataProtocol {
            let title: String
            let createdDate: Date
            let dueDate: Date
        }
        
        let testData = TestData(
            title: "Task with Dates",
            createdDate: Date().addingTimeInterval(-86400), // Yesterday
            dueDate: Date().addingTimeInterval(86400) // Tomorrow
        )
        
        // Verify that our test data conforms to CellDataProtocol
        XCTAssertTrue(testData is CellDataProtocol)
    }
    
    func testMultipleDateFormats() {
        let baseDate = createDate(year: 2024, month: 3, day: 15)
        
        let formats: [DateFormatStyle] = [.short, .medium, .long, .time]
        
        for format in formats {
            let result = dateFormatter.formatDate(baseDate, style: format)
            XCTAssertFalse(result.isEmpty, "Format \(format) should produce non-empty result")
        }
    }
    
    // MARK: - Helper Methods
    
    private func createDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        components.minute = 0
        components.second = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func createDateTime(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
}