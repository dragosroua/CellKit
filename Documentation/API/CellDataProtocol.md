# CellDataProtocol

A protocol that marks data types for automatic binding with `CellKit` cells.

## Overview

`CellDataProtocol` serves as a marker protocol for data types that can be automatically bound to `CellKit` cells. The protocol enables reflection-based data binding with special handling for common property names and automatic date formatting.

## Declaration

```swift
public protocol CellDataProtocol {
    // Marker protocol - no required methods
}
```

## Topics

### Default Conformances

Several built-in types conform to `CellDataProtocol` by default:

```swift
extension String: CellDataProtocol {}
extension Int: CellDataProtocol {}
extension Double: CellDataProtocol {}
extension Date: CellDataProtocol {}
```

### Automatic Property Binding

`CellKit` automatically binds properties based on their names using reflection:

#### Title Properties
- `title` → Main title label/text view
- `name` → Main title label/text view

#### Icon Properties
- `icon` → Icon image view (expects `UIImage`)
- `image` → Icon image view (expects `UIImage` or `String` for SF Symbol names)

#### Badge Properties
- `badge` → Badge label (expects `String`)
- `count` → Badge label (expects `Int`, converted to string)

#### Metadata Properties
All other properties are automatically assigned to available metadata views in order.

### Automatic Date Formatting

Properties of type `Date` are automatically formatted using `DateFormattingUtility`:

```swift
struct TaskData: CellDataProtocol {
    let title: String
    let dueDate: Date        // Automatically formatted as "15 Jan 2024"
    let createdDate: Date    // Automatically formatted as "2h ago"
    let priority: String     // Assigned to first available metadata view
}
```

## Creating Custom Data Types

### Basic Implementation

```swift
struct MyTaskData: CellDataProtocol {
    let title: String           // → Title
    let icon: UIImage?          // → Icon
    let badge: String?          // → Badge
    let dueDate: Date?          // → Metadata (automatically formatted)
    let priority: String?       // → Metadata
    let context: String?        // → Metadata
}
```

### Complex Data Model

```swift
struct ProjectTask: CellDataProtocol {
    let name: String                    // → Title (using 'name' instead of 'title')
    let image: String                   // → Icon (SF Symbol name)
    let count: Int                      // → Badge (converted to string)
    let deadline: Date                  // → Metadata (formatted date)
    let assignee: String               // → Metadata
    let status: TaskStatus             // → Metadata (enum converted to string)
    let estimatedHours: Double         // → Metadata
    let notes: String?                 // → Metadata (if not nil)
}

enum TaskStatus: String, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
    case blocked = "Blocked"
}
```

### Data with Custom Icon Logic

```swift
struct TodoItem: CellDataProtocol {
    let title: String
    let isCompleted: Bool
    let dueDate: Date?
    let priority: Priority
    
    // Computed property for icon
    var icon: UIImage? {
        return isCompleted 
            ? UIImage(systemName: "checkmark.circle.fill")
            : UIImage(systemName: "circle")
    }
    
    // Computed property for badge
    var badge: String? {
        guard let dueDate = dueDate else { return nil }
        let timeInterval = dueDate.timeIntervalSince(Date())
        return timeInterval < 0 ? "!" : nil  // Overdue indicator
    }
}
```

## Property Binding Examples

### Example 1: Simple Task

```swift
struct SimpleTask: CellDataProtocol {
    let title: String = "Review documents"
    let badge: String = "3"
}

// Results in:
// - Title: "Review documents"
// - Badge: "3"
// - No icon, no metadata
```

### Example 2: Task with Date

```swift
struct TaskWithDate: CellDataProtocol {
    let title: String = "Complete project"
    let dueDate: Date = Date().addingTimeInterval(86400)  // Tomorrow
    let priority: String = "High"
}

// Results in:
// - Title: "Complete project"
// - Metadata 1: "16 Jan 2024" (automatically formatted date)
// - Metadata 2: "High"
```

### Example 3: Complete Task

```swift
struct CompleteTask: CellDataProtocol {
    let title: String = "Design review meeting"
    let icon: UIImage? = UIImage(systemName: "person.3.fill")
    let count: Int = 5
    let scheduledDate: Date = Date().addingTimeInterval(3600)  // 1 hour from now
    let location: String = "Conference Room A"
    let duration: String = "2 hours"
}

// Results in:
// - Title: "Design review meeting"
// - Icon: person.3.fill symbol
// - Badge: "5"
// - Metadata 1: "15:30" (automatically formatted time)
// - Metadata 2: "Conference Room A"
// - Metadata 3: "2 hours"
```

## Date Formatting Behavior

Date properties are automatically formatted using different styles based on context:

```swift
let now = Date()
let oneHourAgo = now.addingTimeInterval(-3600)
let tomorrow = now.addingTimeInterval(86400)
let nextWeek = now.addingTimeInterval(604800)

// Automatic formatting results:
// oneHourAgo → "1h ago" (relative format)
// now → "Just now" (relative format)
// tomorrow → "16 Jan 2024" (medium format)
// nextWeek → "22 Jan 2024" (medium format)
```

## Best Practices

### Property Naming

Use conventional property names for automatic binding:

```swift
// ✅ Good - uses recognized property names
struct Task: CellDataProtocol {
    let title: String        // Automatically bound to title
    let icon: UIImage?       // Automatically bound to icon
    let badge: String?       // Automatically bound to badge
}

// ⚠️ Works but less intuitive
struct Task: CellDataProtocol {
    let description: String  // Goes to metadata, not title
    let symbol: UIImage?     // Goes to metadata, not icon
    let number: String?      // Goes to metadata, not badge
}
```

### Optional vs Non-Optional Properties

Use optional properties for content that may not always be present:

```swift
struct Task: CellDataProtocol {
    let title: String           // Always present
    let icon: UIImage?          // Optional - may not have icon
    let badge: String?          // Optional - may not have badge
    let dueDate: Date?          // Optional - may not have due date
}
```

### Complex Objects

For complex nested objects, provide computed properties:

```swift
struct Task: CellDataProtocol {
    let title: String
    let assignedUser: User      // Complex object
    let project: Project        // Complex object
    
    // Computed properties for binding
    var assignee: String {
        return assignedUser.name
    }
    
    var projectName: String {
        return project.displayName
    }
}
```

## See Also

- [CellKit](CellKit.md) - Main cell class that uses this protocol
- [DateFormattingUtility](DateFormattingUtility.md) - Date formatting system
- [CellConfiguration](CellConfiguration.md) - Cell configuration options