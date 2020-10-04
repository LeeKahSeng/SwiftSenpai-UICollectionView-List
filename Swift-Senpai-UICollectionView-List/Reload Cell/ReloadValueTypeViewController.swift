//
//  ReloadValueTypeViewController.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 30/09/2020.
//

import UIKit

class ReloadValueTypeViewController: UIViewController {

    struct Superhero: Hashable {
        var name: String
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Superhero>!
    
    let heroArray = [
        Superhero(name: "Spider-Man"),
        Superhero(name: "Superman"),
        Superhero(name: "Batman"),
        Superhero(name: "Captain America"),
        Superhero(name: "Thor"),
        Superhero(name: "Wonder Woman"),
        Superhero(name: "Iron Man"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Reload Value Type"
        
        // MARK: Setup list layout
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        // MARK: Setup collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // MARK: Make collection view take up the entire view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        // MARK: Cell registration
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Superhero> { (cell, indexPath, item) in
            
            // Define how data should be shown using content configuration
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            
            // Assign content configuration to cell
            cell.contentConfiguration = content
        }
        
        // MARK: Setup data source
        dataSource = UICollectionViewDiffableDataSource<Section, Superhero>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, hero) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: hero)
            
            return cell
        })
        
        // MARK: Data source snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Superhero>()
        snapshot.appendSections([.main])
        snapshot.appendItems(heroArray, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension ReloadValueTypeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        // Get selected hero using index path
        guard let selectedHero = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        // Create a new copy of selectedHero & update it
        var updatedHero = selectedHero
        updatedHero.name = updatedHero.name.appending(" ★")

        // Create a new copy of data source snapshot for modification
        var newSnapshot = dataSource.snapshot()

        // Replacing selectedHero with updatedHero
        newSnapshot.insertItems([updatedHero], beforeItem: selectedHero)
        newSnapshot.deleteItems([selectedHero])

        // Apply snapshot changes to data source
        dataSource.apply(newSnapshot)
    }

}
