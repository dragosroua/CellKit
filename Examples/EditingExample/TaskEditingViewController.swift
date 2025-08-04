import UIKit
import MetaCellKit

class TaskEditingViewController: UITableViewController {
    
    // MARK: - Data
    private var tasks: [TaskData] = [
        TaskData(
            title: "Review quarterly financial reports and prepare summary",
            dueDate: Date().addingTimeInterval(86400 * 3),
            priority: "High",
            context: "Work",
            status: "In Progress"
        ),
        TaskData(
            title: "Prepare comprehensive presentation for board meeting",
            dueDate: Date().addingTimeInterval(86400 * 7),
            priority: "High",
            context: "Work", 
            status: "Not Started"
        ),
        TaskData(
            title: "Call dentist to schedule appointment",
            dueDate: Date().addingTimeInterval(86400 * 2),
            priority: "Medium",
            context: "Personal",
            status: "Not Started"
        ),
        TaskData(
            title: "Update project documentation",
            dueDate: Date().addingTimeInterval(86400 * 5),
            priority: "Medium",
            context: "Work",
            status: "In Progress"
        ),
        TaskData(
            title: "Plan weekend trip with family",
            dueDate: Date().addingTimeInterval(86400 * 10),
            priority: "Low",
            context: "Personal",
            status: "Not Started"
        )
    ]
    
    // MARK: - Configuration
    private lazy var editingConfig: CellConfiguration = {
        var config = CellConfiguration()
        config.style = .detail
        config.metadataViewCount = 3
        config.iconAlignment = .top  // Icon stays at top during editing
        
        // Editing configuration
        config.editing.isEditingEnabled = true
        config.editing.maxTextLength = 300
        config.editing.characterCountDisplay = .both
        config.editing.enablesDynamicHeight = true
        config.editing.autoSaveInterval = 2.0
        config.editing.placeholderText = "Enter task description..."
        
        // Validation rules
        config.editing.validationRules = [
            LengthValidationRule(min: 5, max: 300),
            RegexValidationRule(
                pattern: "^[A-Za-z0-9\\s.,!?'\"\\-()]*$",
                message: "Only basic characters and punctuation allowed"
            ),
            TaskValidationRule()  // Custom business logic
        ]
        
        // Metadata configurations
        let priorityConfig = MetadataViewConfig(
            icon: UIImage(systemName: "flag.fill"),
            backgroundColor: .systemRed,
            textColor: .white
        )
        
        let contextConfig = MetadataViewConfig(
            icon: UIImage(systemName: "folder.fill"),
            backgroundColor: .systemBlue,
            textColor: .white
        )
        
        let statusConfig = MetadataViewConfig(
            icon: UIImage(systemName: "circle.fill"),
            backgroundColor: .systemGreen,
            textColor: .white
        )
        
        config.metadataConfigs = [priorityConfig, contextConfig, statusConfig]
        
        return config
    }()
    
    private lazy var middleAlignmentConfig: CellConfiguration = {
        var config = editingConfig
        config.iconAlignment = .middle
        return config
    }()
    
    private lazy var bottomAlignmentConfig: CellConfiguration = {
        var config = editingConfig
        config.iconAlignment = .bottom
        return config
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.register(MetaCellKit.self, forCellReuseIdentifier: "EditingCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.systemGroupedBackground
    }
    
    private func setupNavigationBar() {
        title = "Editable Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Task",
            style: .plain,
            target: self,
            action: #selector(addTask)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Alignment",
            style: .plain,
            target: self,
            action: #selector(showAlignmentOptions)
        )
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3  // One section for each alignment type
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? tasks.count : 1  // Main tasks in section 0, demos in other sections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Tasks (Top Alignment)"
        case 1: return "Demo: Middle Alignment"
        case 2: return "Demo: Bottom Alignment"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditingCell", for: indexPath) as! MetaCellKit
        
        if indexPath.section == 0 {
            // Main tasks with top alignment
            let task = tasks[indexPath.row]
            cell.configure(with: task, configuration: editingConfig)
        } else if indexPath.section == 1 {
            // Demo task with middle alignment
            let demoTask = TaskData(
                title: "This is a demo task showing middle icon alignment during editing",
                dueDate: Date(),
                priority: "Demo",
                context: "Example",
                status: "Active"
            )
            cell.configure(with: demoTask, configuration: middleAlignmentConfig)
        } else {
            // Demo task with bottom alignment
            let demoTask = TaskData(
                title: "This is a demo task showing bottom icon alignment during editing",
                dueDate: Date(),
                priority: "Demo",
                context: "Example",
                status: "Active"
            )
            cell.configure(with: demoTask, configuration: bottomAlignmentConfig)
        }
        
        cell.editingDelegate = self
        return cell
    }
    
