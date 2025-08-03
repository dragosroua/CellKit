# Migration Guide

This guide helps you migrate from existing table view cell implementations to CellKit.

## Overview

CellKit is designed to replace multiple specialized cell classes with a single, configurable solution. This guide covers common migration scenarios and provides step-by-step instructions.

## Common Migration Scenarios

### Scenario 1: Multiple Cell Classes

**Before:** Multiple UITableViewCell subclasses
```swift
class BasicTaskCell: UITableViewCell { ... }
class DetailTaskCell: UITableViewCell { ... }
class PriorityTaskCell: UITableViewCell { ... }
class CompleteTaskCell: UITableViewCell { ... }
```

**After:** Single CellKit with configurations
```swift
// Replace all with CellKit and different configurations
let basicConfig = CellKit.basicConfiguration()
let detailConfig = CellKit.singleMetadataConfiguration(style: .detail)
let priorityConfig = CellKit.dualMetadataConfiguration()
let completeConfig = CellKit.tripleMetadataConfiguration(style: .detail)
```

### Scenario 2: Manual Data Binding

**Before:** Manual property assignment
```swift
class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        iconImageView.image = task.icon
        badgeLabel.text = task.badge
        badgeLabel.isHidden = task.badge == nil
    }
}
```

**After:** Automatic data binding
```swift
struct Task: CellDataProtocol {
    let title: String
    let icon: UIImage?
    let badge: String?
}

// Automatic binding - no manual assignment needed
cell.configure(with: task, metadataViews: 0, style: .master)
```

### Scenario 3: Custom Styling

**Before:** Custom cell styling
```swift
class StyledTaskCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
    }
}
```

**After:** Built-in styling
```swift
// Built-in detail style provides similar appearance
cell.configure(with: task, metadataViews: 1, style: .detail)
```

## Step-by-Step Migration

### Step 1: Audit Existing Cells

First, inventory your existing cell types:

```swift
// Identify your current cell classes
class BasicCell: UITableViewCell { ... }           // → CellKit basic configuration
class DetailCell: UITableViewCell { ... }          // → CellKit with metadata
class PriorityCell: UITableViewCell { ... }        // → CellKit with priority metadata
class StatusCell: UITableViewCell { ... }          // → CellKit with status metadata
```

### Step 2: Create Data Models

Convert your data objects to conform to `CellDataProtocol`:

**Before:**
```swift
struct Task {
    let title: String
    let priority: String
    let dueDate: Date
    let isCompleted: Bool
}
```

**After:**
```swift
struct Task: CellDataProtocol {
    let title: String           // Automatically bound to title
    let priority: String        // Bound to metadata
    let dueDate: Date          // Automatically formatted and bound to metadata
    let isCompleted: Bool      // Can be used for conditional configuration
    
    // Optional: computed properties for better binding
    var icon: UIImage? {
        return isCompleted 
            ? UIImage(systemName: "checkmark.circle.fill")
            : UIImage(systemName: "circle")
    }
    
    var badge: String? {
        return isCompleted ? nil : "!"
    }
}
```

### Step 3: Replace Cell Registration

**Before:**
```swift
tableView.register(UINib(nibName: "BasicTaskCell", bundle: nil), 
                  forCellReuseIdentifier: "BasicTaskCell")
tableView.register(UINib(nibName: "DetailTaskCell", bundle: nil), 
                  forCellReuseIdentifier: "DetailTaskCell")
tableView.register(UINib(nibName: "PriorityTaskCell", bundle: nil), 
                  forCellReuseIdentifier: "PriorityTaskCell")
```

**After:**
```swift
tableView.register(CellKit.self, forCellReuseIdentifier: "CellKit")
```

### Step 4: Update cellForRowAt

