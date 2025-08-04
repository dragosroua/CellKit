import UIKit

public enum IconAlignment {
    case top      // Icon aligned to top of text area
    case middle   // Icon aligned to middle of text area (default)
    case bottom   // Icon aligned to bottom of text area
}

public enum CharacterCountStyle {
    case none
    case remaining  // "45 characters remaining"
    case count      // "55/100"
    case both       // "55/100 (45 remaining)"
}

public struct EditingConfiguration {
    public var isEditingEnabled: Bool = false
    public var maxTextLength: Int? = nil
    public var minTextLength: Int? = nil
    public var keyboardType: UIKeyboardType = .default
    public var returnKeyType: UIReturnKeyType = .done
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences
    public var autocorrectionType: UITextAutocorrectionType = .default
    public var enablesDynamicHeight: Bool = true
    public var autoSaveInterval: TimeInterval? = nil
    public var placeholderText: String? = "Enter text..."
    public var allowsUndoRedo: Bool = true
    public var characterCountDisplay: CharacterCountStyle = .none
    public var validationRules: [ValidationRule] = []
    
    public init() {}
}

public struct CellConfiguration {
    public var style: MetaCellKit.CellStyle = .master
    public var metadataViewCount: Int = 0
    public var metadataConfigs: [MetadataViewConfig] = []
    public var showBadge: Bool = true
    public var showDisclosure: Bool = true
    public var useTitleTextView: Bool = false
    
    // Font and color customization
    public var titleFont: UIFont?
    public var iconTintColor: UIColor?
    public var badgeBackgroundColor: UIColor?
    public var badgeTextColor: UIColor?
    public var disclosureColor: UIColor?
    
    // New v1.1.0 features
    public var iconAlignment: IconAlignment = .middle
    public var editing: EditingConfiguration = EditingConfiguration()
    
    public init() {}
    
    public init(
        style: MetaCellKit.CellStyle = .master,
        metadataViewCount: Int = 0,
        metadataConfigs: [MetadataViewConfig] = [],
        showBadge: Bool = true,
        showDisclosure: Bool = true,
        useTitleTextView: Bool = false,
        titleFont: UIFont? = nil,
        iconTintColor: UIColor? = nil,
        badgeBackgroundColor: UIColor? = nil,
        badgeTextColor: UIColor? = nil,
        disclosureColor: UIColor? = nil,
        iconAlignment: IconAlignment = .middle,
        editing: EditingConfiguration = EditingConfiguration()
    ) {
        self.style = style
        self.metadataViewCount = metadataViewCount
        self.metadataConfigs = metadataConfigs
        self.showBadge = showBadge
        self.showDisclosure = showDisclosure
        self.useTitleTextView = useTitleTextView
        self.titleFont = titleFont
        self.iconTintColor = iconTintColor
        self.badgeBackgroundColor = badgeBackgroundColor
        self.badgeTextColor = badgeTextColor
        self.disclosureColor = disclosureColor
        self.iconAlignment = iconAlignment
        self.editing = editing
    }
}

public struct MetadataViewConfig {
    public var icon: UIImage?
    public var text: String?
    public var backgroundColor: UIColor
    public var textColor: UIColor
    public var cornerRadius: CGFloat
    public var font: UIFont
    
    public init(
        icon: UIImage? = nil,
        text: String? = nil,
        backgroundColor: UIColor = .systemBlue,
        textColor: UIColor = .white,
        cornerRadius: CGFloat = 8,
        font: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    ) {
        self.icon = icon
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.font = font
    }
}