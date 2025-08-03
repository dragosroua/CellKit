import UIKit

public class MetadataView: UIView {
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let stackView = UIStackView()
    private let iconImageView = UIImageView()
    private let textLabel = UILabel()
    
    // MARK: - Public Properties
    public var text: String? {
        get { textLabel.text }
        set { 
            textLabel.text = newValue
            iconImageView.isHidden = icon == nil
            updateVisibility()
        }
    }
    
    public var icon: UIImage? {
        get { iconImageView.image }
        set { 
            iconImageView.image = newValue
            iconImageView.isHidden = newValue == nil
            updateVisibility()
        }
    }
    
    public var config: MetadataViewConfig? {
        didSet {
            applyConfiguration()
        }
    }
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Public Methods
    public func configure(with config: MetadataViewConfig) {
        self.config = config
        self.text = config.text
        self.icon = config.icon
    }
    
    public func reset() {
        text = nil
        icon = nil
        config = nil
        isHidden = true
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .clear
        
        // Container view for background and styling
        containerView.backgroundColor = .systemBlue
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view for icon and text
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon configuration
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Text label configuration
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.textColor = .white
        textLabel.numberOfLines = 1
        textLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // Initially hidden until configured
        isHidden = true
    }
    
    private func applyConfiguration() {
        guard let config = config else { return }
        
        containerView.backgroundColor = config.backgroundColor
        containerView.layer.cornerRadius = config.cornerRadius
        textLabel.textColor = config.textColor
        textLabel.font = config.font
        iconImageView.tintColor = config.textColor
        
        updateVisibility()
    }
    
    private func updateVisibility() {
        let hasContent = (text != nil && !text!.isEmpty) || icon != nil
        isHidden = !hasContent
    }
    
    public override var intrinsicContentSize: CGSize {
        guard !isHidden else { return CGSize.zero }
        
        let stackSize = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(
            width: stackSize.width + 16, // 8pt padding on each side
            height: max(24, stackSize.height + 12) // 6pt padding top/bottom, minimum height
        )
    }
}