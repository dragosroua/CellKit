import XCTest
@testable import MetaCellKit

final class EditingFunctionalityTests: XCTestCase {
    
    var cell: MetaCellKit!
    var mockDelegate: MockEditingDelegate!
    
    override func setUp() {
        super.setUp()
        cell = MetaCellKit(style: .default, reuseIdentifier: "test")
        mockDelegate = MockEditingDelegate()
        cell.editingDelegate = mockDelegate
    }
    
    override func tearDown() {
        cell = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Basic Editing State Tests
    
    func testEditingStateInitiallyFalse() {
        XCTAssertFalse(cell.isEditing)
    }
    
    func testEnableEditingWithoutConfiguration() {
        // Should not enable editing if editing is not configured
        cell.enableEditing()
        XCTAssertFalse(cell.isEditing)
        XCTAssertFalse(mockDelegate.didBeginEditingCalled)
    }
    
    func testEnableEditingWithConfiguration() {
        // Configure cell for editing
        var config = CellConfiguration()
        config.editing.isEditingEnabled = true
        
        let testData = TestCellData(title: "Test Title")
        cell.configure(with: testData, configuration: config)
        
        cell.enableEditing()
        XCTAssertTrue(cell.isEditing)
        XCTAssertTrue(mockDelegate.didBeginEditingCalled)
    }
    
    func testDisableEditing() {
        // Configure and enable editing
        var config = CellConfiguration()
        config.editing.isEditingEnabled = true
        
        let testData = TestCellData(title: "Test Title")
        cell.configure(with: testData, configuration: config)
        
        cell.enableEditing()
        XCTAssertTrue(cell.isEditing)
        
        cell.disableEditing()
        XCTAssertFalse(cell.isEditing)
        XCTAssertTrue(mockDelegate.didEndEditingCalled)
    }
    
    func testCancelEditing() {
        var config = CellConfiguration()
        config.editing.isEditingEnabled = true
        
        let testData = TestCellData(title: "Original Title")
        cell.configure(with: testData, configuration: config)
        
        cell.enableEditing()
        cell.setText("Modified Title")
        
        cell.cancelEditing()
        XCTAssertFalse(cell.isEditing)
        XCTAssertEqual(mockDelegate.lastEndEditingText, "Original Title")
    }
    
    // MARK: - Text Management Tests
    
    func testGetTextWhenNotEditing() {
        let testData = TestCellData(title: "Test Title")
        let config = CellConfiguration()
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(cell.getText(), "Test Title")
    }
    
    func testSetTextWhenNotEditing() {
        let testData = TestCellData(title: "Original")
        let config = CellConfiguration()
        cell.configure(with: testData, configuration: config)
        
        cell.setText("New Title")
        XCTAssertEqual(cell.getText(), "New Title")
    }
    
    func testSetTextWhenEditing() {
        var config = CellConfiguration()
        config.editing.isEditingEnabled = true
        
        let testData = TestCellData(title: "Original")
        cell.configure(with: testData, configuration: config)
        
        cell.enableEditing()
        cell.setText("Edited Text")
        
        XCTAssertEqual(cell.getText(), "Edited Text")
        XCTAssertTrue(mockDelegate.didChangeTextCalled)
        XCTAssertEqual(mockDelegate.lastChangedText, "Edited Text")
    }
    
    // MARK: - Validation Tests
    
    func testCommitEditingWithValidation() {
        var config = CellConfiguration()
        config.editing.isEditingEnabled = true
        config.editing.validationRules = [
            LengthValidationRule(min: 3, max: 10)
        ]
        
        let testData = TestCellData(title: "Test")
        cell.configure(with: testData, configuration: config)
        
        cell.enableEditing()
        cell.setText("Valid")
        
        let success = cell.commitEditing()
        XCTAssertTrue(success)
        XCTAssertFalse(cell.isEditing)
    }
    
    func testCommitEditingWithValidationFailure() {
        var config = CellConfiguration()
        config.editing.isEditingEnabled = true
        config.editing.validationRules = [
            LengthValidationRule(min: 5, max: 10)
        ]
        
        let testData = TestCellData(title: "Test")
        cell.configure(with: testData, configuration: config)
        
        cell.enableEditing()
        cell.setText("Hi") // Too short
        
        let success = cell.commitEditing()
        XCTAssertFalse(success)
        XCTAssertTrue(cell.isEditing) // Should still be editing
    }
    
    // MARK: - Icon Alignment Tests
    
    func testIconAlignmentConfiguration() {
        var config = CellConfiguration()
        config.iconAlignment = .top
        
        let testData = TestCellData(title: "Test", icon: "star")
        cell.configure(with: testData, configuration: config)
        
        // Test that configuration is applied (we can't easily test constraint values in unit tests)
        XCTAssertNotNil(cell.currentConfiguration)
        XCTAssertEqual(cell.currentConfiguration?.iconAlignment, .top)
    }
    
    // MARK: - Character Count Tests
    
    func testCharacterCountConfiguration() {
        var config = CellConfiguration()
        config.editing.isEditingEnabled = true
        config.editing.characterCountDisplay = .count
        config.editing.maxTextLength = 100
        
        let testData = TestCellData(title: "Test")
        cell.configure(with: testData, configuration: config)
        
        XCTAssertEqual(config.editing.characterCountDisplay, .count)
        XCTAssertEqual(config.editing.maxTextLength, 100)
    }
    
    // MARK: - Auto-save Tests
    
    func testAutoSaveConfiguration() {
        var config = CellConfiguration()
        config.editing.isEditingEnabled = true
        config.editing.autoSaveInterval = 2.0
        
        let testData = TestCellData(title: "Test")
        cell.configure(with: testData, configuration: config)
        
        cell.enableEditing()
        
        // Test auto-save timer setup (timer should be created)
        let expectation = XCTestExpectation(description: "Auto-save should be called")
        mockDelegate.autoSaveExpectation = expectation
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertTrue(mockDelegate.autoSaveCalled)
    }
}

// MARK: - Mock Delegate

class MockEditingDelegate: MetaCellKitEditingDelegate {
    var didBeginEditingCalled = false
    var didEndEditingCalled = false
    var didChangeTextCalled = false
    var autoSaveCalled = false
    var validationFailedCalled = false
    var willChangeHeightCalled = false
    
