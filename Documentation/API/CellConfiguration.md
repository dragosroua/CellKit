# CellConfiguration

A configuration structure that defines the layout, styling, and behavior of a `MetaCellKit` instance.

## Overview

`CellConfiguration` provides a comprehensive way to customize the appearance and behavior of `MetaCellKit` cells. It controls layout variants, visual styles, content visibility, and metadata view configurations.

## Declaration

```swift
public struct CellConfiguration
```

## Topics

### Properties

#### `style`

```swift
public var style: MetaCellKit.CellStyle = .master
```

The visual style of the cell.
- `.master` - Subtle styling for list controllers
- `.detail` - Enhanced paper-like styling for detail views

#### `metadataViewCount`

```swift
public var metadataViewCount: Int = 0
```

Number of metadata views to display (0-3). Determines the layout variant:
- `0` - Basic layout only
- `1` - Single metadata layout
- `2` - Dual metadata layout  
- `3` - Triple metadata layout

#### `metadataConfigs`

```swift
public var metadataConfigs: [MetadataViewConfig] = []
```

Array of metadata view configurations. Should contain `metadataViewCount` elements for complete customization.

#### `showBadge`

```swift
public var showBadge: Bool = true
```

Controls visibility of the badge label. When `false`, the badge is hidden even if data contains badge information.

#### `showDisclosure`

```swift
public var showDisclosure: Bool = true
```

Controls visibility of the disclosure indicator (chevron). Set to `false` for cells that don't navigate to detail views.

#### `useTitleTextView`

```swift
public var useTitleTextView: Bool = false
```

When `true`, uses `UITextView` instead of `UILabel` for the title, enabling multi-line text and text selection.

### Initializers

#### `init()`

```swift
public init()
```

Creates a configuration with default values.

#### `init(style:metadataViewCount:metadataConfigs:showBadge:showDisclosure:useTitleTextView:)`

```swift
public init(
    style: MetaCellKit.CellStyle = .master,
    metadataViewCount: Int = 0,
    metadataConfigs: [MetadataViewConfig] = [],
    showBadge: Bool = true,
    showDisclosure: Bool = true,
    useTitleTextView: Bool = false
)
```

Creates a configuration with specified parameters.

## Configuration Examples

### Basic Configuration

```swift
let config = CellConfiguration(
    style: .master,
    metadataViewCount: 0,
    showBadge: true,
    showDisclosure: true
)
```

### Single Metadata Configuration

```swift
let priorityMetadata = MetadataViewConfig(
    text: "High",
    backgroundColor: .systemRed,
    textColor: .white
)

let config = CellConfiguration(
    style: .detail,
    metadataViewCount: 1,
    metadataConfigs: [priorityMetadata]
)
```

### Triple Metadata Configuration

```swift
let priority = MetadataViewConfig(text: "High", backgroundColor: .systemRed)
let context = MetadataViewConfig(text: "Work", backgroundColor: .systemBlue)
let status = MetadataViewConfig(text: "Active", backgroundColor: .systemGreen)

let config = CellConfiguration(
    style: .detail,
    metadataViewCount: 3,
    metadataConfigs: [priority, context, status],
    showDisclosure: false
)
```

### Multi-line Title Configuration

```swift
let config = CellConfiguration(
    style: .detail,
    metadataViewCount: 2,
    useTitleTextView: true  // Enables multi-line text
)
```

## Pre-configured Options

`MetaCellKit` provides convenience methods for common configurations:

```swift
// Basic layouts
let basicMaster = MetaCellKit.basicConfiguration(style: .master)
let basicDetail = MetaCellKit.basicConfiguration(style: .detail)

// Metadata layouts
let singleMetadata = MetaCellKit.singleMetadataConfiguration(style: .detail)
let dualMetadata = MetaCellKit.dualMetadataConfiguration(style: .master)
let tripleMetadata = MetaCellKit.tripleMetadataConfiguration(style: .detail)
```

## Best Practices

### Metadata View Count vs. Configuration Array

Ensure the `metadataConfigs` array contains configurations for the number specified in `metadataViewCount`:

```swift
// ✅ Correct - 2 configs for 2 metadata views
config.metadataViewCount = 2
config.metadataConfigs = [config1, config2]

// ⚠️ Incomplete - Only 1 config for 2 metadata views
config.metadataViewCount = 2
config.metadataConfigs = [config1]  // Second view will use defaults

// ❌ Excessive - 3 configs for 1 metadata view
config.metadataViewCount = 1
config.metadataConfigs = [config1, config2, config3]  // Extra configs ignored
```

### Style Selection

Choose styles based on context:

```swift
// Master style - for primary lists
let masterConfig = CellConfiguration(style: .master)

// Detail style - for secondary lists, detail views
let detailConfig = CellConfiguration(style: .detail)
```

### Performance Considerations

Reuse configuration objects when possible:

```swift
// ✅ Good - reuse configurations
class TableViewController: UITableViewController {
    let basicConfig = CellConfiguration(style: .master)
    let detailConfig = CellConfiguration(style: .detail, metadataViewCount: 2)
    
    // Use in cellForRowAt
}

// ❌ Avoid - creating new configurations each time
func cellForRowAt(...) -> UITableViewCell {
    let config = CellConfiguration(...)  // Creates new object every time
}
```

## See Also

- [MetaCellKit](MetaCellKit.md) - Main cell class
- [MetadataViewConfig](MetadataViewConfig.md) - Metadata view configuration
- [CellDataProtocol](CellDataProtocol.md) - Data binding protocol