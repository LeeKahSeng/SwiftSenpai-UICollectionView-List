//
//  CustomHeaderFooterViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 27/10/2020.
//

import UIKit

class CustomHeaderFooterViewController: UIViewController {

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
        
        self.title = "Custom Header & Footer"

        // MARK: Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
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
        <InteractiveHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in

            // Obtain header item using index path
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            headerView.titleLabel.text = headerItem.title
            headerView.infoButtonDidTappedCallback = { [unowned self] in

                // Show an alert when user tap on infoButton
                let symbolCount = headerItem.symbols.count
                let alert = UIAlertController(title: "Info", message: "This section has \(symbolCount) symbols.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                self.present(alert, animated: true)
            }
        }
        
        // MARK: Define supplementary view provider
        dataSource.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            // Dequeue header view
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
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
