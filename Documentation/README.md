# MetaCellKit Documentation

Welcome to the comprehensive documentation for MetaCellKit - a unified, highly configurable table view cell system for iOS apps.

## 📚 Documentation Structure

### [API Reference](API/)
Complete API documentation for all public classes, structs, and protocols:
- [MetaCellKit](API/MetaCellKit.md) - Main cell class
- [CellConfiguration](API/CellConfiguration.md) - Configuration system
- [MetadataViewConfig](API/MetadataViewConfig.md) - Metadata view configuration
- [CellDataProtocol](API/CellDataProtocol.md) - Data binding protocol
- [DynamicBadgeLabel](API/DynamicBadgeLabel.md) - Badge component
- [MetadataView](API/MetadataView.md) - Metadata container view
- [DateFormattingUtility](API/DateFormattingUtility.md) - Date formatting system

### [Tutorials](Tutorials/)
Step-by-step guides for getting started:
- [Getting Started](Tutorials/GettingStarted.md) - Basic setup and usage
- [Configuration Guide](Tutorials/Configuration.md) - Advanced configuration options
- [Data Binding](Tutorials/DataBinding.md) - Working with custom data models
- [Styling Guide](Tutorials/Styling.md) - Customizing appearance
- [Migration Guide](Tutorials/Migration.md) - Migrating from existing cell classes

### [Examples](Examples/)
Practical examples and use cases:
- [Basic Usage](Examples/BasicUsage.md) - Simple implementation examples
- [Advanced Configurations](Examples/AdvancedConfigurations.md) - Complex setup examples
- [Custom Data Models](Examples/CustomDataModels.md) - Creating your own data types
- [Table View Integration](Examples/TableViewIntegration.md) - Complete table view setup

## 🚀 Quick Navigation

### New to MetaCellKit?
Start with [Getting Started](Tutorials/GettingStarted.md) to learn the basics.

### Looking for specific functionality?
Check the [API Reference](API/) for detailed class documentation.

### Need examples?
Browse the [Examples](Examples/) section for code samples.

### Migrating from existing cells?
Read the [Migration Guide](Tutorials/Migration.md) for step-by-step instructions.

## 📖 Key Concepts

### Unified Cell Architecture
MetaCellKit provides a single cell class that can be configured for different use cases, replacing the need for multiple specialized cell classes.

### Layout Variants
- **Basic**: Icon + Title + Badge + Disclosure
- **Single Metadata**: Basic + 1 metadata view
- **Dual Metadata**: Basic + 2 metadata views  
- **Triple Metadata**: Basic + 3 metadata views

### Style System
- **Master Style**: Subtle styling for list controllers
- **Detail Style**: Enhanced paper-like styling for detail views

### Automatic Data Binding
MetaCellKit uses reflection to automatically bind data properties to UI elements, with special handling for dates and common property names.

## 🔗 External Resources

- [GitHub Repository](https://github.com/dragosroua/MetaCellKit)
- [Release Notes](https://github.com/dragosroua/MetaCellKit/releases)
- [Contributing Guidelines](https://github.com/dragosroua/MetaCellKit/blob/main/CONTRIBUTING.md)
- [Issue Tracker](https://github.com/dragosroua/MetaCellKit/issues)

## 📝 Feedback

Found an issue with the documentation? Please [create an issue](https://github.com/dragosroua/MetaCellKit/issues/new) or contribute improvements via pull request.

---

*Last updated: $(date +"%B %d, %Y")*