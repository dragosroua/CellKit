import UIKit

public class MetaCellKit: UITableViewCell {
    
    /// Current version of MetaCellKit
    public static let version = "1.1.1"
    
    public enum CellStyle {
        case master
        case detail
    }
    
    // MARK: - Private Properties
    private let cardView = UIView()
    private let contentStackView = UIStackView()
    private let mainContentView = UIView()
    private let metadataStackView = UIStackView()
    
    // Main content elements
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let titleTextView = UITextView()
    private let badgeLabel = DynamicBadgeLabel()
    private let disclosureImageView = UIImageView()
    
    // Metadata views (0-3)
    private var metadataViews: [MetadataView] = []
    
    // Configuration
    private var configuration: CellConfiguration?
    private var cellStyle: CellStyle = .master
    
    // MARK: - Internal Properties for Testing
    internal var currentConfiguration: CellConfiguration? { return configuration }
    
    // MARK: - Editing Properties (v1.1.0)
    public weak var editingDelegate: MetaCellKitEditingDelegate?
    public private(set) var isInEditMode: Bool = false
    private var originalText: String?
    private var editingTextView: UITextView?
    private var autoSaveTimer: Timer?
    private var characterCountLabel: UILabel?
    private var iconAlignmentConstraint: NSLayoutConstraint?
    
    // Constraint references for style switching
    private var topConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    // Colors for master style (system background)
    private let normalCardColor = UIColor.systemBackground
    private let selectedMasterCardColor = UIColor.secondarySystemFill
    private let highlightedMasterCardColor = UIColor.tertiarySystemFill
    
    // Colors for detail style (paper background)
    private let normalDetailCardColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
    private let selectedDetailCardColor = UIColor(red: 0.92, green: 0.90, blue: 0.87, alpha: 1.0)
    private let highlightedDetailCardColor = UIColor(red: 0.88, green: 0.85, blue: 0.81, alpha: 1.0)
    
    // MARK: - Initialization
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    // MARK: - Public Methods
    public func configure(with data: any CellDataProtocol, configuration: CellConfiguration) {
        self.configuration = configuration
        self.cellStyle = configuration.style
        
        setupLayout(for: configuration)
        bindData(data)
        applyStyleConfiguration()
    }
    
    public func configure(with data: any CellDataProtocol, metadataViews: Int = 0, style: CellStyle = .master) {
        var config = CellConfiguration()
        config.metadataViewCount = metadataViews
        config.style = style
        configure(with: data, configuration: config)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    // MARK: - Editing Methods (v1.1.0)
    
    /// Enables editing mode for the cell
    public func enableEditing() {
        guard !isInEditMode, configuration?.editing.isEditingEnabled == true else { return }
        
        isInEditMode = true
        originalText = getCurrentText()
        
        setupEditingTextView()
        showEditingInterface()
        
        editingDelegate?.cellDidBeginEditing(self)
        
        // Start auto-save timer if configured
        if let interval = configuration?.editing.autoSaveInterval {
            startAutoSaveTimer(interval: interval)
        }
    }
    
    /// Disables editing mode and commits changes
    public func disableEditing() {
        guard isInEditMode else { return }
        
        let finalText = editingTextView?.text ?? ""
        
        // Validate text before committing
        if let config = configuration, !config.editing.validationRules.isEmpty {
            let validationResult = ValidationUtility.validateText(finalText, with: config.editing.validationRules)
            if case .invalid(let message) = validationResult {
                let error = ValidationError(rule: config.editing.validationRules.first!, message: message)
                editingDelegate?.cell(self, validationFailedWith: error)
                return
            }
        }
        
        commitEditing()
    }
    
    /// Commits the current editing changes
    @discardableResult
    public func commitEditing() -> Bool {
        guard isInEditMode else { return false }
        
        let finalText = editingTextView?.text ?? ""
        
        // Validate text
        if let config = configuration, !config.editing.validationRules.isEmpty {
            let validationResult = ValidationUtility.validateText(finalText, with: config.editing.validationRules)
            if case .invalid = validationResult {
                return false
            }
        }
        
        stopAutoSaveTimer()
        hideEditingInterface()
        setTitle(finalText)
        
        isInEditMode = false
        editingDelegate?.cellDidEndEditing(self, with: finalText)
        
        return true
    }
    
    /// Cancels editing and reverts to original text
    public func cancelEditing() {
        guard isInEditMode else { return }
        
        stopAutoSaveTimer()
        hideEditingInterface()
        
        if let original = originalText {
            setTitle(original)
        }
        
        isInEditMode = false
        editingDelegate?.cellDidEndEditing(self, with: originalText ?? "")
    }
    
    /// Gets the current text (either from editing view or title)
    public func getText() -> String? {
        if isInEditMode {
            return editingTextView?.text
        } else {
            return getCurrentText()
        }
    }
    
    /// Sets the text programmatically
    public func setText(_ text: String) {
        if isInEditMode {
            editingTextView?.text = text
            updateCharacterCount()
            editingDelegate?.cell(self, didChangeText: text)
        } else {
            setTitle(text)
        }
    }
    
    /// Returns whether the cell is currently in editing mode
    public func isCurrentlyEditing() -> Bool {
        return isInEditMode
    }
    
    /// Begins editing mode (convenience method)
    public func beginEditing() {
        enableEditing()
    }
    
    /// Ends editing mode (convenience method)
    public func endEditing() {
        disableEditing()
    }
    
    // MARK: - Private Methods
    private func setupCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        selectedBackgroundView = nil
        
        setupCardView()
        setupMainContent()
        setupMetadataStack()
    }
    
