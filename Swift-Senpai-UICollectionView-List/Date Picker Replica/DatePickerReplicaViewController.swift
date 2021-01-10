//
//  DatePickerReplicaViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 01/01/2021.
//

import UIKit

enum DatePickerItem: Hashable {
    case header(Date)
    case picker(Date, UIAction)
}

class DatePickerReplicaViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, DatePickerItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, DatePickerItem>!
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Date Picker Replica"
        
        dateFormatter.dateFormat = "EEEE, d MMM yyyy, hh:mm a"
        
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
        
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DatePickerItem> { [unowned self]
            (cell, indexPath, item) in
            
            // Extract date from DatePickerItem
            if case let DatePickerItem.header(date) = item {
                
                // Show date on cell
                var content = cell.defaultContentConfiguration()
                content.text = dateFormatter.string(from: date)
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
                
            case .picker(_, _):
                
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
        let action = UIAction(handler: { [unowned self] (action) in
            
            // Make sure sender is a date picker
            guard let picker = action.sender as? UIDatePicker else {
                return
            }
            
            // Reload header cell with date picker's date
            reloadHeader(with: picker.date)
        })
        let picker = DatePickerItem.picker(now, action)
        sectionSnapshot.append([picker], to: header)
        
        // Expand this section by default
        sectionSnapshot.expand([header])
        
        // Apply section snapshot to main section
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
        
    }
    
}

private extension DatePickerReplicaViewController {
    
    private func reloadHeader(with date: Date) {

        let sectionSnapshot = dataSource.snapshot(for: .main)
        
        // Obtain reference to the header item and date picker item
        guard
            let oldHeaderItem = sectionSnapshot.rootItems.first,
            let datePickerItem = sectionSnapshot.snapshot(of: oldHeaderItem).items.first else {
            return
        }
        
        // Create new header item with new date
        let newHeaderItem = DatePickerItem.header(date)

        // Create a new copy of section snapshot for modification
        var newSectionSnapshot = sectionSnapshot

        // Replace the header item (by insert new item and then delete old item)
        newSectionSnapshot.insert([newHeaderItem], before: oldHeaderItem)
        
        // Important: Delete `oldHeaderItem` must come before append `datePickerItem` to avoid 'NSInternalInconsistencyException' with reason: 'Supplied identifiers are not unique.'
        newSectionSnapshot.delete([oldHeaderItem])
        
        // Reconstruct section snapshot by appending `datePickerItem` to `newHeaderItem`
        newSectionSnapshot.append([datePickerItem], to: newHeaderItem)
        
        // Expand the section
        newSectionSnapshot.expand([newHeaderItem])
        
        // Apply new section snapshot to `main` section
        dataSource.apply(newSectionSnapshot, to: .main, animatingDifferences: false)
        
    }
}
