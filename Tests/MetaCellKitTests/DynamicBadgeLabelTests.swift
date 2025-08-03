import XCTest
@testable import MetaCellKit
import UIKit

final class DynamicBadgeLabelTests: XCTestCase {
    
    var badgeLabel: DynamicBadgeLabel!
    
    override func setUp() {
        super.setUp()
        badgeLabel = DynamicBadgeLabel()
    }
    
    override func tearDown() {
        badgeLabel = nil
        super.tearDown()
    }
    
    // MARK: - Basic Functionality Tests
    
    func testInitialState() {
        XCTAssertTrue(badgeLabel.isHidden, "Badge should be hidden initially when empty")
        XCTAssertNil(badgeLabel.text)
        XCTAssertEqual(badgeLabel.backgroundColor, .systemRed)
        XCTAssertEqual(badgeLabel.textColor, .white)
    }
    
    func testTextAssignment() {
        badgeLabel.text = "5"
        
        XCTAssertFalse(badgeLabel.isHidden, "Badge should be visible when text is set")
        XCTAssertEqual(badgeLabel.text, "5")
    }
    
    func testEmptyTextHidesBadge() {
        badgeLabel.text = "5"
        XCTAssertFalse(badgeLabel.isHidden)
        
        badgeLabel.text = ""
        XCTAssertTrue(badgeLabel.isHidden, "Badge should be hidden when text is empty")
        
        badgeLabel.text = nil
        XCTAssertTrue(badgeLabel.isHidden, "Badge should be hidden when text is nil")
    }
    
    // MARK: - Color Customization Tests
    
    func testBadgeColorCustomization() {
        badgeLabel.badgeColor = .systemBlue
        XCTAssertEqual(badgeLabel.backgroundColor, .systemBlue)
    }
    
    func testBadgeTextColorCustomization() {
        badgeLabel.badgeTextColor = .black
        XCTAssertEqual(badgeLabel.textColor, .black)
    }
    
    // MARK: - Size Tests
    
    func testIntrinsicContentSizeEmpty() {
        let size = badgeLabel.intrinsicContentSize
        XCTAssertEqual(size, CGSize.zero, "Empty badge should have zero intrinsic size")
    }
    
    func testIntrinsicContentSizeWithText() {
        badgeLabel.text = "5"
        let size = badgeLabel.intrinsicContentSize
        
        XCTAssertGreaterThan(size.width, 0, "Badge with text should have positive width")
        XCTAssertGreaterThan(size.height, 0, "Badge with text should have positive height")
        XCTAssertGreaterThanOrEqual(size.width, 24, "Badge should respect minimum width")
        XCTAssertGreaterThanOrEqual(size.height, 24, "Badge should respect minimum height")
    }
    
    func testIntrinsicContentSizeWithLongText() {
        badgeLabel.text = "999+"
        let size = badgeLabel.intrinsicContentSize
        
        XCTAssertGreaterThan(size.width, 24, "Badge with long text should be wider than minimum")
        XCTAssertEqual(size.height, 24, "Badge height should remain consistent")
    }
    
    func testMinimumSizeCustomization() {
        badgeLabel.minimumSize = CGSize(width: 30, height: 30)
        badgeLabel.text = "1"
        
        let size = badgeLabel.intrinsicContentSize
        XCTAssertGreaterThanOrEqual(size.width, 30, "Badge should respect custom minimum width")
        XCTAssertGreaterThanOrEqual(size.height, 30, "Badge should respect custom minimum height")
    }
    
    // MARK: - Badge Value Setting Tests
    
    func testSetBadgeValueWithString() {
        badgeLabel.setBadgeValue("Test")
        XCTAssertEqual(badgeLabel.text, "Test")
        XCTAssertFalse(badgeLabel.isHidden)
    }
    
    func testSetBadgeValueWithPositiveInt() {
        badgeLabel.setBadgeValue(42)
        XCTAssertEqual(badgeLabel.text, "42")
        XCTAssertFalse(badgeLabel.isHidden)
    }
    
    func testSetBadgeValueWithZeroInt() {
        badgeLabel.setBadgeValue(0)
        XCTAssertNil(badgeLabel.text)
        XCTAssertTrue(badgeLabel.isHidden, "Badge should be hidden for zero values")
    }
    
    func testSetBadgeValueWithNegativeInt() {
        badgeLabel.setBadgeValue(-5)
        XCTAssertNil(badgeLabel.text)
        XCTAssertTrue(badgeLabel.isHidden, "Badge should be hidden for negative values")
    }
    
    func testSetBadgeValueWithPositiveDouble() {
        badgeLabel.setBadgeValue(3.7)
        XCTAssertEqual(badgeLabel.text, "3.7")
        XCTAssertFalse(badgeLabel.isHidden)
    }
    
    func testSetBadgeValueWithZeroDouble() {
        badgeLabel.setBadgeValue(0.0)
        XCTAssertNil(badgeLabel.text)
        XCTAssertTrue(badgeLabel.isHidden, "Badge should be hidden for zero double values")
    }
    
    func testSetBadgeValueWithNil() {
        badgeLabel.text = "Previous"
        badgeLabel.setBadgeValue(nil)
        
        XCTAssertNil(badgeLabel.text)
        XCTAssertTrue(badgeLabel.isHidden, "Badge should be hidden when set to nil")
    }
    
    // MARK: - Layout Tests
    
    func testLayoutSubviews() {
        badgeLabel.text = "5"
        badgeLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        badgeLabel.layoutSubviews()
        
        let expectedRadius = min(30, 30) / 2
        XCTAssertEqual(badgeLabel.layer.cornerRadius, expectedRadius, "Corner radius should be half of minimum dimension")
    }
    
    func testRoundedAppearance() {
        badgeLabel.text = "1"
        badgeLabel.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        badgeLabel.layoutSubviews()
        
        XCTAssertEqual(badgeLabel.layer.cornerRadius, 12, "Square badge should be perfectly round")
        XCTAssertTrue(badgeLabel.clipsToBounds, "Badge should clip to bounds for rounded appearance")
    }
    
    // MARK: - Performance Tests
    
    func testMultipleTextChanges() {
        measure {
            for i in 0..<100 {
                badgeLabel.text = "\(i)"
            }
        }
    }
    
    func testMultipleBadgeValueChanges() {
        measure {
            for i in 0..<100 {
                badgeLabel.setBadgeValue(i)
            }
        }
    }
}