# Configuration Guide

Learn how to use `CellConfiguration` and `MetadataViewConfig` to customize MetaCellKit cells for your specific needs.

## Overview

MetaCellKit provides two main configuration approaches:
1. **Simple Configuration** - Quick setup with sensible defaults
2. **Advanced Configuration** - Full control over appearance and behavior

## Simple Configuration

### Basic Usage

The simplest way to configure a MetaCellKit cell:

```swift
// Just specify the number of metadata views
cell.configure(with: data, metadataViews: 2, style: .detail)
```

This automatically:
- Shows badge and disclosure indicator
- Uses default metadata colors (systemBlue, systemGreen, systemOrange)
- Applies the specified style

### Pre-configured Layouts

Use built-in configuration helpers:

```swift
// Basic layout (no metadata)
let basicConfig = MetaCellKit.basicConfiguration(style: .master)
cell.configure(with: data, configuration: basicConfig)

// Single metadata view
let singleConfig = MetaCellKit.singleMetadataConfiguration(style: .detail)
cell.configure(with: data, configuration: singleConfig)

// Dual metadata views
let dualConfig = MetaCellKit.dualMetadataConfiguration(style: .master)
cell.configure(with: data, configuration: dualConfig)

// Triple metadata views
let tripleConfig = MetaCellKit.tripleMetadataConfiguration(style: .detail)
cell.configure(with: data, configuration: tripleConfig)
```

## Advanced Configuration

### Creating Custom Configurations

For full control, create a `CellConfiguration` object:

```swift
var config = CellConfiguration()
config.style = .detail
config.metadataViewCount = 3
config.showBadge = true
config.showDisclosure = false
config.useTitleTextView = true

// Define custom metadata configurations
let priorityConfig = MetadataViewConfig(
    icon: UIImage(systemName: "flag.fill"),
    text: "High",
    backgroundColor: .systemRed,
    textColor: .white
)

let contextConfig = MetadataViewConfig(
    icon: UIImage(systemName: "briefcase.fill"),
    text: "Work",
    backgroundColor: .systemBlue,
    textColor: .white
)

let statusConfig = MetadataViewConfig(
    icon: UIImage(systemName: "clock.fill"),
    text: "In Progress",
    backgroundColor: .systemOrange,
    textColor: .white
)

config.metadataConfigs = [priorityConfig, contextConfig, statusConfig]

cell.configure(with: data, configuration: config)
```

## Layout Variants

### Basic Layout (0 metadata views)

Perfect for simple lists where you only need title, icon, badge, and disclosure:

```swift
let config = CellConfiguration(
    style: .master,
    metadataViewCount: 0,
    showBadge: true,
    showDisclosure: true
)
```

**Use cases:**
- Contact lists
- Simple menu items
- Navigation lists

### Single Metadata (1 metadata view)

Adds one metadata container for additional context:

```swift
let priorityConfig = MetadataViewConfig(
    text: "High Priority",
    backgroundColor: .systemRed
)

let config = CellConfiguration(
    style: .detail,
    metadataViewCount: 1,
    metadataConfigs: [priorityConfig]
)
```

**Use cases:**
- Tasks with priority
- Items with status
- Content with categories

### Dual Metadata (2 metadata views)

Provides two metadata containers for richer information:

```swift
let priorityConfig = MetadataViewConfig(text: "High", backgroundColor: .systemRed)
let contextConfig = MetadataViewConfig(text: "Work", backgroundColor: .systemBlue)

let config = CellConfiguration(
    style: .detail,
    metadataViewCount: 2,
    metadataConfigs: [priorityConfig, contextConfig]
)
```

**Use cases:**
- Tasks with priority and context
- Events with type and status
- Items with multiple classifications

### Triple Metadata (3 metadata views)

Maximum metadata display for complex items:

```swift
let priorityConfig = MetadataViewConfig(text: "High", backgroundColor: .systemRed)
let contextConfig = MetadataViewConfig(text: "Work", backgroundColor: .systemBlue)
let statusConfig = MetadataViewConfig(text: "Active", backgroundColor: .systemGreen)

let config = CellConfiguration(
    style: .detail,
    metadataViewCount: 3,
    metadataConfigs: [priorityConfig, contextConfig, statusConfig]
)
```

**Use cases:**
- Complex project tasks
- Multi-dimensional data
- Feature-rich list items

## Style System

### Master Style

Subtle styling for primary lists:

```swift
let config = CellConfiguration(style: .master)
```

**Characteristics:**
- System background colors
- Subtle borders (0.4pt)
- Minimal shadows
- Tight spacing
- Corner radius: 10pt

**Best for:**
- Main navigation lists
- Master view controllers
- Primary content lists

### Detail Style

Enhanced styling for secondary views:

```swift
let config = CellConfiguration(style: .detail)
```

