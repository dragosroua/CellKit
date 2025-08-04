# Validation Rules Best Practices

A comprehensive guide to designing effective validation rules for MetaCellKit editing functionality.

## Overview

This guide provides best practices for creating, configuring, and implementing validation rules in MetaCellKit. Following these practices will ensure robust user input validation while maintaining excellent user experience.

## Validation Strategy

### 1. Layer Your Validation

Use multiple validation layers for comprehensive input checking:

```swift
// Layer 1: Basic constraints
let lengthRule = LengthValidationRule(min: 3, max: 100)

// Layer 2: Format validation
let formatRule = RegexValidationRule(
    pattern: "^[A-Za-z0-9\\s.,!?-]*$",
    message: "Only letters, numbers, and basic punctuation allowed"
)

// Layer 3: Business logic validation
let businessRule = CustomValidationRule(message: "Must describe an actionable task") { text in
    let actionWords = ["create", "update", "review", "send", "call", "meet", "write", "plan"]
    return actionWords.contains { text.lowercased().contains($0) }
}

let validationRules = [lengthRule, formatRule, businessRule]
```

### 2. Order Rules by Performance

Place faster validation rules first to fail fast:

```swift
// ✅ Good - fast rules first
let rules: [ValidationRule] = [
    LengthValidationRule(min: 1, max: 500),           // Fastest
    RegexValidationRule(pattern: "...", message: ""), // Medium
    CustomValidationRule(message: "") { /* complex logic */ } // Slowest
]

// ❌ Avoid - expensive rules first
let rules: [ValidationRule] = [
    CustomValidationRule(message: "") { /* API call */ },     // Very slow
    RegexValidationRule(pattern: "...", message: ""),        // Medium
    LengthValidationRule(min: 1, max: 500)                   // Fast
]
```

## Error Message Design

### 1. Be Specific and Actionable

```swift
// ✅ Good - specific and actionable
LengthValidationRule(min: 5, max: 50, message: "Task title must be 5-50 characters")

RegexValidationRule(
    pattern: "^[A-Za-z0-9\\s]*$",
    message: "Only letters, numbers, and spaces are allowed"
)

// ❌ Avoid - vague messages
LengthValidationRule(min: 5, max: 50, message: "Invalid length")
RegexValidationRule(pattern: "^[A-Za-z0-9\\s]*$", message: "Invalid format")
```

### 2. Provide Context and Solutions

```swift
// ✅ Good - explains what and why
CustomValidationRule(message: "Email address required for notifications") { text in
    return text.contains("@") && text.contains(".")
}

CustomValidationRule(message: "Password must contain at least one number for security") { text in
    return text.rangeOfCharacter(from: .decimalDigits) != nil
}
```

### 3. Use Consistent Language

```swift
// ✅ Good - consistent terminology
let rules = [
    LengthValidationRule(min: 3, message: "Title must be at least 3 characters"),
    LengthValidationRule(max: 100, message: "Title must be no more than 100 characters"),
    RegexValidationRule(pattern: "...", message: "Title can only contain letters and numbers")
]
```

## Common Validation Patterns

### 1. Text Input Validation

```swift
// Safe text input - prevents injection attacks
let safeTextRules: [ValidationRule] = [
    LengthValidationRule(min: 1, max: 500),
    RegexValidationRule(
        pattern: "^[A-Za-z0-9\\s.,!?'\"\\-()]*$",
        message: "Special characters are not allowed"
    ),
    CustomValidationRule(message: "Suspicious content detected") { text in
        let dangerous = ["<script", "javascript:", "onclick", "eval(", "document."]
        return !dangerous.contains { text.lowercased().contains($0) }
    }
]
```

### 2. Task/Todo Validation

```swift
// Task description validation
let taskRules: [ValidationRule] = [
    LengthValidationRule(min: 5, max: 200, message: "Task must be 5-200 characters"),
    CustomValidationRule(message: "Task should describe what needs to be done") { text in
        let actionVerbs = ["create", "update", "review", "send", "call", "meet", "write", "plan", "fix", "test"]
        return actionVerbs.contains { text.lowercased().contains($0) }
    },
    CustomValidationRule(message: "Please provide more specific details") { text in
        let vague = ["do stuff", "handle it", "work on", "deal with"]
        return !vague.contains { text.lowercased().contains($0) }
    }
]
```

### 3. Name/Title Validation

