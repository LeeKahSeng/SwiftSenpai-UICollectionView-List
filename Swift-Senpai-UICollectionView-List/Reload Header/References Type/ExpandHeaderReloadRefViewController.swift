//
//  ExpandHeaderReloadRefViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 17/01/2021.
//

import UIKit

class ExpandHeaderReloadRefViewController: UIViewController {

    // MARK: Item Identifier Types
    class Parent: Hashable {
        var title: String
        let children: [Child]
        
        init(title: String, children: [Child]) {
            self.title = title
            self.children = children
        }
        
        // MARK: Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }

        static func == (lhs: Parent, rhs: Parent) -> Bool {
            lhs.title == rhs.title
        }
    }
    
    class Child: Hashable {
        let title: String
        
        init(title: String) {
            self.title = title
        }
        
        // MARK: Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }

        static func == (lhs: Child, rhs: Child) -> Bool {
            lhs.title == rhs.title
        }
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
            
            // Set headerItem's data to cell
            var content = cell.defaultContentConfiguration()
            content.text = parent.title
            cell.contentConfiguration = content
        }

        let childCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Child> {
            (cell, indexPath, child) in
            
            // Set symbolItem's data to cell
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
                
                // Dequeue symbol cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: childCellRegistration,
                                                                        for: indexPath,
                                                                        item: child)
                return cell
            }
        }
        
        // Loop through each header item so that we can create a section snapshot for each respective header item.
        for parent in parents {
            
            // Create a section snapshot
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<DataItem>()
            
            // Create a header ListItem & append as parent
            let parentDataItem = DataItem.parent(parent)
            sectionSnapshot.append([parentDataItem])
            
            // Create an array of symbol ListItem & append as child of headerListItem
            let childDataItemArray = parent.children.map { DataItem.child($0) }
            sectionSnapshot.append(childDataItemArray, to: parentDataItem)
            
            // Expand this section by default
            sectionSnapshot.expand([parentDataItem])
            
            // Apply section snapshot to the respective collection view section
            dataSource.apply(sectionSnapshot, to: parent, animatingDifferences: false)
        }
        
    }
    
}

extension ExpandHeaderReloadRefViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        var newSnapshot = dataSource.snapshot()
        let parent = newSnapshot.sectionIdentifiers[indexPath.section]
        
        // Extract child from `selectedDataItem`
        let selectedDataItem = newSnapshot.itemIdentifiers(inSection: parent)[indexPath.item]

        guard case let DataItem.child(selectedChild) = selectedDataItem else {
            return
        }

        // Change parent's title to selected cell's title
        parent.title = selectedChild.title

        // Reload the entire section
        newSnapshot.reloadSections([parent])

        // Apply the new snapshot to data source
        dataSource.apply(newSnapshot, animatingDifferences: false) {
            // The cell's select state will be gone after applying new snapshot, thus manually reselect the cell.
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
    }
    
}
