import UIKit

// MARK: - Example Usage and Sample Data

public extension MetaCellKit {
    
    /// Example data model for demonstrating MetaCellKit functionality
    struct TaskData: CellDataProtocol {
        public let title: String
        public let icon: UIImage?
        public let badge: String?
        public let dueDate: Date?
        public let priority: String?
        public let context: String?
        public let status: String?
        
        public init(
            title: String,
            icon: UIImage? = nil,
            badge: String? = nil,
            dueDate: Date? = nil,
            priority: String? = nil,
            context: String? = nil,
            status: String? = nil
        ) {
            self.title = title
            self.icon = icon
            self.badge = badge
            self.dueDate = dueDate
            self.priority = priority
            self.context = context
            self.status = status
        }
    }
    
    /// Creates a sample configuration for basic layout (no metadata views)
    static func basicConfiguration(style: CellStyle = .master) -> CellConfiguration {
        return CellConfiguration(
            style: style,
            metadataViewCount: 0,
            showBadge: true,
            showDisclosure: true
        )
    }
    
    /// Creates a sample configuration for single metadata view
    static func singleMetadataConfiguration(style: CellStyle = .master) -> CellConfiguration {
        let priorityMetadata = MetadataViewConfig(
            icon: UIImage(systemName: "exclamationmark.circle.fill"),
            text: "High",
            backgroundColor: .systemRed,
            textColor: .white
        )
        
        return CellConfiguration(
            style: style,
            metadataViewCount: 1,
            metadataConfigs: [priorityMetadata],
            showBadge: true,
            showDisclosure: true
        )
    }
    
    /// Creates a sample configuration for dual metadata views
    static func dualMetadataConfiguration(style: CellStyle = .master) -> CellConfiguration {
        let priorityMetadata = MetadataViewConfig(
            icon: UIImage(systemName: "flag.fill"),
            text: "High",
            backgroundColor: .systemRed,
            textColor: .white
        )
        
        let contextMetadata = MetadataViewConfig(
            icon: UIImage(systemName: "at"),
            text: "Work",
            backgroundColor: .systemBlue,
            textColor: .white
        )
        
        return CellConfiguration(
            style: style,
            metadataViewCount: 2,
            metadataConfigs: [priorityMetadata, contextMetadata],
            showBadge: true,
            showDisclosure: true
        )
    }
    
    /// Creates a sample configuration for triple metadata views
    static func tripleMetadataConfiguration(style: CellStyle = .master) -> CellConfiguration {
        let priorityMetadata = MetadataViewConfig(
            icon: UIImage(systemName: "flag.fill"),
            text: "High",
            backgroundColor: .systemRed,
            textColor: .white
        )
        
        let contextMetadata = MetadataViewConfig(
            icon: UIImage(systemName: "at"),
            text: "Work",
            backgroundColor: .systemBlue,
            textColor: .white
        )
        
        let statusMetadata = MetadataViewConfig(
            icon: UIImage(systemName: "checkmark.circle"),
            text: "In Progress",
            backgroundColor: .systemOrange,
            textColor: .white
        )
        
        return CellConfiguration(
            style: style,
            metadataViewCount: 3,
            metadataConfigs: [priorityMetadata, contextMetadata, statusMetadata],
            showBadge: true,
            showDisclosure: true
        )
    }
    
    /// Example usage in a table view
    static func exampleTableViewUsage() -> String {
        return """
        // Basic usage
        let cell = tableView.dequeueReusableCell(withIdentifier: "MetaCellKit") as! MetaCellKit
        let taskData = MetaCellKit.TaskData(
            title: "Complete project proposal",
            icon: UIImage(systemName: "doc.text"),
            badge: "3",
            dueDate: Date().addingTimeInterval(86400),
            priority: "High",
            context: "Work"
        )
        
        // Simple configuration
        cell.configure(with: taskData, metadataViews: 2, style: .detail)
        
        // Advanced configuration
        let config = MetaCellKit.dualMetadataConfiguration(style: .detail)
        cell.configure(with: taskData, configuration: config)
        """
    }
}

// MARK: - Sample Data Factory

public class MetaCellKitSampleData {
    
    public static func sampleTasks() -> [MetaCellKit.TaskData] {
        return [
            MetaCellKit.TaskData(
                title: "Review quarterly reports",
                icon: UIImage(systemName: "chart.bar.doc.horizontal"),
                badge: "5",
                dueDate: Date().addingTimeInterval(86400),
                priority: "High",
                context: "Work",
                status: "Pending"
            ),
            MetaCellKit.TaskData(
                title: "Plan weekend trip",
                icon: UIImage(systemName: "airplane"),
                badge: nil,
                dueDate: Date().addingTimeInterval(259200),
                priority: "Medium",
                context: "Personal",
                status: "In Progress"
            ),
            MetaCellKit.TaskData(
                title: "Buy groceries",
                icon: UIImage(systemName: "cart"),
                badge: "12",
                dueDate: Date().addingTimeInterval(21600),
                priority: "Low",
                context: "Home",
                status: "Not Started"
            ),
            MetaCellKit.TaskData(
                title: "Call dentist for appointment",
                icon: UIImage(systemName: "phone"),
                badge: nil,
                dueDate: Date().addingTimeInterval(172800),
                priority: "Medium",
                context: "Health",
                status: "Pending"
            ),
            MetaCellKit.TaskData(
                title: "Finish reading Swift documentation",
                icon: UIImage(systemName: "book"),
                badge: "3",
                dueDate: Date().addingTimeInterval(604800),
                priority: "Medium",
                context: "Learning",
                status: "In Progress"
            )
        ]
    }
    
    public static func sampleConfigurations() -> [CellConfiguration] {
        return [
            MetaCellKit.basicConfiguration(),
            MetaCellKit.singleMetadataConfiguration(),
            MetaCellKit.dualMetadataConfiguration(),
            MetaCellKit.tripleMetadataConfiguration(),
            MetaCellKit.basicConfiguration(style: .detail),
            MetaCellKit.singleMetadataConfiguration(style: .detail),
            MetaCellKit.dualMetadataConfiguration(style: .detail),
            MetaCellKit.tripleMetadataConfiguration(style: .detail)
        ]
    }
}