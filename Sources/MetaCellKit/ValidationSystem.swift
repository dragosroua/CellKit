import Foundation

// MARK: - Validation Protocols

public protocol ValidationRule {
    func validate(_ text: String) -> ValidationResult
    var errorMessage: String { get }
}

public enum ValidationResult {
    case valid
    case invalid(String)
}

public struct ValidationError: Error {
    public let rule: ValidationRule
    public let message: String
    
    public init(rule: ValidationRule, message: String) {
        self.rule = rule
        self.message = message
    }
}

// MARK: - Built-in Validation Rules

public struct LengthValidationRule: ValidationRule {
    public let minLength: Int?
    public let maxLength: Int?
    public let errorMessage: String
    
    public init(min: Int? = nil, max: Int? = nil, message: String? = nil) {
        self.minLength = min
        self.maxLength = max
        
        if let message = message {
            self.errorMessage = message
        } else {
            var parts: [String] = []
            if let min = min { parts.append("minimum \(min)") }
            if let max = max { parts.append("maximum \(max)") }
            self.errorMessage = "Text must have \(parts.joined(separator: " and ")) characters"
        }
    }
    
    public func validate(_ text: String) -> ValidationResult {
        let length = text.count
        
        if let min = minLength, length < min {
            return .invalid(errorMessage)
        }
        
        if let max = maxLength, length > max {
            return .invalid(errorMessage)
        }
        
        return .valid
    }
}

public struct RegexValidationRule: ValidationRule {
    public let pattern: String
    public let errorMessage: String
    private let regex: NSRegularExpression?
    
    public init(pattern: String, message: String) {
        self.pattern = pattern
        self.errorMessage = message
        self.regex = try? NSRegularExpression(pattern: pattern, options: [])
    }
    
    public func validate(_ text: String) -> ValidationResult {
        guard let regex = regex else {
            return .invalid("Invalid regex pattern")
        }
        
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex.numberOfMatches(in: text, options: [], range: range)
        
        return matches > 0 ? .valid : .invalid(errorMessage)
    }
}

public struct CustomValidationRule: ValidationRule {
    public let errorMessage: String
    private let validationClosure: (String) -> Bool
    
    public init(message: String, validation: @escaping (String) -> Bool) {
        self.errorMessage = message
        self.validationClosure = validation
    }
    
    public func validate(_ text: String) -> ValidationResult {
        return validationClosure(text) ? .valid : .invalid(errorMessage)
    }
}

// MARK: - Validation Utility

public class ValidationUtility {
    
    public static func validateText(_ text: String, with rules: [ValidationRule]) -> ValidationResult {
        for rule in rules {
            let result = rule.validate(text)
            if case .invalid = result {
                return result
            }
        }
        return .valid
    }
    
    public static func getAllErrors(for text: String, with rules: [ValidationRule]) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for rule in rules {
            if case .invalid(let message) = rule.validate(text) {
                errors.append(ValidationError(rule: rule, message: message))
            }
        }
        
        return errors
    }
}