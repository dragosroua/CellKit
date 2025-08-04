# MetaCellKit API Reference

Complete API documentation for all MetaCellKit classes, structs, and protocols.

## Core Classes

### [MetaCellKit](MetaCellKit.md)
The main table view cell class that provides unified, configurable cell functionality.

**Key Features:**
- Unified cell architecture replacing multiple specialized cells
- Support for 0-3 configurable metadata views
- Master and Detail style variants  
- Automatic data binding with reflection
- Built-in card-based styling with animations
- **In-place editing with validation** (v1.1.0)
- **Dynamic height adjustment** (v1.1.0)
- **Configurable icon alignment** (v1.1.0)

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
- **`iconAlignment`** - Icon positioning (top/middle/bottom) (v1.1.0)
- **`editing`** - In-place editing configuration (v1.1.0)

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
Protocol for data types that can be automatically bound to MetaCellKit cells.

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

## Editing System (v1.1.0)

### [EditingConfiguration](EditingConfiguration.md)
Configuration struct for in-place editing functionality with comprehensive customization options.

**Key Properties:**
- `isEditingEnabled` - Enable/disable editing
- `maxTextLength`/`minTextLength` - Text length constraints
- `keyboardType`/`returnKeyType` - Keyboard configuration
- `autoSaveInterval` - Auto-save timing
- `characterCountDisplay` - Character count styles
- `validationRules` - Array of validation rules
- `enablesDynamicHeight` - Height adjustment during editing

### [MetaCellKitEditingDelegate](MetaCellKitEditingDelegate.md)
Protocol for handling editing events, validation errors, and height changes.

**Key Methods:**
- `cellDidBeginEditing` - Editing started
- `cellDidEndEditing` - Editing completed  
- `cell(_:didChangeText:)` - Real-time text changes
- `cell(_:validationFailedWith:)` - Validation errors
- `cell(_:willChangeHeightTo:)` - Height change notifications
- `cell(_:didAutoSaveText:)` - Auto-save events

### [ValidationSystem](ValidationSystem.md)
Comprehensive text validation with built-in and custom validation rules.

**Built-in Rules:**
- `LengthValidationRule` - Min/max character limits
- `RegexValidationRule` - Pattern matching validation
- `CustomValidationRule` - Custom validation logic

**Utilities:**
- `ValidationUtility.validateText` - Run multiple validation rules
- `ValidationUtility.getAllErrors` - Get all validation failures

### [IconAlignment](IconAlignment.md)
Enumeration for icon positioning relative to text content.

**Options:**
- `.top` - Icon at top of text (best for multi-line content)
- `.middle` - Icon centered with text (default)
- `.bottom` - Icon at bottom of text

## Class Hierarchy

```
UITableViewCell
└── MetaCellKit
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

MetaCellKit is designed to replace existing table view cell implementations:

1. **Single Class**: Replace multiple cell classes with MetaCellKit
2. **Configuration-Based**: Use `CellConfiguration` instead of custom styling
3. **Automatic Binding**: Conform data to `CellDataProtocol` for automatic binding
4. **Built-in Styling**: Use master/detail styles instead of custom appearance

## Performance Considerations

- **Cell Reuse**: MetaCellKit optimizes for efficient cell reuse
- **Configuration Caching**: Reuse `CellConfiguration` objects when possible
- **Memory Management**: Automatic cleanup in `prepareForReuse`
- **Layout Optimization**: Constraint-based layout with performance optimizations

## Accessibility Support

MetaCellKit includes built-in accessibility features:
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