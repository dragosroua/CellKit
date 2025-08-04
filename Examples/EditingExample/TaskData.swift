import Foundation
import UIKit
import MetaCellKit

struct TaskData: CellDataProtocol {
    var title: String
    let dueDate: Date
    let priority: String
    let context: String
    let status: String
    
    // CellDataProtocol conformance
    var icon: UIImage? { 
        UIImage(systemName: iconName)?.withTintColor(iconColor, renderingMode: .alwaysOriginal)
    }
    
    var badge: String? { 
        // Show badge for overdue tasks
        if dueDate < Date() {
            return "!"
        }
        return nil
    }
    
    // Computed properties for display
    private var iconName: String {
        switch status.lowercased() {
        case "completed":
            return "checkmark.circle.fill"
        case "in progress":
            return "arrow.clockwise.circle.fill"
        case "not started":
            return "circle"
        default:
            return "questionmark.circle"
        }
    }
    
    private var iconColor: UIColor {
        switch status.lowercased() {
        case "completed":
            return .systemGreen
        case "in progress":
            return .systemBlue
        case "not started":
            return .systemGray
        default:
            return .systemGray
        }
    }
    
    init(title: String, dueDate: Date, priority: String, context: String, status: String) {
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.context = context
        self.status = status
    }
    
    // Convenience initializers for demo data
    static func sampleTasks() -> [TaskData] {
        return [
            TaskData(
                title: "Review quarterly financial reports and prepare executive summary",
                dueDate: Date().addingTimeInterval(86400 * 3),
                priority: "High",
                context: "Work",
                status: "In Progress"
            ),
            TaskData(
                title: "Prepare comprehensive presentation for upcoming board meeting",
                dueDate: Date().addingTimeInterval(86400 * 7),
                priority: "High",
                context: "Work", 
                status: "Not Started"
            ),
            TaskData(
                title: "Call dentist office to schedule routine cleaning appointment",
                dueDate: Date().addingTimeInterval(86400 * 2),
                priority: "Medium",
                context: "Personal",
                status: "Not Started"
            ),
            TaskData(
                title: "Update project documentation with latest API changes",
                dueDate: Date().addingTimeInterval(86400 * 5),
                priority: "Medium",
                context: "Work",
                status: "In Progress"
            ),
            TaskData(
                title: "Plan and organize weekend family trip to the mountains",
                dueDate: Date().addingTimeInterval(86400 * 10),
                priority: "Low",
                context: "Personal",
                status: "Not Started"
            ),
            TaskData(
                title: "Send thank you notes to conference attendees",
                dueDate: Date().addingTimeInterval(-86400 * 2), // Overdue
                priority: "Medium",
                context: "Work",
                status: "Not Started"
            ),
            TaskData(
                title: "Complete online training course on project management",
                dueDate: Date().addingTimeInterval(86400 * 14),
                priority: "Low",
                context: "Professional Development",
                status: "In Progress"
            )
        ]
    }
    
    static func demoTaskForAlignment(_ alignment: String) -> TaskData {
        let title: String
        
        switch alignment {
        case "top":
            title = "This is a demo task with a longer description to show how top icon alignment works during editing. The icon stays at the top while text expands."
        case "middle":
            title = "Demo task showing middle icon alignment during editing"
        case "bottom":
            title = "Demo task showing bottom icon alignment during editing"
        default:
            title = "Demo task"
        }
        
        return TaskData(
            title: title,
            dueDate: Date(),
            priority: "Demo",
            context: "Example",
            status: "Active"
        )
    }
}

// MARK: - TaskData Extensions for Metadata Display
extension TaskData {
    /// Returns formatted priority for metadata display
    var formattedPriority: String {
        return priority
    }
    
    /// Returns formatted context for metadata display
    var formattedContext: String {
        return context
    }
    
    /// Returns formatted status for metadata display
    var formattedStatus: String {
        return status
    }
    
    /// Returns formatted due date for metadata display
    var formattedDueDate: String {
        let formatter = DateFormatter()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(dueDate) {
            return "Today"
        } else if calendar.isDateInTomorrow(dueDate) {
            return "Tomorrow"
        } else if calendar.isDate(dueDate, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE"  // Day of week
            return formatter.string(from: dueDate)
        } else if dueDate < Date() {
            let days = calendar.dateComponents([.day], from: dueDate, to: Date()).day ?? 0
            return "\(days) days overdue"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: dueDate)
        }
    }
    
    /// Returns color for priority metadata
    var priorityColor: UIColor {
        switch priority.lowercased() {
        case "high":
            return .systemRed
        case "medium":
            return .systemOrange
        case "low":
            return .systemGreen
        default:
            return .systemGray
        }
    }
    
    /// Returns color for context metadata
    var contextColor: UIColor {
        switch context.lowercased() {
        case "work":
            return .systemBlue
        case "personal":
            return .systemPurple
        case "professional development":
            return .systemIndigo
        default:
            return .systemTeal
        }
    }
    
    /// Returns color for status metadata
    var statusColor: UIColor {
        switch status.lowercased() {
        case "completed":
            return .systemGreen
        case "in progress":
            return .systemBlue
        case "not started":
            return .systemGray
        default:
            return .systemGray
        }
    }
}

// MARK: - Sample Data Generation
extension TaskData {
    static func generateSampleData(count: Int = 50) -> [TaskData] {
        let titles = [
            "Review project specifications",
            "Update team documentation",
            "Schedule client meeting",
            "Prepare quarterly report",
            "Fix critical bug in authentication",
            "Design new user interface",
            "Conduct user testing session",
            "Write unit test cases",
            "Optimize database queries",
            "Plan team building event",
            "Call insurance company",
            "Book doctor appointment",
            "Grocery shopping for the week",
            "Plan weekend getaway",
            "Organize home office space",
            "Pay monthly bills",
            "Research vacation destinations",
            "Schedule car maintenance",
            "Update personal website",
            "Learn new programming language"
        ]
        
        let priorities = ["High", "Medium", "Low"]
        let contexts = ["Work", "Personal", "Professional Development", "Health", "Finance"]
        let statuses = ["Not Started", "In Progress", "Completed"]
        
        var tasks: [TaskData] = []
        
        for i in 0..<min(count, titles.count) {
            let daysOffset = Int.random(in: -10...30)
            let dueDate = Date().addingTimeInterval(TimeInterval(daysOffset * 86400))
            
            let task = TaskData(
                title: titles[i],
                dueDate: dueDate,
                priority: priorities.randomElement() ?? "Medium",
                context: contexts.randomElement() ?? "Personal",
                status: statuses.randomElement() ?? "Not Started"
            )
            
            tasks.append(task)
        }
        
        return tasks
    }
}