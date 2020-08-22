//
//  SFSymbolNameContentConfiguration.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 17/08/2020.
//

import Foundation
import UIKit

struct SFSymbolNameContentConfiguration: UIContentConfiguration, Hashable {

    var name: String?
    
    func makeContentView() -> UIView & UIContentView {
        // Initialize an instance of SFSymbolNameContentView
        return SFSymbolNameContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
