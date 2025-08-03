# CellKit API Reference

Complete API documentation for all CellKit classes, structs, and protocols.

## Core Classes

### [CellKit](CellKit.md)
The main table view cell class that provides unified, configurable cell functionality.

**Key Features:**
- Unified cell architecture replacing multiple specialized cells
- Support for 0-3 configurable metadata views
- Master and Detail style variants
- Automatic data binding with reflection
- Built-in card-based styling with animations

### [DynamicBadgeLabel](DynamicBadgeLabel.md)
Auto-sizing badge component for displaying counts and status indicators.

**Key Features:**
- Automatic width calculation based on content
- Support for strings, numbers, and custom values
- Customizable colors and minimum size
- Automatic show/hide behavior

### [MetadataView](MetadataView.md)
Individual metadata container that displays icon and text with custom styling.

**Key Features:**
- Icon and text display with flexible layout
- Parametrizable background and text colors
- Auto-hiding when empty
- Configurable corner radius and fonts

## Configuration System

### [CellConfiguration](CellConfiguration.md)
Main configuration struct that defines cell layout, styling, and behavior.

**Key Properties:**
- `style` - Visual style (master/detail)
- `metadataViewCount` - Number of metadata views (0-3)
- `metadataConfigs` - Array of metadata view configurations
- `showBadge` - Badge visibility control
- `showDisclosure` - Disclosure indicator control
- `useTitleTextView` - Title display mode

### [MetadataViewConfig](MetadataViewConfig.md)
Configuration for individual metadata views with full customization options.

**Key Properties:**
- `icon` - Optional SF Symbol or custom image
- `text` - Display text
- `backgroundColor` - Container background color
- `textColor` - Text and icon color
- `cornerRadius` - Corner rounding
- `font` - Text font

## Data Binding

### [CellDataProtocol](CellDataProtocol.md)
Protocol for data types that can be automatically bound to CellKit cells.

**Automatic Binding:**
- `title`/`name` → Main title
- `icon`/`image` → Icon display
- `badge`/`count` → Badge display
- Other properties → Metadata views
- `Date` properties → Automatic formatting

### [DateFormattingUtility](DateFormattingUtility.md)
Utility class for automatic date formatting with multiple styles.

**Format Styles:**
- `.short` - "15 Jan"
- `.medium` - "15 Jan 2024"
- `.long` - "Monday, January 15, 2024"
- `.time` - "3:30 PM"
- `.relative` - "2h ago", "3d ago"

## Class Hierarchy

```
UITableViewCell
└── CellKit
    ├── DynamicBadgeLabel (UILabel)
    └── MetadataView (UIView)

Protocols
├── CellDataProtocol
└── Built-in conformances:
    ├── String
    ├── Int
    ├── Double
    └── Date

Configuration
├── CellConfiguration (struct)
└── MetadataViewConfig (struct)

Utilities
└── DateFormattingUtility (class)
```

## Quick Reference

### Basic Usage
```swift
// Simple configuration
cell.configure(with: data, metadataViews: 2, style: .detail)

// Advanced configuration
let config = CellConfiguration(
    style: .detail,
    metadataViewCount: 3,
    metadataConfigs: [priority, context, status]
)
cell.configure(with: data, configuration: config)
```

### Data Model
```swift
struct MyData: CellDataProtocol {
    let title: String       // → Title
    let icon: UIImage?      // → Icon
    let badge: String?      // → Badge
    let dueDate: Date       // → Metadata (auto-formatted)
    let priority: String    // → Metadata
}
```

### Metadata Configuration
```swift
let metadata = MetadataViewConfig(
    icon: UIImage(systemName: "flag.fill"),
    text: "High",
    backgroundColor: .systemRed,
    textColor: .white
)
```

## Migration from UITableViewCell

CellKit is designed to replace existing table view cell implementations:

1. **Single Class**: Replace multiple cell classes with CellKit
2. **Configuration-Based**: Use `CellConfiguration` instead of custom styling
3. **Automatic Binding**: Conform data to `CellDataProtocol` for automatic binding
4. **Built-in Styling**: Use master/detail styles instead of custom appearance

## Performance Considerations

- **Cell Reuse**: CellKit optimizes for efficient cell reuse
- **Configuration Caching**: Reuse `CellConfiguration` objects when possible
- **Memory Management**: Automatic cleanup in `prepareForReuse`
- **Layout Optimization**: Constraint-based layout with performance optimizations

## Accessibility Support

CellKit includes built-in accessibility features:
- VoiceOver support with automatic labels
- Dynamic Type support
- High contrast mode adaptation
- Larger text support when configured

## See Also

- [Getting Started Tutorial](../Tutorials/GettingStarted.md)
- [Configuration Guide](../Tutorials/Configuration.md)
- [Migration Guide](../Tutorials/Migration.md)
- [Basic Usage Examples](../Examples/BasicUsage.md)
- [Advanced Configuration Examples](../Examples/AdvancedConfigurations.md)