```swift
// Name validation with cultural sensitivity
let nameRules: [ValidationRule] = [
    LengthValidationRule(min: 2, max: 50, message: "Name must be 2-50 characters"),
    RegexValidationRule(
        pattern: "^[A-Za-z\\s'\\-\\.]+$",
        message: "Names can contain letters, spaces, apostrophes, hyphens, and periods"
    ),
    CustomValidationRule(message: "Please enter a valid name") { text in
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && trimmed.count >= 2
    }
]
```

### 4. Email Validation

```swift
// Comprehensive email validation
let emailRules: [ValidationRule] = [
    LengthValidationRule(max: 254, message: "Email address too long"),
    RegexValidationRule(
        pattern: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
        message: "Please enter a valid email address"
    ),
    CustomValidationRule(message: "Email domain not supported") { text in
        let blockedDomains = ["tempmail.com", "10minutemail.com"]
        return !blockedDomains.contains { text.lowercased().contains($0) }
    }
]
```

## Performance Optimization

### 1. Cache Compiled Regex

```swift
// ✅ Good - cache regex for reuse
struct OptimizedRegexRule: ValidationRule {
    private static let compiledRegex = try! NSRegularExpression(pattern: "^[A-Za-z0-9\\s]*$")
    let errorMessage: String
    
    func validate(_ text: String) -> ValidationResult {
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = Self.compiledRegex.numberOfMatches(in: text, range: range)
        return matches > 0 ? .valid : .invalid(errorMessage)
    }
}

// ❌ Avoid - creating regex each time
RegexValidationRule(pattern: "^[A-Za-z0-9\\s]*$", message: "Invalid format")
```

### 2. Short-Circuit Complex Validation

```swift
// ✅ Good - quick checks first
CustomValidationRule(message: "Invalid task format") { text in
    // Quick checks first
    guard !text.isEmpty else { return false }
    guard text.count >= 5 else { return false }
    
    // Expensive checks last
    return performComplexValidation(text)
}
```

### 3. Debounce Real-time Validation

```swift
// In your EditingConfiguration
config.editing.validationDebounceInterval = 0.5  // Wait 500ms after typing stops
```

## User Experience Guidelines

### 1. Progressive Disclosure

Show validation errors progressively rather than all at once:

```swift
extension ViewController: MetaCellKitEditingDelegate {
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {
        // Show most critical error first
        switch error.rule {
        case is LengthValidationRule:
            showInlineError(error.message)  // Show immediately
        case is RegexValidationRule:
            scheduleDelayedError(error.message)  // Show after 1 second
        case is CustomValidationRule:
            // Only show if other validations pass
            showAdvancedError(error.message)
        default:
            break
        }
    }
}
```

### 2. Real-time vs. On-Submit Validation

```swift
// Real-time validation for critical fields
var config = CellConfiguration()
config.editing.realtimeValidation = true
config.editing.validationRules = [
    LengthValidationRule(max: 50)  // Simple rules only
]

// On-submit validation for complex rules
config.editing.submitValidationRules = [
    CustomValidationRule(message: "Complex business logic error") { text in
        // Complex validation only on submit
        return performExpensiveValidation(text)
    }
]
```

### 3. Contextual Help

```swift
CustomValidationRule(message: "Password must contain: uppercase, lowercase, number (e.g., 'MyPass123')") { text in
    let hasUpper = text.rangeOfCharacter(from: .uppercaseLetters) != nil
    let hasLower = text.rangeOfCharacter(from: .lowercaseLetters) != nil
    let hasNumber = text.rangeOfCharacter(from: .decimalDigits) != nil
    return hasUpper && hasLower && hasNumber
}
```

## Testing Validation Rules

### 1. Unit Test Edge Cases

```swift
class ValidationRuleTests: XCTestCase {
    func testLengthValidationEdgeCases() {
        let rule = LengthValidationRule(min: 5, max: 10)
        
        // Test boundaries
        XCTAssertEqual(rule.validate("1234"), .invalid(rule.errorMessage))
        XCTAssertEqual(rule.validate("12345"), .valid)
        XCTAssertEqual(rule.validate("1234567890"), .valid)
        XCTAssertEqual(rule.validate("12345678901"), .invalid(rule.errorMessage))
        
        // Test edge cases
        XCTAssertEqual(rule.validate(""), .invalid(rule.errorMessage))
        XCTAssertEqual(rule.validate("     "), .invalid(rule.errorMessage))  // Whitespace only
    }
    
    func testRegexWithUnicodeCharacters() {
        let rule = RegexValidationRule(pattern: "^[A-Za-z\\s]*$", message: "Letters only")
        
        XCTAssertEqual(rule.validate("José"), .invalid(rule.errorMessage))  // Accented characters
        XCTAssertEqual(rule.validate("北京"), .invalid(rule.errorMessage))  // Chinese characters
        XCTAssertEqual(rule.validate("José María"), .invalid(rule.errorMessage))  // Mixed
    }
}
```

