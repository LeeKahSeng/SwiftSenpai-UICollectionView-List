//
//  DatePickerCell.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 01/01/2021.
//

import Foundation
import UIKit

class DatePickerCell: UICollectionViewListCell {
    
    var item: DatePickerItem?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        // Create new configuration object and update it base on state
        var newConfiguration = DatePickerContentConfiguration().updated(for: state)
        
        // Update any configuration parameters related to data item
        newConfiguration.item = item

        // Set content configuration in order to update custom content view
        contentConfiguration = newConfiguration
        
    }
}
