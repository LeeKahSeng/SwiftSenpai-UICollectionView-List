//
//  DeclarativeHeaderFooterViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 17/10/2020.
//

import UIKit

class DeclarativeHeaderFooterViewController: UIViewController {

    let modelObjects = [
        
        HeaderItem(title: "Devices", symbols: [
            SFSymbolItem(name: "iphone.homebutton"),
            SFSymbolItem(name: "pc"),
            SFSymbolItem(name: "headphones"),
        ]),
        
        HeaderItem(title: "Weather", symbols: [
            SFSymbolItem(name: "sun.min"),
            SFSymbolItem(name: "sunset.fill"),
        ]),
        
        HeaderItem(title: "Nature", symbols: [
            SFSymbolItem(name: "drop.fill"),
            SFSymbolItem(name: "flame"),
            SFSymbolItem(name: "bolt.circle.fill"),
            SFSymbolItem(name: "tortoise.fill"),
        ]),
    ]
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Declarative Header & Footer"

        // MARK: Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
        layoutConfig.footerMode = .supplementary
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
        let symbolCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem> {
            (cell, indexPath, symbolItem) in
            
            // Configure cell content
            var configuration = cell.defaultContentConfiguration()
            configuration.image = symbolItem.image
            configuration.text = symbolItem.name
            cell.contentConfiguration = configuration
        }

        // MARK: Initialize data source
        dataSource = UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>(collectionView: collectionView) {
            (collectionView, indexPath, symbolItem) -> UICollectionViewCell? in
            
            // Dequeue symbol cell
            let cell = collectionView.dequeueConfiguredReusableCell(using: symbolCellRegistration,
                                                                    for: indexPath,
                                                                    item: symbolItem)
            return cell
        }
        
        // MARK: Supplementary view registration
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            
            // Obtain header item using index path
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            // Configure header view content based on headerItem
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem.title
            
            // Customize header appearance to make it more eye-catching
            configuration.textProperties.font = .boldSystemFont(ofSize: 16)
            configuration.textProperties.color = .systemBlue
            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
            
            // Apply the configuration to header view
            headerView.contentConfiguration = configuration
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) {
            [unowned self] (footerView, elementKind, indexPath) in
            
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let symbolCount = headerItem.symbols.count
            
            // Configure footer view content
            var configuration = footerView.defaultContentConfiguration()
            configuration.text = "Symbol count: \(symbolCount)"
            footerView.contentConfiguration = configuration
        }
        
        // MARK: Define supplementary view provider
        dataSource.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            if elementKind == UICollectionView.elementKindSectionHeader {
                
                // Dequeue header view
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration, for: indexPath)
                
            } else {
                
                // Dequeue footer view
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerRegistration, for: indexPath)
            }
        }
        
        // MARK: Setup snapshot
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<HeaderItem, SFSymbolItem>()

        // Create collection view section based on number of HeaderItem in modelObjects
        dataSourceSnapshot.appendSections(modelObjects)

        // Loop through each header item to append symbols to their respective section
        for headerItem in modelObjects {
            dataSourceSnapshot.appendItems(headerItem.symbols, toSection: headerItem)
        }

        dataSource.apply(dataSourceSnapshot, animatingDifferences: false)

    }
}