### 2. Performance Testing

```swift
func testValidationPerformance() {
    let rules: [ValidationRule] = [
        LengthValidationRule(min: 1, max: 1000),
        RegexValidationRule(pattern: "^[A-Za-z0-9\\s.,!?-]*$", message: ""),
        CustomValidationRule(message: "") { text in
            // Simulate complex validation
            return !text.lowercased().contains("banned")
        }
    ]
    
    let longText = String(repeating: "This is a test sentence. ", count: 100)
    
    measure {
        for _ in 0..<1000 {
            _ = ValidationUtility.validateText(longText, with: rules)
        }
    }
}
```

## Security Considerations

### 1. Input Sanitization

```swift
// Prevent common injection attacks
let securityRules: [ValidationRule] = [
    RegexValidationRule(
        pattern: "^[^<>\"'%;()&+]*$",
        message: "Invalid characters detected"
    ),
    CustomValidationRule(message: "Suspicious content blocked") { text in
        let suspiciousPatterns = [
            "<script", "</script>", "javascript:", "vbscript:",
            "onclick", "onerror", "onload", "eval(", "document.",
            "window.", "alert(", "confirm(", "prompt("
        ]
        return !suspiciousPatterns.contains { text.lowercased().contains($0) }
    }
]
```

### 2. Length Limits for Security

```swift
// Prevent DoS attacks with reasonable limits
let securityLengthRule = LengthValidationRule(
    max: 10000,  // Reasonable maximum
    message: "Input too long for security reasons"
)
```

## Internationalization

### 1. Localized Error Messages

```swift
// Use localized strings for error messages
LengthValidationRule(
    min: 5,
    max: 50,
    message: NSLocalizedString("validation.length.error", comment: "Text length validation error")
)

// In Localizable.strings:
// "validation.length.error" = "Text must be 5-50 characters";
```

### 2. Unicode-Aware Patterns

```swift
// Support international characters
let internationalNameRule = RegexValidationRule(
    pattern: "^[\\p{L}\\p{M}\\s'\\-\\.]+$",  // Unicode letter categories
    message: NSLocalizedString("validation.name.international", comment: "")
)
```

## Common Pitfalls to Avoid

### 1. Over-Validation

```swift
// ❌ Avoid - too restrictive
let overRestrictiveRule = RegexValidationRule(
    pattern: "^[A-Z][a-z]{4,19}$",  // Too specific
    message: "Name must start with capital letter and be 5-20 lowercase letters"
)

// ✅ Better - more flexible
let flexibleRule = RegexValidationRule(
    pattern: "^[A-Za-z\\s'\\-]{2,50}$",
    message: "Please enter a valid name"
)
```

### 2. Inconsistent Validation

```swift
// ❌ Avoid - different rules for similar fields
let emailRule1 = LengthValidationRule(max: 100)
let emailRule2 = LengthValidationRule(max: 254)  // Different limit

// ✅ Better - consistent validation
let standardEmailLength = LengthValidationRule(max: 254)  // RFC 5321 standard
```

### 3. Poor Error Recovery

```swift
// ✅ Good - help users fix errors
extension ViewController: MetaCellKitEditingDelegate {
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {
        if let lengthRule = error.rule as? LengthValidationRule {
            let currentLength = cell.getText()?.count ?? 0
            let message = "Current: \(currentLength) characters. \(error.message)"
            showErrorWithContext(message)
        } else {
            showError(error.message)
        }
    }
}
```

## Related Documentation

- [ValidationSystem](../API/ValidationSystem.md) - Complete API reference
- [EditingConfiguration](../API/EditingConfiguration.md) - Editing configuration options
- [MetaCellKitEditingDelegate](../API/MetaCellKitEditingDelegate.md) - Handling validation events
- [Advanced Editing Tutorial](AdvancedEditing.md) - Comprehensive editing implementation guide

## See Also

- [Security Best Practices](SecurityBestPractices.md)
- [Performance Optimization](PerformanceOptimization.md)
- [Accessibility Guidelines](AccessibilityGuidelines.md)