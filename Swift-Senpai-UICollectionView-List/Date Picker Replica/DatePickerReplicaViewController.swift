//
//  DatePickerReplicaViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 01/01/2021.
//

import UIKit

enum DatePickerItem: Hashable {
    case header(Date)
    case picker(Date)
}

class DatePickerReplicaViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, DatePickerItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, DatePickerItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Date Picker Replica"
        
        // Create list layout
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        // Create collection view with list layout
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
        
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DatePickerItem> {
            (cell, indexPath, item) in
            
            if case let DatePickerItem.header(date) = item {
                
                // Show date on cell
                var content = cell.defaultContentConfiguration()
                content.text = "\(date)"
                cell.contentConfiguration = content
            }
            
            // Add outline disclosure accessory
            // With this accessory, the header cell's children will expand / collapse when the header cell is tapped.
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
        }
        
        let pickerCellRegistration = UICollectionView.CellRegistration<DatePickerCell, DatePickerItem> { (cell, indexPath, item) in
            
            // Set `DatePickerItem` to date picker cell
            cell.item = item
        }
        
        // Define data source
        dataSource = UICollectionViewDiffableDataSource<Section, DatePickerItem>(collectionView: collectionView) {
            (collectionView, indexPath, datePickerItem) -> UICollectionViewCell? in
            
            switch datePickerItem {
            case .header(_):
                
                // Dequeue header cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                        for: indexPath,
                                                                        item: datePickerItem)
                return cell
                
            case .picker(_):
                
                // Dequeue symbol cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: pickerCellRegistration,
                                                                        for: indexPath,
                                                                        item: datePickerItem)
                return cell
            }
        }
        
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, DatePickerItem>()
        
        // Define collection view section
        dataSourceSnapshot.appendSections([.main])
        dataSource.apply(dataSourceSnapshot)
        
        // Create a section snapshot
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<DatePickerItem>()
        
        // We will show current date in date picker & header cell
        let now = Date()
        
        // Define header and set it as parent
        let header = DatePickerItem.header(now)
        sectionSnapshot.append([header])
        
        // Define picker and set it as child of `header`
        let picker = DatePickerItem.picker(now)
        sectionSnapshot.append([picker], to: header)
        
        // Expand this section by default
        sectionSnapshot.expand([header])
        
        // Apply section snapshot to main section
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
        
    }
    
}