    var lastEndEditingText: String?
    var lastChangedText: String?
    var lastValidationError: ValidationError?
    var lastHeight: CGFloat?
    
    var autoSaveExpectation: XCTestExpectation?
    
    func cellDidBeginEditing(_ cell: MetaCellKit) {
        didBeginEditingCalled = true
    }
    
    func cellDidEndEditing(_ cell: MetaCellKit, with text: String) {
        didEndEditingCalled = true
        lastEndEditingText = text
    }
    
    func cell(_ cell: MetaCellKit, didChangeText text: String) {
        didChangeTextCalled = true
        lastChangedText = text
    }
    
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {
        validationFailedCalled = true
        lastValidationError = error
    }
    
    func cell(_ cell: MetaCellKit, willChangeHeightTo height: CGFloat) {
        willChangeHeightCalled = true
        lastHeight = height
    }
    
    func cell(_ cell: MetaCellKit, didAutoSaveText text: String) {
        autoSaveCalled = true
        autoSaveExpectation?.fulfill()
    }
    
    func cellShouldAutoSave(_ cell: MetaCellKit) -> Bool {
        return true
    }
    
    func cellShouldReturn(_ cell: MetaCellKit) -> Bool {
        return true
    }
}

// MARK: - Test Data

struct TestCellData: CellDataProtocol {
    let title: String
    let icon: String?
    let badge: String?
    
    init(title: String, icon: String? = nil, badge: String? = nil) {
        self.title = title
        self.icon = icon
        self.badge = badge
    }
}