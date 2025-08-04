# MetaCellKit Editing Features Example

A comprehensive example project demonstrating all editing capabilities of MetaCellKit v1.1.0, including in-place editing, validation, dynamic height adjustment, and icon alignment.

## Overview

This example project shows how to implement and customize all editing features in MetaCellKit, including:

- ✅ In-place text editing with validation
- ✅ Dynamic height adjustment during editing
- ✅ Icon alignment options (top, middle, bottom)
- ✅ Real-time character counting
- ✅ Auto-save functionality
- ✅ Comprehensive validation rules
- ✅ Custom validation with business logic
- ✅ Smooth animations and user experience

## Project Structure

```
EditingExample/
├── TaskEditingViewController.swift      // Main example implementation
├── TaskData.swift                      // Data model conforming to CellDataProtocol
├── CustomValidationRules.swift         // Custom validation examples
├── TaskValidationUtility.swift         // Business logic validation
├── EditingDemoTableViewCell.swift      // Custom cell subclass example
├── Main.storyboard                     // Interface Builder setup
└── Assets.xcassets                     // Icons and colors
```

## Features Demonstrated

### 1. Basic Editing Setup
- Enabling editing on cells
- Handling editing delegate methods
- Basic validation rules

### 2. Advanced Validation
- Multiple validation layers
- Custom business logic validation
- Real-time vs. submit validation
- Localized error messages

### 3. Dynamic Height Adjustment
- Height changes during editing
- Smooth table view animations
- Icon alignment with expanding text

### 4. Auto-Save Functionality
- Configurable auto-save intervals
- Save indicators and feedback
- Handling app lifecycle during editing

### 5. Custom Styling
- Different icon alignments
- Custom fonts and colors
- Metadata view configurations

## Key Implementation Files

### TaskEditingViewController.swift

The main view controller demonstrating all editing features:

