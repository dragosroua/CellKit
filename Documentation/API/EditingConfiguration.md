# EditingConfiguration

A configuration struct that defines editing behavior and appearance for MetaCellKit cells.

## Overview

`EditingConfiguration` provides comprehensive control over in-place editing functionality, including validation, auto-save, character counting, and keyboard management.

## Declaration

```swift
public struct EditingConfiguration
```

## Properties

### Core Editing Settings

#### `isEditingEnabled`
```swift
public var isEditingEnabled: Bool = false
```
Enables or disables editing functionality for the cell.

#### `enablesDynamicHeight`
```swift
public var enablesDynamicHeight: Bool = true
```
Controls whether the cell height adjusts automatically during editing.

### Text Constraints

#### `maxTextLength`
```swift
public var maxTextLength: Int? = nil
```
Maximum number of characters allowed. Set to `nil` for no limit.

#### `minTextLength`
```swift
public var minTextLength: Int? = nil
```
Minimum number of characters required. Set to `nil` for no minimum.

### Keyboard Configuration

#### `keyboardType`
```swift
public var keyboardType: UIKeyboardType = .default
```
The keyboard type to display during editing.

#### `returnKeyType`
```swift
public var returnKeyType: UIReturnKeyType = .done
```
The return key type to display on the keyboard.

#### `autocapitalizationType`
```swift
public var autocapitalizationType: UITextAutocapitalizationType = .sentences
```
Controls automatic capitalization behavior.

#### `autocorrectionType`
```swift
public var autocorrectionType: UITextAutocorrectionType = .default
```
Controls automatic correction behavior.

### Auto-Save Configuration

#### `autoSaveInterval`
```swift
public var autoSaveInterval: TimeInterval? = nil
```
Time interval for automatic saving. Set to `nil` to disable auto-save.

### UI Customization

#### `placeholderText`
```swift
public var placeholderText: String? = "Enter text..."
```
Placeholder text shown when the cell content is empty.

#### `characterCountDisplay`
```swift
public var characterCountDisplay: CharacterCountStyle = .none
```
Style of character count display. See `CharacterCountStyle` for options.

### Advanced Features

#### `allowsUndoRedo`
```swift
public var allowsUndoRedo: Bool = true
```
Enables undo/redo functionality during editing.

#### `validationRules`
```swift
public var validationRules: [ValidationRule] = []
```
Array of validation rules to apply to text input. See `ValidationRule` for details.

## Usage Examples

### Basic Editing Setup
```swift
var config = CellConfiguration()
config.editing.isEditingEnabled = true
config.editing.maxTextLength = 100
config.editing.placeholderText = "Enter task title..."
```

### Advanced Configuration
```swift
var config = CellConfiguration()
config.editing.isEditingEnabled = true
config.editing.maxTextLength = 500
config.editing.minTextLength = 3
config.editing.keyboardType = .default
config.editing.returnKeyType = .done
config.editing.autoSaveInterval = 2.0
config.editing.characterCountDisplay = .both
config.editing.enablesDynamicHeight = true

// Add validation rules
config.editing.validationRules = [
    LengthValidationRule(min: 3, max: 500),
    RegexValidationRule(pattern: "^[A-Za-z0-9\\s.,!?-]*$", 
                       message: "Only letters, numbers, and basic punctuation allowed")
]
```

### Character Count Styles
```swift
// Show remaining characters
config.editing.characterCountDisplay = .remaining  // "45 characters remaining"

// Show current count with limit
config.editing.characterCountDisplay = .count      // "55/100"

// Show both count and remaining
config.editing.characterCountDisplay = .both       // "55/100 (45 remaining)"

// Hide character count
config.editing.characterCountDisplay = .none
```

## Related Types

- `CharacterCountStyle` - Enumeration for character count display options
- `ValidationRule` - Protocol for text validation rules
- `MetaCellKitEditingDelegate` - Delegate protocol for editing events

## See Also

- `CellConfiguration`
- `MetaCellKit`
- `ValidationSystem`