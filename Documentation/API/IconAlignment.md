# IconAlignment

An enumeration that defines how icons are positioned relative to text content in MetaCellKit cells.

## Overview

`IconAlignment` provides three alignment options for positioning icons within cells, particularly useful when dealing with multi-line text content or varying text heights.

## Declaration

```swift
public enum IconAlignment
```

## Cases

### `top`
```swift
case top
```
Aligns the icon to the top of the text area. Perfect for cells with long, multi-line text content where you want the icon to stay at the top.

### `middle`
```swift
case middle
```
Aligns the icon to the middle/center of the text area. This is the default alignment and provides a balanced appearance for most content types.

### `bottom`
```swift
case bottom
```
Aligns the icon to the bottom of the text area. Creates a unique visual style and can be useful for specific design requirements.

## Usage Examples

### Basic Icon Alignment Configuration
```swift
import MetaCellKit

// Top alignment - icon stays at top of text
var config = CellConfiguration()
config.iconAlignment = .top

// Middle alignment (default)
var config = CellConfiguration()
config.iconAlignment = .middle

// Bottom alignment - icon at bottom of text
var config = CellConfiguration() 
config.iconAlignment = .bottom
```

### With Different Content Types

#### Single Line Text (Default)
```swift
var config = CellConfiguration()
config.iconAlignment = .middle  // Works well for single line

let taskData = TaskData(
    title: "Complete project review",
    icon: UIImage(systemName: "checkmark.circle")
)

cell.configure(with: taskData, configuration: config)
```

#### Multi-line Text Content
```swift
var config = CellConfiguration()
config.iconAlignment = .top  // Icon stays at top when text wraps

let taskData = TaskData(
    title: "Review the quarterly financial reports and prepare a comprehensive summary presentation for the upcoming board meeting scheduled for next week",
    icon: UIImage(systemName: "doc.text.magnifyingglass")
)

cell.configure(with: taskData, configuration: config)
```

#### With Editing and Dynamic Height
```swift
var config = CellConfiguration()
config.iconAlignment = .top
config.editing.isEditingEnabled = true
config.editing.enablesDynamicHeight = true

// Icon will stay at top as user types and cell expands
let taskData = TaskData(
    title: "Short initial text",
    icon: UIImage(systemName: "pencil")
)

cell.configure(with: taskData, configuration: config)
cell.editingDelegate = self
```

### Design Patterns

#### Task Lists
```swift
// Good for action items - icon at top for readability
var taskConfig = CellConfiguration()
taskConfig.iconAlignment = .top
taskConfig.style = .detail
```

#### Status Indicators
```swift
// Status icons work well in middle alignment
var statusConfig = CellConfiguration()
statusConfig.iconAlignment = .middle
statusConfig.style = .master
```

#### Notes or Comments
```swift
// Bottom alignment can create interesting visual hierarchy
var noteConfig = CellConfiguration()
noteConfig.iconAlignment = .bottom
noteConfig.useTitleTextView = true
```

### With Different Cell Styles

#### Master Style
```swift
var config = CellConfiguration()
config.style = .master
config.iconAlignment = .middle  // Subtle, balanced look

cell.configure(with: data, configuration: config)
```

#### Detail Style
```swift
var config = CellConfiguration()
config.style = .detail
config.iconAlignment = .top     // Better for longer content

cell.configure(with: data, configuration: config)
```

### Combined with Metadata Views
```swift
var config = CellConfiguration()
config.iconAlignment = .top
config.metadataViewCount = 3

// Icon alignment works with metadata views
let metadata1 = MetadataViewConfig(text: "Priority", backgroundColor: .systemRed)
let metadata2 = MetadataViewConfig(text: "Due Soon", backgroundColor: .systemOrange)
let metadata3 = MetadataViewConfig(text: "Work", backgroundColor: .systemBlue)

config.metadataConfigs = [metadata1, metadata2, metadata3]

cell.configure(with: data, configuration: config)
```

## Constraints and Layout Behavior

### Top Alignment
- Icon's top edge aligns with the top of the text area
- Best for multi-line content where icon should stay at the beginning
- Maintains position as text content grows vertically

### Middle Alignment
- Icon's center aligns with the center of the text area
- Default behavior that works well for most content
- Automatically adjusts as text area changes size

### Bottom Alignment
- Icon's bottom edge aligns with the bottom of the text area
- Unique visual style for special design requirements
- Icon moves down as text content grows

## Backward Compatibility

Icon alignment is a v1.1.0 feature that maintains full backward compatibility:

```swift
// v1.0.x code continues to work with default middle alignment
cell.configure(with: data, metadataViews: 2, style: .detail)
// Automatically uses .middle alignment

// v1.1.0 code can specify alignment
var config = CellConfiguration()
config.metadataViewCount = 2
config.style = .detail
config.iconAlignment = .top  // New feature
cell.configure(with: data, configuration: config)
```

## Performance Considerations

- Icon alignment uses constraint-based layout for smooth performance
- Alignment changes trigger constraint updates but are optimized for smooth scrolling
- Dynamic alignment adjustments during editing are handled efficiently

## Best Practices

### When to Use Each Alignment

**Top Alignment:**
- Multi-line text content
- Task lists with descriptions  
- Cells with editing enabled
- When icon represents the beginning of content

**Middle Alignment:**
- Single-line or short text content
- Balanced visual appearance needed
- Status indicators
- Default choice for most use cases

**Bottom Alignment:**
- Unique design requirements
- Visual hierarchy needs
- Decorative or supplementary icons
- When icon represents end result or outcome

### Design Guidelines
- Maintain consistency within similar content types
- Consider text length when choosing alignment
- Test with various content lengths
- Use top alignment for editable content

## Related Types

- `CellConfiguration` - Contains icon alignment setting
- `MetaCellKit` - Applies icon alignment constraints
- `EditingConfiguration` - Works with dynamic height and alignment

## See Also

- `CellConfiguration`
- `MetaCellKit`
- `EditingConfiguration`