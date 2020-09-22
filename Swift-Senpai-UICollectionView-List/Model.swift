//
//  Model.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 22/09/2020.
//

import Foundation
import UIKit

enum Section {
    case main
}

enum ListItem: Hashable {
    case header(HeaderItem)
    case symbol(SFSymbolItem)
}

struct HeaderItem: Hashable {
    let title: String
    let symbols: [SFSymbolItem]
}

struct SFSymbolItem: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String) {
        self.name = name
        self.image = UIImage(systemName: name)!
    }
}