```swift
import UIKit
import MetaCellKit

class TaskEditingViewController: UITableViewController {
    
    // MARK: - Data
    private var tasks: [TaskData] = [
        TaskData(
            title: "Review quarterly reports",
            dueDate: Date().addingTimeInterval(86400 * 3),
            priority: "High",
            context: "Work",
            status: "In Progress"
        ),
        TaskData(
            title: "Prepare presentation for board meeting next week",
            dueDate: Date().addingTimeInterval(86400 * 7),
            priority: "High",
            context: "Work", 
            status: "Not Started"
        ),
        // ... more sample data
    ]
    
    // MARK: - Configuration
    private lazy var editingConfig: CellConfiguration = {
        var config = CellConfiguration()
        config.style = .detail
        config.metadataViewCount = 3
        config.iconAlignment = .top  // Icon stays at top during editing
        
        // Editing configuration
        config.editing.isEditingEnabled = true
        config.editing.maxTextLength = 300
        config.editing.characterCountDisplay = .both
        config.editing.enablesDynamicHeight = true
        config.editing.autoSaveInterval = 2.0
        config.editing.placeholderText = "Enter task description..."
        
        // Validation rules
        config.editing.validationRules = [
            LengthValidationRule(min: 5, max: 300),
            RegexValidationRule(
                pattern: "^[A-Za-z0-9\\s.,!?'\"\\-()]*$",
                message: "Only basic characters and punctuation allowed"
            ),
            TaskValidationRule()  // Custom business logic
        ]
        
        // Metadata configurations
        let priorityConfig = MetadataViewConfig(
            icon: UIImage(systemName: "flag.fill"),
            backgroundColor: .systemRed,
            textColor: .white
        )
        
        let contextConfig = MetadataViewConfig(
            icon: UIImage(systemName: "folder.fill"),
            backgroundColor: .systemBlue,
            textColor: .white
        )
        
        let statusConfig = MetadataViewConfig(
            icon: UIImage(systemName: "circle.fill"),
            backgroundColor: .systemGreen,
            textColor: .white
        )
        
        config.metadataConfigs = [priorityConfig, contextConfig, statusConfig]
        
        return config
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.register(MetaCellKit.self, forCellReuseIdentifier: "EditingCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.systemGroupedBackground
    }
    
    private func setupNavigationBar() {
        title = "Editable Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Task",
            style: .plain,
            target: self,
            action: #selector(addTask)
        )
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditingCell", for: indexPath) as! MetaCellKit
        
        let task = tasks[indexPath.row]
        cell.configure(with: task, configuration: editingConfig)
        cell.editingDelegate = self
        
        return cell
    }
    
    // MARK: - Actions
    @objc private func addTask() {
        let newTask = TaskData(
            title: "New task",
            dueDate: Date().addingTimeInterval(86400),
            priority: "Medium",
            context: "Personal",
            status: "Not Started"
        )
        
        tasks.insert(newTask, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        // Start editing the new task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MetaCellKit {
                cell.beginEditing()
            }
        }
    }
}

// MARK: - MetaCellKitEditingDelegate
extension TaskEditingViewController: MetaCellKitEditingDelegate {
    
    func cellDidBeginEditing(_ cell: MetaCellKit) {
        // Disable table view scrolling during editing for better UX
        tableView.isScrollEnabled = false
        
        // Scroll to make cell visible if needed
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    func cellDidEndEditing(_ cell: MetaCellKit, with text: String) {
        // Re-enable scrolling
        tableView.isScrollEnabled = true
        
        // Save the edited text
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tasks[indexPath.row].title = text
        
        // Persist data
        saveTaskData()
        
        // Show completion feedback
        showSaveCompletedFeedback()
    }
    
    func cell(_ cell: MetaCellKit, didChangeText text: String) {
        // Real-time feedback - update character count display
        updateCharacterCountDisplay(for: cell, text: text)
    }
    
    func cellShouldReturn(_ cell: MetaCellKit) -> Bool {
        // Custom return key handling
        guard let text = cell.getText(), !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(message: "Please enter a task description")
            return false
        }
        
        // Allow ending editing
        return true
    }
    
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {
        // Handle validation errors with user-friendly messages
        handleValidationError(error, for: cell)
    }
    
    func cell(_ cell: MetaCellKit, willChangeHeightTo height: CGFloat) {
        // Animate height changes smoothly
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        })
    }
    
    func cell(_ cell: MetaCellKit, didAutoSaveText text: String) {
        // Handle auto-save
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tasks[indexPath.row].title = text
        
        // Auto-save to persistent storage
        autoSaveTaskData()
        
        // Show subtle auto-save indicator
        showAutoSaveIndicator(for: cell)
    }
    
    func cellShouldAutoSave(_ cell: MetaCellKit) -> Bool {
        // Only auto-save when app is active and not performing bulk operations
        return UIApplication.shared.applicationState == .active
    }
    
    // MARK: - Helper Methods
    private func handleValidationError(_ error: ValidationError, for cell: MetaCellKit) {
        switch error.rule {
        case is LengthValidationRule:
            showInlineError(error.message, for: cell)
        case is RegexValidationRule:
            showFormattingError(error.message, for: cell)
        case is TaskValidationRule:
            showBusinessLogicError(error.message, for: cell)
        default:
            showGenericError(error.message, for: cell)
        }
    }
    
    private func showInlineError(_ message: String, for cell: MetaCellKit) {
        // Show error directly in the cell or nearby
        let alert = UIAlertController(title: "Input Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showAutoSaveIndicator(for cell: MetaCellKit) {
        // Show a subtle save indicator
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let indicator = UILabel()
        indicator.text = "Auto-saved"
        indicator.font = UIFont.systemFont(ofSize: 12)
        indicator.textColor = .systemGreen
        indicator.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        indicator.textAlignment = .center
        indicator.layer.cornerRadius = 4
        indicator.clipsToBounds = true
        
        // Add to cell temporarily
        cell.contentView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            indicator.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            indicator.widthAnchor.constraint(equalToConstant: 80),
            indicator.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Fade out after 2 seconds
        UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
            indicator.alpha = 0
        }) { _ in
            indicator.removeFromSuperview()
        }
    }
    
    private func saveTaskData() {
        // Implement persistent storage
        print("Saving task data...")
    }
    
    private func autoSaveTaskData() {
        // Implement auto-save logic
        print("Auto-saving task data...")
    }
    
    private func showSaveCompletedFeedback() {
        // Brief success feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
```

### TaskData.swift

Data model demonstrating CellDataProtocol conformance:

```swift
import Foundation
import MetaCellKit

struct TaskData: CellDataProtocol {
    var title: String
    var icon: UIImage? { UIImage(systemName: "checkmark.circle") }
    var badge: String? { nil }
    let dueDate: Date
    let priority: String
    let context: String
    let status: String
    
    init(title: String, dueDate: Date, priority: String, context: String, status: String) {
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.context = context
        self.status = status
    }
}
```

### CustomValidationRules.swift

Custom validation rules for business logic:

