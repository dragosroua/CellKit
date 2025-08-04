# ValidationSystem

A comprehensive text validation system for MetaCellKit editing functionality.

## Overview

The ValidationSystem provides flexible, extensible text validation with built-in rules and support for custom validation logic. It includes three built-in validation rule types and utilities for managing multiple validation rules.

## Core Components

### ValidationRule Protocol

```swift
public protocol ValidationRule {
    func validate(_ text: String) -> ValidationResult
    var errorMessage: String { get }
}
```

The base protocol that all validation rules must implement.

### ValidationResult Enum

```swift
public enum ValidationResult {
    case valid
    case invalid(String)
}
```

Represents the result of a validation check.

### ValidationError Struct

```swift
public struct ValidationError: Error {
    public let rule: ValidationRule
    public let message: String
}
```

Error type that encapsulates validation failure details.

## Built-in Validation Rules

### LengthValidationRule

Validates text length constraints.

```swift
public struct LengthValidationRule: ValidationRule {
    public let minLength: Int?
    public let maxLength: Int?
    public let errorMessage: String
    
    public init(min: Int? = nil, max: Int? = nil, message: String? = nil)
}
```

**Usage Examples:**
```swift
// Minimum length only
let minRule = LengthValidationRule(min: 5)

// Maximum length only  
let maxRule = LengthValidationRule(max: 100)

// Both min and max
let rangeRule = LengthValidationRule(min: 3, max: 50)

// Custom error message
let customRule = LengthValidationRule(min: 5, max: 20, message: "Username must be 5-20 characters")
```

### RegexValidationRule

Validates text against regular expression patterns.

```swift
public struct RegexValidationRule: ValidationRule {
    public let pattern: String
    public let errorMessage: String
    
    public init(pattern: String, message: String)
}
```

**Usage Examples:**
```swift
// Email validation
let emailRule = RegexValidationRule(
    pattern: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
    message: "Please enter a valid email address"
)

// Alphanumeric only
let alphanumericRule = RegexValidationRule(
    pattern: "^[A-Za-z0-9\\s]*$",
    message: "Only letters, numbers, and spaces allowed"
)

// Phone number format
let phoneRule = RegexValidationRule(
    pattern: "^\\+?[1-9]\\d{1,14}$",
    message: "Please enter a valid phone number"
)

// No special characters
let safeTextRule = RegexValidationRule(
    pattern: "^[A-Za-z0-9\\s.,!?-]*$",
    message: "Special characters are not allowed"
)
```

### CustomValidationRule

Allows custom validation logic with closures.

```swift
public struct CustomValidationRule: ValidationRule {
    public let errorMessage: String
    private let validationClosure: (String) -> Bool
    
    public init(message: String, validation: @escaping (String) -> Bool)
}
```

**Usage Examples:**
```swift
// Check for profanity
let profanityRule = CustomValidationRule(message: "Text contains inappropriate content") { text in
    let bannedWords = ["spam", "fake", "scam"]
    return !bannedWords.contains { text.lowercased().contains($0) }
}

// Business logic validation
let taskRule = CustomValidationRule(message: "Task must contain an action word") { text in
    let actionWords = ["create", "review", "update", "send", "call", "meet", "write"]
    return actionWords.contains { text.lowercased().contains($0) }
}

// Even number validation
let evenNumberRule = CustomValidationRule(message: "Must be an even number") { text in
    guard let number = Int(text) else { return false }
    return number % 2 == 0
}

// Date format validation
let dateRule = CustomValidationRule(message: "Must be in MM/DD/YYYY format") { text in
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.date(from: text) != nil
}
```

## ValidationUtility

Helper class for managing multiple validation rules.

### Methods

#### `validateText(_:with:)`
```swift
public static func validateText(_ text: String, with rules: [ValidationRule]) -> ValidationResult
```
Validates text against multiple rules, returning the first failure or success.

#### `getAllErrors(for:with:)`
```swift
public static func getAllErrors(for text: String, with rules: [ValidationRule]) -> [ValidationError]
```
Returns all validation errors for the given text and rules.

**Usage Examples:**
```swift
let rules: [ValidationRule] = [
    LengthValidationRule(min: 5, max: 50),
    RegexValidationRule(pattern: "^[A-Za-z\\s]*$", message: "Only letters and spaces"),
    CustomValidationRule(message: "Must contain 'important'") { $0.lowercased().contains("important") }
]

// Validate and get first error
let result = ValidationUtility.validateText("Hi", with: rules)
switch result {
case .valid:
    print("Text is valid")
case .invalid(let message):
    print("Validation failed: \(message)")
}

// Get all validation errors
let errors = ValidationUtility.getAllErrors(for: "Hi123", with: rules)
for error in errors {
    print("Rule failed: \(error.message)")
}
```

## Integration with MetaCellKit

### Configuration Setup
```swift
var config = CellConfiguration()
config.editing.isEditingEnabled = true
config.editing.validationRules = [
    LengthValidationRule(min: 3, max: 100),
    RegexValidationRule(pattern: "^[A-Za-z0-9\\s.,!?-]*$", 
                       message: "Only basic characters allowed"),
    CustomValidationRule(message: "Must be meaningful") { text in
        return text.trimmingCharacters(in: .whitespaces).count >= 3
    }
]
```

### Delegate Implementation
```swift
extension ViewController: MetaCellKitEditingDelegate {
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {
        // Handle specific validation types
        switch error.rule {
        case let lengthRule as LengthValidationRule:
            showLengthError(message: error.message, rule: lengthRule)
        case let regexRule as RegexValidationRule:
            showFormatError(message: error.message, pattern: regexRule.pattern)
        case is CustomValidationRule:
            showCustomError(message: error.message)
        default:
            showGenericError(message: error.message)
        }
    }
}
```

## Best Practices

### Performance
- Keep validation logic simple and fast
- Avoid expensive operations in custom validation closures
- Consider caching regex compilation for frequently used patterns

### User Experience
- Provide clear, actionable error messages
- Use real-time validation sparingly to avoid interrupting typing
- Combine related rules for better error messaging

### Rule Design
- Make error messages specific and helpful
- Use appropriate validation types for different content
- Test edge cases thoroughly

### Common Patterns
```swift
// Email validation with length constraint
let emailRules: [ValidationRule] = [
    LengthValidationRule(max: 100, message: "Email too long"),
    RegexValidationRule(pattern: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", 
                       message: "Invalid email format")
]

// Task title validation
let taskRules: [ValidationRule] = [
    LengthValidationRule(min: 3, max: 200),
    CustomValidationRule(message: "Task must describe an action") { text in
        let text = text.lowercased()
        let actionVerbs = ["create", "update", "review", "send", "call", "meet", "write", "plan"]
        return actionVerbs.contains { text.contains($0) }
    }
]

// Safe text input (no injection)
let safeInputRules: [ValidationRule] = [
    RegexValidationRule(pattern: "^[A-Za-z0-9\\s.,!?-]*$", 
                       message: "Special characters not allowed"),
    CustomValidationRule(message: "Suspicious content detected") { text in
        let dangerous = ["<script", "javascript:", "onclick", "onerror"]
        return !dangerous.contains { text.lowercased().contains($0) }
    }
]
```

## Related Types

- `EditingConfiguration` - Contains validation rules for editing
- `MetaCellKitEditingDelegate` - Handles validation errors
- `MetaCellKit` - Uses validation during editing

## See Also

- `EditingConfiguration`
- `MetaCellKitEditingDelegate`
- `MetaCellKit`