    private func setupCardView() {
        cardView.backgroundColor = normalCardColor
        cardView.layer.cornerCurve = .continuous
        cardView.layer.masksToBounds = false
        
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        topConstraint = cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
        bottomConstraint = cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        leadingConstraint = cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        trailingConstraint = cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    private func setupMainContent() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        contentStackView.alignment = .fill
        
        cardView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
        
        setupMainContentRow()
        contentStackView.addArrangedSubview(mainContentView)
    }
    
    private func setupMainContentRow() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Title container for label/textview switching
        let titleContainer = UIView()
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        
        titleTextView.isScrollEnabled = false
        titleTextView.isEditable = false
        titleTextView.backgroundColor = .clear
        titleTextView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleTextView.textColor = .label
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.textContainerInset = .zero
        
        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(titleTextView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            
            titleTextView.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            titleTextView.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor)
        ])
        
        // Badge
        badgeLabel.setContentHuggingPriority(.required, for: .horizontal)
        badgeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Disclosure
        disclosureImageView.image = UIImage(systemName: "chevron.right")
        disclosureImageView.tintColor = .systemGray3
        disclosureImageView.contentMode = .scaleAspectFit
        disclosureImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleContainer)
        stackView.addArrangedSubview(badgeLabel)
        stackView.addArrangedSubview(disclosureImageView)
        
        mainContentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: mainContentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            disclosureImageView.widthAnchor.constraint(equalToConstant: 12),
            disclosureImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        // Set up initial icon alignment (will be updated in applyStyleConfiguration)
        iconAlignmentConstraint = iconImageView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor)
        iconAlignmentConstraint?.isActive = true
    }
    
    private func setupMetadataStack() {
        metadataStackView.axis = .horizontal
        metadataStackView.spacing = 8
        metadataStackView.distribution = .fillEqually
        contentStackView.addArrangedSubview(metadataStackView)
    }
    
    private func setupLayout(for configuration: CellConfiguration) {
        // Clear existing metadata views
        metadataViews.forEach { $0.removeFromSuperview() }
        metadataViews.removeAll()
        
        // Create new metadata views based on configuration
        for i in 0..<configuration.metadataViewCount {
            let metadataView = MetadataView()
            if i < configuration.metadataConfigs.count {
                metadataView.configure(with: configuration.metadataConfigs[i])
            }
            metadataViews.append(metadataView)
            metadataStackView.addArrangedSubview(metadataView)
        }
        
        // Show/hide metadata stack based on count
        metadataStackView.isHidden = configuration.metadataViewCount == 0
        
        // Configure badge visibility
        badgeLabel.isHidden = !configuration.showBadge
        
        // Configure disclosure visibility
        disclosureImageView.isHidden = !configuration.showDisclosure
    }
    
    private func bindData(_ data: any CellDataProtocol) {
        let mirror = Mirror(reflecting: data)
        
        for child in mirror.children {
            guard let label = child.label else { continue }
            
            switch label.lowercased() {
            case "title", "name":
                if let value = child.value as? String {
                    setTitle(value)
                }
            case "icon", "image":
                if let value = child.value as? UIImage {
                    iconImageView.image = value
                } else if let value = child.value as? String {
                    iconImageView.image = UIImage(systemName: value)
                }
            case "badge", "count":
                if let value = child.value as? String {
                    badgeLabel.text = value
                } else if let value = child.value as? Int {
                    badgeLabel.text = "\(value)"
                }
            default:
                // Handle metadata - check if it's a Date and format automatically
                if let date = child.value as? Date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM yyyy"
                    bindMetadataValue(formatter.string(from: date), for: label)
                } else if let value = child.value as? String {
                    bindMetadataValue(value, for: label)
                }
            }
        }
    }
    
    private func setTitle(_ title: String) {
        if configuration?.useTitleTextView == true {
            titleLabel.isHidden = true
            titleTextView.isHidden = false
            titleTextView.text = title
        } else {
            titleLabel.isHidden = false
            titleTextView.isHidden = true
            titleLabel.text = title
        }
    }
    
    private func bindMetadataValue(_ value: String, for key: String) {
        // Simple binding - assign to available metadata views
        for (index, metadataView) in metadataViews.enumerated() {
            if metadataView.text == nil || metadataView.text?.isEmpty == true {
                metadataView.text = value
                break
            }
        }
    }
    
    private func resetCell() {
        // Cancel editing if active
        if isInEditMode {
            cancelEditing()
        }
        
        titleLabel.text = nil
        titleTextView.text = nil
        iconImageView.image = nil
        badgeLabel.text = nil
        
        metadataViews.forEach { $0.reset() }
        
        cardView.backgroundColor = (cellStyle == .detail) ? normalDetailCardColor : normalCardColor
        
        // Reset editing delegate
        editingDelegate = nil
    }
    
    private func applyStyleConfiguration() {
        // Apply card styling based on cell style
        switch cellStyle {
        case .master:
            cardView.layer.cornerRadius = 10
            cardView.layer.borderWidth = 0.4
            cardView.layer.borderColor = UIColor.label.withAlphaComponent(0.4).cgColor
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.1
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 12
            
            topConstraint.constant = 0
            bottomConstraint.constant = -8
            leadingConstraint.constant = 12
            trailingConstraint.constant = -12
            
        case .detail:
            cardView.backgroundColor = normalDetailCardColor
            
            cardView.layer.cornerRadius = 6
            cardView.layer.borderWidth = 0.8
            cardView.layer.borderColor = UIColor.lightGray.cgColor
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.08
            cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
            cardView.layer.shadowRadius = 16
            
            topConstraint.constant = 6
            bottomConstraint.constant = -10
            leadingConstraint.constant = 16
            trailingConstraint.constant = -16
        }
        
        // Apply custom configuration options
        if let config = configuration {
            // Apply custom title font
            if let titleFont = config.titleFont {
                titleLabel.font = titleFont
                titleTextView.font = titleFont
            }
            
            // Apply custom icon tint color
            if let iconTintColor = config.iconTintColor {
                iconImageView.tintColor = iconTintColor
            }
            
            // Apply custom badge styling
            if let badgeBackgroundColor = config.badgeBackgroundColor {
                badgeLabel.backgroundColor = badgeBackgroundColor
            }
            if let badgeTextColor = config.badgeTextColor {
                badgeLabel.textColor = badgeTextColor
            }
            
            // Apply custom disclosure color
            if let disclosureColor = config.disclosureColor {
                disclosureImageView.tintColor = disclosureColor
            }
            
            // Apply icon alignment
            updateIconAlignment()
        }
        
        setNeedsLayout()
    }
    
    // MARK: - Selection/Highlight Handling
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateCardColor(animated: animated)
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateCardColor(animated: animated)
    }
    
    private func updateCardColor(animated: Bool) {
        let targetColor: UIColor
        
        if isHighlighted {
            targetColor = (cellStyle == .detail) ? highlightedDetailCardColor : highlightedMasterCardColor
        } else if isSelected {
            targetColor = (cellStyle == .detail) ? selectedDetailCardColor : selectedMasterCardColor
        } else {
            targetColor = (cellStyle == .detail) ? normalDetailCardColor : normalCardColor
        }
        
        let changes = { self.cardView.backgroundColor = targetColor }
        animated ? UIView.animate(withDuration: 0.2, animations: changes) : changes()
    }
    
    // MARK: - Editing Helper Methods (v1.1.0)
    
    private func getCurrentText() -> String {
        if titleLabel.isHidden {
            return titleTextView.text ?? ""
        } else {
            return titleLabel.text ?? ""
        }
    }
    
    private func setupEditingTextView() {
        guard let config = configuration else { return }
        
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = config.titleFont ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        textView.textColor = .label
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.isScrollEnabled = false
        textView.keyboardType = config.editing.keyboardType
        textView.returnKeyType = config.editing.returnKeyType
        textView.autocapitalizationType = config.editing.autocapitalizationType
        textView.autocorrectionType = config.editing.autocorrectionType
        textView.delegate = self
        
        if config.editing.allowsUndoRedo {
            textView.allowsEditingTextAttributes = true
        }
        
        textView.text = getCurrentText()
        if textView.text.isEmpty, let placeholder = config.editing.placeholderText {
            textView.text = placeholder
            textView.textColor = .placeholderText
        }
        
        self.editingTextView = textView
    }
    
    private func showEditingInterface() {
        guard let textView = editingTextView else { return }
        
        // Hide the current title display
        titleLabel.isHidden = true
        titleTextView.isHidden = true
        
        // Add editing text view
        let titleContainer = titleLabel.superview!
        titleContainer.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            textView.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor)
        ])
        
        // Setup character count if needed
        setupCharacterCountLabel()
        
        // Focus and show keyboard
        DispatchQueue.main.async {
            textView.becomeFirstResponder()
        }
    }
    
    private func hideEditingInterface() {
        editingTextView?.removeFromSuperview()
        editingTextView = nil
        
        characterCountLabel?.removeFromSuperview()
        characterCountLabel = nil
        
        // Show appropriate title display
        if configuration?.useTitleTextView == true {
            titleTextView.isHidden = false
        } else {
            titleLabel.isHidden = false
        }
    }
    
    private func setupCharacterCountLabel() {
        guard let config = configuration, config.editing.characterCountDisplay != .none else { return }
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        
        characterCountLabel = label
        contentStackView.addArrangedSubview(label)
        updateCharacterCount()
    }
    
    private func updateCharacterCount() {
        guard let label = characterCountLabel,
              let config = configuration,
              let text = editingTextView?.text else { return }
        
        let currentCount = text.count
        let maxLength = config.editing.maxTextLength
        
        switch config.editing.characterCountDisplay {
        case .none:
            break
        case .remaining:
            if let max = maxLength {
                let remaining = max - currentCount
                label.text = "\(remaining) characters remaining"
                label.textColor = remaining < 10 ? .systemRed : .secondaryLabel
            }
        case .count:
            if let max = maxLength {
                label.text = "\(currentCount)/\(max)"
                label.textColor = currentCount > max ? .systemRed : .secondaryLabel
            } else {
                label.text = "\(currentCount)"
            }
        case .both:
            if let max = maxLength {
                let remaining = max - currentCount
                label.text = "\(currentCount)/\(max) (\(remaining) remaining)"
                label.textColor = remaining < 10 ? .systemRed : .secondaryLabel
            }
        }
    }
    
    private func startAutoSaveTimer(interval: TimeInterval) {
        stopAutoSaveTimer()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self,
                  let text = self.editingTextView?.text,
                  self.editingDelegate?.cellShouldAutoSave(self) == true else { return }
            
            self.editingDelegate?.cell(self, didAutoSaveText: text)
        }
    }
    
    private func stopAutoSaveTimer() {
        autoSaveTimer?.invalidate()
        autoSaveTimer = nil
    }
    
    private func updateIconAlignment() {
        guard let config = configuration else { return }
        
        iconAlignmentConstraint?.isActive = false
        
        let titleContainer = titleLabel.superview!
        
        switch config.iconAlignment {
        case .top:
            iconAlignmentConstraint = iconImageView.topAnchor.constraint(equalTo: titleContainer.topAnchor)
        case .middle:
            iconAlignmentConstraint = iconImageView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor)
        case .bottom:
            iconAlignmentConstraint = iconImageView.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor)
        }
        
        iconAlignmentConstraint?.isActive = true
    }
}

