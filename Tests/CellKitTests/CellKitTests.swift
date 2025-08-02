import XCTest
@testable import CellKit
import UIKit

final class CellKitTests: XCTestCase {
    
    var cell: CellKit!
    
    override func setUp() {
        super.setUp()
        cell = CellKit(style: .default, reuseIdentifier: "TestCell")
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    // MARK: - Basic Configuration Tests
    
    func testBasicConfiguration() {
        let config = CellConfiguration(
            style: .master,
            metadataViewCount: 0,
            showBadge: true,
            showDisclosure: true
        )
        
        let data = MockCellData(title: "Test Title", badge: "5")
        cell.configure(with: data, configuration: config)
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell.reuseIdentifier, "TestCell")
    }
    
    func testSimpleConfiguration() {
        let data = MockCellData(title: "Simple Test", badge: "3")
        cell.configure(with: data, metadataViews: 1, style: .detail)
        
        XCTAssertNotNil(cell)
    }
    
    // MARK: - Style Tests
    
    func testMasterStyle() {
        let config = CellConfiguration(style: .master)
        let data = MockCellData(title: "Master Style Test")
        
        cell.configure(with: data, configuration: config)
        
        // Verify that configuration doesn't crash
        XCTAssertNotNil(cell)
    }
    
    func testDetailStyle() {
        let config = CellConfiguration(style: .detail)
        let data = MockCellData(title: "Detail Style Test")
        
        cell.configure(with: data, configuration: config)
        
        // Verify that configuration doesn't crash
        XCTAssertNotNil(cell)
    }
    
    // MARK: - Metadata View Tests
    
    func testSingleMetadataView() {
        let metadataConfig = MetadataViewConfig(
            icon: UIImage(systemName: "clock"),
            text: "Due Soon",
            backgroundColor: .systemOrange
        )
        
        let config = CellConfiguration(
            metadataViewCount: 1,
            metadataConfigs: [metadataConfig]
        )
        
        let data = MockCellData(title: "Task with Metadata")
        cell.configure(with: data, configuration: config)
        
        XCTAssertNotNil(cell)
    }
    
    func testDualMetadataViews() {
        let metadata1 = MetadataViewConfig(
            icon: UIImage(systemName: "at"),
            text: "Context",
            backgroundColor: .systemBlue
        )
        
        let metadata2 = MetadataViewConfig(
            icon: UIImage(systemName: "clock"),
            text: "Due Date",
            backgroundColor: .systemGreen
        )
        
        let config = CellConfiguration(
            metadataViewCount: 2,
            metadataConfigs: [metadata1, metadata2]
        )
        
        let data = MockCellData(title: "Task with Two Metadata")
        cell.configure(with: data, configuration: config)
        
        XCTAssertNotNil(cell)
    }
    
    func testTripleMetadataViews() {
        let metadata1 = MetadataViewConfig(text: "High", backgroundColor: .systemRed)
        let metadata2 = MetadataViewConfig(text: "Work", backgroundColor: .systemBlue)
        let metadata3 = MetadataViewConfig(text: "Today", backgroundColor: .systemOrange)
        
        let config = CellConfiguration(
            metadataViewCount: 3,
            metadataConfigs: [metadata1, metadata2, metadata3]
        )
        
        let data = MockCellData(title: "Task with Three Metadata")
        cell.configure(with: data, configuration: config)
        
        XCTAssertNotNil(cell)
    }
    
    // MARK: - Data Binding Tests
    
    func testDataBindingWithString() {
        let data = MockCellData(title: "String Title", badge: "10")
        cell.configure(with: data, metadataViews: 0)
        
        XCTAssertNotNil(cell)
    }
    
    func testDataBindingWithIcon() {
        let data = MockCellDataWithIcon(
            title: "Task with Icon",
            icon: UIImage(systemName: "star.fill"),
            badge: "5"
        )
        cell.configure(with: data, metadataViews: 0)
        
        XCTAssertNotNil(cell)
    }
    
    func testDataBindingWithDate() {
        let futureDate = Date().addingTimeInterval(86400) // Tomorrow
        let data = MockCellDataWithDate(
            title: "Task with Date",
            dueDate: futureDate,
            context: "Important"
        )
        cell.configure(with: data, metadataViews: 1)
        
        XCTAssertNotNil(cell)
    }
    
    // MARK: - Cell Reuse Tests
    
    func testPrepareForReuse() {
        let data = MockCellData(title: "Original Title", badge: "5")
        cell.configure(with: data, metadataViews: 2)
        
        cell.prepareForReuse()
        
        // Verify cell can be reused without crashing
        let newData = MockCellData(title: "New Title", badge: "3")
        cell.configure(with: newData, metadataViews: 1)
        
        XCTAssertNotNil(cell)
    }
    
    // MARK: - Badge Configuration Tests
    
    func testBadgeVisibility() {
        let configWithBadge = CellConfiguration(showBadge: true)
        let configWithoutBadge = CellConfiguration(showBadge: false)
        
        let data = MockCellData(title: "Test", badge: "5")
        
        cell.configure(with: data, configuration: configWithBadge)
        // Badge should be configured but testing visibility requires UI testing
        
        cell.configure(with: data, configuration: configWithoutBadge)
        // Badge should be hidden but testing visibility requires UI testing
        
        XCTAssertNotNil(cell)
    }
    
    // MARK: - Disclosure Configuration Tests
    
    func testDisclosureVisibility() {
        let configWithDisclosure = CellConfiguration(showDisclosure: true)
        let configWithoutDisclosure = CellConfiguration(showDisclosure: false)
        
        let data = MockCellData(title: "Test")
        
        cell.configure(with: data, configuration: configWithDisclosure)
        cell.configure(with: data, configuration: configWithoutDisclosure)
        
        XCTAssertNotNil(cell)
    }
    
    // MARK: - Title Configuration Tests
    
    func testTitleLabelVsTextView() {
        let configWithLabel = CellConfiguration(useTitleTextView: false)
        let configWithTextView = CellConfiguration(useTitleTextView: true)
        
        let data = MockCellData(title: "Test Title")
        
        cell.configure(with: data, configuration: configWithLabel)
        cell.configure(with: data, configuration: configWithTextView)
        
        XCTAssertNotNil(cell)
    }
}

// MARK: - Mock Data Types

struct MockCellData: CellDataProtocol {
    let title: String
    let badge: String?
    
    init(title: String, badge: String? = nil) {
        self.title = title
        self.badge = badge
    }
}

struct MockCellDataWithIcon: CellDataProtocol {
    let title: String
    let icon: UIImage?
    let badge: String?
    
    init(title: String, icon: UIImage? = nil, badge: String? = nil) {
        self.title = title
        self.icon = icon
        self.badge = badge
    }
}

struct MockCellDataWithDate: CellDataProtocol {
    let title: String
    let dueDate: Date
    let context: String
    
    init(title: String, dueDate: Date, context: String) {
        self.title = title
        self.dueDate = dueDate
        self.context = context
    }
}