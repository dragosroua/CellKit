# CellKit

The main cell class that provides a unified, configurable table view cell system.

## Overview

`CellKit` is a `UITableViewCell` subclass that replaces multiple specialized cell classes with a single, parametric solution. It supports 0-3 configurable metadata views, automatic data binding, and flexible styling options.

## Declaration

```swift
public class CellKit: UITableViewCell
```

## Topics

### Cell Styles

#### `CellStyle`

```swift
public enum CellStyle {
    case master
    case detail
}
```

Visual style variants for the cell:
- `.master` - Subtle styling for list controllers with system backgrounds
- `.detail` - Enhanced paper-like styling for detail views

### Configuration Methods

#### `configure(with:configuration:)`

```swift
public func configure(with data: any CellDataProtocol, configuration: CellConfiguration)
```

Configures the cell with data and a complete configuration object.

**Parameters:**
- `data` - Any object conforming to `CellDataProtocol`
- `configuration` - A `CellConfiguration` object defining layout and appearance

#### `configure(with:metadataViews:style:)`

```swift
public func configure(with data: any CellDataProtocol, metadataViews: Int = 0, style: CellStyle = .master)
```

Simplified configuration method for common use cases.

**Parameters:**
- `data` - Any object conforming to `CellDataProtocol`
- `metadataViews` - Number of metadata views to display (0-3)
- `style` - Visual style (`.master` or `.detail`)

### Data Binding

CellKit automatically binds data properties to UI elements using reflection:

- `title`, `name` → Main title label/text view
- `icon`, `image` → Icon image view (supports `UIImage` or SF Symbol names)
- `badge`, `count` → Badge label (supports `String` or `Int`)
- Other properties → Metadata views (with automatic date formatting)

### Layout Variants

#### Basic Layout (0 metadata views)
- Icon + Title + Badge + Disclosure indicator

#### Single Metadata (1 metadata view)
- Basic layout + 1 configurable metadata container

#### Dual Metadata (2 metadata views)
- Basic layout + 2 configurable metadata containers

#### Triple Metadata (3 metadata views)
- Basic layout + 3 configurable metadata containers

### Automatic Features

#### Date Formatting
`Date` properties are automatically detected and formatted using `DateFormattingUtility`:

```swift
struct TaskData: CellDataProtocol {
    let title: String
    let dueDate: Date  // Automatically formatted as "15 Jan 2024"
}
```

#### Content Switching
Title content automatically switches between `UILabel` and `UITextView` based on configuration:

```swift
var config = CellConfiguration()
config.useTitleTextView = true  // Uses UITextView for multi-line support
```

### Cell Reuse

The cell properly implements `prepareForReuse()` to reset all content and styling for efficient reuse in table views.

## Example Usage

### Basic Usage

```swift
let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit") as! CellKit
let taskData = TaskData(title: "Complete project", badge: "3")
cell.configure(with: taskData, metadataViews: 1, style: .detail)
```

### Advanced Configuration

```swift
var config = CellConfiguration()
config.style = .detail
config.metadataViewCount = 2
config.showBadge = true
config.showDisclosure = false

let priorityMetadata = MetadataViewConfig(
    text: "High", 
    backgroundColor: .systemRed
)
config.metadataConfigs = [priorityMetadata]

cell.configure(with: taskData, configuration: config)
```

### Pre-configured Layouts

```swift
// Use built-in configuration helpers
let config = CellKit.dualMetadataConfiguration(style: .detail)
cell.configure(with: taskData, configuration: config)
```

## See Also

- [CellConfiguration](CellConfiguration.md) - Configuration options
- [CellDataProtocol](CellDataProtocol.md) - Data binding protocol
- [MetadataViewConfig](MetadataViewConfig.md) - Metadata view configuration