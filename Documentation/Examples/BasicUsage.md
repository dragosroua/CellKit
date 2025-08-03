# Basic Usage Examples

This guide provides practical examples of using CellKit in common scenarios.

## Simple Task List

A basic task list with titles, icons, and badges:

```swift
import UIKit
import CellKit

struct Task: CellDataProtocol {
    let title: String
    let icon: UIImage?
    let badge: String?
    
    init(title: String, iconName: String? = nil, badge: String? = nil) {
        self.title = title
        self.icon = iconName.map { UIImage(systemName: $0) } ?? nil
        self.badge = badge
    }
}

class TaskListViewController: UITableViewController {
    
    let tasks = [
        Task(title: "Buy groceries", iconName: "cart", badge: "3"),
        Task(title: "Call doctor", iconName: "phone", badge: nil),
        Task(title: "Review documents", iconName: "doc.text", badge: "12"),
        Task(title: "Plan vacation", iconName: "airplane", badge: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellKit.self, forCellReuseIdentifier: "Task")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath) as! CellKit
        let task = tasks[indexPath.row]
        
        // Basic configuration - no metadata views
        cell.configure(with: task, metadataViews: 0, style: .master)
        
        return cell
    }
}
```

## Contact List

A contact list with profile pictures and status indicators:

```swift
struct Contact: CellDataProtocol {
    let title: String           // Full name
    let icon: UIImage?          // Profile picture
    let badge: String?          // Unread message count
    let status: String          // Online status
    
    init(name: String, profileImage: UIImage? = nil, unreadCount: Int = 0, isOnline: Bool = false) {
        self.title = name
        self.icon = profileImage ?? UIImage(systemName: "person.circle.fill")
        self.badge = unreadCount > 0 ? "\(unreadCount)" : nil
        self.status = isOnline ? "Online" : "Offline"
    }
}

class ContactListViewController: UITableViewController {
    
    let contacts = [
        Contact(name: "Alice Johnson", unreadCount: 3, isOnline: true),
        Contact(name: "Bob Smith", unreadCount: 0, isOnline: false),
        Contact(name: "Carol Williams", unreadCount: 1, isOnline: true),
        Contact(name: "David Brown", unreadCount: 0, isOnline: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(CellKit.self, forCellReuseIdentifier: "Contact")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Contact", for: indexPath) as! CellKit
        let contact = contacts[indexPath.row]
        
        // Single metadata view for status
        cell.configure(with: contact, metadataViews: 1, style: .master)
        
        return cell
    }
}
```

## Settings Menu

A settings menu with icons and navigation indicators:

```swift
struct SettingsItem: CellDataProtocol {
    let title: String
    let icon: UIImage?
    let hasSubmenu: Bool
    
    init(title: String, iconName: String, hasSubmenu: Bool = true) {
        self.title = title
        self.icon = UIImage(systemName: iconName)
        self.hasSubmenu = hasSubmenu
    }
}

class SettingsViewController: UITableViewController {
    
    let settingsItems = [
        SettingsItem(title: "Notifications", iconName: "bell.fill"),
        SettingsItem(title: "Privacy & Security", iconName: "lock.fill"),
        SettingsItem(title: "Account", iconName: "person.fill"),
        SettingsItem(title: "About", iconName: "info.circle.fill"),
        SettingsItem(title: "Sign Out", iconName: "power", hasSubmenu: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        title = "Settings"
        tableView.register(CellKit.self, forCellReuseIdentifier: "Setting")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.style = .insetGrouped
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as! CellKit
        let item = settingsItems[indexPath.row]
        
        var config = CellConfiguration()
        config.style = .master
        config.metadataViewCount = 0
        config.showBadge = false
        config.showDisclosure = item.hasSubmenu
        
        cell.configure(with: item, configuration: config)
        
        return cell
    }
}
```

## News Feed

A news feed with article metadata:

```swift
struct Article: CellDataProtocol {
    let title: String
    let icon: UIImage?
    let publishedDate: Date
    let category: String
    let readTime: String
    
    init(title: String, imageName: String? = nil, publishedDate: Date, category: String, readTime: String) {
        self.title = title
        self.icon = imageName.map { UIImage(systemName: $0) } ?? UIImage(systemName: "newspaper")
        self.publishedDate = publishedDate
        self.category = category
        self.readTime = readTime
    }
}

class NewsViewController: UITableViewController {
    
    let articles = [
        Article(
            title: "iOS 17 Features You Should Know",
            imageName: "iphone",
            publishedDate: Date().addingTimeInterval(-3600), // 1 hour ago
            category: "Technology",
            readTime: "5 min"
        ),
        Article(
            title: "Swift 6 Released with New Features",
            imageName: "swift",
            publishedDate: Date().addingTimeInterval(-7200), // 2 hours ago
            category: "Development",
            readTime: "8 min"
        ),
        Article(
            title: "App Store Guidelines Updated",
            imageName: "app.badge",
            publishedDate: Date().addingTimeInterval(-86400), // 1 day ago
            category: "News",
            readTime: "3 min"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        title = "News"
        tableView.register(CellKit.self, forCellReuseIdentifier: "Article")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath) as! CellKit
        let article = articles[indexPath.row]
        
        // Triple metadata: published date, category, read time
        cell.configure(with: article, metadataViews: 3, style: .detail)
        
        return cell
    }
}
```

## File Browser

A file browser with file types and sizes:

```swift
struct FileItem: CellDataProtocol {
    let title: String           // File name
    let icon: UIImage?          // File type icon
    let fileSize: String        // File size
    let modifiedDate: Date      // Last modified
    let fileType: String        // File type
    
    init(name: String, size: String, modified: Date, type: FileType) {
        self.title = name
        self.fileSize = size
        self.modifiedDate = modified
        self.fileType = type.rawValue
        self.icon = type.icon
    }
}

enum FileType: String, CaseIterable {
    case document = "Document"
    case image = "Image"
    case video = "Video"
    case audio = "Audio"
    case archive = "Archive"
    case folder = "Folder"
    
    var icon: UIImage? {
        switch self {
        case .document: return UIImage(systemName: "doc.text.fill")
        case .image: return UIImage(systemName: "photo.fill")
        case .video: return UIImage(systemName: "video.fill")
        case .audio: return UIImage(systemName: "music.note")
        case .archive: return UIImage(systemName: "archivebox.fill")
        case .folder: return UIImage(systemName: "folder.fill")
        }
    }
}

class FileBrowserViewController: UITableViewController {
    
    let files = [
        FileItem(name: "Presentation.pptx", size: "2.3 MB", modified: Date().addingTimeInterval(-3600), type: .document),
        FileItem(name: "IMG_1234.jpg", size: "4.1 MB", modified: Date().addingTimeInterval(-7200), type: .image),
        FileItem(name: "Project Files", size: "—", modified: Date().addingTimeInterval(-86400), type: .folder),
        FileItem(name: "Recording.mp3", size: "8.7 MB", modified: Date().addingTimeInterval(-172800), type: .audio)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        title = "Files"
        tableView.register(CellKit.self, forCellReuseIdentifier: "File")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.style = .plain
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "File", for: indexPath) as! CellKit
        let file = files[indexPath.row]
        
        // Dual metadata: file size and modified date (automatically formatted)
        cell.configure(with: file, metadataViews: 2, style: .master)
        
        return cell
    }
}
```

## Shopping Cart

A shopping cart with quantities and prices:

```swift
struct CartItem: CellDataProtocol {
    let title: String           // Product name
    let icon: UIImage?          // Product image
    let badge: String           // Quantity
    let price: String           // Unit price
    let total: String           // Total price
    
    init(name: String, imageName: String? = nil, quantity: Int, unitPrice: Double) {
        self.title = name
        self.icon = imageName.map { UIImage(systemName: $0) } ?? UIImage(systemName: "bag.fill")
        self.badge = "\(quantity)"
        self.price = String(format: "$%.2f", unitPrice)
        self.total = String(format: "$%.2f", Double(quantity) * unitPrice)
    }
}

class ShoppingCartViewController: UITableViewController {
    
    let cartItems = [
        CartItem(name: "iPhone 15 Pro", imageName: "iphone", quantity: 1, unitPrice: 999.00),
        CartItem(name: "AirPods Pro", imageName: "airpods", quantity: 2, unitPrice: 249.00),
        CartItem(name: "Apple Watch", imageName: "applewatch", quantity: 1, unitPrice: 399.00),
        CartItem(name: "MacBook Air", imageName: "laptopcomputer", quantity: 1, unitPrice: 1199.00)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        title = "Shopping Cart"
        tableView.register(CellKit.self, forCellReuseIdentifier: "CartItem")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.style = .insetGrouped
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItem", for: indexPath) as! CellKit
        let item = cartItems[indexPath.row]
        
        // Dual metadata: unit price and total price
        cell.configure(with: item, metadataViews: 2, style: .detail)
        
        return cell
    }
}
```

## Email List

An email list with sender info and status:

```swift
struct Email: CellDataProtocol {
    let title: String           // Subject
    let icon: UIImage?          // Sender avatar or default
    let badge: String?          // Unread indicator
    let sender: String          // Sender name
    let receivedDate: Date      // When received
    let isImportant: Bool       // Priority flag
    
    var importance: String? {
        return isImportant ? "Important" : nil
    }
    
    init(subject: String, from sender: String, received: Date, isUnread: Bool = false, isImportant: Bool = false) {
        self.title = subject
        self.icon = UIImage(systemName: "person.circle.fill")
        self.badge = isUnread ? "●" : nil
        self.sender = sender
        self.receivedDate = received
        self.isImportant = isImportant
    }
}

class EmailListViewController: UITableViewController {
    
    let emails = [
        Email(subject: "Project Update", from: "Alice Johnson", received: Date().addingTimeInterval(-1800), isUnread: true, isImportant: true),
        Email(subject: "Meeting Tomorrow", from: "Bob Smith", received: Date().addingTimeInterval(-3600), isUnread: true),
        Email(subject: "Weekly Report", from: "Carol Williams", received: Date().addingTimeInterval(-7200), isUnread: false),
        Email(subject: "Budget Approval", from: "David Brown", received: Date().addingTimeInterval(-86400), isUnread: false, isImportant: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        title = "Inbox"
        tableView.register(CellKit.self, forCellReuseIdentifier: "Email")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.style = .plain
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Email", for: indexPath) as! CellKit
        let email = emails[indexPath.row]
        
        if email.isImportant {
            // Triple metadata for important emails: sender, date, importance
            cell.configure(with: email, metadataViews: 3, style: .detail)
        } else {
            // Dual metadata for normal emails: sender, date
            cell.configure(with: email, metadataViews: 2, style: .master)
        }
        
        return cell
    }
}
```

## Common Patterns

### Conditional Configuration

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
    let item = items[indexPath.row]
    
    // Configure based on item properties
    if item.isHighPriority {
        cell.configure(with: item, metadataViews: 3, style: .detail)
    } else if item.hasMetadata {
        cell.configure(with: item, metadataViews: 1, style: .master)
    } else {
        cell.configure(with: item, metadataViews: 0, style: .master)
    }
    
    return cell
}
```

### Section-based Configuration

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
    let item = items[indexPath.row]
    
    // Different styles for different sections
    let style: CellKit.CellStyle = indexPath.section == 0 ? .detail : .master
    let metadataCount = indexPath.section == 0 ? 2 : 1
    
    cell.configure(with: item, metadataViews: metadataCount, style: style)
    
    return cell
}
```

### Performance Optimization

```swift
class OptimizedViewController: UITableViewController {
    
    // Pre-create configurations for reuse
    private let detailConfig = CellKit.dualMetadataConfiguration(style: .detail)
    private let masterConfig = CellKit.basicConfiguration(style: .master)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellKit", for: indexPath) as! CellKit
        let item = items[indexPath.row]
        
        // Use pre-created configurations
        let config = item.isDetailed ? detailConfig : masterConfig
        cell.configure(with: item, configuration: config)
        
        return cell
    }
}
```

These examples demonstrate how CellKit can be used across various app types and scenarios, from simple lists to complex data displays, all with minimal code and consistent styling.