//
//  NormalHeaderReloadRefViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 17/01/2021.
//

import UIKit

class NormalHeaderReloadRefViewController: UIViewController {
    
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
    var dataSource: UICollectionViewDiffableDataSource<Parent, Child>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
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
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Child> {
            (cell, indexPath, child) in
            
            // Configure cell content
            var configuration = cell.defaultContentConfiguration()
            configuration.text = child.title
            cell.contentConfiguration = configuration
        }

        // MARK: Initialize data source
        dataSource = UICollectionViewDiffableDataSource<Parent, Child>(collectionView: collectionView) {
            (collectionView, indexPath, child) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: child)
            return cell
        }
        
        // MARK: Supplementary view registration
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            
            // Obtain parent using index path
            let parent = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            // Configure header view content based on parent
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = parent.title
            
            // Apply the configuration to header view
            headerView.contentConfiguration = configuration
        }
        
        // MARK: Define supplementary view provider
        dataSource.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            // Dequeue header view
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
            
        }
        
        // MARK: Setup snapshot
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Parent, Child>()

        // Create collection view section based on number of parent in parents
        dataSourceSnapshot.appendSections(parents)

        // Loop through each parent to append children to their respective parent
        for parent in parents {
            dataSourceSnapshot.appendItems(parent.children, toSection: parent)
        }

        dataSource.apply(dataSourceSnapshot, animatingDifferences: false, completion: nil)
        
    }

}

extension NormalHeaderReloadRefViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        var newSnapshot = dataSource.snapshot()
        let parent = newSnapshot.sectionIdentifiers[indexPath.section]
        
        // Change parent's title to selected cell's title
        parent.title = newSnapshot.itemIdentifiers(inSection: parent)[indexPath.item].title
        
        // Reload the entire section
        newSnapshot.reloadSections([parent])
        
        // Apply the new snapshot to data source
        dataSource.apply(newSnapshot, animatingDifferences: false) {
            // The cell's select state will be gone after applying new snapshot, thus manually reselect the cell.
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
    }
    
}