```swift
import Foundation
import MetaCellKit

// Custom validation rule for task descriptions
struct TaskValidationRule: ValidationRule {
    let errorMessage = "Task should describe a specific action to be taken"
    
    func validate(_ text: String) -> ValidationResult {
        let text = text.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Check for action verbs
        let actionVerbs = [
            "create", "make", "build", "develop", "design",
            "review", "check", "verify", "test", "validate",
            "update", "modify", "change", "edit", "revise",
            "send", "email", "call", "contact", "reach",
            "meet", "schedule", "plan", "organize", "arrange",
            "write", "document", "record", "note", "draft",
            "fix", "repair", "solve", "resolve", "debug",
            "analyze", "research", "study", "investigate"
        ]
        
        let hasActionVerb = actionVerbs.contains { text.contains($0) }
        
        // Check for vague terms to avoid
        let vagueTerms = [
            "do stuff", "handle it", "work on", "deal with",
            "take care of", "sort out", "figure out"
        ]
        
        let hasVagueTerm = vagueTerms.contains { text.contains($0) }
        
        if hasVagueTerm {
            return .invalid("Please be more specific about what needs to be done")
        }
        
        if !hasActionVerb {
            return .invalid(errorMessage)
        }
        
        return .valid
    }
}

// Validation rule for preventing duplicate tasks
struct DuplicateTaskValidationRule: ValidationRule {
    let existingTasks: [String]
    let errorMessage = "A task with this description already exists"
    
    init(existingTasks: [String]) {
        self.existingTasks = existingTasks.map { $0.lowercased() }
    }
    
    func validate(_ text: String) -> ValidationResult {
        let normalizedText = text.lowercased().trimmingCharacters(in: .whitespaces)
        return existingTasks.contains(normalizedText) ? .invalid(errorMessage) : .valid
    }
}

// Validation rule for ensuring tasks have time-bound elements
struct TimeBoundValidationRule: ValidationRule {
    let errorMessage = "Task should include timing information (today, tomorrow, this week, etc.)"
    
    func validate(_ text: String) -> ValidationResult {
        let text = text.lowercased()
        
        let timeIndicators = [
            "today", "tomorrow", "tonight", "this week", "next week",
            "this month", "next month", "by friday", "before",
            "after", "during", "asap", "urgent", "deadline",
            "monday", "tuesday", "wednesday", "thursday", "friday"
        ]
        
        let hasTimeIndicator = timeIndicators.contains { text.contains($0) }
        return hasTimeIndicator ? .valid : .invalid(errorMessage)
    }
}
```

## Running the Example

1. Open the project in Xcode
2. Make sure MetaCellKit is properly linked
3. Build and run the project
4. Try different editing scenarios:
   - Tap on any task to start editing
   - Type long text to see dynamic height adjustment
   - Try invalid input to see validation in action
   - Experience auto-save functionality
   - Test different icon alignments

## Key Learning Points

### 1. Editing Configuration
- How to enable and configure editing functionality
- Setting up validation rules effectively
- Configuring auto-save and character counting

### 2. Delegate Implementation
- Handling all editing events properly
- Providing smooth user experience during editing
- Managing table view animations during height changes

### 3. Validation Design
- Creating layered validation rules
- Implementing custom business logic validation
- Providing helpful error messages and user guidance

### 4. Performance Considerations
- Optimizing validation for real-time typing
- Managing auto-save frequency
- Efficient cell reuse with editing state

### 5. User Experience
- Smooth animations and transitions
- Contextual feedback and error handling
- Accessibility and keyboard management

## Customization Examples

The example project includes several customization patterns:

- **Icon Alignment Variants**: Different cells showing top, middle, and bottom icon alignment
- **Validation Complexity**: From simple length validation to complex business logic
- **Auto-Save Strategies**: Different auto-save intervals and triggers
- **Error Handling**: Various approaches to displaying validation errors
- **Animation Customization**: Custom animations for height changes and feedback

## Best Practices Demonstrated

1. **Performance**: Efficient validation ordering and debouncing
2. **User Experience**: Clear feedback and smooth interactions
3. **Data Management**: Proper save strategies and data persistence
4. **Error Handling**: Comprehensive validation with helpful messages
5. **Accessibility**: VoiceOver support and dynamic type compatibility

## See Also

- [Editing Tutorial](../Tutorials/AdvancedEditing.md)
- [Validation Best Practices](../Tutorials/ValidationBestPractices.md)
- [API Reference](../API/README.md)
- [Migration Guide](../Tutorials/Migration.md)