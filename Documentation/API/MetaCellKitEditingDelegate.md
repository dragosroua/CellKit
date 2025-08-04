# MetaCellKitEditingDelegate

A protocol that defines methods for responding to editing events in MetaCellKit cells.

## Overview

The `MetaCellKitEditingDelegate` protocol provides comprehensive callbacks for all editing-related events, including text changes, validation errors, height adjustments, and auto-save operations.

## Declaration

```swift
public protocol MetaCellKitEditingDelegate: AnyObject
```

## Required Methods

All methods have default implementations, making them effectively optional.

### Core Editing Events

#### `cellDidBeginEditing(_:)`
```swift
func cellDidBeginEditing(_ cell: MetaCellKit)
```
Called when the cell begins editing mode.

**Parameters:**
- `cell`: The cell that began editing

#### `cellDidEndEditing(_:with:)`
```swift
func cellDidEndEditing(_ cell: MetaCellKit, with text: String)
```
Called when the cell ends editing mode with the final text.

**Parameters:**
- `cell`: The cell that ended editing
- `text`: The final text content

#### `cell(_:didChangeText:)`
```swift
func cell(_ cell: MetaCellKit, didChangeText text: String)
```
Called whenever the text changes during editing.

**Parameters:**
- `cell`: The cell being edited
- `text`: The current text content

### User Interaction

#### `cellShouldReturn(_:)`
```swift
func cellShouldReturn(_ cell: MetaCellKit) -> Bool
```
Called when the return key is pressed. Return `true` to end editing and dismiss the keyboard.

**Parameters:**
- `cell`: The cell being edited

**Returns:** `Bool` - `true` to end editing, `false` to continue

### Validation

#### `cell(_:validationFailedWith:)`
```swift
func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError)
```
Called when text validation fails.

**Parameters:**
- `cell`: The cell with validation error
- `error`: The validation error details

### Height Management

#### `cell(_:willChangeHeightTo:)`
```swift
func cell(_ cell: MetaCellKit, willChangeHeightTo height: CGFloat)
```
Called before the cell changes height to allow table view animation.

**Parameters:**
- `cell`: The cell that will change height
- `height`: The new height value

### Auto-Save

#### `cell(_:didAutoSaveText:)`
```swift
func cell(_ cell: MetaCellKit, didAutoSaveText text: String)
```
Called when auto-save occurs.

**Parameters:**
- `cell`: The cell that auto-saved
- `text`: The text that was saved

#### `cellShouldAutoSave(_:)`
```swift
func cellShouldAutoSave(_ cell: MetaCellKit) -> Bool
```
Called to check if auto-save should occur. Return `false` to skip this auto-save cycle.

**Parameters:**
- `cell`: The cell requesting auto-save

**Returns:** `Bool` - `true` to allow auto-save, `false` to skip

## Usage Examples

### Basic Implementation
```swift
extension TaskViewController: MetaCellKitEditingDelegate {
    func cellDidEndEditing(_ cell: MetaCellKit, with text: String) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tasks[indexPath.row].title = text
        saveData()
    }
    
    func cell(_ cell: MetaCellKit, willChangeHeightTo height: CGFloat) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
```

### Comprehensive Implementation
```swift
extension TaskViewController: MetaCellKitEditingDelegate {
    func cellDidBeginEditing(_ cell: MetaCellKit) {
        // Disable table view scrolling during editing
        tableView.isScrollEnabled = false
    }
    
    func cellDidEndEditing(_ cell: MetaCellKit, with text: String) {
        // Re-enable scrolling and save data
        tableView.isScrollEnabled = true
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tasks[indexPath.row].title = text
        persistData()
    }
    
    func cell(_ cell: MetaCellKit, didChangeText text: String) {
        // Real-time character count or preview updates
        updatePreview(with: text)
    }
    
    func cellShouldReturn(_ cell: MetaCellKit) -> Bool {
        // Custom logic for return key handling
        if cell.getText()?.isEmpty == true {
            // Don't end editing if text is empty
            showAlert(message: "Please enter some text")
            return false
        }
        return true
    }
    
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {
        // Show user-friendly error message
        let alert = UIAlertController(
            title: "Invalid Input",
            message: error.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func cell(_ cell: MetaCellKit, willChangeHeightTo height: CGFloat) {
        // Animate table view height changes
        UIView.animate(withDuration: 0.3) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func cell(_ cell: MetaCellKit, didAutoSaveText text: String) {
        // Handle auto-save
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tasks[indexPath.row].title = text
        autoSaveData()
        
        // Show brief save indicator
        showSaveIndicator()
    }
    
    func cellShouldAutoSave(_ cell: MetaCellKit) -> Bool {
        // Skip auto-save if app is in background or during other operations
        return UIApplication.shared.applicationState == .active && !isPerformingBulkOperation
    }
}
```

### Error Handling
```swift
extension TaskViewController: MetaCellKitEditingDelegate {
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {
        switch error.rule {
        case is LengthValidationRule:
            showLengthError(message: error.message)
        case is RegexValidationRule:
            showFormatError(message: error.message)
        case is CustomValidationRule:
            showCustomError(message: error.message)
        default:
            showGenericError(message: error.message)
        }
    }
    
    private func showLengthError(message: String) {
        // Custom UI for length validation errors
        let alert = UIAlertController(title: "Text Length Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

## Best Practices

### Performance
- Keep delegate method implementations lightweight
- Avoid heavy computations in `didChangeText`
- Use `cellShouldAutoSave` to control auto-save frequency

### User Experience
- Always implement `validationFailedWith` to show errors
- Use `willChangeHeightTo` for smooth animations
- Provide feedback for auto-save operations

### Data Management
- Implement both `didEndEditing` and `didAutoSaveText` for robust data persistence
- Use appropriate save strategies (immediate vs. batched)
- Handle edge cases like app backgrounding during editing

## Related Types

- `MetaCellKit` - The cell class that uses this delegate
- `EditingConfiguration` - Configuration for editing behavior
- `ValidationError` - Error type for validation failures
- `ValidationRule` - Protocol for validation rules

## See Also

- `EditingConfiguration`
- `ValidationSystem`
- `MetaCellKit`