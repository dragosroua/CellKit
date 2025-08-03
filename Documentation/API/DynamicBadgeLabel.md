# DynamicBadgeLabel

A customizable badge label that automatically sizes itself based on content and provides flexible styling options.

## Overview

`DynamicBadgeLabel` is a `UILabel` subclass that creates rounded badges with automatic width calculation, minimum size constraints, and support for various content types. It's designed to display counts, status indicators, or short text in a visually appealing badge format.

## Declaration

```swift
public class DynamicBadgeLabel: UILabel
```

## Topics

### Properties

#### `badgeColor`

```swift
public var badgeColor: UIColor = .systemRed
```

The background color of the badge. Default is `.systemRed`.

#### `badgeTextColor`

```swift
public var badgeTextColor: UIColor = .white
```

The text color of the badge. Default is `.white`.

#### `minimumSize`

```swift
public var minimumSize: CGSize = CGSize(width: 24, height: 24)
```

The minimum size of the badge. The badge will never be smaller than this size, ensuring readability even with single characters or small numbers.

### Methods

#### `setBadgeValue(_:)`

```swift
public func setBadgeValue(_ value: Any?)
```

Sets the badge value with automatic type handling and formatting.

**Parameters:**
- `value` - The value to display. Supports `String`, `Int`, `Double`, or `nil`

**Behavior:**
- `String` - Displayed as-is
- `Int` - Converted to string if > 0, hidden if ≤ 0
- `Double` - Formatted to 1 decimal place if > 0, hidden if ≤ 0  
- `nil` - Hides the badge

### Automatic Behavior

#### Size Calculation

The badge automatically calculates its size based on:
- Text content width (with padding)
- Minimum size constraints
- Rounded appearance requirements

#### Visibility Management

The badge automatically shows/hides based on content:
- Shows when `text` is set to a non-empty string
- Hides when `text` is `nil`, empty, or when using `setBadgeValue` with zero/negative numbers

#### Corner Radius

The badge automatically maintains a rounded appearance by setting `cornerRadius` to half of the minimum dimension during layout.

## Usage Examples

### Basic Text Badge

```swift
let badge = DynamicBadgeLabel()
badge.text = "NEW"
badge.badgeColor = .systemBlue
badge.badgeTextColor = .white
```

### Numeric Badge

```swift
let countBadge = DynamicBadgeLabel()
countBadge.setBadgeValue(42)
// Displays "42" in default red badge
```

### Custom Styling

```swift
let customBadge = DynamicBadgeLabel()
customBadge.text = "VIP"
customBadge.badgeColor = .systemGold
customBadge.badgeTextColor = .black
customBadge.minimumSize = CGSize(width: 30, height: 20)
customBadge.font = UIFont.systemFont(ofSize: 12, weight: .bold)
```

### Zero/Negative Handling

```swift
let badge = DynamicBadgeLabel()
badge.setBadgeValue(5)      // Shows "5"
badge.setBadgeValue(0)      // Hides badge
badge.setBadgeValue(-1)     // Hides badge
badge.setBadgeValue(nil)    // Hides badge
```

### Double Values

```swift
let progressBadge = DynamicBadgeLabel()
progressBadge.setBadgeValue(3.7)    // Shows "3.7"
progressBadge.setBadgeValue(0.0)    // Hides badge
```

## Integration with CellKit

`DynamicBadgeLabel` is automatically used within `CellKit` for badge display:

```swift
// Data with badge property
struct TaskData: CellDataProtocol {
    let title: String
    let badge: String     // Automatically bound to DynamicBadgeLabel
}

// Or with count property
struct TaskData: CellDataProtocol {
    let title: String
    let count: Int        // Automatically converted and displayed
}
```

## Common Use Cases

### Notification Counts

```swift
let notificationBadge = DynamicBadgeLabel()
notificationBadge.setBadgeValue(unreadCount)
notificationBadge.badgeColor = .systemRed
```

### Status Indicators

```swift
let statusBadge = DynamicBadgeLabel()
statusBadge.text = "LIVE"
statusBadge.badgeColor = .systemGreen
statusBadge.font = UIFont.systemFont(ofSize: 10, weight: .bold)
```

### Progress Indicators

```swift
let progressBadge = DynamicBadgeLabel()
progressBadge.setBadgeValue(completionPercentage)
progressBadge.badgeColor = .systemBlue
```

### Priority Labels

```swift
let priorityBadge = DynamicBadgeLabel()
switch priority {
case .high:
    priorityBadge.text = "!"
    priorityBadge.badgeColor = .systemRed
case .medium:
    priorityBadge.text = "•"
    priorityBadge.badgeColor = .systemOrange
case .low:
    priorityBadge.setBadgeValue(nil)  // Hide for low priority
}
```

## Accessibility

`DynamicBadgeLabel` inherits accessibility features from `UILabel`:

```swift
let badge = DynamicBadgeLabel()
badge.text = "3"
badge.accessibilityLabel = "3 unread messages"
badge.accessibilityTraits = .staticText
```

## Performance Considerations

### Efficient Updates

```swift
// ✅ Efficient - only updates when value changes
func updateBadge(with count: Int) {
    guard badge.text != "\(count)" else { return }
    badge.setBadgeValue(count)
}

// ❌ Inefficient - updates every time
func updateBadge(with count: Int) {
    badge.setBadgeValue(count)  // Always calls update methods
}
```

### Reuse in Table Views

When using in table view cells, ensure proper reset:

```swift
override func prepareForReuse() {
    super.prepareForReuse()
    badge.setBadgeValue(nil)  // Clear previous value
}
```

## Customization

### Advanced Styling

```swift
let badge = DynamicBadgeLabel()
badge.text = "NEW"
badge.badgeColor = UIColor.systemBlue
badge.badgeTextColor = .white
badge.layer.borderWidth = 1
badge.layer.borderColor = UIColor.white.cgColor
badge.layer.shadowColor = UIColor.black.cgColor
badge.layer.shadowOffset = CGSize(width: 0, height: 1)
badge.layer.shadowOpacity = 0.3
badge.layer.shadowRadius = 2
```

### Animation

```swift
// Animate color changes
UIView.animate(withDuration: 0.3) {
    badge.badgeColor = .systemGreen
}

// Animate appearance
badge.alpha = 0
badge.setBadgeValue(newCount)
UIView.animate(withDuration: 0.3) {
    badge.alpha = 1
}
```

## See Also

- [CellKit](CellKit.md) - Main cell class that uses DynamicBadgeLabel
- [CellDataProtocol](CellDataProtocol.md) - Data binding for badge values
- [MetadataView](MetadataView.md) - Similar component for metadata display