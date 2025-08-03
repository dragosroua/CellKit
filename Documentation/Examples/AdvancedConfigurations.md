# Advanced Configuration Examples

This guide showcases advanced CellKit configurations for complex use cases and custom styling requirements.

## Dynamic Configuration Factory

Create a sophisticated configuration system that adapts to data:

```swift
import CellKit
import UIKit

class ProjectTaskConfigurationFactory {
    
    enum TaskType {
        case bug, feature, documentation, testing
    }
    
    enum Priority {
        case low, medium, high, critical
    }
    
    enum Status {
        case todo, inProgress, review, done
    }
    
    static func configuration(for task: ProjectTask) -> CellConfiguration {
        var config = CellConfiguration()
        
        // Choose style based on urgency
        config.style = task.isUrgent ? .detail : .master
        config.useTitleTextView = task.description.count > 50
        
        var metadataConfigs: [MetadataViewConfig] = []
        
        // Priority metadata (always shown)
        let priorityConfig = MetadataViewConfig(
            icon: iconForPriority(task.priority),
            text: task.priority.rawValue.capitalized,
            backgroundColor: colorForPriority(task.priority),
            textColor: .white,
            cornerRadius: task.priority == .critical ? 4 : 8
        )
        metadataConfigs.append(priorityConfig)
        
        // Type metadata (if space available)
        if task.priority != .critical { // Save space for critical tasks
            let typeConfig = MetadataViewConfig(
                icon: iconForTaskType(task.type),
                text: task.type.rawValue.capitalized,
                backgroundColor: colorForTaskType(task.type),
                textColor: .white
            )
            metadataConfigs.append(typeConfig)
        }
        
        // Status metadata (conditional)
        if task.status != .todo {
            let statusConfig = MetadataViewConfig(
                icon: iconForStatus(task.status),
                text: task.status.rawValue.replacingOccurrences(of: "inProgress", with: "In Progress"),
                backgroundColor: colorForStatus(task.status),
                textColor: task.status == .done ? .white : .black,
                font: UIFont.systemFont(ofSize: 11, weight: .semibold)
            )
            metadataConfigs.append(statusConfig)
        }
        
        // Due date metadata (if overdue or due soon)
        if let dueDate = task.dueDate {
            let timeInterval = dueDate.timeIntervalSince(Date())
            if timeInterval < 86400 { // Due within 24 hours
                let dueDateConfig = MetadataViewConfig(
                    icon: UIImage(systemName: timeInterval < 0 ? "exclamationmark.triangle.fill" : "clock.fill"),
                    text: timeInterval < 0 ? "Overdue" : "Due Soon",
                    backgroundColor: timeInterval < 0 ? .systemRed : .systemOrange,
                    textColor: .white
                )
                metadataConfigs.append(dueDateConfig)
            }
        }
        
        config.metadataViewCount = min(metadataConfigs.count, 3)
        config.metadataConfigs = Array(metadataConfigs.prefix(3))
        config.showBadge = task.subtaskCount > 0
        config.showDisclosure = task.hasDetails
        
        return config
    }
    
    // MARK: - Helper Methods
    
    private static func colorForPriority(_ priority: Priority) -> UIColor {
        switch priority {
        case .low: return .systemGreen
        case .medium: return .systemBlue
        case .high: return .systemOrange
        case .critical: return .systemRed
        }
    }
    
    private static func colorForTaskType(_ type: TaskType) -> UIColor {
        switch type {
        case .bug: return .systemRed
        case .feature: return .systemBlue
        case .documentation: return .systemPurple
        case .testing: return .systemTeal
        }
    }
    
    private static func colorForStatus(_ status: Status) -> UIColor {
        switch status {
        case .todo: return .systemGray
        case .inProgress: return .systemBlue
        case .review: return .systemYellow
        case .done: return .systemGreen
        }
    }
    
    private static func iconForPriority(_ priority: Priority) -> UIImage? {
        switch priority {
        case .low: return UIImage(systemName: "arrow.down.circle.fill")
        case .medium: return UIImage(systemName: "minus.circle.fill")
        case .high: return UIImage(systemName: "arrow.up.circle.fill")
        case .critical: return UIImage(systemName: "exclamationmark.triangle.fill")
        }
    }
    
    private static func iconForTaskType(_ type: TaskType) -> UIImage? {
        switch type {
        case .bug: return UIImage(systemName: "ladybug.fill")
        case .feature: return UIImage(systemName: "star.fill")
        case .documentation: return UIImage(systemName: "doc.text.fill")
        case .testing: return UIImage(systemName: "checkmark.circle.fill")
        }
    }
    
    private static func iconForStatus(_ status: Status) -> UIImage? {
        switch status {
        case .todo: return UIImage(systemName: "circle")
        case .inProgress: return UIImage(systemName: "clock.fill")
        case .review: return UIImage(systemName: "eye.fill")
        case .done: return UIImage(systemName: "checkmark.circle.fill")
        }
    }
}

// Enhanced data model
struct ProjectTask: CellDataProtocol {
    let title: String
    let description: String
    let icon: UIImage?
    let priority: ProjectTaskConfigurationFactory.Priority
    let type: ProjectTaskConfigurationFactory.TaskType
    let status: ProjectTaskConfigurationFactory.Status
    let dueDate: Date?
    let subtaskCount: Int
    let assignee: String?
    
    var badge: String? {
        return subtaskCount > 0 ? "\(subtaskCount)" : nil
    }
    
    var isUrgent: Bool {
        return priority == .critical || (dueDate?.timeIntervalSince(Date()) ?? 0) < 3600
    }
    
    var hasDetails: Bool {
        return !description.isEmpty || assignee != nil
    }
}
```

