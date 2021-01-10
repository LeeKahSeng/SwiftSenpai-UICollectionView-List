//
//  DatePickerContentConfiguration.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 01/01/2021.
//

import Foundation
import UIKit

struct DatePickerContentConfiguration: UIContentConfiguration, Hashable {

    var item: DatePickerItem?
    
    func makeContentView() -> UIView & UIContentView {
        // Initialize an instance of DatePickerContentView
        return DatePickerContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
}
