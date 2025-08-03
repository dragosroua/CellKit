import UIKit

public struct CellConfiguration {
    public var style: MetaCellKit.CellStyle = .master
    public var metadataViewCount: Int = 0
    public var metadataConfigs: [MetadataViewConfig] = []
    public var showBadge: Bool = true
    public var showDisclosure: Bool = true
    public var useTitleTextView: Bool = false
    
    public init() {}
    
    public init(
        style: MetaCellKit.CellStyle = .master,
        metadataViewCount: Int = 0,
        metadataConfigs: [MetadataViewConfig] = [],
        showBadge: Bool = true,
        showDisclosure: Bool = true,
        useTitleTextView: Bool = false
    ) {
        self.style = style
        self.metadataViewCount = metadataViewCount
        self.metadataConfigs = metadataConfigs
        self.showBadge = showBadge
        self.showDisclosure = showDisclosure
        self.useTitleTextView = useTitleTextView
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