## Adaptive Layout System

Create layouts that adapt to device size and orientation:

```swift
class AdaptiveLayoutManager {
    
    static func configuration(for data: any CellDataProtocol, 
                            in tableView: UITableView, 
                            at indexPath: IndexPath) -> CellConfiguration {
        
        let deviceType = UIDevice.current.userInterfaceIdiom
        let isLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
        let tableWidth = tableView.bounds.width
        
        var config = CellConfiguration()
        
        // Adapt based on device and orientation
        switch (deviceType, isLandscape) {
        case (.pad, true):
            // iPad landscape - maximum metadata
            config.style = .detail
            config.metadataViewCount = 3
            config.useTitleTextView = true
            
        case (.pad, false):
            // iPad portrait - moderate metadata
            config.style = .detail
            config.metadataViewCount = 2
            
        case (.phone, true):
            // iPhone landscape - minimal metadata
            config.style = .master
            config.metadataViewCount = 1
            
        case (.phone, false):
            // iPhone portrait - standard metadata
            config.style = tableWidth > 390 ? .detail : .master
            config.metadataViewCount = tableWidth > 390 ? 2 : 1
            
        default:
            config.style = .master
            config.metadataViewCount = 1
        }
        
        // Adapt based on content density
        if indexPath.section == 0 {
            // Featured section - always use detail style
            config.style = .detail
            config.metadataViewCount = min(config.metadataViewCount + 1, 3)
        }
        
        return config
    }
}
```

## Theme-Aware Configuration

Create configurations that adapt to light/dark mode and custom themes:

```swift
class ThemeAwareConfiguration {
    
    enum AppTheme {
        case system, light, dark, custom(primary: UIColor, secondary: UIColor)
    }
    
    private static var currentTheme: AppTheme = .system
    
    static func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
    
    static func metadataConfiguration(for type: MetadataType) -> MetadataViewConfig {
        let colors = colorsForCurrentTheme()
        
        switch type {
        case .priority(let level):
            return MetadataViewConfig(
                text: level,
                backgroundColor: colors.priority,
                textColor: colors.onPriority,
                cornerRadius: 6,
                font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            )
            
        case .category(let name):
            return MetadataViewConfig(
                icon: UIImage(systemName: "tag.fill"),
                text: name,
                backgroundColor: colors.category,
                textColor: colors.onCategory,
                cornerRadius: 8
            )
            
        case .status(let status):
            return MetadataViewConfig(
                icon: iconForStatus(status),
                text: status,
                backgroundColor: colors.status,
                textColor: colors.onStatus,
                cornerRadius: 10
            )
            
        case .custom(let icon, let text, let accentColor):
            return MetadataViewConfig(
                icon: icon,
                text: text,
                backgroundColor: accentColor ?? colors.accent,
                textColor: colors.onAccent,
                cornerRadius: 8
            )
        }
    }
    
    private static func colorsForCurrentTheme() -> ThemeColors {
        switch currentTheme {
        case .system:
            return systemThemeColors()
        case .light:
            return lightThemeColors()
        case .dark:
            return darkThemeColors()
        case .custom(let primary, let secondary):
            return customThemeColors(primary: primary, secondary: secondary)
        }
    }
    
    private static func systemThemeColors() -> ThemeColors {
        return ThemeColors(
            priority: .systemRed,
            onPriority: .white,
            category: .systemBlue,
            onCategory: .white,
            status: .systemGreen,
            onStatus: .white,
            accent: .systemPurple,
            onAccent: .white
        )
    }
    
    private static func lightThemeColors() -> ThemeColors {
        return ThemeColors(
            priority: UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0),
            onPriority: .white,
            category: UIColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1.0),
            onCategory: .white,
            status: UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0),
            onStatus: .white,
            accent: UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0),
            onAccent: .white
        )
    }
    
    private static func darkThemeColors() -> ThemeColors {
        return ThemeColors(
            priority: UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0),
            onPriority: .black,
            category: UIColor(red: 0.4, green: 0.6, blue: 0.9, alpha: 1.0),
            onCategory: .black,
            status: UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0),
            onStatus: .black,
            accent: UIColor(red: 0.7, green: 0.4, blue: 0.9, alpha: 1.0),
            onAccent: .black
        )
    }
    
    private static func customThemeColors(primary: UIColor, secondary: UIColor) -> ThemeColors {
        return ThemeColors(
            priority: primary,
            onPriority: .white,
            category: secondary,
            onCategory: .white,
            status: primary.withAlphaComponent(0.8),
            onStatus: .white,
            accent: secondary.withAlphaComponent(0.8),
            onAccent: .white
        )
    }
    
    private static func iconForStatus(_ status: String) -> UIImage? {
        switch status.lowercased() {
        case "active": return UIImage(systemName: "play.circle.fill")
        case "paused": return UIImage(systemName: "pause.circle.fill")
        case "completed": return UIImage(systemName: "checkmark.circle.fill")
        case "cancelled": return UIImage(systemName: "xmark.circle.fill")
        default: return UIImage(systemName: "circle.fill")
        }
    }
}

struct ThemeColors {
    let priority: UIColor
    let onPriority: UIColor
    let category: UIColor
    let onCategory: UIColor
    let status: UIColor
    let onStatus: UIColor
    let accent: UIColor
    let onAccent: UIColor
}

enum MetadataType {
    case priority(String)
    case category(String)
    case status(String)
    case custom(icon: UIImage?, text: String, accentColor: UIColor?)
}
```

## Animated Configuration Changes

Implement smooth transitions between different configurations:

```swift
class AnimatedCellConfigurationManager {
    
    static func animateConfigurationChange(
        in cell: CellKit,
        from oldData: any CellDataProtocol,
        to newData: any CellDataProtocol,
        duration: TimeInterval = 0.3
    ) {
        
        // Determine if configuration needs to change
        let oldConfig = configurationForData(oldData)
        let newConfig = configurationForData(newData)
        
        guard configurationChanged(from: oldConfig, to: newConfig) else {
            // Just update data without animation
            cell.configure(with: newData, configuration: newConfig)
            return
        }
        
        // Animate the transition
        UIView.transition(with: cell, duration: duration, options: [.transitionCrossDissolve], animations: {
            cell.configure(with: newData, configuration: newConfig)
        }, completion: nil)
    }
    
    private static func configurationForData(_ data: any CellDataProtocol) -> CellConfiguration {
        // Implement your configuration logic here
        return CellConfiguration()
    }
    
    private static func configurationChanged(from old: CellConfiguration, to new: CellConfiguration) -> Bool {
        return old.metadataViewCount != new.metadataViewCount ||
               old.style != new.style ||
               old.showBadge != new.showBadge
    }
}

// Usage in your table view controller
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
    let newData = items[indexPath.row]
    
    // Get the old data if this is an update
    if let oldData = cell.currentData {
        AnimatedCellConfigurationManager.animateConfigurationChange(
            in: cell,
            from: oldData,
            to: newData
        )
    } else {
        // First time configuration
        let config = configurationForItem(newData)
        cell.configure(with: newData, configuration: config)
    }
    
    return cell
}
```

