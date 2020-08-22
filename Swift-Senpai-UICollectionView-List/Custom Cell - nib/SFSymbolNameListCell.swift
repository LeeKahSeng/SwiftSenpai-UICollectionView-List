//
//  SFSymbolNameListCell.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 17/08/2020.
//

import Foundation
import UIKit

class SFSymbolNameListCell: UICollectionViewListCell {
    
    var item: SFSymbolItem?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        // Create new configuration object and update it base on state
        var newConfiguration = SFSymbolNameContentConfiguration().updated(for: state)
        
        // Update any configuration parameters related to data item
        newConfiguration.name = item?.name

        // Set content configuration in order to update custom content view
        contentConfiguration = newConfiguration
        
    }
}
