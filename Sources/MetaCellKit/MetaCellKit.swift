import UIKit

public class MetaCellKit: UITableViewCell {
    
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
        titleLabel.text = nil
        titleTextView.text = nil
        iconImageView.image = nil
        badgeLabel.text = nil
        
        metadataViews.forEach { $0.reset() }
        
        cardView.backgroundColor = (cellStyle == .detail) ? normalDetailCardColor : normalCardColor
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
}