## Performance-Optimized Configuration Pool

Create a configuration pool for optimal performance:

```swift
class ConfigurationPool {
    
    private static var configurationCache: [String: CellConfiguration] = [:]
    private static let cacheQueue = DispatchQueue(label: "configuration.cache", attributes: .concurrent)
    
    static func configuration(for key: String, 
                            factory: @escaping () -> CellConfiguration) -> CellConfiguration {
        return cacheQueue.sync {
            if let cached = configurationCache[key] {
                return cached
            }
            
            let newConfiguration = factory()
            cacheQueue.async(flags: .barrier) {
                configurationCache[key] = newConfiguration
            }
            
            return newConfiguration
        }
    }
    
    static func preloadConfigurations() {
        let commonConfigurations: [(String, CellConfiguration)] = [
            ("basic_master", CellKit.basicConfiguration(style: .master)),
            ("basic_detail", CellKit.basicConfiguration(style: .detail)),
            ("single_master", CellKit.singleMetadataConfiguration(style: .master)),
            ("single_detail", CellKit.singleMetadataConfiguration(style: .detail)),
            ("dual_master", CellKit.dualMetadataConfiguration(style: .master)),
            ("dual_detail", CellKit.dualMetadataConfiguration(style: .detail)),
            ("triple_master", CellKit.tripleMetadataConfiguration(style: .master)),
            ("triple_detail", CellKit.tripleMetadataConfiguration(style: .detail))
        ]
        
        cacheQueue.async(flags: .barrier) {
            for (key, config) in commonConfigurations {
                configurationCache[key] = config
            }
        }
    }
    
    static func clearCache() {
        cacheQueue.async(flags: .barrier) {
            configurationCache.removeAll()
        }
    }
}

// Usage
class OptimizedTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigurationPool.preloadConfigurations()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
        let item = items[indexPath.row]
        
        let configKey = "\(item.type)_\(item.priority)_\(item.style)"
        let config = ConfigurationPool.configuration(for: configKey) {
            return createCustomConfiguration(for: item)
        }
        
        cell.configure(with: item, configuration: config)
        return cell
    }
    
    private func createCustomConfiguration(for item: Item) -> CellConfiguration {
        // Custom configuration logic here
        return CellConfiguration()
    }
}
```

## Contextual Configuration

Create configurations that adapt to user context and app state:

```swift
class ContextualConfigurationManager {
    
    enum UserContext {
        case focused        // User is actively using the app
        case background     // App is in background
        case accessibility  // Accessibility features enabled
        case lowPower      // Low power mode
    }
    
    private static var currentContext: UserContext = .focused
    private static var accessibilityEnabled = false
    
    static func updateContext(_ context: UserContext) {
        currentContext = context
        NotificationCenter.default.post(name: .contextChanged, object: nil)
    }
    
    static func configuration(for data: any CellDataProtocol, 
                            baseConfiguration: CellConfiguration) -> CellConfiguration {
        var config = baseConfiguration
        
        // Adapt based on current context
        switch currentContext {
        case .focused:
            // Full configuration
            break
            
        case .background:
            // Simplified configuration for background refresh
            config.metadataViewCount = min(config.metadataViewCount, 1)
            
        case .accessibility:
            // Accessibility-optimized configuration
            config.useTitleTextView = true
            config.metadataConfigs = config.metadataConfigs.map { metaConfig in
                var newConfig = metaConfig
                newConfig.font = UIFont.systemFont(ofSize: max(16, metaConfig.font.pointSize))
                newConfig.cornerRadius = max(8, metaConfig.cornerRadius)
                return newConfig
            }
            
        case .lowPower:
            // Power-efficient configuration
            config.metadataViewCount = 0
            config.showBadge = false
        }
        
        // Additional accessibility adaptations
        if UIAccessibility.isVoiceOverRunning {
            config.useTitleTextView = true
        }
        
        if UIAccessibility.isDarkerSystemColorsEnabled {
            config.metadataConfigs = config.metadataConfigs.map { metaConfig in
                var newConfig = metaConfig
                newConfig.backgroundColor = newConfig.backgroundColor.darkened()
                return newConfig
            }
        }
        
        return config
    }
}

extension UIColor {
    func darkened(by amount: CGFloat = 0.2) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: max(0, brightness - amount), alpha: alpha)
        }
        
        return self
    }
}

extension Notification.Name {
    static let contextChanged = Notification.Name("contextChanged")
}
```

