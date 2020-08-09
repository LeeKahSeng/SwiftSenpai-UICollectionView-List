//
//  SFSymbolVerticalListCell.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 02/08/2020.
//

import Foundation
import UIKit

class SFSymbolVerticalListCell: UICollectionViewListCell {
    
    var item: SFSymbolItem?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        // Create a new background configuration so that
        // the cell must always have systemBackground background color
        // This will remove the gray background when cell is selected
        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = .systemBackground
        backgroundConfiguration = newBgConfiguration
            
        // Create new configuration object and update it base on state
        var newConfiguration = SFSymbolContentConfiguration().updated(for: state)
        
        // Update any configuration parameters related to data item
        newConfiguration.name = item?.name
        newConfiguration.symbol = item?.image

        // Set content configuration in order to update custom content view
        contentConfiguration = newConfiguration
        
    }
}
