//
//  InteractiveHeader.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 29/10/2020.
//

import UIKit

class InteractiveHeader: UICollectionReusableView {
    
    let titleLabel = UILabel()
    let infoButton = UIButton()
    
    var infoButtonDidTappedCallback: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
}

extension InteractiveHeader {
    
    func configure() {
        
        // Add a stack view to section container
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
         
        // Adjust top anchor constant & priority
        let topAnchor = stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 15)
        topAnchor.priority = UILayoutPriority(999)
        
        // Adjust bottom anchor constant & priority
        let bottomAnchor = stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10)
        bottomAnchor.priority = UILayoutPriority(999)
    
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            topAnchor,
            bottomAnchor,
        ])

        // Setup label and add to stack view
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        stackView.addArrangedSubview(titleLabel)

        // Set button image
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        let infoImage = UIImage(systemName: "info.circle.fill", withConfiguration: largeConfig)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        infoButton.setImage(infoImage, for: .normal)
        
        // Set button action
        infoButton.addAction(UIAction(handler: { [unowned self] (_) in
            // Trigger callback when button tapped
            self.infoButtonDidTappedCallback?()
        }), for: .touchUpInside)
        
        // Add button to stack view
        stackView.addArrangedSubview(infoButton)
        
    }
}
