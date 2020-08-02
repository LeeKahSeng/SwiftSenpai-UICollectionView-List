//
//  SFSymbolVerticalContentView.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 01/08/2020.
//

import Foundation
import UIKit

class SFSymbolVerticalContentView: UIView, UIContentView {
    
    let nameLabel = UILabel()
    let symbolImageView = UIImageView()
    
    // Conform to UIContentView
    // Must make configuration as computed property becuase to satisfy UIContentView protocol requirement
    // Create a private currentConfiguration to hold the value with actual data type
    // currentConfiguration will be force unwrapped because MyCustomContentView must have a configuration
    private var currentConfiguration: SFSymbolContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? SFSymbolContentConfiguration else {
                return
            }
            
            // Keep track on current configuration and apply it to MyCustomContentView
            apply(configuration: newConfiguration)
        }
    }
    

    init(configuration: SFSymbolContentConfiguration) {
        super.init(frame: .zero)
        
        // Create the custom content view UI
        setupAllViews()
        
        // Apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SFSymbolVerticalContentView {
    
    private func setupAllViews() {
        
        // Add stack view to content view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        
        // Add image view to stack view
        symbolImageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(symbolImageView)
        
        // Add label to stack view
        nameLabel.textAlignment = .center
        stackView.addArrangedSubview(nameLabel)
    }
    
    private func apply(configuration: SFSymbolContentConfiguration) {
    
        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }
        
        // Replace current configuration with new configuration
        currentConfiguration = configuration
        
        // Set data to UI elements
        nameLabel.text = configuration.name
        nameLabel.textColor = configuration.nameColor
        
        // Set font weight
        if let fontWeight = configuration.fontWeight {
            nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize, weight: fontWeight)
        }
        
        // Set symbol color & weight
        if
            let symbolColor = configuration.symbolColor,
            let symbolWeight = configuration.symbolWeight {
            var symbol = configuration.symbol?.withConfiguration(UIImage.SymbolConfiguration(weight: symbolWeight))
            symbol = symbol?.withTintColor(symbolColor, renderingMode: .alwaysOriginal)
            symbolImageView.image = symbol
        }
    }
}
