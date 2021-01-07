//
//  DatePickerContentView.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 01/01/2021.
//

import Foundation
import UIKit

class DatePickerContentView: UIView, UIContentView {

    private let datePicker = UIDatePicker()
    
    private var currentConfiguration: DatePickerContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? DatePickerContentConfiguration else {
                return
            }
      
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: DatePickerContentConfiguration) {
        super.init(frame: .zero)
        
        // Create the content view UI
        setupAllViews()
        
        // Apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- Private functions
private extension DatePickerContentView {
    
    private func setupAllViews() {
        
        datePicker.preferredDatePickerStyle = .wheels
        
        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func apply(configuration: DatePickerContentConfiguration) {
    
        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }
        
        // Replace current configuration with new configuration
        currentConfiguration = configuration
        
        if case let DatePickerItem.picker(date, action) = configuration.item! {
            // Set date picker's date
            datePicker.date = date
            
            // Set date picker action (value changed)
            datePicker.addAction(action, for: .valueChanged)
        }
    }
}
