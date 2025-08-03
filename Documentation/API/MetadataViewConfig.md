# MetadataViewConfig

A configuration structure that defines the appearance and content of metadata views within a `MetaCellKit` cell.

## Overview

`MetadataViewConfig` allows you to customize individual metadata views with icons, text, colors, and styling options. Each metadata view is a rounded container that can display an icon and/or text with fully customizable appearance.

## Declaration

```swift
public struct MetadataViewConfig
```

## Topics

### Properties

#### `icon`

```swift
public var icon: UIImage?
```

Optional icon to display in the metadata view. Supports SF Symbols and custom images. The icon is tinted with the `textColor`.

#### `text`

```swift
public var text: String?
```

Optional text to display in the metadata view. Displayed alongside the icon if both are provided.

#### `backgroundColor`

```swift
public var backgroundColor: UIColor
```

Background color of the metadata view container. Default is `.systemBlue`.

#### `textColor`

```swift
public var textColor: UIColor
```

Color of the text and icon. Default is `.white`.

#### `cornerRadius`

```swift
public var cornerRadius: CGFloat
```

Corner radius of the metadata view container. Default is `8`.

#### `font`

```swift
public var font: UIFont
```

Font used for the text. Default is `UIFont.systemFont(ofSize: 12, weight: .medium)`.

### Initializers

#### `init(icon:text:backgroundColor:textColor:cornerRadius:font:)`

```swift
public init(
    icon: UIImage? = nil,
    text: String? = nil,
    backgroundColor: UIColor = .systemBlue,
    textColor: UIColor = .white,
    cornerRadius: CGFloat = 8,
    font: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
)
```

Creates a metadata view configuration with the specified parameters.

## Configuration Examples

### Text-Only Metadata

```swift
let priorityConfig = MetadataViewConfig(
    text: "High Priority",
    backgroundColor: .systemRed,
    textColor: .white
)
```

### Icon-Only Metadata

```swift
let statusConfig = MetadataViewConfig(
    icon: UIImage(systemName: "checkmark.circle.fill"),
    backgroundColor: .systemGreen,
    textColor: .white
)
```

### Icon and Text Metadata

```swift
let contextConfig = MetadataViewConfig(
    icon: UIImage(systemName: "at"),
    text: "Work",
    backgroundColor: .systemBlue,
    textColor: .white
)
```

### Custom Styling

```swift
let customConfig = MetadataViewConfig(
    text: "Custom",
    backgroundColor: .systemPurple,
    textColor: .white,
    cornerRadius: 12,
    font: UIFont.systemFont(ofSize: 14, weight: .bold)
)
```

## Common Patterns

### Priority Indicators

```swift
let highPriority = MetadataViewConfig(
    icon: UIImage(systemName: "exclamationmark.triangle.fill"),
    text: "High",
    backgroundColor: .systemRed
)

let mediumPriority = MetadataViewConfig(
    icon: UIImage(systemName: "minus.circle.fill"),
    text: "Medium",
    backgroundColor: .systemOrange
)

let lowPriority = MetadataViewConfig(
    icon: UIImage(systemName: "checkmark.circle.fill"),
    text: "Low",
    backgroundColor: .systemGreen
)
```

### Context Tags

```swift
let workContext = MetadataViewConfig(
    icon: UIImage(systemName: "briefcase.fill"),
    text: "Work",
    backgroundColor: .systemBlue
)

let personalContext = MetadataViewConfig(
    icon: UIImage(systemName: "house.fill"),
    text: "Personal",
    backgroundColor: .systemIndigo
)

let healthContext = MetadataViewConfig(
    icon: UIImage(systemName: "heart.fill"),
    text: "Health",
    backgroundColor: .systemPink
)
```

### Status Indicators

```swift
let activeStatus = MetadataViewConfig(
    icon: UIImage(systemName: "play.fill"),
    text: "Active",
    backgroundColor: .systemGreen
)

let pausedStatus = MetadataViewConfig(
    icon: UIImage(systemName: "pause.fill"),
    text: "Paused",
    backgroundColor: .systemYellow,
    textColor: .black  // Better contrast on yellow
)

let completedStatus = MetadataViewConfig(
    icon: UIImage(systemName: "checkmark.circle.fill"),
    text: "Done",
    backgroundColor: .systemGray
)
```

### Time-based Metadata

```swift
let dueSoonConfig = MetadataViewConfig(
    icon: UIImage(systemName: "clock.fill"),
    text: "Due Soon",
    backgroundColor: .systemOrange
)

let overdueConfig = MetadataViewConfig(
    icon: UIImage(systemName: "exclamationmark.triangle.fill"),
    text: "Overdue",
    backgroundColor: .systemRed
)
```

## Design Guidelines

### Color Accessibility

Ensure sufficient contrast between `backgroundColor` and `textColor`:

```swift
// ✅ Good contrast
MetadataViewConfig(backgroundColor: .systemBlue, textColor: .white)
MetadataViewConfig(backgroundColor: .systemYellow, textColor: .black)

// ⚠️ Poor contrast - avoid
MetadataViewConfig(backgroundColor: .systemYellow, textColor: .white)
```

### Icon Selection

Use meaningful SF Symbols that clearly represent the metadata:

```swift
// ✅ Clear meaning
MetadataViewConfig(icon: UIImage(systemName: "flag.fill"), text: "Priority")
MetadataViewConfig(icon: UIImage(systemName: "clock"), text: "Due Date")
MetadataViewConfig(icon: UIImage(systemName: "person.fill"), text: "Assignee")

// ❌ Unclear meaning
MetadataViewConfig(icon: UIImage(systemName: "circle"), text: "Priority")
```

### Text Length

Keep text concise for optimal appearance:

```swift
// ✅ Concise
MetadataViewConfig(text: "High")
MetadataViewConfig(text: "Work")
MetadataViewConfig(text: "Due Today")

// ⚠️ Too long - may truncate
MetadataViewConfig(text: "Very High Priority Task")
```

### Consistent Styling

Use consistent corner radius and font across related metadata views:

```swift
let standardFont = UIFont.systemFont(ofSize: 12, weight: .medium)
let standardRadius: CGFloat = 8

let config1 = MetadataViewConfig(text: "High", cornerRadius: standardRadius, font: standardFont)
let config2 = MetadataViewConfig(text: "Work", cornerRadius: standardRadius, font: standardFont)
```

## Integration with CellConfiguration

Metadata view configs are used within `CellConfiguration`:

```swift
let priorityConfig = MetadataViewConfig(text: "High", backgroundColor: .systemRed)
let contextConfig = MetadataViewConfig(text: "Work", backgroundColor: .systemBlue)

let cellConfig = CellConfiguration(
    metadataViewCount: 2,
    metadataConfigs: [priorityConfig, contextConfig]
)
```

## See Also

- [CellConfiguration](CellConfiguration.md) - Complete cell configuration
- [MetaCellKit](MetaCellKit.md) - Main cell class
- [MetadataView](MetadataView.md) - Metadata view implementation