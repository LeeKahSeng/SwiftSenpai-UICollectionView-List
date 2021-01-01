//
//  DatePickerContentConfiguration.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 01/01/2021.
//

import Foundation
import UIKit

struct DatePickerContentConfiguration: UIContentConfiguration, Hashable {

    var date: Date?
    
    func makeContentView() -> UIView & UIContentView {
        // Initialize an instance of SFSymbolNameContentView
        return DatePickerContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
}