**Characteristics:**
- Paper-like background (#F6F5F3)
- Stronger borders (0.8pt)
- Enhanced shadows
- More spacing
- Corner radius: 6pt

**Best for:**
- Detail view lists
- Secondary content
- Emphasis on individual items

## Metadata View Configuration

### Basic Metadata Configuration

```swift
let config = MetadataViewConfig(
    text: "High",
    backgroundColor: .systemRed,
    textColor: .white
)
```

### Icon + Text Configuration

```swift
let config = MetadataViewConfig(
    icon: UIImage(systemName: "flag.fill"),
    text: "Priority",
    backgroundColor: .systemRed,
    textColor: .white
)
```

### Custom Styling

```swift
let config = MetadataViewConfig(
    icon: UIImage(systemName: "star.fill"),
    text: "Premium",
    backgroundColor: .systemPurple,
    textColor: .white,
    cornerRadius: 12,
    font: UIFont.systemFont(ofSize: 14, weight: .bold)
)
```

### Icon-Only Configuration

```swift
let config = MetadataViewConfig(
    icon: UIImage(systemName: "checkmark.circle.fill"),
    backgroundColor: .systemGreen,
    textColor: .white
)
```

## Visibility Controls

### Badge Visibility

Control when badges are shown:

```swift
var config = CellConfiguration()
config.showBadge = false  // Hide badge even if data contains badge info

// Or conditionally
config.showBadge = task.isImportant
```

### Disclosure Indicator

Control navigation affordance:

```swift
var config = CellConfiguration()
config.showDisclosure = false  // No navigation indicator

// Or conditionally  
config.showDisclosure = task.hasDetails
```

### Title Text View

Switch between UILabel and UITextView for title:

```swift
var config = CellConfiguration()
config.useTitleTextView = true  // Enables multi-line, selection, etc.
```

**UILabel vs UITextView:**
- **UILabel**: Single/multi-line text, better performance
- **UITextView**: Scrollable, selectable, interactive links

## Conditional Configuration

### Based on Data

```swift
func configureCell(_ cell: MetaCellKit, with task: Task) {
    var config = CellConfiguration()
    
    // Style based on importance
    config.style = task.isImportant ? .detail : .master
    
    // Metadata based on data availability
    var metadataConfigs: [MetadataViewConfig] = []
    
    if let priority = task.priority {
        metadataConfigs.append(MetadataViewConfig(
            text: priority,
            backgroundColor: colorForPriority(priority)
        ))
    }
    
    if let context = task.context {
        metadataConfigs.append(MetadataViewConfig(
            text: context,
            backgroundColor: .systemBlue
        ))
    }
    
    if task.isOverdue {
        metadataConfigs.append(MetadataViewConfig(
            icon: UIImage(systemName: "exclamationmark.triangle.fill"),
            text: "Overdue",
            backgroundColor: .systemRed
        ))
    }
    
    config.metadataViewCount = metadataConfigs.count
    config.metadataConfigs = metadataConfigs
    
    cell.configure(with: task, configuration: config)
}
```

### Based on Index Path

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MetaCellKit", for: indexPath) as! MetaCellKit
    let task = tasks[indexPath.row]
    
    // Different configuration for first item
    if indexPath.row == 0 {
        let config = MetaCellKit.tripleMetadataConfiguration(style: .detail)
        cell.configure(with: task, configuration: config)
    } else {
        cell.configure(with: task, metadataViews: 1, style: .master)
    }
    
    return cell
}
```

## Performance Optimization

### Reuse Configurations

Create configurations once and reuse them:

```swift
class TaskListViewController: UITableViewController {
    
    // Pre-created configurations
    private let highPriorityConfig: CellConfiguration = {
        var config = CellConfiguration(style: .detail, metadataViewCount: 2)
        config.metadataConfigs = [
            MetadataViewConfig(text: "High", backgroundColor: .systemRed),
            MetadataViewConfig(text: "Work", backgroundColor: .systemBlue)
        ]
        return config
    }()
    
    private let lowPriorityConfig = MetaCellKit.basicConfiguration(style: .master)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MetaCellKit", for: indexPath) as! MetaCellKit
        let task = tasks[indexPath.row]
        
        // Use pre-created configurations
        let config = task.priority == "High" ? highPriorityConfig : lowPriorityConfig
        cell.configure(with: task, configuration: config)
        
        return cell
    }
}
```

### Configuration Factory

Create a factory for generating configurations:

```swift
struct TaskCellConfigurationFactory {
    
    static func configuration(for task: Task) -> CellConfiguration {
        var config = CellConfiguration()
        config.style = task.isImportant ? .detail : .master
        
        var metadataConfigs: [MetadataViewConfig] = []
        
        // Priority metadata
        if let priority = task.priority {
            metadataConfigs.append(MetadataViewConfig(
                text: priority,
                backgroundColor: backgroundColorForPriority(priority)
            ))
        }
        
        // Context metadata
        if let context = task.context {
            metadataConfigs.append(MetadataViewConfig(
                icon: UIImage(systemName: "at"),
                text: context,
                backgroundColor: .systemBlue
            ))
        }
        
        config.metadataViewCount = metadataConfigs.count
        config.metadataConfigs = metadataConfigs
        
        return config
    }
    
    private static func backgroundColorForPriority(_ priority: String) -> UIColor {
        switch priority.lowercased() {
        case "high": return .systemRed
        case "medium": return .systemOrange
        case "low": return .systemGreen
        default: return .systemGray
        }
    }
}

// Usage
let config = TaskCellConfigurationFactory.configuration(for: task)
cell.configure(with: task, configuration: config)
```

## Best Practices

### 1. Consistent Styling

Use consistent metadata colors across your app:

```swift
extension MetadataViewConfig {
    static let highPriority = MetadataViewConfig(text: "High", backgroundColor: .systemRed)
    static let mediumPriority = MetadataViewConfig(text: "Medium", backgroundColor: .systemOrange)
    static let lowPriority = MetadataViewConfig(text: "Low", backgroundColor: .systemGreen)
}
```

### 2. Responsive Design

Adjust configuration based on device:

```swift
let metadataCount = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
cell.configure(with: data, metadataViews: metadataCount, style: .detail)
```

### 3. Accessibility

Consider accessibility when configuring:

```swift
var config = CellConfiguration()
config.useTitleTextView = UIAccessibility.isVoiceOverRunning  // Better VoiceOver support
```

## Summary

MetaCellKit's configuration system provides:
- **Simple APIs** for common use cases
- **Advanced control** for custom requirements
- **Performance optimization** through reusable configurations
- **Consistent styling** across different layouts

Choose the configuration approach that best fits your needs, from simple metadata counts to fully customized metadata view configurations.