**Before:**
```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let task = tasks[indexPath.row]
    
    if task.isHighPriority {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriorityTaskCell", for: indexPath) as! PriorityTaskCell
        cell.configure(with: task)
        return cell
    } else if task.hasDetails {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTaskCell", for: indexPath) as! DetailTaskCell
        cell.configure(with: task)
        return cell
    } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTaskCell", for: indexPath) as! BasicTaskCell
        cell.configure(with: task)
        return cell
    }
}
```

**After:**
```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
    let task = tasks[indexPath.row]
    
    if task.isHighPriority {
        cell.configure(with: task, metadataViews: 2, style: .detail)
    } else if task.hasDetails {
        cell.configure(with: task, metadataViews: 1, style: .detail)
    } else {
        cell.configure(with: task, metadataViews: 0, style: .master)
    }
    
    return cell
}
```

## Specific Migration Examples

### Example 1: Basic List Cell

**Before:**
```swift
class ContactCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func configure(with contact: Contact) {
        nameLabel.text = contact.name
        avatarImageView.image = contact.avatar
    }
}

struct Contact {
    let name: String
    let avatar: UIImage?
}
```

**After:**
```swift
struct Contact: CellDataProtocol {
    let title: String    // Renamed from 'name' or use computed property
    let icon: UIImage?   // Renamed from 'avatar' or use computed property
    
    // Or keep original names and use computed properties
    let name: String
    let avatar: UIImage?
    
    var title: String { return name }
    var icon: UIImage? { return avatar }
}

// Usage
cell.configure(with: contact, metadataViews: 0, style: .master)
```

### Example 2: Task Cell with Priority

**Before:**
```swift
class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var priorityLabel: UILabel!
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        priorityLabel.text = task.priority
        priorityView.backgroundColor = colorForPriority(task.priority)
    }
}
```

**After:**
```swift
struct Task: CellDataProtocol {
    let title: String
    let priority: String    // Automatically bound to metadata
}

// Create configuration with priority metadata
let priorityConfig = MetadataViewConfig(
    text: task.priority,
    backgroundColor: colorForPriority(task.priority)
)

let config = CellConfiguration(
    metadataViewCount: 1,
    metadataConfigs: [priorityConfig]
)

cell.configure(with: task, configuration: config)
```

### Example 3: Complex Cell with Multiple Elements

**Before:**
```swift
class ProjectTaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityBadge: UIView!
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet weak var statusIndicator: UIView!
    
    func configure(with task: ProjectTask) {
        titleLabel.text = task.title
        iconImageView.image = task.icon
        dueDateLabel.text = formatDate(task.dueDate)
        priorityBadge.backgroundColor = colorForPriority(task.priority)
        contextLabel.text = task.context
        statusIndicator.backgroundColor = colorForStatus(task.status)
    }
}
```

**After:**
```swift
struct ProjectTask: CellDataProtocol {
    let title: String       // Automatically bound to title
    let icon: UIImage?      // Automatically bound to icon
    let dueDate: Date       // Automatically formatted and bound to metadata
    let priority: String    // Bound to metadata
    let context: String     // Bound to metadata
    let status: String      // Bound to metadata
}

// Use triple metadata configuration
cell.configure(with: task, metadataViews: 3, style: .detail)

// Or create custom configuration for specific colors
let priorityConfig = MetadataViewConfig(text: task.priority, backgroundColor: colorForPriority(task.priority))
let contextConfig = MetadataViewConfig(text: task.context, backgroundColor: .systemBlue)
let statusConfig = MetadataViewConfig(text: task.status, backgroundColor: colorForStatus(task.status))

let config = CellConfiguration(
    style: .detail,
    metadataViewCount: 3,
    metadataConfigs: [priorityConfig, contextConfig, statusConfig]
)

cell.configure(with: task, configuration: config)
```

## Common Migration Issues

### Issue 1: Property Name Mismatch

**Problem:** Your existing data model uses different property names.

**Solution:** Use computed properties or rename properties.

