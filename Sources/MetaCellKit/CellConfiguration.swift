import UIKit

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
        disclosureColor: UIColor? = nil
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