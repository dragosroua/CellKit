import UIKit

public protocol MetaCellKitEditingDelegate: AnyObject {
    /// Called when the cell begins editing
    func cellDidBeginEditing(_ cell: MetaCellKit)
    
    /// Called when the cell ends editing with the final text
    func cellDidEndEditing(_ cell: MetaCellKit, with text: String)
    
    /// Called as the user types, providing real-time text updates
    func cell(_ cell: MetaCellKit, didChangeText text: String)
    
    /// Called when the return key is pressed. Return true to dismiss keyboard, false to continue editing
    func cellShouldReturn(_ cell: MetaCellKit) -> Bool
    
    /// Called when validation fails
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError)
    
    /// Called before the cell changes height to allow table view animation
    func cell(_ cell: MetaCellKit, willChangeHeightTo height: CGFloat)
    
    /// Called when auto-save occurs
    func cell(_ cell: MetaCellKit, didAutoSaveText text: String)
    
    /// Called to check if auto-save should occur
    func cellShouldAutoSave(_ cell: MetaCellKit) -> Bool
}

// MARK: - Default implementations to make methods optional

public extension MetaCellKitEditingDelegate {
    func cellDidBeginEditing(_ cell: MetaCellKit) {}
    
    func cellDidEndEditing(_ cell: MetaCellKit, with text: String) {}
    
    func cell(_ cell: MetaCellKit, didChangeText text: String) {}
    
    func cellShouldReturn(_ cell: MetaCellKit) -> Bool { return true }
    
    func cell(_ cell: MetaCellKit, validationFailedWith error: ValidationError) {}
    
    func cell(_ cell: MetaCellKit, willChangeHeightTo height: CGFloat) {}
    
    func cell(_ cell: MetaCellKit, didAutoSaveText text: String) {}
    
    func cellShouldAutoSave(_ cell: MetaCellKit) -> Bool { return true }
}