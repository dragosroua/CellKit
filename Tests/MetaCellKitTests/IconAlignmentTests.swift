import XCTest
@testable import MetaCellKit

final class IconAlignmentTests: XCTestCase {
    
    var cell: MetaCellKit!
    
    override func setUp() {
        super.setUp()
        cell = MetaCellKit(style: .default, reuseIdentifier: "test")
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    // MARK: - IconAlignment Enum Tests
    
    func testIconAlignmentCases() {
        // Test that all cases exist
        let topAlignment = IconAlignment.top
        let middleAlignment = IconAlignment.middle
        let bottomAlignment = IconAlignment.bottom
        
        XCTAssertNotNil(topAlignment)
        XCTAssertNotNil(middleAlignment)
        XCTAssertNotNil(bottomAlignment)
    }
    
    // MARK: - Configuration Tests
    
    func testDefaultIconAlignment() {
        let config = CellConfiguration()
        XCTAssertEqual(config.iconAlignment, .middle)
    }
    
    func testIconAlignmentConfigurationTop() {
        var config = CellConfiguration()
        config.iconAlignment = .top
        
        XCTAssertEqual(config.iconAlignment, .top)
    }
    
    func testIconAlignmentConfigurationBottom() {
        var config = CellConfiguration()
        config.iconAlignment = .bottom
        
        XCTAssertEqual(config.iconAlignment, .bottom)
    }
    
    func testInitializerWithIconAlignment() {
        let config = CellConfiguration(
            style: .master,
            metadataViewCount: 2,
            iconAlignment: .top
        )
        
        XCTAssertEqual(config.iconAlignment, .top)
        XCTAssertEqual(config.style, .master)
        XCTAssertEqual(config.metadataViewCount, 2)
    }
    
    // MARK: - Cell Configuration Tests
    
    func testCellConfigurationWithTopAlignment() {
        var config = CellConfiguration()
        config.iconAlignment = .top
        
        let testData = TestIconAlignmentData(title: "Test Title", icon: "star")
        cell.configure(with: testData, configuration: config)
        
        // Verify configuration is stored
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .top)
    }
    
    func testCellConfigurationWithMiddleAlignment() {
        var config = CellConfiguration()
        config.iconAlignment = .middle
        
        let testData = TestIconAlignmentData(title: "Test Title", icon: "star")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .middle)
    }
    
    func testCellConfigurationWithBottomAlignment() {
        var config = CellConfiguration()
        config.iconAlignment = .bottom
        
        let testData = TestIconAlignmentData(title: "Test Title", icon: "star")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .bottom)
    }
    
    // MARK: - Integration with Editing Tests
    
    func testIconAlignmentWithEditingEnabled() {
        var config = CellConfiguration()
        config.iconAlignment = .top
        config.editing.isEditingEnabled = true
        config.editing.enablesDynamicHeight = true
        
        let testData = TestIconAlignmentData(title: "Multi-line\nText Content", icon: "doc.text")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .top)
        XCTAssertTrue(cell.currentConfiguration?.editing.isEditingEnabled ?? false)
    }
    
    func testIconAlignmentWithMultipleMetadataViews() {
        var config = CellConfiguration()
        config.iconAlignment = .bottom
        config.metadataViewCount = 3
        
        let metadata1 = MetadataViewConfig(text: "Priority", backgroundColor: .systemRed)
        let metadata2 = MetadataViewConfig(text: "Context", backgroundColor: .systemBlue)
        let metadata3 = MetadataViewConfig(text: "Due", backgroundColor: .systemGreen)
        config.metadataConfigs = [metadata1, metadata2, metadata3]
        
        let testData = TestIconAlignmentData(title: "Task with metadata", icon: "checkmark.circle")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .bottom)
        XCTAssertEqual(cell.currentConfiguration?.metadataViewCount, 3)
    }
    
    // MARK: - Different Cell Styles Tests
    
    func testIconAlignmentWithMasterStyle() {
        var config = CellConfiguration()
        config.style = .master
        config.iconAlignment = .top
        
        let testData = TestIconAlignmentData(title: "Master Style Cell", icon: "house")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.currentConfiguration?.style, .master)
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .top)
    }
    
    func testIconAlignmentWithDetailStyle() {
        var config = CellConfiguration()
        config.style = .detail
        config.iconAlignment = .bottom
        
        let testData = TestIconAlignmentData(title: "Detail Style Cell", icon: "info.circle")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.currentConfiguration?.style, .detail)
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .bottom)
    }
    
    // MARK: - Configuration Persistence Tests
    
    func testIconAlignmentPersistsAfterReconfiguration() {
        // Initial configuration
        var config1 = CellConfiguration()
        config1.iconAlignment = .top
        
        let testData1 = TestIconAlignmentData(title: "First Config", icon: "1.circle")
        cell.configure(with: testData1, configuration: config1)
        
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .top)
        
        // Reconfigure with different alignment
        var config2 = CellConfiguration()
        config2.iconAlignment = .bottom
        
        let testData2 = TestIconAlignmentData(title: "Second Config", icon: "2.circle")
        cell.configure(with: testData2, configuration: config2)
        
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .bottom)
    }
    
    // MARK: - Backward Compatibility Tests
    
    func testLegacyConfigureMethodUsesDefaultAlignment() {
        let testData = TestIconAlignmentData(title: "Legacy Config", icon: "star")
        cell.configure(with: testData, metadataViews: 1, style: .master)
        
        // Should use default middle alignment
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .middle)
    }
    
    // MARK: - Edge Cases
    
    func testIconAlignmentWithoutIcon() {
        var config = CellConfiguration()
        config.iconAlignment = .top
        
        let testData = TestIconAlignmentData(title: "No Icon", icon: nil)
        cell.configure(with: testData, configuration: config)
        
        // Configuration should still be set even without icon
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .top)
    }
    
    func testIconAlignmentWithEmptyTitle() {
        var config = CellConfiguration()
        config.iconAlignment = .bottom
        
        let testData = TestIconAlignmentData(title: "", icon: "star")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .bottom)
    }
    
    func testIconAlignmentWithLongText() {
        var config = CellConfiguration()
        config.iconAlignment = .top
        config.useTitleTextView = true
        
        let longText = "This is a very long title that spans multiple lines and should test how icon alignment works with multi-line text content in a table view cell."
        let testData = TestIconAlignmentData(title: longText, icon: "doc.text")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .top)
        XCTAssertTrue(cell.currentConfiguration?.useTitleTextView ?? false)
    }
}

// MARK: - Test Data

struct TestIconAlignmentData: CellDataProtocol {
    let title: String
    let icon: String?
    
    init(title: String, icon: String?) {
        self.title = title
        self.icon = icon
    }
}

// MARK: - IconAlignment Equatable Extension

extension IconAlignment: Equatable {
    public static func == (lhs: IconAlignment, rhs: IconAlignment) -> Bool {
        switch (lhs, rhs) {
        case (.top, .top), (.middle, .middle), (.bottom, .bottom):
            return true
        default:
            return false
        }
    }
}