import Foundation
import MetaCellKit

// MARK: - Task-Specific Validation Rules

/// Custom validation rule for task descriptions that ensures tasks describe actionable items
struct TaskValidationRule: ValidationRule {
    let errorMessage = "Task should describe a specific action to be taken"
    
    func validate(_ text: String) -> ValidationResult {
        let text = text.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Check for action verbs
        let actionVerbs = [
            // Creation/Building
            "create", "make", "build", "develop", "design", "construct", "generate",
            "produce", "craft", "establish", "form", "implement",
            
            // Review/Analysis
            "review", "check", "verify", "test", "validate", "examine", "inspect",
            "analyze", "research", "study", "investigate", "evaluate", "assess",
            
            // Update/Modification
            "update", "modify", "change", "edit", "revise", "improve", "enhance",
            "refactor", "optimize", "adjust", "correct", "amend",
            
            // Communication
            "send", "email", "call", "contact", "reach", "notify", "inform",
            "discuss", "present", "explain", "communicate", "share",
            
            // Planning/Organization
            "plan", "schedule", "organize", "arrange", "coordinate", "prepare",
            "setup", "configure", "structure", "outline",
            
            // Documentation
            "write", "document", "record", "note", "draft", "compose",
            "publish", "report", "summarize",
            
            // Problem Solving
            "fix", "repair", "solve", "resolve", "debug", "troubleshoot",
            "address", "handle", "tackle",
            
            // Meeting/Collaboration
            "meet", "collaborate", "discuss", "brainstorm", "consult"
        ]
        
        let hasActionVerb = actionVerbs.contains { text.contains($0) }
        
        // Check for vague terms to avoid
        let vagueTerms = [
            "do stuff", "handle it", "work on", "deal with",
            "take care of", "sort out", "figure out", "look into",
            "think about", "consider", "maybe", "perhaps"
        ]
        
        let hasVagueTerm = vagueTerms.contains { text.contains($0) }
        
        if hasVagueTerm {
            return .invalid("Please be more specific about what needs to be done")
        }
        
        if !hasActionVerb && text.count > 10 {
            return .invalid(errorMessage)
        }
        
        return .valid
    }
}

/// Validation rule for preventing duplicate tasks
struct DuplicateTaskValidationRule: ValidationRule {
    let existingTasks: [String]
    let errorMessage = "A task with this description already exists"
    
    init(existingTasks: [String]) {
        self.existingTasks = existingTasks.map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
    }
    
    func validate(_ text: String) -> ValidationResult {
        let normalizedText = text.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Check for exact duplicates
        if existingTasks.contains(normalizedText) {
            return .invalid(errorMessage)
        }
        
        // Check for very similar tasks (fuzzy matching)
        for existingTask in existingTasks {
            let similarity = calculateSimilarity(between: normalizedText, and: existingTask)
            if similarity > 0.9 {  // 90% similarity threshold
                return .invalid("This task is very similar to an existing one")
            }
        }
        
        return .valid
    }
    
    private func calculateSimilarity(between text1: String, and text2: String) -> Double {
        // Simple Levenshtein distance-based similarity
        let distance = levenshteinDistance(text1, text2)
        let maxLength = max(text1.count, text2.count)
        return maxLength == 0 ? 1.0 : 1.0 - (Double(distance) / Double(maxLength))
    }
    
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let a = Array(s1)
        let b = Array(s2)
        let m = a.count
        let n = b.count
        
        var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        
        for i in 0...m { dp[i][0] = i }
        for j in 0...n { dp[0][j] = j }
        
        for i in 1...m {
            for j in 1...n {
                if a[i-1] == b[j-1] {
                    dp[i][j] = dp[i-1][j-1]
                } else {
                    dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
                }
            }
        }
        
        return dp[m][n]
    }
}

/// Validation rule for ensuring tasks have time-bound elements or urgency indicators
struct TimeBoundValidationRule: ValidationRule {
    let errorMessage = "Consider adding timing information (today, tomorrow, by Friday, etc.)"
    let isStrict: Bool
    
    init(strict: Bool = false) {
        self.isStrict = strict
    }
    
    func validate(_ text: String) -> ValidationResult {
        let text = text.lowercased()
        
        let timeIndicators = [
            // Immediate timing
            "today", "tonight", "now", "asap", "urgent", "immediately",
            "right away", "this morning", "this afternoon", "this evening",
            
            // Near future
            "tomorrow", "this week", "next week", "this month", "next month",
            "soon", "quickly", "shortly",
            
            // Specific days
            "monday", "tuesday", "wednesday", "thursday", "friday",
            "saturday", "sunday", "weekend",
            
            // Deadline language
            "by friday", "before", "after", "during", "deadline", "due",
            "schedule", "appointment", "meeting"
        ]
        
        let hasTimeIndicator = timeIndicators.contains { text.contains($0) }
        
        if isStrict && !hasTimeIndicator {
            return .invalid("Task must include specific timing information")
        } else if !hasTimeIndicator && text.count > 20 {
            // For longer tasks, suggest adding timing (but don't require it)
            return .invalid(errorMessage)
        }
        
        return .valid
    }
}

/// Validation rule for preventing potentially harmful or inappropriate content
struct SafeContentValidationRule: ValidationRule {
    let errorMessage = "Content contains inappropriate or potentially harmful information"
    
