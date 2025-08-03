# Getting Started with CellKit

This tutorial will guide you through setting up and using CellKit in your iOS project.

## Prerequisites

- iOS 13.0 or later
- Xcode 14.0 or later
- Swift 5.7 or later

## Installation

### Swift Package Manager

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/dragosroua/CellKit`
3. Choose the latest version and add to your target

### Manual Installation

Alternatively, add CellKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/dragosroua/CellKit", from: "1.0.0")
]
```

## Basic Setup

### 1. Import CellKit

Add the import statement to your view controller:

```swift
import UIKit
import CellKit
```

### 2. Register the Cell

In your table view setup, register the CellKit cell:

```swift
class TaskListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register CellKit
        tableView.register(CellKit.self, forCellReuseIdentifier: "CellKit")
        
        // Enable automatic row height for dynamic content
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
}
```

### 3. Create Your Data Model

Create a data model that conforms to `CellDataProtocol`:

```swift
struct Task: CellDataProtocol {
    let title: String
    let icon: UIImage?
    let badge: String?
    let dueDate: Date?
    let priority: String?
    
    init(title: String, icon: String? = nil, badge: String? = nil, dueDate: Date? = nil, priority: String? = nil) {
        self.title = title
        self.icon = icon.map { UIImage(systemName: $0) } ?? nil
        self.badge = badge
        self.dueDate = dueDate
        self.priority = priority
    }
}
```

### 4. Configure Cells in Table View

Implement `cellForRowAt` to configure your cells:

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
    let task = tasks[indexPath.row]
    
    // Simple configuration with 1 metadata view
    cell.configure(with: task, metadataViews: 1, style: .master)
    
    return cell
}
```

## Your First CellKit Implementation

Let's create a complete example with a simple task list:

```swift
import UIKit
import CellKit

class TaskListViewController: UITableViewController {
    
    // Sample data
    let tasks: [Task] = [
        Task(
            title: "Review quarterly reports",
            icon: "chart.bar.doc.horizontal",
            badge: "3",
            dueDate: Date().addingTimeInterval(86400), // Tomorrow
            priority: "High"
        ),
        Task(
            title: "Plan team meeting",
            icon: "person.3.fill",
            badge: nil,
            dueDate: Date().addingTimeInterval(259200), // 3 days
            priority: "Medium"
        ),
        Task(
            title: "Update project documentation",
            icon: "doc.text.fill",
            badge: "12",
            dueDate: Date().addingTimeInterval(604800), // 1 week
            priority: "Low"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        title = "Tasks"
        
        // Register CellKit
        tableView.register(CellKit.self, forCellReuseIdentifier: "CellKit")
        
        // Configure for dynamic height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        // Style the table view
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
        let task = tasks[indexPath.row]
        
        // Configure with 2 metadata views to show due date and priority
        cell.configure(with: task, metadataViews: 2, style: .master)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        print("Selected task: \(task.title)")
    }
}
```

## Understanding the Result

With this basic setup, you'll see:

1. **Task titles** displayed prominently
2. **Icons** from SF Symbols on the left
3. **Badges** showing counts (like "3" for reports)
4. **Due dates** automatically formatted (like "16 Jan 2024")
5. **Priority levels** in the second metadata view
6. **Disclosure indicators** showing the rows are tappable

## Customizing Appearance

### Using Detail Style

For a more prominent appearance, use the detail style:

```swift
cell.configure(with: task, metadataViews: 2, style: .detail)
```

This provides:
- Paper-like background color
- Enhanced shadows and borders
- More spacing around content

### Controlling Visibility

You can control what elements are shown:

```swift
// Hide badge for certain tasks
if task.priority == "Low" {
    var config = CellConfiguration()
    config.showBadge = false
    config.metadataViewCount = 1
    cell.configure(with: task, configuration: config)
} else {
    cell.configure(with: task, metadataViews: 2, style: .master)
}
```

## Next Steps

Now that you have CellKit working, explore these topics:

1. **[Configuration Guide](Configuration.md)** - Learn about advanced configuration options
2. **[Data Binding](DataBinding.md)** - Understand how automatic data binding works
3. **[Styling Guide](Styling.md)** - Customize colors and appearance
4. **[Advanced Examples](../Examples/AdvancedConfigurations.md)** - See complex implementations

## Common Issues

### Cell Height Issues

If your cells appear cut off, ensure you've set up automatic dimensions:

```swift
tableView.rowHeight = UITableView.automaticDimension
tableView.estimatedRowHeight = 80
```

### Badge Not Showing

Ensure your data model has a `badge` or `count` property:

```swift
struct Task: CellDataProtocol {
    let title: String
    let badge: String?  // ← This property name is automatically recognized
}
```

### Icon Not Appearing

Check that your icon property returns a valid `UIImage`:

```swift
// ✅ Correct
let icon: UIImage? = UIImage(systemName: "star.fill")

// ✅ Also works - CellKit will convert SF Symbol names
let image: String = "star.fill"

// ❌ Won't work - invalid symbol name
let icon: UIImage? = UIImage(systemName: "invalid-symbol")
```

## Summary

You've learned how to:
- Install and set up CellKit
- Create conforming data models
- Configure basic cells
- Handle table view integration

CellKit automatically handles layout, data binding, and styling, letting you focus on your app's functionality rather than cell implementation details.