```swift
// Option 1: Computed properties
struct User: CellDataProtocol {
    let fullName: String
    let profileImage: UIImage?
    
    var title: String { return fullName }
    var icon: UIImage? { return profileImage }
}

// Option 2: Rename properties
struct User: CellDataProtocol {
    let title: String       // Renamed from fullName
    let icon: UIImage?      // Renamed from profileImage
}
```

### Issue 2: Complex Data Binding

**Problem:** Your cell displays computed or formatted data.

**Solution:** Use computed properties in your data model.

```swift
struct Task: CellDataProtocol {
    let title: String
    let createdAt: Date
    let assignedTo: User?
    
    // Computed properties for display
    var badge: String? {
        return assignedTo != nil ? "👤" : nil
    }
    
    var timeCreated: String {
        return "Created \(DateFormattingUtility.shared.formatDate(createdAt, style: .relative))"
    }
}
```

### Issue 3: Custom Cell Height

**Problem:** Your existing cells have custom height calculations.

**Solution:** Enable automatic dimensions and let CellKit handle sizing.

```swift
// Enable automatic height
tableView.rowHeight = UITableView.automaticDimension
tableView.estimatedRowHeight = 80

// CellKit automatically sizes based on content
cell.configure(with: data, metadataViews: 2, style: .detail)
```

### Issue 4: Custom Animations

**Problem:** Your cells have custom selection or highlight animations.

**Solution:** CellKit includes built-in animations, but you can add custom animations if needed.

```swift
// CellKit handles selection automatically, but you can add custom animations
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! CellKit
    
    UIView.animate(withDuration: 0.1, animations: {
        cell.transform = CGAffineTransform(scaleX: 0.95, scaleY: 0.95)
    }) { _ in
        UIView.animate(withDuration: 0.1) {
            cell.transform = .identity
        }
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
}
```

## Performance Considerations

### Before Migration
- Multiple cell classes to maintain
- Manual outlet connections
- Custom styling code
- Manual data binding

### After Migration
- Single cell class
- Automatic data binding
- Built-in styling
- Configuration reuse

### Performance Tips

1. **Reuse configurations:**
```swift
// Create configurations once
private let highPriorityConfig = CellKit.dualMetadataConfiguration(style: .detail)
private let normalConfig = CellKit.basicConfiguration(style: .master)

// Reuse in cellForRowAt
let config = task.isHighPriority ? highPriorityConfig : normalConfig
cell.configure(with: task, configuration: config)
```

2. **Use simple configuration when possible:**
```swift
// Prefer simple configuration
cell.configure(with: task, metadataViews: 1, style: .master)

// Over complex configuration when not needed
```

## Testing Your Migration

### Verification Checklist

- [ ] All cell types replaced with CellKit
- [ ] Data models conform to `CellDataProtocol`
- [ ] Cell registration updated
- [ ] `cellForRowAt` simplified
- [ ] Visual appearance matches or improves upon original
- [ ] Performance is maintained or improved
- [ ] No unused cell classes remain

### Test Cases

1. **Visual comparison:** Take screenshots before and after migration
2. **Performance testing:** Compare scroll performance
3. **Data binding:** Verify all data displays correctly
4. **Edge cases:** Test with empty data, long text, missing images

## Rollback Plan

If you need to rollback during migration:

1. Keep original cell classes temporarily
2. Use feature flags to switch between implementations
3. Test thoroughly before removing old code

```swift
// Temporary feature flag approach
if useNewCellKit {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
    cell.configure(with: task, metadataViews: 1, style: .master)
    return cell
} else {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OldTaskCell", for: indexPath) as! OldTaskCell
    cell.configure(with: task)
    return cell
}
```

## Summary

Migrating to CellKit provides:
- **Reduced code complexity** - Single cell class instead of multiple
- **Automatic data binding** - No more manual outlet management
- **Consistent styling** - Built-in design system
- **Better maintainability** - Configuration-based approach
- **Improved performance** - Optimized cell reuse

The migration process involves updating data models, simplifying cell configuration, and leveraging CellKit's automatic features to reduce custom code.