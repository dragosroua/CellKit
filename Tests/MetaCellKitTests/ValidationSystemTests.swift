import XCTest
@testable import MetaCellKit

final class ValidationSystemTests: XCTestCase {
    
    // MARK: - LengthValidationRule Tests
    
    func testLengthValidationRuleValid() {
        let rule = LengthValidationRule(min: 3, max: 10)
        let result = rule.validate("Hello")
        
        if case .valid = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid result")
        }
    }
    
    func testLengthValidationRuleTooShort() {
        let rule = LengthValidationRule(min: 5, max: 10)
        let result = rule.validate("Hi")
        
        if case .invalid(let message) = result {
            XCTAssertTrue(message.contains("minimum 5"))
        } else {
            XCTFail("Expected invalid result")
        }
    }
    
    func testLengthValidationRuleTooLong() {
        let rule = LengthValidationRule(min: 3, max: 5)
        let result = rule.validate("This is too long")
        
        if case .invalid(let message) = result {
            XCTAssertTrue(message.contains("maximum 5"))
        } else {
            XCTFail("Expected invalid result")
        }
    }
    
    func testLengthValidationRuleMinOnly() {
        let rule = LengthValidationRule(min: 3)
        
        XCTAssertEqual(rule.validate("Hi"), ValidationResult.invalid(rule.errorMessage))
        
        if case .valid = rule.validate("Hello") {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid result")
        }
    }
    
    func testLengthValidationRuleMaxOnly() {
        let rule = LengthValidationRule(max: 5)
        
        if case .valid = rule.validate("Hi") {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid result")
        }
        
        XCTAssertEqual(rule.validate("This is too long"), ValidationResult.invalid(rule.errorMessage))
    }
    
    func testLengthValidationRuleCustomMessage() {
        let customMessage = "Custom error message"
        let rule = LengthValidationRule(min: 5, message: customMessage)
        let result = rule.validate("Hi")
        
        if case .invalid(let message) = result {
            XCTAssertEqual(message, customMessage)
        } else {
            XCTFail("Expected invalid result with custom message")
        }
    }
    
    // MARK: - RegexValidationRule Tests
    
    func testRegexValidationRuleValid() {
        let rule = RegexValidationRule(pattern: "^[A-Za-z]+$", message: "Only letters allowed")
        let result = rule.validate("Hello")
        
        if case .valid = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid result")
        }
    }
    
    func testRegexValidationRuleInvalid() {
        let rule = RegexValidationRule(pattern: "^[A-Za-z]+$", message: "Only letters allowed")
        let result = rule.validate("Hello123")
        
        if case .invalid(let message) = result {
            XCTAssertEqual(message, "Only letters allowed")
        } else {
            XCTFail("Expected invalid result")
        }
    }
    
    func testRegexValidationRuleEmailPattern() {
        let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let rule = RegexValidationRule(pattern: emailPattern, message: "Invalid email format")
        
        if case .valid = rule.validate("test@example.com") {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid email")
        }
        
        if case .invalid = rule.validate("invalid-email") {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected invalid email")
        }
    }
    
    func testRegexValidationRuleInvalidPattern() {
        let rule = RegexValidationRule(pattern: "[", message: "Invalid pattern")
        let result = rule.validate("test")
        
        if case .invalid(let message) = result {
            XCTAssertTrue(message.contains("Invalid regex pattern"))
        } else {
            XCTFail("Expected invalid result due to bad regex pattern")
        }
    }
    
    // MARK: - CustomValidationRule Tests
    
    func testCustomValidationRuleValid() {
        let rule = CustomValidationRule(message: "Must contain 'test'") { text in
            return text.lowercased().contains("test")
        }
        
        if case .valid = rule.validate("This is a test") {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid result")
        }
    }
    
    func testCustomValidationRuleInvalid() {
        let rule = CustomValidationRule(message: "Must contain 'test'") { text in
            return text.lowercased().contains("test")
        }
        
        if case .invalid(let message) = rule.validate("Hello world") {
            XCTAssertEqual(message, "Must contain 'test'")
        } else {
            XCTFail("Expected invalid result")
        }
    }
    
    func testCustomValidationRuleComplexLogic() {
        let rule = CustomValidationRule(message: "Must be even number") { text in
            guard let number = Int(text) else { return false }
            return number % 2 == 0
        }
        
        if case .valid = rule.validate("42") {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid even number")
        }
        
        if case .invalid = rule.validate("43") {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected invalid odd number")
        }
        
        if case .invalid = rule.validate("not a number") {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected invalid non-number")
        }
    }
    
    // MARK: - ValidationUtility Tests
    
    func testValidateTextWithMultipleRules() {
        let rules: [ValidationRule] = [
            LengthValidationRule(min: 5, max: 20),
            RegexValidationRule(pattern: "^[A-Za-z\\s]+$", message: "Only letters and spaces")
        ]
        
        // Valid text
        if case .valid = ValidationUtility.validateText("Hello World", with: rules) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid result")
        }
        
        // Too short
        if case .invalid = ValidationUtility.validateText("Hi", with: rules) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected invalid result for too short text")
        }
        
        // Contains numbers
        if case .invalid = ValidationUtility.validateText("Hello123", with: rules) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected invalid result for text with numbers")
        }
    }
    
    func testValidateTextWithNoRules() {
        let result = ValidationUtility.validateText("Any text", with: [])
        
        if case .valid = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected valid result with no rules")
        }
    }
    
    func testGetAllErrors() {
        let rules: [ValidationRule] = [
            LengthValidationRule(min: 10, max: 20),  // Will fail - too short
            RegexValidationRule(pattern: "^[A-Za-z]+$", message: "Only letters"),  // Will fail - contains space
            CustomValidationRule(message: "Must contain 'test'") { $0.contains("test") }  // Will fail - no "test"
        ]
        
        let errors = ValidationUtility.getAllErrors(for: "Hi World", with: rules)
        
        XCTAssertEqual(errors.count, 3)
        XCTAssertTrue(errors.contains { $0.message.contains("minimum 10") })
        XCTAssertTrue(errors.contains { $0.message == "Only letters" })
        XCTAssertTrue(errors.contains { $0.message == "Must contain 'test'" })
    }
    
    func testGetAllErrorsWithValidText() {
        let rules: [ValidationRule] = [
            LengthValidationRule(min: 3, max: 10),
            RegexValidationRule(pattern: "^[A-Za-z]+$", message: "Only letters")
        ]
        
        let errors = ValidationUtility.getAllErrors(for: "Hello", with: rules)
        
        XCTAssertEqual(errors.count, 0)
    }
    
    // MARK: - ValidationError Tests
    
    func testValidationErrorCreation() {
        let rule = LengthValidationRule(min: 5)
        let error = ValidationError(rule: rule, message: "Test error")
        
        XCTAssertEqual(error.message, "Test error")
        XCTAssertTrue(error.rule is LengthValidationRule)
    }
}

// MARK: - ValidationResult Equatable Extension for Testing

extension ValidationResult: Equatable {
    public static func == (lhs: ValidationResult, rhs: ValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid):
            return true
        case (.invalid(let lhsMessage), .invalid(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}