    // MARK: - Actions
    @objc private func addTask() {
        let newTask = TaskData(
            title: "New task - tap to edit",
            dueDate: Date().addingTimeInterval(86400),
            priority: "Medium",
            context: "Personal",
            status: "Not Started"
        )
        
        tasks.insert(newTask, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        // Start editing the new task after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MetaCellKit {
                cell.enableEditing()
            }
        }
    }
    
    @objc private func showAlignmentOptions() {
        let alert = UIAlertController(
            title: "Icon Alignment Demo",
            message: "Try editing tasks in different sections to see how icon alignment affects the editing experience.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Got it", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - MetaCellKitEditingDelegate
extension TaskEditingViewController: MetaCellKitEditingDelegate {
    
    func cellDidBeginEditing(_ cell: MetaCellKit) {
        // Disable table view scrolling during editing for better UX
        tableView.isScrollEnabled = false
        
        // Scroll to make cell visible if needed
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
        print("📝 Started editing cell")
    }
    
    func cellDidEndEditing(_ cell: MetaCellKit, with text: String) {
        // Re-enable scrolling
        tableView.isScrollEnabled = true
        
        // Save the edited text
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if indexPath.section == 0 {
            tasks[indexPath.row].title = text
            saveTaskData()
            showSaveCompletedFeedback()
            print("💾 Saved task: \(text)")
        } else {
            print("✅ Demo editing completed: \(text)")
        }
    }
    
    func cell(_ cell: MetaCellKit, didChangeText text: String) {
        // Real-time feedback - could update preview or character count
        print("⌨️ Text changed: \(text.count) characters")
    }
    
    func cellShouldReturn(_ cell: MetaCellKit) -> Bool {
        // Custom return key handling
        guard let text = cell.getText(), !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(message: "Please enter a task description")
            return false
        }
        
        // Allow ending editing
        return true
    }
    
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {
        // Handle validation errors with user-friendly messages
        handleValidationError(error, for: cell)
    }
    
    func cell(_ cell: MetaCellKit, willChangeHeightTo height: CGFloat) {
        // Animate height changes smoothly
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        })
    }
    
    func cell(_ cell: MetaCellKit, didAutoSaveText text: String) {
        // Handle auto-save
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if indexPath.section == 0 {
            tasks[indexPath.row].title = text
            autoSaveTaskData()
            showAutoSaveIndicator(for: cell)
            print("💾 Auto-saved task: \(text)")
        }
    }
    
    func cellShouldAutoSave(_ cell: MetaCellKit) -> Bool {
        // Only auto-save when app is active
        return UIApplication.shared.applicationState == .active
    }
    
    // MARK: - Helper Methods
    private func handleValidationError(_ error: ValidationError, for cell: MetaCellKit) {
        let title: String
        let message = error.message
        
        switch error.rule {
        case is LengthValidationRule:
            title = "Text Length Error"
            if let currentText = cell.getText() {
                let enhanced = "\(message)\n\nCurrent length: \(currentText.count) characters"
                showAlert(title: title, message: enhanced)
            } else {
                showAlert(title: title, message: message)
            }
        case is RegexValidationRule:
            title = "Format Error"
            showAlert(title: title, message: message)
        case is TaskValidationRule:
            title = "Task Description Error"
            showAlert(title: title, message: "\(message)\n\nTip: Start with an action word like 'Create', 'Review', 'Call', etc.")
        default:
            title = "Validation Error"
            showAlert(title: title, message: message)
        }
        
        print("❌ Validation failed: \(message)")
    }
    
    private func showAlert(title: String = "Notice", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showAutoSaveIndicator(for cell: MetaCellKit) {
        // Show a subtle save indicator
        let indicator = UILabel()
        indicator.text = "Auto-saved ✓"
        indicator.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        indicator.textColor = .white
        indicator.backgroundColor = UIColor.systemGreen
        indicator.textAlignment = .center
        indicator.layer.cornerRadius = 12
        indicator.clipsToBounds = true
        indicator.alpha = 0
        
        // Add to cell temporarily
        cell.contentView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            indicator.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            indicator.widthAnchor.constraint(equalToConstant: 90),
            indicator.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Animate in and out
        UIView.animateKeyframes(withDuration: 3.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                indicator.alpha = 1.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                indicator.alpha = 0.0
            }
        }) { _ in
            indicator.removeFromSuperview()
        }
    }
    
    private func saveTaskData() {
        // Simulate saving to persistent storage
        print("💾 Saving all task data to storage...")
    }
    
    private func autoSaveTaskData() {
        // Simulate auto-save to persistent storage
        print("💾 Auto-saving task data...")
    }
    
    private func showSaveCompletedFeedback() {
        // Brief success feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}