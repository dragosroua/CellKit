import XCTest
@testable import MetaCellKit
import UIKit

final class MetadataViewTests: XCTestCase {
    
    var metadataView: MetadataView!
    
    override func setUp() {
        super.setUp()
        metadataView = MetadataView()
    }
    
    override func tearDown() {
        metadataView = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertTrue(metadataView.isHidden, "MetadataView should be hidden initially")
        XCTAssertNil(metadataView.text)
        XCTAssertNil(metadataView.icon)
        XCTAssertNil(metadataView.config)
    }
    
    // MARK: - Text Property Tests
    
    func testTextAssignment() {
        metadataView.text = "Test Text"
        
        XCTAssertEqual(metadataView.text, "Test Text")
        XCTAssertFalse(metadataView.isHidden, "MetadataView should be visible when text is set")
    }
    
    func testEmptyTextHidesView() {
        metadataView.text = "Visible"
        XCTAssertFalse(metadataView.isHidden)
        
        metadataView.text = ""
        XCTAssertTrue(metadataView.isHidden, "MetadataView should be hidden when text is empty")
        
        metadataView.text = nil
        XCTAssertTrue(metadataView.isHidden, "MetadataView should be hidden when text is nil")
    }
    
    // MARK: - Icon Property Tests
    
    func testIconAssignment() {
        let testIcon = UIImage(systemName: "star.fill")
        metadataView.icon = testIcon
        
        XCTAssertEqual(metadataView.icon, testIcon)
        XCTAssertFalse(metadataView.isHidden, "MetadataView should be visible when icon is set")
    }
    
    func testIconOnlyVisibility() {
        metadataView.icon = UIImage(systemName: "clock")
        XCTAssertFalse(metadataView.isHidden, "MetadataView should be visible with icon only")
        
        metadataView.icon = nil
        XCTAssertTrue(metadataView.isHidden, "MetadataView should be hidden when icon is removed")
    }
    
    // MARK: - Combined Content Tests
    
    func testTextAndIconTogether() {
        metadataView.text = "Due Soon"
        metadataView.icon = UIImage(systemName: "clock")
        
        XCTAssertFalse(metadataView.isHidden, "MetadataView should be visible with both text and icon")
        XCTAssertEqual(metadataView.text, "Due Soon")
        XCTAssertNotNil(metadataView.icon)
    }
    
    func testPartialContentRemoval() {
        metadataView.text = "Text"
        metadataView.icon = UIImage(systemName: "star")
        XCTAssertFalse(metadataView.isHidden)
        
        metadataView.text = nil
        XCTAssertFalse(metadataView.isHidden, "MetadataView should remain visible if icon is still present")
        
        metadataView.icon = nil
        XCTAssertTrue(metadataView.isHidden, "MetadataView should be hidden when all content is removed")
    }
    
    // MARK: - Configuration Tests
    
    func testBasicConfiguration() {
        let config = MetadataViewConfig(
            text: "Priority",
            backgroundColor: .systemRed,
            textColor: .white
        )
        
        metadataView.configure(with: config)
        
        XCTAssertEqual(metadataView.text, "Priority")
        XCTAssertEqual(metadataView.config?.backgroundColor, .systemRed)
        XCTAssertEqual(metadataView.config?.textColor, .white)
        XCTAssertFalse(metadataView.isHidden)
    }
    
    func testConfigurationWithIcon() {
        let testIcon = UIImage(systemName: "exclamationmark.triangle.fill")
        let config = MetadataViewConfig(
            icon: testIcon,
            text: "Warning",
            backgroundColor: .systemOrange,
            textColor: .black
        )
        
        metadataView.configure(with: config)
        
        XCTAssertEqual(metadataView.text, "Warning")
        XCTAssertEqual(metadataView.icon, testIcon)
        XCTAssertEqual(metadataView.config?.backgroundColor, .systemOrange)
        XCTAssertEqual(metadataView.config?.textColor, .black)
    }
    
