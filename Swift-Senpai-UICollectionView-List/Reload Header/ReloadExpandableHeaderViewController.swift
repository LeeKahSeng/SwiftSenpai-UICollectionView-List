//
//  ReloadExpandableHeaderViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 20/01/2021.
//

import UIKit

class ReloadExpandableHeaderViewController: UIViewController {
    
    // MARK: Identifier Types
    struct Parent: Hashable {
        var title: String
        let children: [Child]
    }
    
    struct Child: Hashable {
        let title: String
    }
    
    enum DataItem: Hashable {
        case parent(Parent)
        case child(Child)
    }
    
    // MARK: Model objects
    let parents = [
        
        Parent(title: "Parent 1", children: [
            Child(title: "Child 1 - A"),
            Child(title: "Child 1 - B"),
            Child(title: "Child 1 - C"),
        ]),
        
        Parent(title: "Parent 2", children: [
            Child(title: "Child 2 - A"),
            Child(title: "Child 2 - B"),
            Child(title: "Child 2 - C"),
            Child(title: "Child 2 - D"),
        ]),
    ]
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Parent, DataItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Reload Expandable Section Header"
        
        // MARK: Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        // MARK: Configure collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        // MARK: Cell registration
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Parent> {
            (cell, indexPath, parent) in
            
            // Set parent's title to header cell
            var content = cell.defaultContentConfiguration()
            content.text = parent.title
            cell.contentConfiguration = content
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
        }
        
        let childCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Child> {
            (cell, indexPath, child) in
            
            // Set child title to cell
            var content = cell.defaultContentConfiguration()
            content.text = child.title
            cell.contentConfiguration = content
        }
        
        // MARK: Initialize data source
        dataSource = UICollectionViewDiffableDataSource<Parent, DataItem>(collectionView: collectionView) {
            (collectionView, indexPath, listItem) -> UICollectionViewCell? in
            
            switch listItem {
            case .parent(let parent):
                
                // Dequeue header cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                        for: indexPath,
                                                                        item: parent)
                return cell
                
            case .child(let child):
                
                // Dequeue cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: childCellRegistration,
                                                                        for: indexPath,
                                                                        item: child)
                return cell
            }
        }
        
        // MARK: Construct data source snapshot
        // Loop through each parent items to create a section snapshots.
        for parent in parents {
            
            // Create a section snapshot
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<DataItem>()
            
            // Create a parent DataItem & append as parent
            let parentDataItem = DataItem.parent(parent)
            sectionSnapshot.append([parentDataItem])
            
            // Create an array of child items & append as children of parentDataItem
            let childDataItemArray = parent.children.map { DataItem.child($0) }
            sectionSnapshot.append(childDataItemArray, to: parentDataItem)
            
            // Expand this section by default
            sectionSnapshot.expand([parentDataItem])
            
            // Apply section snapshot to the respective collection view section
            dataSource.apply(sectionSnapshot, to: parent, animatingDifferences: false)
        }
        
    }
    
}

extension ReloadExpandableHeaderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let selectedSection = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        let selectedSectionSnapshot = dataSource.snapshot(for: selectedSection)
        
        // 1
        // Obtain a reference to the selected parent
        guard
            let selectedParentDataItem = selectedSectionSnapshot.rootItems.first,
            case let DataItem.parent(selectedParent) = selectedParentDataItem else {
            return
        }
        
        // 2
        // Obtain a reference to the selected child
        let selectedChildDataItem = selectedSectionSnapshot.items[indexPath.item]
        guard case let DataItem.child(selectedChild) = selectedChildDataItem else {
            return
        }
        
        // 3
        // Create a new parent with selectedChild's title
        let newParent = Parent(title: selectedChild.title, children: selectedParent.children)
        let newParentDataItem = DataItem.parent(newParent)
        
        // 4
        // Avoid crash when user tap on same cell twice (snapshot data must be unique)
        guard selectedParent != newParent else {
            return
        }
        
        // 5
        // Replace the parent in section snapshot (by insert new item and then delete old item)
        var newSectionSnapshot = selectedSectionSnapshot
        newSectionSnapshot.insert([newParentDataItem], before: selectedParentDataItem)
        newSectionSnapshot.delete([selectedParentDataItem])
        
        // 6
        // Reconstruct section snapshot by appending children to `newParentDataItem`
        let allChildDataItems = selectedParent.children.map { DataItem.child($0) }
        newSectionSnapshot.append(allChildDataItems, to: newParentDataItem)
        
        // 7
        // Expand the section
        newSectionSnapshot.expand([newParentDataItem])
        
        // 8
        // Apply new section snapshot to selected section
        dataSource.apply(newSectionSnapshot, to: selectedSection, animatingDifferences: true) {
            // The cell's select state will be gone after applying a new snapshot, thus manually reselecting the cell.
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
    }
    
}
