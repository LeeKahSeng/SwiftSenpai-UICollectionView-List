//
//  ExpandableListViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 04/09/2020.
//

import UIKit

class ExpandableListViewController: UIViewController {
    
    enum ListItem: Hashable {
        case header(HeaderItem)
        case symbol(SFSymbolItem)
    }
    
    struct HeaderItem: Hashable {
        let title: String
        let symbols: [SFSymbolItem]
    }
    
    let allSections = [
        
        HeaderItem(title: "Communication", symbols: [
            SFSymbolItem(name: "mic"),
            SFSymbolItem(name: "mic.fill"),
            SFSymbolItem(name: "message"),
            SFSymbolItem(name: "message.fill"),
        ]),
        
        HeaderItem(title: "Weather", symbols: [
            SFSymbolItem(name: "sun.min"),
            SFSymbolItem(name: "sun.min.fill"),
            SFSymbolItem(name: "sunset"),
            SFSymbolItem(name: "sunset.fill"),
        ]),
        
        HeaderItem(title: "Objects & Tools", symbols: [
            SFSymbolItem(name: "pencil"),
            SFSymbolItem(name: "pencil.circle"),
            SFSymbolItem(name: "highlighter"),
            SFSymbolItem(name: "pencil.and.outline"),
        ]),
        
        HeaderItem(title: "Connectivity", symbols: [
            SFSymbolItem(name: "personalhotspot"),
            SFSymbolItem(name: "network"),
            SFSymbolItem(name: "icloud"),
            SFSymbolItem(name: "icloud.fill"),
        ]),
        
        HeaderItem(title: "Transportation", symbols: [
            SFSymbolItem(name: "car"),
            SFSymbolItem(name: "car.fill"),
            SFSymbolItem(name: "bus"),
            SFSymbolItem(name: "bus.fill"),
        ]),
        
        HeaderItem(title: "Nature", symbols: [
            SFSymbolItem(name: "flame"),
            SFSymbolItem(name: "flame.fill"),
            SFSymbolItem(name: "bolt"),
            SFSymbolItem(name: "bolt.fill")
        ]),
        
    ]
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, ListItem>!
    var dataSourceSnapshot: NSDiffableDataSourceSnapshot<HeaderItem, ListItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        
        // Make collection view take up the entire view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        // Cell registration
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem> { (cell, indexPath, headerItem) in
            
            // Set headerItem's data to cell
            var content = cell.defaultContentConfiguration()
            content.text = headerItem.title
            cell.contentConfiguration = content
            
            // Add outline disclosure accessory
            // With this accessory, the header cell's children will expand / collapse when the header cell is tapped.
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:disclosureOptions)]
        }
        
        let symbolCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem> { (cell, indexPath, symbolItem) in
            
            // Set symbolItem's data to cell
            var content = cell.defaultContentConfiguration()
            content.image = symbolItem.image
            content.text = symbolItem.name
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<HeaderItem, ListItem>(collectionView: collectionView) {
            (collectionView, indexPath, listItem) -> UICollectionViewCell? in
            
            switch listItem {
            case .header(let headerItem):
            
                // Dequeue header cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                        for: indexPath,
                                                                        item: headerItem)
                return cell
            
            case .symbol(let symbolItem):
                
                // Dequeue symbol cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: symbolCellRegistration,
                                                                        for: indexPath,
                                                                        item: symbolItem)
                return cell
            }
        }
        
        
        dataSourceSnapshot = NSDiffableDataSourceSnapshot<HeaderItem, ListItem>()
        
        // Create sections in data source snapshot
        dataSourceSnapshot.appendSections(allSections)
        dataSource.apply(dataSourceSnapshot)
        
        for headerItem in allSections {
           
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            
            // Create a header ListItem & append as parent
            let headerListItem = ListItem.header(headerItem)
            sectionSnapshot.append([headerListItem])
            
            // Expand this section by default
            sectionSnapshot.expand([headerListItem])
            
            // Create an array of symbol ListItem & append as child of headerListItem
            let symbolListItemArray = headerItem.symbols.map { ListItem.symbol($0) }
            sectionSnapshot.append(symbolListItemArray, to: headerListItem)
            
            // Apply section snapshot to collection view section
            dataSource.apply(sectionSnapshot, to: headerItem, animatingDifferences: false)
        }

    }

}