// MARK: - UITextViewDelegate

extension MetaCellKit: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        guard let config = configuration else { return }
        
        // Clear placeholder text
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Handle return key
        if text == "\n" {
            let shouldReturn = editingDelegate?.cellShouldReturn(self) ?? true
            if shouldReturn {
                disableEditing()
            }
            return !shouldReturn
        }
        
        // Check max length
        if let maxLength = configuration?.editing.maxTextLength {
            let currentText = textView.text ?? ""
            let newLength = currentText.count + text.count - range.length
            if newLength > maxLength {
                return false
            }
        }
        
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        // Update character count
        updateCharacterCount()
        
        // Update cell height if dynamic height is enabled
        if configuration?.editing.enablesDynamicHeight == true {
            updateCellHeight()
        }
        
        // Notify delegate
        editingDelegate?.cell(self, didChangeText: text)
        
        // Real-time validation
        if let config = configuration, !config.editing.validationRules.isEmpty {
            let validationResult = ValidationUtility.validateText(text, with: config.editing.validationRules)
            if case .invalid(let message) = validationResult {
                // Visual feedback for validation error could be added here
            }
        }
    }
    
    private func updateCellHeight() {
        guard let textView = editingTextView else { return }
        
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        let newHeight = size.height
        
        editingDelegate?.cell(self, willChangeHeightTo: newHeight)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1) {
            self.layoutIfNeeded()
        }
    }
}