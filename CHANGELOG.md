# Changelog

All notable changes to MetaCellKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.2] - 2024-08-04

### Fixed
- Added missing `validationRules` property to `EditingConfiguration` struct
- Resolves compilation error when using validation features in projects
- Maintains full backward compatibility

## [1.1.1] - 2024-08-04

### Fixed
- **BREAKING CHANGE**: Renamed `isEditing` property to `isInEditMode` to avoid conflicts with UITableViewCell's built-in `isEditing` property
- Added convenience methods `beginEditing()`, `endEditing()`, and `isCurrentlyEditing()` for better API ergonomics

### Migration Guide
If you were using the `isEditing` property directly:

```swift
// v1.1.0 (broken)
if cell.isEditing {
    // handle editing state
}

// v1.1.1+ (fixed)
if cell.isCurrentlyEditing() {
    // handle editing state
}
// OR
if cell.isInEditMode {
    // handle editing state
}
```

## [1.1.0] - 2024-08-04

### Added
- **In-place text editing** with UITextView integration
- **Dynamic height adjustment** during editing with smooth animations
- **Icon alignment options** (top, middle, bottom) for better text layout
- **Comprehensive validation system** with built-in and custom rules
- **Auto-save functionality** with configurable intervals
- **Character counting** with multiple display modes
- **Real-time validation** with delegate callbacks
- **Keyboard management** with custom keyboard types and return key handling
- **Editing delegate protocol** for comprehensive event handling

### Changed
- Enhanced `CellConfiguration` with editing-specific properties
- Improved constraint system to support dynamic height changes
- Better accessibility support for editing interactions

### Enhanced
- Documentation with comprehensive editing tutorials and examples
- Example projects demonstrating all editing features
- Validation best practices guide
- Migration guide for v1.0.x users

## [1.0.0] - 2024-07-30

### Added
- **Initial release** of MetaCellKit
- Unified table view cell supporting 0-3 metadata views
- Master and Detail style variants with card-based design
- Automatic data binding with reflection
- Built-in date formatting utility
- Dynamic badge system with auto-sizing
- Comprehensive test suite
- Complete documentation and examples

### Features
- **Layout variants**: Basic, Single, Dual, and Triple metadata layouts
- **Style system**: Master (subtle) and Detail (paper-like) styles  
- **Data binding**: Automatic property mapping with `CellDataProtocol`
- **Date handling**: Automatic date formatting for Date properties
- **Customization**: Parametrizable colors, fonts, and styling options
- **Performance**: Optimized for efficient cell reuse
- **Accessibility**: VoiceOver support and Dynamic Type compatibility