## Multi-Level Conditional Configuration

Create sophisticated conditional logic for complex app requirements:

```swift
class MultiLevelConfigurationEngine {
    
    struct ConfigurationRules {
        let userRole: UserRole
        let contentType: ContentType
        let displayContext: DisplayContext
        let deviceCapabilities: DeviceCapabilities
    }
    
    enum UserRole {
        case guest, user, premium, admin
    }
    
    enum ContentType {
        case standard, premium, sensitive, promotional
    }
    
    enum DisplayContext {
        case list, search, favorites, archive
    }
    
    struct DeviceCapabilities {
        let supportsHaptics: Bool
        let supportsLiveActivities: Bool
        let hasLargeScreen: Bool
        let supportsDynamicType: Bool
    }
    
    static func configuration(for data: any CellDataProtocol, 
                            rules: ConfigurationRules) -> CellConfiguration {
        var config = CellConfiguration()
        
        // Base configuration from user role
        switch rules.userRole {
        case .guest:
            config.style = .master
            config.metadataViewCount = 1
            config.showBadge = false
            
        case .user:
            config.style = .master
            config.metadataViewCount = 2
            config.showBadge = true
            
        case .premium:
            config.style = .detail
            config.metadataViewCount = 3
            config.showBadge = true
            
        case .admin:
            config.style = .detail
            config.metadataViewCount = 3
            config.showBadge = true
            config.useTitleTextView = true
        }
        
        // Modify based on content type
        switch rules.contentType {
        case .standard:
            break // Use base configuration
            
        case .premium:
            config.style = .detail
            config.metadataViewCount = min(config.metadataViewCount + 1, 3)
            
        case .sensitive:
            config.showBadge = false
            config.metadataConfigs = config.metadataConfigs.map { metaConfig in
                var newConfig = metaConfig
                newConfig.backgroundColor = .systemGray
                return newConfig
            }
            
        case .promotional:
            config.style = .detail
            config.metadataConfigs.append(MetadataViewConfig(
                icon: UIImage(systemName: "star.fill"),
                text: "Featured",
                backgroundColor: .systemYellow,
                textColor: .black
            ))
        }
        
        // Adapt to display context
        switch rules.displayContext {
        case .list:
            break // Standard configuration
            
        case .search:
            config.metadataViewCount = min(config.metadataViewCount, 2)
            config.useTitleTextView = false
            
        case .favorites:
            config.style = .detail
            config.metadataConfigs.insert(MetadataViewConfig(
                icon: UIImage(systemName: "heart.fill"),
                backgroundColor: .systemPink,
                textColor: .white
            ), at: 0)
            
        case .archive:
            config.style = .master
            config.metadataViewCount = 1
            config.metadataConfigs = config.metadataConfigs.map { metaConfig in
                var newConfig = metaConfig
                newConfig.backgroundColor = .systemGray4
                newConfig.textColor = .systemGray
                return newConfig
            }
        }
        
        // Device capability adaptations
        if rules.deviceCapabilities.hasLargeScreen {
            config.metadataViewCount = min(config.metadataViewCount + 1, 3)
        }
        
        if rules.deviceCapabilities.supportsDynamicType {
            config.metadataConfigs = config.metadataConfigs.map { metaConfig in
                var newConfig = metaConfig
                newConfig.font = UIFont.preferredFont(forTextStyle: .caption1)
                return newConfig
            }
        }
        
        return config
    }
}
```

These advanced configuration examples demonstrate the flexibility and power of CellKit's configuration system, enabling sophisticated, adaptive user interfaces that respond to context, user preferences, and device capabilities.