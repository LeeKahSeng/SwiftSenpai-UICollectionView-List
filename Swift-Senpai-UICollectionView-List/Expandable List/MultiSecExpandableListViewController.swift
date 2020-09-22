//
//  MultiSecExpandableListViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 04/09/2020.
//

import UIKit

class MultiSecExpandableListViewController: UIViewController {

    let modelObjects = [
        
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
        
    ]
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, ListItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Multi Section"
    
        // MARK: Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        // MARK: Configure collection view
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

        // MARK: Cell registration
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem> {
            (cell, indexPath, headerItem) in
            
            // Set headerItem's data to cell
            var content = cell.defaultContentConfiguration()
            content.text = headerItem.title
            cell.contentConfiguration = content
            
            // Add outline disclosure accessory
            // With this accessory, the header cell's children will expand / collapse when the header cell is tapped.
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
        }

        let symbolCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem> {
            (cell, indexPath, symbolItem) in
            
            // Set symbolItem's data to cell
            var content = cell.defaultContentConfiguration()
            content.image = symbolItem.image
            content.text = symbolItem.name
            cell.contentConfiguration = content
        }
        
        // MARK: Initialize data source
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
        
        // MARK: Setup snapshots
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<HeaderItem, ListItem>()

        // Create collection view section based on number of HeaderItem in modelObjects
        dataSourceSnapshot.appendSections(modelObjects)
        dataSource.apply(dataSourceSnapshot)
        
        // Loop through each header item so that we can create a section snapshot for each respective header item.
        for headerItem in modelObjects {
            
            // Create a section snapshot
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            
            // Create a header ListItem & append as parent
            let headerListItem = ListItem.header(headerItem)
            sectionSnapshot.append([headerListItem])
            
            // Create an array of symbol ListItem & append as child of headerListItem
            let symbolListItemArray = headerItem.symbols.map { ListItem.symbol($0) }
            sectionSnapshot.append(symbolListItemArray, to: headerListItem)
            
            // Expand this section by default
            sectionSnapshot.expand([headerListItem])
            
            // Apply section snapshot to the respective collection view section
            dataSource.apply(sectionSnapshot, to: headerItem, animatingDifferences: false)
        }
    }
}