    func validate(_ text: String) -> ValidationResult {
        let text = text.lowercased()
        
        // Security-related suspicious content
        let suspiciousPatterns = [
            // Script injection attempts
            "<script", "</script>", "javascript:", "vbscript:",
            "onclick", "onerror", "onload", "eval(", "document.",
            "window.", "alert(", "confirm(", "prompt(",
            
            // SQL injection attempts
            "drop table", "delete from", "insert into", "select *",
            "union select", "' or '1'='1", "'; drop",
            
            // File system access
            "../", "..\\", "/etc/passwd", "c:\\windows",
            
            // Network/system commands
            "curl", "wget", "ssh", "ftp", "telnet"
        ]
        
        // Inappropriate content indicators
        let inappropriate = [
            "password", "secret", "token", "api key", "private key",
            "credit card", "ssn", "social security"
        ]
        
        for pattern in suspiciousPatterns {
            if text.contains(pattern) {
                return .invalid("Suspicious content detected for security reasons")
            }
        }
        
        for term in inappropriate {
            if text.contains(term) {
                return .invalid("Please avoid including sensitive information in task descriptions")
            }
        }
        
        return .valid
    }
}

/// Validation rule for ensuring professional language in work contexts
struct ProfessionalLanguageValidationRule: ValidationRule {
    let errorMessage = "Please use more professional language"
    
    func validate(_ text: String) -> ValidationResult {
        let text = text.lowercased()
        
        // Casual/unprofessional terms to flag
        let unprofessionalTerms = [
            "gonna", "wanna", "dunno", "yeah", "nah", "whatever",
            "stuff", "things", "junk", "crap", "sucks", "stupid",
            "dumb", "lame", "weird", "crazy"
        ]
        
        // Check for excessive informal language
        let informalCount = unprofessionalTerms.reduce(0) { count, term in
            return count + (text.contains(term) ? 1 : 0)
        }
        
        if informalCount > 1 {
            return .invalid("Please use more professional language for work tasks")
        }
        
        // Check for proper capitalization (basic check)
        if !text.isEmpty && Character(text.prefix(1)).isLowercase && text.count > 5 {
            return .invalid("Task description should start with a capital letter")
        }
        
        return .valid
    }
}

/// Validation rule for ensuring task completeness and specificity
struct TaskCompletenessValidationRule: ValidationRule {
    let errorMessage = "Task needs more specific details to be actionable"
    
    func validate(_ text: String) -> ValidationResult {
        let text = text.trimmingCharacters(in: .whitespaces)
        
        // Check for minimum word count
        let words = text.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if words.count < 3 {
            return .invalid("Task description should contain at least 3 words")
        }
        
        // Check for overly generic terms
        let genericTerms = [
            "something", "anything", "everything", "nothing",
            "misc", "various", "general", "random", "other"
        ]
        
        let hasGenericTerm = genericTerms.contains { text.lowercased().contains($0) }
        if hasGenericTerm {
            return .invalid("Please be more specific instead of using generic terms")
        }
        
        // Check for question marks (tasks should be statements)
        if text.contains("?") {
            return .invalid("Tasks should be statements of what to do, not questions")
        }
        
        return .valid
    }
}

// MARK: - Composite Validation Rules

/// A comprehensive validation rule that combines multiple task-specific validations
struct ComprehensiveTaskValidationRule: ValidationRule {
    let errorMessage = "Task validation failed"
    private let rules: [ValidationRule]
    
    init(existingTasks: [String] = [], requireTiming: Bool = false, requireProfessional: Bool = false) {
        var rules: [ValidationRule] = [
            TaskValidationRule(),
            SafeContentValidationRule(),
            TaskCompletenessValidationRule()
        ]
        
        if !existingTasks.isEmpty {
            rules.append(DuplicateTaskValidationRule(existingTasks: existingTasks))
        }
        
        if requireTiming {
            rules.append(TimeBoundValidationRule(strict: true))
        }
        
        if requireProfessional {
            rules.append(ProfessionalLanguageValidationRule())
        }
        
        self.rules = rules
    }
    
    func validate(_ text: String) -> ValidationResult {
        for rule in rules {
            let result = rule.validate(text)
            if case .invalid = result {
                return result
            }
        }
        return .valid
    }
}

// MARK: - Utility Functions

/// Utility class for creating common validation rule combinations
struct TaskValidationUtility {
    
    /// Creates validation rules for personal tasks
    static func personalTaskRules(existingTasks: [String] = []) -> [ValidationRule] {
        return [
            LengthValidationRule(min: 3, max: 200),
            TaskValidationRule(),
            SafeContentValidationRule(),
            TaskCompletenessValidationRule()
        ] + (existingTasks.isEmpty ? [] : [DuplicateTaskValidationRule(existingTasks: existingTasks)])
    }
    
    /// Creates validation rules for work tasks
    static func workTaskRules(existingTasks: [String] = []) -> [ValidationRule] {
        return [
            LengthValidationRule(min: 5, max: 300),
            TaskValidationRule(),
            SafeContentValidationRule(),
            ProfessionalLanguageValidationRule(),
            TaskCompletenessValidationRule(),
            TimeBoundValidationRule(strict: false)
        ] + (existingTasks.isEmpty ? [] : [DuplicateTaskValidationRule(existingTasks: existingTasks)])
    }
    
    /// Creates basic validation rules for simple use cases
    static func basicTaskRules() -> [ValidationRule] {
        return [
            LengthValidationRule(min: 3, max: 150),
            TaskValidationRule(),
            SafeContentValidationRule()
        ]
    }
    
    /// Creates strict validation rules for critical tasks
    static func strictTaskRules(existingTasks: [String] = []) -> [ValidationRule] {
        return [
            LengthValidationRule(min: 10, max: 500),
            ComprehensiveTaskValidationRule(
                existingTasks: existingTasks,
                requireTiming: true,
                requireProfessional: true
            )
        ]
    }
}