import UIKit

public class DynamicBadgeLabel: UILabel {
    
    private var minWidth: CGFloat = 24
    private var minHeight: CGFloat = 24
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupBadge()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBadge()
    }
    
    private func setupBadge() {
        textAlignment = .center
        backgroundColor = UIColor.systemRed
        textColor = UIColor.white
        font = UIFont.systemFont(ofSize: 14, weight: .medium)
        clipsToBounds = true
    }
    
    public override var text: String? {
        didSet {
            updateBadgeAppearance()
        }
    }
    
    public var badgeColor: UIColor = .systemRed {
        didSet {
            backgroundColor = badgeColor
        }
    }
    
    public var badgeTextColor: UIColor = .white {
        didSet {
            textColor = badgeTextColor
        }
    }
    
    public var minimumSize: CGSize = CGSize(width: 24, height: 24) {
        didSet {
            minWidth = minimumSize.width
            minHeight = minimumSize.height
            updateBadgeAppearance()
        }
    }
    
    private func updateBadgeAppearance() {
        guard let text = text, !text.isEmpty else {
            isHidden = true
            return
        }
        
        isHidden = false
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
    
    public override var intrinsicContentSize: CGSize {
        guard let text = text, !text.isEmpty else {
            return CGSize(width: 0, height: 0)
        }
        
        let textSize = text.size(withAttributes: [.font: font!])
        let padding: CGFloat = 12
        let width = max(minWidth, textSize.width + padding)
        let height = minHeight
        
        return CGSize(width: width, height: height)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
    
    public func setBadgeValue(_ value: Any?) {
        if let stringValue = value as? String {
            text = stringValue
        } else if let intValue = value as? Int {
            text = intValue > 0 ? "\(intValue)" : nil
        } else if let doubleValue = value as? Double {
            text = doubleValue > 0 ? String(format: "%.1f", doubleValue) : nil
        } else {
            text = nil
        }
    }
}