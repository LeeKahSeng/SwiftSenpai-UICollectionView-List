//
//  SFSymbolNameContentView.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 16/08/2020.
//

import Foundation
import UIKit

class SFSymbolNameContentView: UIView, UIContentView {
    
    // 1
    // IBOutlet to connect to interface builder
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    
    private var currentConfiguration: SFSymbolNameContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            // Make sure the given configuration is of type SFSymbolNameContentConfiguration
            guard let newConfiguration = newValue as? SFSymbolNameContentConfiguration else {
                return
            }
            
            // Set name to label
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: SFSymbolNameContentConfiguration) {
        super.init(frame: .zero)
        
        // 2
        // Load SFSymbolNameContentView.xib
        loadNib()
        
        // Set name to label
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SFSymbolNameContentView {
    
    private func loadNib() {
        
        // 3
        // Load SFSymbolNameContentView.xib by making self as owner of SFSymbolNameContentView.xib
        Bundle.main.loadNibNamed("\(SFSymbolNameContentView.self)", owner: self, options: nil)
        
        // 4
        // Add containerView as subview and make it cover the entire content view
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
        ])
        
        // 5
        // Add border & rounded corner to name label
        nameLabel.layer.borderWidth = 1.5
        nameLabel.layer.borderColor = UIColor.systemPink.cgColor
        nameLabel.layer.cornerRadius = 5.0
    }
    
    private func apply(configuration: SFSymbolNameContentConfiguration) {
    
        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }
        
        // Replace current configuration with new configuration
        currentConfiguration = configuration
        
        // Set name to label
        nameLabel.text = configuration.name
    }
}