    func testConfigurationCustomization() {
        let customFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        let config = MetadataViewConfig(
            text: "Custom",
            backgroundColor: .systemPurple,
            textColor: .white,
            cornerRadius: 12,
            font: customFont
        )
        
        metadataView.configure(with: config)
        
        XCTAssertEqual(metadataView.config?.cornerRadius, 12)
        XCTAssertEqual(metadataView.config?.font, customFont)
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        let config = MetadataViewConfig(
            icon: UIImage(systemName: "heart.fill"),
            text: "Favorite",
            backgroundColor: .systemPink
        )
        
        metadataView.configure(with: config)
        XCTAssertFalse(metadataView.isHidden)
        
        metadataView.reset()
        
        XCTAssertNil(metadataView.text)
        XCTAssertNil(metadataView.icon)
        XCTAssertNil(metadataView.config)
        XCTAssertTrue(metadataView.isHidden, "MetadataView should be hidden after reset")
    }
    
    // MARK: - Intrinsic Content Size Tests
    
    func testIntrinsicContentSizeHidden() {
        let size = metadataView.intrinsicContentSize
        XCTAssertEqual(size, CGSize.zero, "Hidden MetadataView should have zero intrinsic size")
    }
    
    func testIntrinsicContentSizeWithContent() {
        metadataView.text = "Test"
        let size = metadataView.intrinsicContentSize
        
        XCTAssertGreaterThan(size.width, 0, "MetadataView with content should have positive width")
        XCTAssertGreaterThanOrEqual(size.height, 24, "MetadataView should have minimum height of 24")
    }
    
    func testIntrinsicContentSizeWithIconAndText() {
        metadataView.icon = UIImage(systemName: "star")
        metadataView.text = "Important"
        
        let textOnlyView = MetadataView()
        textOnlyView.text = "Important"
        
        let iconTextSize = metadataView.intrinsicContentSize
        let textOnlySize = textOnlyView.intrinsicContentSize
        
        XCTAssertGreaterThan(iconTextSize.width, textOnlySize.width, 
                           "MetadataView with icon should be wider than text-only")
    }
    
    // MARK: - Visual Properties Tests
    
    func testDefaultConfiguration() {
        let defaultConfig = MetadataViewConfig()
        metadataView.configure(with: defaultConfig)
        
        XCTAssertEqual(metadataView.config?.backgroundColor, .systemBlue)
        XCTAssertEqual(metadataView.config?.textColor, .white)
        XCTAssertEqual(metadataView.config?.cornerRadius, 8)
    }
    
    // MARK: - Edge Cases
    
    func testConfigurationOverride() {
        let config1 = MetadataViewConfig(text: "First", backgroundColor: .systemRed)
        let config2 = MetadataViewConfig(text: "Second", backgroundColor: .systemBlue)
        
        metadataView.configure(with: config1)
        XCTAssertEqual(metadataView.text, "First")
        
        metadataView.configure(with: config2)
        XCTAssertEqual(metadataView.text, "Second")
        XCTAssertEqual(metadataView.config?.backgroundColor, .systemBlue)
    }
    
    func testDirectPropertyOverrideAfterConfiguration() {
        let config = MetadataViewConfig(text: "Config Text", backgroundColor: .systemGreen)
        metadataView.configure(with: config)
        
        metadataView.text = "Override Text"
        
        XCTAssertEqual(metadataView.text, "Override Text")
        // Config should still exist but text is overridden
        XCTAssertNotNil(metadataView.config)
    }
    
    // MARK: - Performance Tests
    
    func testMultipleConfigurationChanges() {
        let configs = [
            MetadataViewConfig(text: "Config 1", backgroundColor: .systemRed),
            MetadataViewConfig(text: "Config 2", backgroundColor: .systemBlue),
            MetadataViewConfig(text: "Config 3", backgroundColor: .systemGreen),
            MetadataViewConfig(text: "Config 4", backgroundColor: .systemOrange),
            MetadataViewConfig(text: "Config 5", backgroundColor: .systemPurple)
        ]
        
        measure {
            for config in configs {
                metadataView.configure(with: config)
            }
        }
    }
    
    func testMultipleResetOperations() {
        let config = MetadataViewConfig(text: "Test", backgroundColor: .systemBlue)
        
        measure {
            for _ in 0..<100 {
                metadataView.configure(with: config)
                metadataView.reset()
            }
        }
    }
}